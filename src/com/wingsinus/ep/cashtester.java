package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

public class cashtester {
	public String uid;
	public int score;
	public int rank;
	public int season;
	public int server;
	
	private static HashMap<String,cashtester> hash = null;
	
	public cashtester(){		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			Connection conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select uid,score,rank,season from admin_ranksummary");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				cashtester data = new cashtester();
				data.uid = rs.getString(idx++);
				data.score = rs.getInt(idx++);
				data.rank = rs.getInt(idx++);
				data.season = rs.getInt(idx++);
				hash.put(data.uid, data);
			}
		}
		finally{
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(hash == null){
			hash = new HashMap<String,cashtester>();
			initData();
		}
	}
	
	public static void cashreset(){
		hash = null;
	}
	
	public static cashtester getData(String uid) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(uid);
	}
}
