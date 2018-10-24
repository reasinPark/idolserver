<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.Question" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;라이브 서비스</H2>
<section>
	<H3 style="font-size:100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;문의 내역 보기</H3>
</section>

<table border="1" style="border-style: solid;" width="90%">
	<tr>
		<td width="100%" height="200">
			<iframe name="result_frame" width="100%" height="200"></iframe>
		</td>
	</tr>
</table>

<%
	ArrayList<Question> list = new ArrayList<Question>();

	try {
		Connection conn = ConnectionProvider.getConnection("afgt");
		PreparedStatement pstmt = conn.prepareStatement("select idx, uid, email, subject, contents, date from question");
		ResultSet rs = pstmt.executeQuery();
				
		%>
		<table border="1" style="border-style:solid;">
			<tr>
				<td>idx</td>
				<td>uid</td>
				<td>email</td>
				<td>subject</td>
				<td>contents</td>
				<td>date</td>
			</tr>
		<%
		while(rs.next()) {
			Question ques = new Question();
			ques.idx = rs.getInt(1);
			ques.uid = rs.getString(2);
			ques.email = rs.getString(3);
			ques.subject = rs.getString(4);
			ques.contents = rs.getString(5);
			ques.date = String.valueOf(rs.getTimestamp(6));
			list.add(ques);
		}
		
		for(int i = list.size()-1;i>=0;i--) {
			%>
			<tr>
				<td><%=list.get(i).idx%></td>
				<td><%=list.get(i).uid%></td>
				<td><%=list.get(i).email%></td>
				<td><%=list.get(i).subject%></td>
				<td><%=list.get(i).contents%></td>
				<td><%=list.get(i).date%></td>
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