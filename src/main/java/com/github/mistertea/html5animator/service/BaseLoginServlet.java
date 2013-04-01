package com.github.mistertea.html5animator.service;

import java.io.IOException;
import java.util.LinkedList;
import java.util.Set;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.thrift.TException;

import com.github.mistertea.zombiedb.IndexedDatabaseEngineManager;

public class BaseLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    protected IndexedDatabaseEngineManager databaseEngine;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BaseLoginServlet() {
        super();
        try {
			databaseEngine = Utils.createDatabaseEngine(false);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
