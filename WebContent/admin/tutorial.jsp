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
		String Story_id_1 = "";
		String Story_id_2 = "";
		int episode_num_1 = 0;
		int episode_num_2 = 0;
		String summary_1 = "";
		String summary_2 = "";
		
		pstmt = conn.prepareStatement("select Story_id, episode_num, summary from tutorial where idx = 1");
		rs = pstmt.executeQuery();
		if(rs.next()) {
			Story_id_1 = rs.getString(1);
			episode_num_1 = rs.getInt(2);
			summary_1 = rs.getString(3);
		}
		else {
			%>
			<script type="text/javascript">alert("쿼리에 문제가 있습니다. 확인해주세요.");</script>
			<%
		}
		
		pstmt = conn.prepareStatement("select Story_id, episode_num, summary from tutorial where idx = 2");
		rs = pstmt.executeQuery();
		if(rs.next()) {
			Story_id_2 = rs.getString(1);
			episode_num_2 = rs.getInt(2);
			summary_2 = rs.getString(3);
		}
		else {
			%>
			<script type="text/javascript">alert("쿼리에 문제가 있습니다. 확인해주세요.");</script>
			<%
		}
		%>
		
		<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;튜토리얼 작품 수정</H2>
		
		<form target="result_frame" method="post" name="update_form" id="item_form" action="tutorial_update.jsp">
			<table border="1" style="border-style:solid;">
				<tr>
					<td>스토리 아이디가 하나라도 0이면 튜토리얼을 스킵합니다.</td>
				</tr>
				<tr>
					<td>스토리 아이디</td>
					<td>에피소드 번호</td>
					<td>튜토리얼 소개</td>
				</tr>
				<tr>
					<td><input type="text" name="Story_id_1" size="20" value="<%=String.valueOf(Story_id_1) %>">
					<td><input type="text" name="episode_num_1" size="20" value="<%=String.valueOf(episode_num_1) %>">
					<td><input type="text" name="summary_1" size="200" value="<%=String.valueOf(summary_1) %>">
				</tr>
				<tr>
					<td><input type="text" name="Story_id_2" size="20" value="<%=String.valueOf(Story_id_2) %>">
					<td><input type="text" name="episode_num_2" size="20" value="<%=String.valueOf(episode_num_2) %>">
					<td><input type="text" name="summary_2" size="200" value="<%=String.valueOf(summary_2) %>">
				</tr>
				<tr>
					<td colspan="10" align="center"><input type="submit" value="    적용    "></td>
				</tr>
			</table>
		</form>
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