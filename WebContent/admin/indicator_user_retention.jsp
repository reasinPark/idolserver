<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.AdminDateCount" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2,7,30일자 리텐션</H2>
<section>
	<H3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전일자/6일전/29일전 로그인 유저중 해당 날짜 로그인한 유니크 유저 숫자</H3>
</section>
	<%
	String filepath = "";
	String filename = "";
	FileWriter fw = null;
	String lastweek = "";
	String today = "";
	
	//mysql
	PreparedStatement pstmt = null;
	Connection conn = null;
	ResultSet rs = null;

	String type = request.getParameter("type");
	String startdate = request.getParameter("startdate");
	String enddate = request.getParameter("enddate");
	boolean isfirst = false;

	conn = ConnectionProvider.getConnection("afgt");
	pstmt = conn.prepareStatement("select date_format(date_add(now(), interval -7 day),'%Y-%m-%d'),date_format(now(),'%Y-%m-%d')");
	rs = pstmt.executeQuery();
	
	if(rs.next()) {
		lastweek = rs.getString(1);
		today = rs.getString(2);
	}
	
	if((startdate!=null) && (enddate!=null)) {
		isfirst = true;
	}
	
	%>

	<form action="indicator_user_retention.jsp" method="post">
		<table border = "1" style="border-style:solid;">
			<tr>
				<td> 시작 날짜 </td>
				<td><input type="date" id="startdate" name="startdate" value="<%=((isfirst)? startdate : lastweek)%>" /></td>
			</tr>
			<tr>
				<td> 끝 날짜 </td>
				<td><input type="date" id="enddate" name="enddate" value="<%=((isfirst)? enddate : today)%>" /></td>
			</tr>
			<tr>
				<td colspan = "2" align="center">
				<input type="submit" value="검색" /> </td>
			</tr>
		</table>
		<input type="hidden" name="type" value="retention">
	</form>

	<%
	
	try {
		if(type != null) {
			%>	
			<tr>
				<td> csv로 다운받기 </td>
			</tr>
			
			<form action="csvfiledownload.jsp" method="post">
				<input type="hidden" name="filename" value="user_retention">
				<input type ="submit" value ="다운로드">
			</form>
			
			<%
			ArrayList<AdminDateCount> list = new ArrayList<AdminDateCount>();
			
			// test
			if(ConnectionProvider.afgt_build_ver == 0) {
				filepath = "/usr/share/tomcat6/webapps/tempcsv/";
			}
			// live
			else if(ConnectionProvider.afgt_build_ver == 1) {
				filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
			}
			
			filename = "user_retention.csv";
			fw = new FileWriter(filepath+filename);
			
			conn = ConnectionProvider.getConnection("logdb");
			
			pstmt = conn.prepareStatement("select date_format(date, '%Y-%m-%d'), day1, day1n0, day6, day6n0, day29, day29n0 from user_retention where date between " +
										  "? and ?");
			Timestamp start = Timestamp.valueOf(startdate + " 00:00:00");
			Timestamp end = Timestamp.valueOf(enddate + " 23:59:59");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();

			fw.append("기준일");
			fw.append(',');
			fw.append("DAY2");
			fw.append(',');
			fw.append("DAY7");
			fw.append(',');
			fw.append("DAY30");
			fw.append('\n');
			
			%>
			<table border="1" style="border-style:solid;">
				<tr>
					<td>기준일</td>
					<td>DAY2</td>
					<td>DAY7</td>
					<td>DAY30</td>
				</tr>
			<%
			
			while(rs.next()) {
				String date = String.valueOf(rs.getString(1));
				String day2 = "";
				String day7 = "";
				String day30 = "";
				
				if(Double.isNaN(rs.getFloat(3)/rs.getFloat(2))) {
					day2 = "0";
				}
				else {
					day2 = String.format("%.2f", rs.getFloat(3)/rs.getFloat(2));
				}
				
				if(Double.isNaN(rs.getFloat(5)/rs.getFloat(4))) {
					day7 = "0";
				}
				else {
					day7 = String.format("%.2f", rs.getFloat(5)/rs.getFloat(4));
				}
				
				if(Double.isNaN(rs.getFloat(7)/rs.getFloat(6))) {
					day30 = "0";
				}
				else {
					day30 = String.format("%.2f", rs.getFloat(7)/rs.getFloat(6));
				}
				
				fw.append(date);
				fw.append(',');
				fw.append(day2);
				fw.append(',');
				fw.append(day7);
				fw.append(',');
				fw.append(day30);
				fw.append('\n');
				
				%>
				<tr>
					<td><%=date%></td>
					<td><%=day2%></td>
					<td><%=day7%></td>
					<td><%=day30%></td>
				</tr>
				<%
				
			}
			
			%>
			</table>
			<%
			
			fw.flush();
			fw.close();
		}
	}
	catch(Exception e) {
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