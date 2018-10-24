	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
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
<%@ page import="com.wingsinus.ep.cashtester" %>
<%@ page import="com.wingsinus.ep.StoryManager" %>
<%@ page import="com.wingsinus.ep.LogManager" %>
<%@ include file="GameVariable.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
	// test log
	PreparedStatement pstmt = null;
	Statement stmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	int Storyversion = 0;	
	try {
		
		pstmt = conn.prepareStatement("SELECT DATE_FORMAT(now(), '%Y-%m-%d');");
		stmt = conn.createStatement();
		
		String uid = request.getParameter("uid");
		
		rs = pstmt.executeQuery();

		rs = stmt.executeQuery("select storyversion from story_version limit 1");
		if(rs.next()){
			Storyversion = rs.getInt(1);
		}
		
		System.out.println("story version is :"+Storyversion);
		
		Calendar date = Calendar.getInstance();
		String strTime = date.get(Calendar.HOUR_OF_DAY) + ":" + date.get(Calendar.MINUTE) + ":" + date.get(Calendar.SECOND);
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String now = dateFormat.format(date.getTime());
		long millis = date.getTimeInMillis();
		
		JSONObject timeInObj = new JSONObject();
		System.out.println("------------------- SELECT 1 DATE -------------------");
		System.out.println(strTime);
		
		System.out.println("------------------- SELECT 2 DATE -------------------");
		System.out.println(now);
		
		System.out.println("------------------- SELECT 2 DATE -------------------");
		System.out.println(millis);
		
		while(rs.next()){
		//	key = rs.getInt("user_key");
			System.out.println("------------------- WHILE user_key -------------------");
		//	System.out.println(key);
		}
		
		String cmd = request.getParameter("cmd");
		
		if (cmd.equals("loadstory")){
			
			StoryManager.CheckStoryversion(Storyversion);
			
			ArrayList<StoryManager> stList = StoryManager.getDataAll();
	
			JSONArray retlist = new JSONArray();
			/*
			pstmt = conn.prepareStatement("select Story_id from user_story where UID = ?");
			pstmt.setString(1, uid);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				JSONObject data = new JSONObject();
				StoryManager tmp = StoryManager.getData(rs.getString(1));
				data.put("Story_id", tmp.Story_id);
				data.put("csvfilename", tmp.csvfilename);
				data.put("title", tmp.title);
				data.put("writer", tmp.writer);
				data.put("summary", tmp.summary);
				data.put("category_id", 10000);//category 10000 is my read
				data.put("imgname", tmp.imgname);
				data.put("recommend", tmp.recommend);
				data.put("totalcount", tmp.totalcount);
				retlist.add(data);
			}
			*/
			for(int i=0;i<stList.size();i++){
				JSONObject data = new JSONObject();
				StoryManager tmp = stList.get(i);
				int viewcount = 0;
				pstmt = conn.prepareStatement("select sum(readcount) from episoderead where Story_id = ?");
				pstmt.setString(1, tmp.Story_id);
				
				rs = pstmt.executeQuery();
				if(rs.next()){
					viewcount = rs.getInt(1);
				}
				
				data.put("Story_id", tmp.Story_id);
				data.put("csvfilename", tmp.csvfilename);
				data.put("title", tmp.title);
				data.put("writer", tmp.writer);
				data.put("summary", tmp.summary);
				data.put("category_id", tmp.category_id);
				data.put("imgname", tmp.imgname);
				data.put("recommend", tmp.recommend);
				data.put("totalcount", tmp.totalcount);
				data.put("director", tmp.diretor);
				data.put("viewcount", viewcount);
				retlist.add(data);
			}
			timeInObj.put("Story", retlist);
		}
		
		cashtester mydata = cashtester.getData("1000");
		timeInObj.put("score",mydata.score);
		timeInObj.put("rank",mydata.rank);
		timeInObj.put("season", mydata.season);
		timeInObj.put("server", mydata.server);
		timeInObj.put("time_now", now);
		timeInObj.put("time_millis", millis);
		//timeInObj.put("month", "0");
		//timeInObj.put("day", "0");
		
		//get user story load log
		LogManager.writeNorLog(uid, "success", cmd, "null","null", 0);
		out.print(timeInObj.toString());
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(stmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>