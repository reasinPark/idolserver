<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.AdminCostume" %>
<%@ page import="com.wingsinus.ep.AdminStory" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;룰렛 아이템별 획득 횟수</H2>
<section>
	<H3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;룰렛 아이템별 획득 횟수</H3>
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

	conn = ConnectionProvider.getConnection("logdb");
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

	<form action="indicator_user_roulettecount.jsp" method="post">
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
		<input type="hidden" name="type" value="roulettecount">
	</form>

	<%
	
	try {
		if(type != null) {
			%>	
			<tr>
				<td> csv로 다운받기 </td>
			</tr>
			
			<form action="csvfiledownload.jsp" method="post">
				<input type="hidden" name="filename" value="user_roulettecount">
				<input type ="submit" value ="다운로드">
			</form>
			
			<%
			ArrayList<AdminCostume> list = new ArrayList<AdminCostume>();
			
			// test
			if(ConnectionProvider.afgt_build_ver == 0) {
				filepath = "/usr/share/tomcat6/webapps/tempcsv/";
			}
			// live
			else if(ConnectionProvider.afgt_build_ver == 1) {
				filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
			}
			
			filename = "user_roulettecount.csv";
			fw = new FileWriter(filepath+filename);

			pstmt = conn.prepareStatement("select date_format(regdate, '%Y-%m-%d') m, itemidx from info_roulette where regdate between ? and ?");

			Timestamp start = Timestamp.valueOf(startdate + " 00:00:00");
			Timestamp end = Timestamp.valueOf(enddate + " 23:59:59");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				AdminCostume ac = new AdminCostume();
				ac.date = rs.getString(1);
				ac.costumeid = rs.getInt(2);
				ac.count = 0;
				list.add(ac);
			}
			
			pstmt = conn.prepareStatement("select date_format(regdate, '%Y-%m-%d'),itemidx,count from user_roulettecount where regdate between ? and ?");
			pstmt.setTimestamp(1, start);
			pstmt.setTimestamp(2, end);
			rs = pstmt.executeQuery();

			fw.append("날짜");
			fw.append(',');
			fw.append("룰렛 아이템 ID");
			fw.append(',');
			fw.append("획득 횟수");
			fw.append('\n');
			
			%>
			<table border="1" style="border-style:solid;">
				<tr>
					<td>날짜</td>
					<td>룰렛 아이템 ID</td>
					<td>획득 횟수</td>
				</tr>
			<%
			
			while(rs.next()) {
				String date = rs.getString(1);
				int itemidx = rs.getInt(2);
				int count = rs.getInt(3);
				
				for(int i = 0; i<list.size();i++) {
					if(list.get(i).date.equals(date) && (list.get(i).costumeid == itemidx)) {
						list.get(i).count = count;
						break;
					}
				}
			}
						
			for(int i = 0; i<list.size();i++) {
				fw.append(list.get(i).date);
				fw.append(',');
				fw.append(String.valueOf(list.get(i).costumeid));
				fw.append(',');
				fw.append(String.valueOf(list.get(i).count));
				fw.append('\n');
				
				%>
				<tr>
					<td><%=list.get(i).date%></td>
					<td><%=list.get(i).costumeid%></td>
					<td><%=list.get(i).count%></td>
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