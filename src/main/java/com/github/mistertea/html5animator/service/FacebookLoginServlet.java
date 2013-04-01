package com.github.mistertea.html5animator.service;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.thrift.TException;

import com.github.mistertea.html5animator.rpc.NotAuthorizedException;
import com.github.mistertea.html5animator.thrift.UserInternal;
import com.restfb.Connection;
import com.restfb.DefaultFacebookClient;
import com.restfb.Parameter;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/facebooklogin.servlet")
public class FacebookLoginServlet extends BaseLoginServlet {
	private final static Logger logger = Logger
			.getLogger(FacebookLoginServlet.class.getName());

	private static final long serialVersionUID = 1L;

	public static String APP_ID = "535653579801438";
	public static String SECRET = "c565e3a6d4f54bcebe44f73ff16513eb";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FacebookLoginServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException {

		HttpClient httpclient = new DefaultHttpClient();
		try {
			{
				String accessToken = request.getParameter("accessToken");
				long expiresOn = Long.parseLong(request
						.getParameter("expiresIn"))
						* 1000
						+ System.currentTimeMillis();

				DefaultFacebookClient facebookClient = new DefaultFacebookClient(
						accessToken);

				com.restfb.types.User user = facebookClient.fetchObject("me",
						com.restfb.types.User.class,
						Parameter.with("fields", "id,name"));
				Long uid = Long.parseLong(user.getId());

				logger.info("User name: " + user.getName() + " id: " + uid
						+ " token: " + request.getParameter("state")
						+ " IP ADDRESS: " + request.getRemoteAddr());

				String token = request.getParameter("state");

				String id = "F_" + uid;
				com.github.mistertea.html5animator.thrift.User player = databaseEngine
						.get(com.github.mistertea.html5animator.thrift.User.class,
								id);
				UserInternal pip = databaseEngine.get(UserInternal.class, id);
				if (player == null) {
					// New account
					String[] nameTokens = user.getName().split(" ");
					String username = nameTokens[0];
					for (int a = 1; a < nameTokens.length; a++) {
						username += " " + nameTokens[a].charAt(0) + ".";
					}
					player = new com.github.mistertea.html5animator.thrift.User()
							.setId(id).setName(username);
					pip = new UserInternal().setId(id).setEmailAddress(
							user.getEmail());
					databaseEngine.createWithId(player);
					databaseEngine.createWithId(pip);
					databaseEngine.commit();
				} else {
					if (pip == null) {
						pip = new UserInternal().setId(id).setEmailAddress(
								user.getEmail());
					} else {
						pip.setEmailAddress(user.getEmail());
					}
					databaseEngine.upsert(player);
					databaseEngine.upsert(pip);
					databaseEngine.commit();
				}

				Connection<com.restfb.types.User> myFriends = facebookClient.fetchConnection(
						"me/friends", com.restfb.types.User.class);
				Set<String> friends = new HashSet<String>();
				for (com.restfb.types.User friend : myFriends.getData()) {
					String friendId = "F_" + friend.getId();
					friends.add(friendId);
				}
				pip.friends = friends;
				databaseEngine.upsert(pip);

				AuthHandler.authComplete(databaseEngine, id, token, request.getRemoteAddr(), expiresOn);
			}
		} catch (NotAuthorizedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			// When HttpClient instance is no longer needed,
			// shut down the connection manager to ensure
			// immediate deallocation of all system resources
			httpclient.getConnectionManager().shutdown();
		}

		logger.info("FACEBOOK SERVLET COMPLETE");
		try {
			response.setStatus(200);
			response.getWriter()
					.write("<html><body onload=\"window.close();\" >You can close this window.</html>");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setHeader("content-type", "text/html");
		logger.info("FACEBOOK SERVLET COMPLETE");
	}

	public String convertStreamToString(java.io.InputStream is) {
		try {
			return new java.util.Scanner(is).useDelimiter("\\A").next();
		} catch (java.util.NoSuchElementException e) {
			return "";
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
