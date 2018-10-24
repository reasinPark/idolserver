package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class SoundtableManager {
	public String soundid;
	public float timer;
	
	private static ArrayList<SoundtableManager> list = null;
	
	private static HashMap<String,SoundtableManager> hash = null;
	
	public SoundtableManager(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select soundid, timer from soundtable");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				SoundtableManager data = new SoundtableManager();
				data.soundid = rs.getString(idx++);
				data.timer = rs.getFloat(idx++);
				list.add(data);
				hash.put(data.soundid, data);
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
			list = new ArrayList<SoundtableManager>();
			hash = new HashMap<String,SoundtableManager>();
			initData();
		}
	}
	
	public static void SoundtableManagerReset(){
		list = null;
		hash = null;
	}
	
	public static SoundtableManager getData(String soundid) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(soundid);
	}
	
	public static ArrayList<SoundtableManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
}
