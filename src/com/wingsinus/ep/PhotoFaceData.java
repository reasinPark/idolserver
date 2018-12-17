package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class PhotoFaceData {
	public int photofaceid;
	public String photofacename;
	public String thumbnail;
	public String photofaceaniname;
	public static int nowversion;
	
	private static ArrayList<PhotoFaceData> list = null;
	
	private static HashMap<Integer,PhotoFaceData> hash = null;
	
	public PhotoFaceData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select pfid,pfname,thumbnail,pfaniname from photoface");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				PhotoFaceData data = new PhotoFaceData();
				data.photofaceid = rs.getInt(idx++);
				data.photofacename = rs.getString(idx++);
				data.thumbnail = rs.getString(idx++);
				data.photofaceaniname = rs.getString(idx++);
				list.add(data);
				hash.put(data.photofaceid, data);
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null||hash == null){
			list = new ArrayList<PhotoFaceData>();
			hash = new HashMap<Integer,PhotoFaceData>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			PhotoFaceDataReset();
		}
	}
	
	public static void PhotoFaceDataReset(){
		list = null;
		hash = null;
	}
	
	public static PhotoFaceData getData(int pfid) throws SQLException{
		checkDataInit();
		if(hash == null||hash.size()<1){
			return null;
		}
		return hash.get(pfid);
	}
	
	public static ArrayList<PhotoFaceData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null||list.size()<1){
			return null;
		}
		return list;
	}
}
