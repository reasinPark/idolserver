<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@	page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@	page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%
	request.setCharacterEncoding("UTF-8");
	PreparedStatement pstmt = null;
	Statement stmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	try{
		/* select ticketgentime , DATE_FORMAT(ticketgentime,'%Y-%m-%d %H:%i:%s') from user limit 1; */
		int storyversion = 0;
		String command = request.getParameter("command");
		if(command!=null&&command.equals("update")){
			pstmt = conn.prepareStatement("update story_version set storyversion = storyversion +1");
			pstmt.executeUpdate();
		}
		pstmt = conn.prepareStatement("select storyversion from story_version limit 1;");
		rs = pstmt.executeQuery();
		if(rs.next()){
			storyversion = rs.getInt(1);
		}
		
		%>
		
		<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;스토리 버전 수정</H2>
		
		<table border="1" style="border-style:solid;">
		<tr height="10">
			<td colspan="3"> 현재 스토리 버전은 <%=storyversion %> 입니다.</td>
		</tr>
		</table>
		<br>
		<form method="post" name="update_form" id="story_form" action="storyVersion.jsp">
		<input type="hidden" name="command" value="update">
		<table border="1" style="border-style:solid;">
		<tr height="10">
			<td colspan="3"> 스토리 정보를 갱신합니다. 
		</tr>
		<tr height="30">
			<td><input type="submit" value="갱신"></td>
		</tr>
		</table>
		</form>
<%
	}catch(Exception e){
		
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(stmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>