package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class ChlistManager {
	//캐릭터 리스트 클래스
	public String id;
	public String name;
	public String hid;
	public String bid;
	public String oid;
	public String portrait;
	
	private static ArrayList<ChlistManager> list = null;
	
	private static HashMap<String, ChlistManager> hash = null;
	
	public ChlistManager() {
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select id, name, hid, bid, oid, portrait from chlist");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				ChlistManager data = new ChlistManager();
				data.id = rs.getString(idx++);
				data.name = rs.getString(idx++);
				data.hid = rs.getString(idx++);
				data.bid = rs.getString(idx++);
				data.oid = rs.getString(idx++);
				data.portrait = rs.getString(idx++);
				list.add(data);
				hash.put(data.id, data);
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
			list = new ArrayList<ChlistManager>();
			hash = new HashMap<String,ChlistManager>();
			initData();
		}
	}
	
	public static void ChlistManagerReset(){
		list = null;
		hash = null;
	}
	
	public static ChlistManager getData(String id) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(id);
	}
	
	public static ArrayList<ChlistManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
}
