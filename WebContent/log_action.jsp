<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.wingsinus.ep.LogManager" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	try{
		String userid = request.getParameter("uid");
		String type = request.getParameter("type");
		String name = request.getParameter("name");
		String item = request.getParameter("item");
		String point = request.getParameter("point");
		int count = Integer.valueOf(request.getParameter("count"));
				
		LogManager.writeNorLog(userid, type, name, item, point, count);
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		
	}
%>