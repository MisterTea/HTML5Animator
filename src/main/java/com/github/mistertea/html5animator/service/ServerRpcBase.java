package com.github.mistertea.html5animator.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.thrift.TException;

import com.github.mistertea.html5animator.rpc.NotAuthorizedException;
import com.github.mistertea.html5animator.thrift.User;
import com.github.mistertea.html5animator.thrift.UserSession;
import com.github.mistertea.zombiedb.IndexedDatabaseEngineManager;

public class ServerRpcBase implements ContextHolder {
	private final static Logger logger = Logger.getLogger(ServerRpcBase.class.getName());

	protected IndexedDatabaseEngineManager databaseEngine;
	protected HttpServletRequest request;
	
	public ServerRpcBase() {
		try {
			databaseEngine = Utils.createDatabaseEngine(false);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public UserSession getSession(String token) throws NotAuthorizedException, TException {
		logger.info("Getting session " + token);
		if (token == null || token.isEmpty()) {
			logger.info("Invalid token");
			return null;
		}
		try {
			UserSession userSession = databaseEngine.get(UserSession.class, token);
			if (userSession == null) {
				logger.info("Not found");
				return null;
			}
			// Optimization: Only update access time every second
			long accessTimeSeconds = TimeUnit.MILLISECONDS.toSeconds(userSession.accessTime);
			long currentTimeSeconds = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());
			if (accessTimeSeconds != currentTimeSeconds) {
				userSession.accessTime = System.currentTimeMillis();
				databaseEngine.upsert(userSession);
			}
			logger.info("Got session");
			return userSession;
		} catch(IOException e) {
			throw new TException(e);
		}
	}
	
	public User getSessionUser(String token) throws NotAuthorizedException, TException {
		try {
			return databaseEngine.get(User.class, getSession(token).userId);
		} catch (IOException e) {
			throw new TException(e);
		}
	}

	@Override
	public void setContext(HttpServletRequest request) {
		this.request = request;
	}
}
