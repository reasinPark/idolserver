<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;csv 파일 적용</H2>
<section>
	<H3 style="font-size:100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;화보북 데이터</H3>
</section>

<form target="result_frame" action="csvupload_photobook_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 적용할 photobook.csv 파일 </td>
			<td><input type="file" name="photobook" /></td>
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
		PreparedStatement pstmt = conn.prepareStatement("select photobookid,photobookname,col1,col1content,col2,col2content,col3,col3content,col4,col4content,col5,col5content,photopage1id,photopage2id,photopage3id,chid,chnum from photobook");
		ResultSet rs = pstmt.executeQuery();
				
		%>
		<H2 style="font-size:20">&nbsp;&nbsp;&nbsp;&nbsp;현재 DB</H2>
		<table border="1" style="border-style:solid;">
			<tr>
				<td>photobookid</td>
				<td>photobookname</td>
				<td>col1</td>
				<td>col1content</td>
				<td>col2</td>
				<td>col2content</td>
				<td>col3</td>
				<td>col3content</td>
				<td>col4</td>
				<td>col4content</td>
				<td>col5</td>
				<td>col5content</td>
				<td>photopage1id</td>
				<td>photopage2id</td>
				<td>photopage3id</td>
				<td>chid</td>
				<td>chnum</td>
			</tr>
		<%
		while(rs.next()) {
		%>
			<tr>
				<td><%=String.valueOf(rs.getInt(1))%></td>
				<td><%=String.valueOf(rs.getString(2))%></td>
				<td><%=String.valueOf(rs.getString(3))%></td>
				<td><%=String.valueOf(rs.getString(4))%></td>
				<td><%=String.valueOf(rs.getString(5))%></td>
				<td><%=String.valueOf(rs.getString(6))%></td>
				<td><%=String.valueOf(rs.getString(7))%></td>
				<td><%=String.valueOf(rs.getString(8))%></td>
				<td><%=String.valueOf(rs.getString(9))%></td>
				<td><%=String.valueOf(rs.getString(10))%></td>
				<td><%=String.valueOf(rs.getString(11))%></td>
				<td><%=String.valueOf(rs.getString(12))%></td>
				<td><%=String.valueOf(rs.getInt(13))%></td>
				<td><%=String.valueOf(rs.getInt(14))%></td>
				<td><%=String.valueOf(rs.getInt(15))%></td>
				<td><%=String.valueOf(rs.getString(16))%></td>
				<td><%=String.valueOf(rs.getInt(17))%></td>
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