package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class TutorialList {
	// 튜토리얼 리스트
	public String Story_id;
	public int episode_num;
	public String summary;
	public static int nowversion = 0;
	
	private static ArrayList<TutorialList> list = null;
	
	private static HashMap<String,TutorialList> hash = null;
	
	public TutorialList(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select Story_id, episode_num, summary from tutorial");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				TutorialList data = new TutorialList();
				data.Story_id = rs.getString(idx++);
				data.episode_num = rs.getInt(idx++);
				data.summary = rs.getString(idx++);
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
			list = new ArrayList<TutorialList>();
			hash = new HashMap<String,TutorialList>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			TutorialListReset();
		}
	}
	
	public static void TutorialListReset(){
		list = null;
		hash = null;
	}
	
	public static TutorialList getData(String Story_id) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(Story_id);
	}
	
	public static ArrayList<TutorialList> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
}
