<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
    
<H2>&nbsp;&nbsp;&nbsp;&nbsp;csv 파일 적용</H2>
<section>
	<H3 style="font-size:100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;스토리 데이터</H3>
</section>

<form target="result_frame" action="csvupload_story_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 적용할 story.csv 파일 </td>
			<td><input type="file" name="story" /></td>
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
		Connection conn = ConnectionProvider.getConnection("idol");
		PreparedStatement pstmt = conn.prepareStatement("select Story_id, csvfilename, title, writer, summary, category_id, imgname, recommend, totalcount, director, sort, engname, comment, col1, col1content, col2, col2content, col3, col3content,photobookid,rankchnum from story");
		ResultSet rs = pstmt.executeQuery();
				
		%>
		<H2 style="font-size:20">&nbsp;&nbsp;&nbsp;&nbsp;현재 DB</H2>
		<table border="1" style="border-style:solid;">
			<tr>
				<td>Story_id</td>
				<td>csvfilename</td>
				<td>title</td>
				<td>writer</td>
				<td>summary</td>
				<td>category_id</td>
				<td>imgname</td>
				<td>recommend</td>
				<td>totalcount</td>
				<td>director</td>
				<td>sort</td>
				<td>engname</td>
				<td>comment</td>
				<td>col1</td>
				<td>col1content</td>
				<td>col2</td>
				<td>col2content</td>
				<td>col3</td>
				<td>col3content</td>
				<td>photobookid</td>
				<td>rankchnum</td>
			</tr>
		<%
		while(rs.next()) {
		%>
			<tr>
				<td><%=String.valueOf(rs.getString(1))%></td>
				<td><%=String.valueOf(rs.getString(2))%></td>
				<td><%=String.valueOf(rs.getString(3))%></td>
				<td><%=String.valueOf(rs.getString(4))%></td>
				<td><%=String.valueOf(rs.getString(5))%></td>
				<td><%=String.valueOf(rs.getInt(6))%></td>
				<td><%=String.valueOf(rs.getString(7))%></td>
				<td><%=String.valueOf(rs.getInt(8))%></td>
				<td><%=String.valueOf(rs.getInt(9))%></td>
				<td><%=String.valueOf(rs.getString(10))%></td>
				<td><%=String.valueOf(rs.getInt(11))%></td>
				<td><%=String.valueOf(rs.getString(12))%></td>
				<td><%=String.valueOf(rs.getString(13))%></td>
				<td><%=String.valueOf(rs.getString(14))%></td>
				<td><%=String.valueOf(rs.getString(15))%></td>
				<td><%=String.valueOf(rs.getString(16))%></td>
				<td><%=String.valueOf(rs.getString(17))%></td>
				<td><%=String.valueOf(rs.getString(18))%></td>
				<td><%=String.valueOf(rs.getString(19))%></td>
				<td><%=String.valueOf(rs.getInt(20))%></td>
				<td><%=String.valueOf(rs.getInt(21))%></td>
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