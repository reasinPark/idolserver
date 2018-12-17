package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class SpecialEpisodeManager {
	public int Specialid;
	public int epcondition;
	public String stcondition;
	public int cool;
	public int hot;
	public int cute;
	public String texture1;
	public String texture2;
	public String texture3;
	public String detailtitle;
	public String detailcontent;
	public static int nowversion = 0;
	
	private static ArrayList<SpecialEpisodeManager> list = null;
	
	private static HashMap<Integer,SpecialEpisodeManager> hash = null;
	
	public SpecialEpisodeManager(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select Specialid,epcondition,stcondition,cool,hot,cute,texture1,texture2,texture3,detailtitle,detailcontent from specialepisode");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				SpecialEpisodeManager data = new SpecialEpisodeManager();
				data.Specialid = rs.getInt(idx++);
				data.epcondition = rs.getInt(idx++);
				data.stcondition = rs.getString(idx++);
				data.cool = rs.getInt(idx++);
				data.hot = rs.getInt(idx++);
				data.cute = rs.getInt(idx++);
				data.texture1 = rs.getString(idx++);
				data.texture2 = rs.getString(idx++);
				data.texture3 = rs.getString(idx++);
				data.detailtitle = rs.getString(idx++);
				data.detailcontent = rs.getString(idx++);
				list.add(data);
				hash.put(data.Specialid, data);
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null||hash == null){
			list = new ArrayList<SpecialEpisodeManager>();
			hash = new HashMap<Integer,SpecialEpisodeManager>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			SpecialEpisodeReset();
		}
	}
	
	public static void SpecialEpisodeReset(){
		list = null;
		hash = null;
	}
	
	public static SpecialEpisodeManager getData(int spid) throws SQLException{
		checkDataInit();
		if(hash == null||hash.size()<1)
			return null;
		return hash.get(spid);
	}
	
	public static ArrayList<SpecialEpisodeManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
}
