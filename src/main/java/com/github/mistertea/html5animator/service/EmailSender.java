package com.github.mistertea.html5animator.service;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.github.mistertea.html5animator.thrift.UserInternal;

public class EmailSender {
	public EmailSender() {
	}

	public void sendEmailFromLocalhost(String to, String body) {
		// Sender's email ID needs to be mentioned
		String from = "offersmailer@10ghost.net";

		// Assuming you are sending email from localhost
		//String host = "localhost";
		String host = "smtp.gmail.com";
		
		// Get system properties
		Properties properties = System.getProperties();

		// Setup mail server
		properties.setProperty("mail.smtp.host", host);

		// Get the default Session object.
		Session session = Session.getDefaultInstance(properties);

		try {
			// Create a default MimeMessage object.
			MimeMessage message = new MimeMessage(session);

			// Set From: header field of the header.
			message.setFrom(new InternetAddress(from));

			// Set To: header field of the header.
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(
					to));

			// Set Subject: header field
			message.setSubject("New Offers");

			// Send the actual HTML message, as big as you like
			message.setContent(body, "text/html");

			// Send message
			Transport.send(message);
			System.out.println("Sent message successfully....");
		} catch (MessagingException mex) {
			mex.printStackTrace();
		}
	}

	public void sendEmailFromGmail(UserInternal toPlayer, String subject, String body) {
		if(toPlayer.emailAddress == null || toPlayer.emailAddress.length()==0) {
			return;
		}
		System.out.println("Sending email " + subject + " " + body + " to " + toPlayer);
		String to = toPlayer.emailAddress;
		sendEmailFromGmail(to,subject,body);
	}
	
	public void sendEmailFromGmail(String to, String subject, String body) {
		final String username = "@gmail.com";
		final String password = "";
 
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
 
		Session session = Session.getInstance(props,
		  new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		  });
 
		try {
 
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress("trivipediamailer@gmail.com"));
			message.setRecipients(Message.RecipientType.TO,
				InternetAddress.parse(to));
			message.setSubject(subject);
			
			// Send the actual HTML message, as big as you like
			message.setContent(body, "text/html");
 
			Transport.send(message);
 
			System.out.println("Done");
 
		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
	}
}
