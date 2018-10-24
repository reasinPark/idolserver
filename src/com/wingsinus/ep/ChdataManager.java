package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class ChdataManager {
	//캐릭터 데이터 클래스
	public String id;
	public String type;
	public String spinename;
	public String skinname;
	public String describe;
	
	private static ArrayList<ChdataManager> list = null;
	
	private static HashMap<String, ChdataManager> hash = null;
	
	public ChdataManager() {
		
	}
	
	private static void initData() throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select id, type, spinename, skinname, `describe` from chdata");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				ChdataManager data = new ChdataManager();
				data.id = rs.getString(idx++);
				data.type = rs.getString(idx++);
				data.spinename = rs.getString(idx++);
				data.skinname = rs.getString(idx++);
				data.describe = rs.getString(idx++);
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
			list = new ArrayList<ChdataManager>();
			hash = new HashMap<String,ChdataManager>();
			initData();
		}
	}
	
	public static void ChdataManagerReset(){
		list = null;
		hash = null;
	}
	
	public static ChdataManager getData(String id) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(id);
	}
	
	public static ArrayList<ChdataManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
}
