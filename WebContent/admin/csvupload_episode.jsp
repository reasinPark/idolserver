<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;csv 파일 적용</H2>
<section>
	<H3 style="font-size:100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;에피소드 데이터</H3>
</section>

<form target="result_frame" action="csvupload_episode_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 적용할 episode.csv 파일 </td>
			<td><input type="file" name="episode" /></td>
		</tr>
		<tr>
			<td colspan = "2" align="center">
			<input type="submit" value="적용하기" /> </td>
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
	try {
		Connection conn = ConnectionProvider.getConnection("afgt");
		PreparedStatement pstmt = conn.prepareStatement("select Story_id, episode_num, episode_name, csvfilename, ticket, gem, purchaseinfo, reward_gem, " +
														"reward_ticket, rewardinfo, writer, director, imgname, likecount, summary, subtitle from episode");
		ResultSet rs = pstmt.executeQuery();
				
		%>
		<H2 style="font-size:20">&nbsp;&nbsp;&nbsp;&nbsp;현재 DB</H2>
		<table border="1" style="border-style:solid;">
			<tr>
				<td>Story_id</td>
				<td>episode_num</td>
				<td>episode_name</td>
				<td>csvfilename</td>
				<td>ticket</td>
				<td>gem</td>
				<td>purchaseinfo</td>
				<td>reward_gem</td>
				<td>reward_ticket</td>
				<td>rewardinfo</td>
				<td>writer</td>
				<td>director</td>
				<td>imgname</td>
				<td>likecount</td>
				<td>summary</td>
				<td>subtitle</td>
			</tr>
		<%
		while(rs.next()) {
		%>
			<tr>
				<td><%=String.valueOf(rs.getString(1))%></td>
				<td><%=String.valueOf(rs.getInt(2))%></td>
				<td><%=String.valueOf(rs.getString(3))%></td>
				<td><%=String.valueOf(rs.getString(4))%></td>
				<td><%=String.valueOf(rs.getInt(5))%></td>
				<td><%=String.valueOf(rs.getInt(6))%></td>
				<td><%=String.valueOf(rs.getInt(7))%></td>
				<td><%=String.valueOf(rs.getInt(8))%></td>
				<td><%=String.valueOf(rs.getInt(9))%></td>
				<td><%=String.valueOf(rs.getInt(10))%></td>
				<td><%=String.valueOf(rs.getString(11))%></td>
				<td><%=String.valueOf(rs.getString(12))%></td>
				<td><%=String.valueOf(rs.getString(13))%></td>
				<td><%=String.valueOf(rs.getInt(14))%></td>
				<td><%=String.valueOf(rs.getString(15))%></td>
				<td><%=String.valueOf(rs.getString(16))%></td>
			</tr>
		<%
		}
		%>
		</table>
		<%
	} catch(Exception e) {
		%>
		다시 확인해 주세요. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	} finally {
	
	}
%>