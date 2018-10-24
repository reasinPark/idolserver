<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@	page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@	page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%
	request.setCharacterEncoding("UTF-8");
	PreparedStatement pstmt = null;
	Statement stmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	String uid = request.getParameter("uid");
	try{
		if(uid != null){
			pstmt = conn.prepareStatement("select Story_id from story");
			rs = pstmt.executeQuery();
			ArrayList<String> slist = new ArrayList<String>();
			ArrayList<String> hlist = new ArrayList<String>();
			ArrayList<String> nlist = new ArrayList<String>();
			while(rs.next()){
				slist.add(rs.getString(1));
			}
			pstmt = conn.prepareStatement("select Story_id from user_story where uid = ?");
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery();
			while(rs.next()){
				hlist.add(rs.getString(1));
			}
			
			for(int i=0;i<slist.size();i++){
				boolean haveno = true;
				String sdata = slist.get(i);
				for(int j=0;j<hlist.size();j++){
					String udata = hlist.get(j);
					if(sdata.equals(udata)){
						haveno = false;
					}
				}
				if(haveno){
					nlist.add(sdata);
				}
			}
			for(int i=0;i<nlist.size();i++){
				String sid = nlist.get(i);
				pstmt = conn.prepareStatement("insert into user_story (UID,Story_id,Episode_num,dir_num,lately_num,buy_num) values(?,?,100,100,100,100)");
				pstmt.setString(1, uid);
				pstmt.setString(2, sid);
				pstmt.executeUpdate();
			}
			pstmt = conn.prepareStatement("update user_story set Episode_num = 100, buy_num = 100 where UID = ?");
			pstmt.setString(1, uid);
			pstmt.executeUpdate();			
			%>작업을 완료하였습니다.<%
		}else{
			%>입력하신 정보와 일치하는 유저를 찾을 수 없습니다. uid[<%=uid%>]<%
		}
	}catch(Exception e){
		%>
		데이터가 잘못 되었습니다. 입력을 다시 확인해 주세요. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(stmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>