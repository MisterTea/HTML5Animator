package com.github.mistertea.html5animator.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.util.HashMap;

import com.github.mistertea.html5animator.thrift.UserSession;
import com.github.mistertea.zombiedb.DatabaseEngineManager;
import com.github.mistertea.zombiedb.IndexedDatabaseEngineManager;
import com.github.mistertea.zombiedb.engine.AstyanaxDatabaseEngine;

public class Utils {
	private static IndexedDatabaseEngineManager engine = null;

	@SuppressWarnings("unchecked")
	public static <T> T deepCopy(T t) {
		try {
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			ObjectOutputStream oos = new ObjectOutputStream(bos);
			oos.writeObject(t);
			oos.flush();
			oos.close();
			bos.close();
			byte [] byteData = bos.toByteArray();
			ByteArrayInputStream bais = new ByteArrayInputStream(byteData);
			return (T) new ObjectInputStream(bais).readObject();
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static IndexedDatabaseEngineManager createDatabaseEngine(boolean readOnly) throws IOException {
		/*
		String dbDirectory = System.getProperty( "user.home" );
		return new BerkeleyDBDatabaseEngine(dbDirectory, "MAMEHub",false,true,false,true, readOnly);
		*/
		if(Utils.engine==null) {
			//Utils.engine = new JdbmDatabaseEngine(dbDirectory, "MAMEHub",false,true,false,true);
			Utils.engine = new IndexedDatabaseEngineManager(new AstyanaxDatabaseEngine("Digi Cluster", "Html5AnimatorServer",false));
		}
		return Utils.engine;
	}

	public static void destroyDatabaseEngine() {
		if(Utils.engine != null) {
			try {
				Utils.engine.destroy();
			} catch (IOException e) {
				e.printStackTrace();
			}
			Utils.engine = null;
		}
	}
}
