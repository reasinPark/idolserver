package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class PhotopageData {
	public int photopageid;
	public String thumbnail;
	public String mainimg;
	public String name;
	public static int nowversion = 0;
	
	private static ArrayList<PhotopageData> list = null;
	
	private static HashMap<Integer,PhotopageData> hash = null;
	
	public PhotopageData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select photopageid,thumbnail,mainimg,name from photopage");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				PhotopageData data = new PhotopageData();
				data.photopageid = rs.getInt(idx++);
				data.thumbnail = rs.getString(idx++);
				data.mainimg = rs.getString(idx++);
				data.name = rs.getString(idx++);
				list.add(data);
				hash.put(data.photopageid, data);
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null || hash == null){
			list = new ArrayList<PhotopageData>();
			hash = new HashMap<Integer,PhotopageData>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			PhotopageDataReset();
		}
	}
	
	public static void PhotopageDataReset(){
		list = null;
		hash = null;
	}
	
	public static PhotopageData getData(int ptid) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size()<1)
			return null;
		return hash.get(ptid);
	}
	
	public static ArrayList<PhotopageData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null||list.size()<1)
			return null;
		return list;
	}
}
