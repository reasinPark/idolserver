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
		%>여기까지 들어옴 성공!<%	
		if(command!=null&&command.equals("sendrentalbook")){
			int itemid = Integer.valueOf(request.getParameter("itemid"));
			String expiredate = request.getParameter("expiredate");
			String title = request.getParameter("title");
			String message = request.getParameter("message");
			pstmt = conn.prepareStatement("select uid from user where lastjointime >= '2018-09-03 10:00:00'");
			List<String> uidlist = new ArrayList<String>();
			rs = pstmt.executeQuery();
			while(rs.next()){
				uidlist.add(rs.getString(1));
			}
			
			for(int i=0;i<uidlist.size();i++){
				pstmt = conn.prepareStatement("insert into user_inven (uid,itemid,count,starttime,expiretime,title,message,img,userconfirm) values(?,?,1,now(),?,?,?,'',1)");
				pstmt.setString(1, uidlist.get(i));
				pstmt.setInt(2, itemid);
				pstmt.setString(3, expiredate);
				pstmt.setString(4, title);
				pstmt.setString(5, message);
				pstmt.executeUpdate();			
			}
		}
		%>
		
		<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;선물 보내기</H2>
		
		<table border="1" style="border-style:solid;">
		<tr height="10">
			<td colspan="3"> 보내실 선물 정보를 입력해 주세요. </td>
		</tr>
		</table>
		<br>
		<form method="post" name="update_form" id="story_form" action="sendRentalBook.jsp">
		
		<table border="1" style="border-style:solid;">
		<input type="hidden" name="command" value="sendrentalbook">
				<tr>
					<td colspan="10" align="center"></td>
				</tr>
				<tr>
					<td>아이템 아이디</td>
					<td>만료 시간</td>
					<td>타이틀</td>
					<td>메세지 본문</td>
				</tr>
				<tr>
					<td><input type="text" name="itemid" size="20" value="">
					<td><input type="text" name="expiredate" size="20" value="">
					<td><input type="text" name="title" size="20" value="">
					<td><input type="text" name="message" size="20" value="">
				</tr>
				<tr>
					<td colspan="10" align="center"><input type="submit" value="    적용    "></td>
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