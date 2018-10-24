package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class StoryManager {
	//스토리 데이터 클래스
	//스토리 데이터 캐싱 및 전달 
	public String Story_id;
	public String csvfilename;
	public String title;
	public String writer;
	public String summary;
	public int category_id;
	public String imgname;
	public int recommend;
	public int totalcount;
	public String diretor;
	public static int nowversion = 0;
	
	private static ArrayList<StoryManager> list = null;
	
	private static HashMap<String,StoryManager> hash = null;
	
	public StoryManager(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select Story_id, csvfilename, title, writer, summary, category_id, imgname, recommend, totalcount, director from story order by sort");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				StoryManager data = new StoryManager();
				data.Story_id = rs.getString(idx++);
				data.csvfilename = rs.getString(idx++);
				data.title = rs.getString(idx++);
				data.writer = rs.getString(idx++);
				data.summary = rs.getString(idx++);
				data.category_id = rs.getInt(idx++);
				data.imgname = rs.getString(idx++);
				data.recommend = rs.getInt(idx++);
				data.totalcount = rs.getInt(idx++);
				data.diretor = rs.getString(idx++);
				list.add(data);
				hash.put(data.Story_id, data);
			}
		}
		finally{
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
			JdbcUtil.close(conn);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(hash == null||list == null){
			list = new ArrayList<StoryManager>();
			hash = new HashMap<String,StoryManager>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			StoryManagerReset();
		}
	}
	
	public static void StoryManagerReset(){
		list = null;
		hash = null;
	}
	
	public static StoryManager getData(String Story_id) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(Story_id);
	}
	
	public static ArrayList<StoryManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
	
}
