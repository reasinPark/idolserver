package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class PhotoDressListData {
	public int photopageid;
	public int photodressid;
	public static int nowversion = 0;
	
	private static ArrayList<PhotoDressListData> list = null;
	
	public PhotoDressListData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select photopageid,photodressid from photodresslist");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				PhotoDressListData data = new PhotoDressListData();
				data.photopageid = rs.getInt(idx++);
				data.photodressid = rs.getInt(idx++);
//				System.out.println("page id is :"+data.photopageid+", dress id is :"+data.photodressid);
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
			list = new ArrayList<PhotoDressListData>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			PhotoDressListDataReset();
		}
	}
	
	public static void PhotoDressListDataReset(){
		list = null;
	}
	
	public static ArrayList<PhotoDressListData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null)
			return null;
		return list;
	}
}
