<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;csv 파일 적용</H2>
<section>
	<H3 style="font-size:100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;코스튬 데이터</H3>
</section>

<form target="result_frame" action="csvupload_costumedata_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 적용할 costumedata.csv 파일 </td>
			<td><input type="file" name="costumedata" /></td>
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
		PreparedStatement pstmt = conn.prepareStatement("select CostumeId, CallId, ChId, Skinname, filename, thumnailname, selectani, buyani, description, cash, " + 
														"name, episodeid, storyid, viewingame, BFilename, BSkinname, FFilename, FSkinname, HFilename, HSkinname, " +
														"AFilename, ASkinname from CostumeData");
		ResultSet rs = pstmt.executeQuery();
				
		%>
		<H2 style="font-size:20">&nbsp;&nbsp;&nbsp;&nbsp;현재 DB</H2>
		<table border="1" style="border-style:solid;">
			<tr>
				<td>CostumeId</td>
				<td>CallId</td>
				<td>ChId</td>
				<td>Skinname</td>
				<td>filename</td>
				<td>thumnailname</td>
				<td>selectani</td>
				<td>buyani</td>
				<td>description</td>
				<td>cash</td>
				<td>name</td>
				<td>episodeid</td>
				<td>storyid</td>
				<td>viewingame</td>
				<td>BFilename</td>
				<td>BSkinname</td>
				<td>FFilename</td>
				<td>FSkinname</td>
				<td>HFilename</td>
				<td>HSkinname</td>
				<td>AFilename</td>
				<td>ASkinname</td>
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
				<td><%=String.valueOf(rs.getInt(10))%></td>
				<td><%=String.valueOf(rs.getString(11))%></td>
				<td><%=String.valueOf(rs.getInt(12))%></td>
				<td><%=String.valueOf(rs.getString(13))%></td>
				<td><%=String.valueOf(rs.getInt(14))%></td>
				<td><%=String.valueOf(rs.getString(15))%></td>
				<td><%=String.valueOf(rs.getString(16))%></td>
				<td><%=String.valueOf(rs.getString(17))%></td>
				<td><%=String.valueOf(rs.getString(18))%></td>
				<td><%=String.valueOf(rs.getString(19))%></td>
				<td><%=String.valueOf(rs.getString(20))%></td>
				<td><%=String.valueOf(rs.getString(21))%></td>
				<td><%=String.valueOf(rs.getString(22))%></td>
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