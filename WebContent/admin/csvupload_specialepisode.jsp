<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*"%>
<%@ page import="com.wingsinus.ep.ConnectionProvider"%>
<%@ page import="com.wingsinus.ep.JdbcUtil"%>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;csv 파일 적용</H2>
<section>
	<H3 style="font-size:100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;스페셜 에피소드 데이터</H3>
</section>

<form target="result_frame" action="csvupload_specialepisode_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 적용할 specialepisode.csv 파일 </td>
			<td><input type="file" name="specialepisode"/></td>
		</tr>
		<tr>
			<td colspan = "2" align = "center">
			<input type="submit" value="적용하긔"/></td>
		</tr>
	</table>
</form>
<table border="1" style="border-style:solid;" width="90%">
	<tr>
		<td width="100%" height="200">
			<iframe name="result_frame" width="100%" height="200"></iframe>
		</td>
	</tr>
</table>

<%
	try{
		Connection conn = ConnectionProvider.getConnection("idol");
		PreparedStatement pstmt = conn.prepareStatement("select Specialid,epcondition,stcondition,cool,hot,cute,texture1,texture2,texture3,detailtitle,detailcontent from specialepisode");
		
		
		ResultSet rs = pstmt.executeQuery();
		
		%>
		<H2 style="font-size:20">&nbsp;&nbsp;&nbsp;&nbsp;현재 DB</H2>
		<table border="1" style="border-style:solid;">
			<tr>
				<td>SpecialId</td>
				<td>epcondition</td>
				<td>stcondition</td>
				<td>cool</td>
				<td>hot</td>
				<td>cute</td>
				<td>texture1</td>
				<td>texture2</td>
				<td>texture3</td>
				<td>detailtitle</td>
				<td>detailcontent</td>
			</tr>
		<%
		while(rs.next()){
		%>
			<tr>
				<td><%=String.valueOf(rs.getInt(1)) %></td>
				<td><%=String.valueOf(rs.getInt(2)) %></td>
				<td><%=String.valueOf(rs.getString(3)) %></td>
				<td><%=String.valueOf(rs.getInt(4)) %></td>
				<td><%=String.valueOf(rs.getInt(5)) %></td>
				<td><%=String.valueOf(rs.getInt(6)) %></td>
				<td><%=String.valueOf(rs.getString(7)) %></td>
				<td><%=String.valueOf(rs.getString(8)) %></td>
				<td><%=String.valueOf(rs.getString(9)) %></td>
				<td><%=String.valueOf(rs.getString(10)) %></td>
				<td><%=String.valueOf(rs.getString(11)) %></td>
			</tr>
		<%
		}
		%>
		</table>
		<%
	}catch(Exception e){
		%>
		다시 확인해 주세요. error!<br>
		<%=e.toString() %><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	}finally{
		
	}
%>