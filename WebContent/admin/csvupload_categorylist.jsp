<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
   
<H2>&nbsp;&nbsp;&nbsp;&nbsp;csv 파일 적용</H2>
<section>
	<H3 style="font-size:100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;카테고리 데이터</H3>
</section>

<form target="result_frame" action="csvupload_categorylist_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 적용할 categorylist.csv 파일 </td>
			<td><input type="file" name="categorylist" /></td>
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
		PreparedStatement pstmt = conn.prepareStatement("select category_id, categoryname, ordernum from categorylist");
		ResultSet rs = pstmt.executeQuery();
				
		%>
		<H2 style="font-size:20">&nbsp;&nbsp;&nbsp;&nbsp;현재 DB</H2>
		<table border="1" style="border-style:solid;">
			<tr>
				<td>category_id</td>
				<td>categoryname</td>
				<td>ordernum</td>
			</tr>
		<%
		while(rs.next()) {
		%>
			<tr>
				<td><%=String.valueOf(rs.getInt(1))%></td>
				<td><%=String.valueOf(rs.getString(2))%></td>
				<td><%=String.valueOf(rs.getInt(3))%></td>
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