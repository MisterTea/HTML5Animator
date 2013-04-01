package com.github.mistertea.html5animator.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.logging.Logger;

import org.apache.thrift.TException;

import com.github.mistertea.html5animator.rpc.NotAuthorizedException;
import com.github.mistertea.html5animator.thrift.User;
import com.github.mistertea.html5animator.thrift.UserData;
import com.github.mistertea.html5animator.thrift.UserSession;
import com.github.mistertea.zombiedb.IndexedDatabaseEngineManager;

public class AuthHandler {
	private final static Logger logger = Logger.getLogger(AuthHandler.class.getName());

	public static void authComplete(
			IndexedDatabaseEngineManager databaseEngine, String id,
			String token, String ipAddress, long expiresIn) throws IOException,
			NotAuthorizedException, TException {
		UserSession oldSession = databaseEngine.get(UserSession.class, token);
		if (oldSession != null) {
			logger.severe("Found an existing session!");
			databaseEngine.delete(oldSession);
		}
		/*  This code forces one session per user
		List<UserSession> moreOldSessions = databaseEngine.secondaryGet(
				UserSession.class, "userId", id);
		for (UserSession session : moreOldSessions) {
			databaseEngine.delete(session);
		}
		*/
		logger.info("Creating user session with token " + token);
		UserSession session = new UserSession(token, id,
				System.currentTimeMillis(), new HashMap<String, String>(),
				expiresIn, System.currentTimeMillis());
		databaseEngine.createWithId(session);

		UserData userData = databaseEngine.get(UserData.class, id);
		if (userData == null) {
			userData = new UserData().setId(id);
			databaseEngine.createWithId(userData);
		}

		User player = databaseEngine.get(User.class, session.userId);
		if (player == null) {
			throw new IOException(
					"Could not find player but player should exist");
		}
		player.setIpAddress(ipAddress);
		player.loggedIn = true;

		databaseEngine.upsert(player);
	}

}
