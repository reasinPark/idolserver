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
	Connection conn = ConnectionProvider.getConnection("idol");
	ResultSet rs = null;
	try{
		/* select ticketgentime , DATE_FORMAT(ticketgentime,'%Y-%m-%d %H:%i:%s') from user limit 1; */
		long gentime = 0;
		String gentimeStr = "";
		int itemidx = 0;
		int count = 0;
		
		boolean isFound = false;
		String uid = request.getParameter("uid");
		String command = request.getParameter("command");
		if(uid!=null){
			pstmt = conn.prepareStatement("select gentime, DATE_FORMAT(gentime,'%Y-%m-%d %H:%i:%s'), itemidx, count from user_roulette where uid = ?");
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery();
			if(rs.next()){
				gentime = rs.getTimestamp(1).getTime()/1000;
				gentimeStr = rs.getString(2);
				itemidx = rs.getInt(3);
				count = rs.getInt(4);
				isFound = true;
			}else{
				%>
				<script type="text/javascript">alert("입력하신 정보와 일치하는 유저를 찾을 수 없습니다.");</script>
				<%
			}
		}
		else if(command != null){
			%>
			<script type="text/javascript">alert("입력을 다시 확인해주세요.");</script>
			<%
		}
		%>
		
		<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;유저 룰렛 정보 수정</H2>
		
		<form method="post" name="search_form" id="item_form" action="user_roulette_reset.jsp">
			<input type="hidden" name="command" value="search">
			<table border="1" style="border-style:solid;">
			<tr height="10">
				<td colspan="3"> 아래에 유저아이디 입력후 정보 검색을 누르면 됩니다.
			</tr>
			<tr height="30">
				<td><input type="text" name="uid" size="30" value="<%=((isFound)? uid : "")%>"></td>
				<td><input type="submit" value="정보 검색"></td>
			</tr>
			</table>
		</form>
		<br>
		<%if(isFound){ %>
		<form target="result_frame" method="post" name="update_form" id="story_form" action="user_roulette_reset_update.jsp">
		<input type="hidden" name="uid" value="<%=((isFound)? uid :"") %>">
			<table border="1" style="border-style:solid;">
				<tr>
					<td colspan="10" align="center"><%=((isFound)? "입력된 정보와 일치하는 유저를 찾았습니다. uid["+uid+"]" : "검색을 먼저 해주세요.")%></td>
				</tr>
				<tr>
					<td>룰렛 초기화 시간</td>
					<td>최근 받은 아이템 번호</td>
					<td>룰렛 회차</td>
				</tr>
				<tr>
					<td><input type="text" name="gentime" size="20" value="<%=((isFound)? String.valueOf(gentimeStr): "") %>">
					<td><input type="text" name="itemidx" size="20" value="<%=((isFound)? String.valueOf(itemidx): "") %>">
					<td><input type="text" name="count" size="20" value="<%=((isFound)? String.valueOf(count): "") %>">
				</tr>
			</table>
			<tr>
				<td colspan="10" align="center"> 룰렛 시간 리셋하기  <input type="submit"  value="    적용    "></td>
			</tr>
		</form>
		<form target="result_frame" method="post" name="update_form" id="story_form" action="user_roulette_resetcount.jsp">
		<input type="hidden" name="uid" value="<%=((isFound)? uid :"") %>">
			<tr>
				<td colspan="10" align="center"> 룰렛 카운트 리셋하기  <input type="submit"  value="    적용    "></td>
			</tr>
		</form>
		<%} %>
		<table border="1" style="border-style: solid;" width="90%">
		<tr>
			<td width="100%" height="200">
				<iframe name="result_frame" width="100%" height="200"></iframe>
			</td>
		</tr>
		</table>
<%
	}catch(Exception e){
		
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(stmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>