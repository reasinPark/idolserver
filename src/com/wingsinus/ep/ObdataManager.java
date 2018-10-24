package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class ObdataManager {
	public String id;
	public String type;
	public String name;
	public String texture;
	public String image;
	
	private static ArrayList<ObdataManager> list = null;
	
	private static HashMap<String,ObdataManager> hash = null;
	
	public ObdataManager(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select id, type, name, texture, image from obdata");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				ObdataManager data = new ObdataManager();
				data.id = rs.getString(idx++);
				data.type = rs.getString(idx++);
				data.name = rs.getString(idx++);
				data.texture = rs.getString(idx++);
				data.image = rs.getString(idx++);
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
			list = new ArrayList<ObdataManager>();
			hash = new HashMap<String,ObdataManager>();
			initData();
		}
	}
	
	public static void ObdataManagerReset(){
		list = null;
		hash = null;
	}
	
	public static ObdataManager getData(String id) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(id);
	}
	
	public static ArrayList<ObdataManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
}
