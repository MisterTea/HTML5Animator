package com.github.mistertea.html5animator.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.thrift.protocol.TJSONProtocol;
import org.apache.thrift.server.TServlet;

import com.github.mistertea.html5animator.rpc.AnimatorRpc;

/**
 * Servlet implementation class Login
 */
@WebServlet("/animator.servlet")
public class AnimatorServlet extends TContextServlet {
	private static final long serialVersionUID = 1L;
	
    public AnimatorServlet() {
    	AnimatorRpcImpl impl = new AnimatorRpcImpl();
        setUp(new AnimatorRpc.Processor<AnimatorRpcImpl>(impl), new TJSONProtocol.Factory(), impl);
    }
    
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	super.doPost(request, response);
	}
}
