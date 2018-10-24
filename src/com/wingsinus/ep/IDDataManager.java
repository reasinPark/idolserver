package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class IDDataManager {
	public String keyname;
	public String id;
	public static int nowversion = 0;
	
	private static ArrayList<IDDataManager> list = null;
	
	public IDDataManager(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select keyname,id from id_data");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				IDDataManager data = new IDDataManager();
				data.keyname = rs.getString(idx++);
				data.id = rs.getString(idx++);
				list.add(data);
			}
		}finally{
			JdbcUtil.close(rs);
			JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list==null){
			list = new ArrayList<IDDataManager>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			IDDataReset();
		}
	}
	
	public static void IDDataReset(){
		list = null;
	}
	
	public static ArrayList<IDDataManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null||list.size() < 1)
			return null;
		return list;
	}
}
