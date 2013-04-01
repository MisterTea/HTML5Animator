package com.github.mistertea.html5animator.service;

import javax.servlet.http.HttpServletRequest;

public interface ContextHolder {

	void setContext(HttpServletRequest request);

}
