package com.github.mistertea.html5animator.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import org.apache.thrift.TException;

import com.github.mistertea.html5animator.rpc.NotAuthorizedException;
import com.github.mistertea.html5animator.rpc.AnimatorRpc;
import com.github.mistertea.html5animator.thrift.ClientErrorInfo;
import com.github.mistertea.html5animator.thrift.Movie;
import com.github.mistertea.html5animator.thrift.User;
import com.github.mistertea.html5animator.thrift.UserData;
import com.github.mistertea.html5animator.thrift.UserInternal;
import com.github.mistertea.html5animator.thrift.UserSession;
import com.github.mistertea.html5animator.thrift.coreConstants;

public class AnimatorRpcImpl extends ServerRpcBase implements AnimatorRpc.Iface {
	private final static Logger logger = Logger.getLogger(AnimatorRpcImpl.class
			.getName());

	private EmailSender emailSender;

	public AnimatorRpcImpl() {
		super();
		emailSender = new EmailSender();
	}

	@Override
	public User getMyself(String token) throws TException {
		UserSession userSession = getSession(token);
		if (userSession == null) {
			// System.out.println("User session " + token + " not found");
			return new User();
		}
		// System.out.println("User session found");
		try {
			User player = databaseEngine.get(User.class, userSession.userId);
			return player;
		} catch (IOException e) {
			throw new TException(e);
		}
	}

	@Override
	public void logout(String token) throws NotAuthorizedException, TException {
		try {
			String id = getSession(token).userId;
			User user = databaseEngine.get(User.class, id);
			user.loggedIn = false;
			databaseEngine.upsert(user);

			databaseEngine.deleteFromId(UserSession.class, token);
		} catch (IOException e) {
			throw new TException(e);
		}
	}

	@Override
	public int ping() throws TException {
		return coreConstants.VERSION;
	}

	@Override
	public boolean changePassword(String token, String oldPassword,
			String newPassword) throws NotAuthorizedException, TException {
		String uid = getSession(token).userId;
		try {
			UserInternal pip = databaseEngine.get(UserInternal.class, uid);
			if (!pip.password.equals(oldPassword)) {
				return false;
			}
			pip.password = newPassword;
			databaseEngine.upsert(pip);
		} catch (IOException e) {
			throw new TException(e);
		}
		return false;
	}

	@Override
	public boolean changeUsername(String token, String newUsername)
			throws NotAuthorizedException, TException {
		try {
			User p = getSessionUser(token);
			if (!databaseEngine.secondaryGet(User.class, "name", newUsername)
					.isEmpty()) {
				return false;
			}
			p.name = newUsername;
			databaseEngine.upsert(p);
			return true;
		} catch (IOException e) {
			throw new TException(e);
		}
	}

	private static String sanitizeEmail(String email) {
		return email.toLowerCase();
	}

	@Override
	public boolean emailPassword(String email) throws TException {
		email = sanitizeEmail(email);
		try {
			ArrayList<UserInternal> usersWithEmail;
			usersWithEmail = databaseEngine.secondaryGet(UserInternal.class,
					"emailAddress", email);
			if (usersWithEmail.size() > 1) {
				logger.severe("Somehow got too many users with email address "
						+ email);
				throw new TException("Server email error");
			}
			if (usersWithEmail.isEmpty()) {
				return false;
			}
			emailSender.sendEmailFromGmail(email, "Your password reminder",
					"Your password is: " + usersWithEmail.get(0).password);
			return true;
		} catch (IOException e) {
			throw new TException(e);
		}
	}

	@Override
	public String login(String token, String email, String password)
			throws TException {
		if (token == null) {
			throw new TException("No Token found.");
		}
		email = sanitizeEmail(email);
		ArrayList<UserInternal> usersWithEmail;
		try {
			usersWithEmail = databaseEngine.secondaryGet(UserInternal.class,
					"emailAddress", email);
		} catch (IOException e) {
			throw new TException(e);
		}
		if (usersWithEmail.size() > 1) {
			logger.severe("Somehow got too many users with email address "
					+ email);
			throw new TException("Server email error");
		}
		if (usersWithEmail.isEmpty()) {
			return "No user with email " + email + " found.";
		}
		if (!usersWithEmail.get(0).password.equals(password)) {
			return "Incorrect Password";
		}
		// If we got here, authentication is complete
		try {
			AuthHandler.authComplete(databaseEngine, usersWithEmail.get(0).id,
					token, request.getRemoteAddr(), 0);
		} catch (IOException e) {
			throw new TException(e);
		}
		logger.info(usersWithEmail.get(0).id
				+ " logged in using internal login");
		return "";
	}

	@Override
	public String createAccount(String token, String email, String name,
			String password) throws TException {
		// Sanitize the email
		email = sanitizeEmail(email);
		try {
			if (!databaseEngine.secondaryGet(UserInternal.class,
					"emailAddress", email).isEmpty()) {
				return "No user with email " + email + " found.";
			}
			User player = new User().setId(null).setName(name)
					.setIpAddress(request.getRemoteAddr());
			databaseEngine.create(player);
			UserInternal pip = new UserInternal().setId(player.id)
					.setPassword(password).setEmailAddress(email);
			databaseEngine.createWithId(pip);
			databaseEngine.commit();
			// If we got here, authentication is complete
			AuthHandler.authComplete(databaseEngine, player.id, token,
					request.getRemoteAddr(), 0);
			logger.info(player.id + " logged in using internal login");
			return "";
		} catch (IOException e) {
			throw new TException(e);
		}
	}

	@Override
	public UserData getMyData(String token) throws TException {
		UserSession userSession = getSession(token);
		if (userSession == null) {
			System.out.println("User session " + token + " not found");
			return new UserData();
		}

		try {
			UserData player = databaseEngine.get(UserData.class,
					userSession.userId);
			return player;
		} catch (IOException e) {
			throw new TException(e);
		}
	}

	@Override
	public boolean validateToken(String token) throws TException {
		return (getSession(token) != null);
	}

	@Override
	public void sendClientError(ClientErrorInfo errorInfo) throws TException {
		try {
			databaseEngine.create(errorInfo);
		} catch (IOException e) {
			// Don't throw or we could have an infinite loop of error reports.
			e.printStackTrace();
		}
	}

	@Override
	public Movie loadMovie(String id) throws TException {
		try {
			return databaseEngine.get(Movie.class, id);
		} catch (IOException e) {
			throw new TException(e);
		}
	}

	@Override
	public void saveMovie(Movie movie) throws TException {
		try {
			databaseEngine.upsert(movie);
		} catch (IOException e) {
			throw new TException(e);
		}
	}
}
