package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class PhotoFaceListData {
	public int photopageid;
	public int photofaceid;
	public static int nowversion;
	
	private static ArrayList<PhotoFaceListData> list = null;
	
	private static HashMap<Integer,PhotoFaceListData> hash = null;
	
	public PhotoFaceListData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select photopageid,photofaceid from photofacelist");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				PhotoFaceListData data = new PhotoFaceListData();
				data.photopageid = rs.getInt(idx++);
				data.photofaceid = rs.getInt(idx++);
				list.add(data);				
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null){
			list = new ArrayList<PhotoFaceListData>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			PhotoFaceListDataReset();
		}
	}
	
	public static void PhotoFaceListDataReset(){
		list = null;
	}
	
	public static ArrayList<PhotoFaceListData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null)
			return null;
		return list;
	}
}
