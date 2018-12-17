package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class PhotoPoseListData {
	public int photopageid;
	public int photoposeid;
	public static int nowversion = 0;
	
	private static ArrayList<PhotoPoseListData> list = null;
	
	public PhotoPoseListData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select photopageid,photoposeid from photoposelist");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				PhotoPoseListData data = new PhotoPoseListData();
				data.photopageid = rs.getInt(idx++);
				data.photoposeid = rs.getInt(idx++);
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
			list = new ArrayList<PhotoPoseListData>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			PhotoPoseListDataReset();
		}
	}
	
	public static void PhotoPoseListDataReset(){
		list = null;
	}
	
	public static ArrayList<PhotoPoseListData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null)
			return null;
		return list;
	}
}
