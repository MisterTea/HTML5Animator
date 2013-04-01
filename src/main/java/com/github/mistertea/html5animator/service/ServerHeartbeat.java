package com.github.mistertea.html5animator.service;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.github.mistertea.html5animator.thrift.UserSession;
import com.github.mistertea.zombiedb.IndexedDatabaseEngineManager;

/**
 * Application Lifecycle Listener implementation class ServerHeartbeatListener
 * 
 */
@WebListener
public class ServerHeartbeat implements ServletContextListener, Runnable {
	private final static Logger logger = Logger.getLogger(ServerHeartbeat.class
			.getName());
	public static ServerHeartbeat instance = null;

	// Class-centric variables
	private boolean finished = false;
	private Thread serverThread;

	// Thread-centric variables
	IndexedDatabaseEngineManager databaseEngine;
	private long lastTickTime = System.currentTimeMillis();
	private long curtick = 0;

	public ServerHeartbeat() {
		instance = this;
	}

	/**
	 * @see ServletContextListener#contextInitialized(ServletContextEvent)
	 */
	@Override
	public void contextInitialized(ServletContextEvent contextEvent) {
		instance = this;
		try {
			databaseEngine = Utils.createDatabaseEngine(false);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// Start the server
		serverThread = new Thread(this);
		serverThread.start();
	}

	/**
	 * @see ServletContextListener#contextDestroyed(ServletContextEvent)
	 */
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// Stop the server
		finished = true;
		try {
			if (serverThread != null)
				serverThread.join();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Utils.destroyDatabaseEngine();
	}

	public void destroy() {
		try {
			databaseEngine.destroy();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void tick() {
		try {
			curtick++;

			if (curtick % 60 == 0) {
				// Every minute

				// Delete all old sessions
				long currentDays = TimeUnit.MILLISECONDS.toDays(System
						.currentTimeMillis());
				Map<String, UserSession> oldSessions = databaseEngine
						.getAllRows(UserSession.class);
				for (UserSession session : oldSessions.values()) {
					if (TimeUnit.MILLISECONDS.toDays(session.accessTime) + 30 < currentDays) {
						logger.info("Deleting session" + session);
						databaseEngine.delete(session);
					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void run() {
		while (!finished) {
			tick();
			lastTickTime += 1000;
			while (lastTickTime > System.currentTimeMillis()) {
				try {
					Thread.sleep(Math.max(0L,
							lastTickTime - System.currentTimeMillis()) / 2);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		destroy();
	}

}
