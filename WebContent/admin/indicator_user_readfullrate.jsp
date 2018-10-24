<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.AdminStory" %>
<%@ page import="com.wingsinus.ep.AdminStoryReadCount" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;완독률</H2>
<section>
	<H3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(해당 이야기 마지막화를 완료 한 유니크 합)/(해당 이야기 1화를 1컷이라도 읽은 유니크 합)</H3>
</section>
	<%
	
	//mysql
	PreparedStatement pstmt = null;
	Connection conn = null;
	ResultSet rs = null;

	boolean isfirst = false;
	
	conn = ConnectionProvider.getConnection("afgt");
	
	try {			
			ArrayList<AdminStoryReadCount> list = new ArrayList<AdminStoryReadCount>();					// 해당 이야기를 1화를 1컷이라도 읽은 유니크 정보 리스트
			ArrayList<AdminStoryReadCount> maxlist = new ArrayList<AdminStoryReadCount>();				// 이야기 마다 최종화 정보 리스트
			ArrayList<AdminStoryReadCount> mylist = new ArrayList<AdminStoryReadCount>();				// 해당 이야기 마지막화를 완료한 유니크 정보 리스트
			
			pstmt = conn.prepareStatement("select Story_id,count(UID) from user_story where buy_num >= 1 and view_date >= '2018-09-04 11:00:00' group by Story_id");
			rs = pstmt.executeQuery();
			while(rs.next()) {
				AdminStoryReadCount data = new AdminStoryReadCount();
				data.storyid = rs.getString(1);
				data.count = rs.getInt(2);
				
				list.add(data);
			}
			
			pstmt = conn.prepareStatement("select Story_id, max(episode_num) from episode group by Story_id;");
			rs = pstmt.executeQuery();
			while(rs.next()) {
				AdminStoryReadCount data = new AdminStoryReadCount();
				data.storyid = rs.getString(1);
				data.count = rs.getInt(2);
				
				maxlist.add(data);
				
				AdminStoryReadCount data2 = new AdminStoryReadCount();
				data2.storyid = rs.getString(1);
				data2.count = 0;
				
				mylist.add(data2);
			}
			
			for(int i=0;i<maxlist.size();i++) {
				pstmt = conn.prepareStatement("select count(UID) from user_story where Episode_num = ? and Story_id = ? and view_date >= '2018-09-04 11:00:00'");
				pstmt.setInt(1, maxlist.get(i).count);
				pstmt.setString(2, maxlist.get(i).storyid);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					mylist.get(i).count = rs.getInt(1);
				}
			}
			
			%>
			<table border="1" style="border-style:solid;">
				<tr>
					<td>스토리명</td>
					<td>최종화까지 본 유저 수</td>
					<td>첫 화를 보기 시작한 유저 수</td>
				</tr>
			<%
			
			for(int i=0;i<mylist.size();i++) {
				%>
				<tr>
					<td><%=mylist.get(i).storyid%></td>
					<td><%=mylist.get(i).count%></td>
					<td><%=list.get(i).count%></td>
				</tr>
				<%
			}
			
			%>
			</table>
			<%
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