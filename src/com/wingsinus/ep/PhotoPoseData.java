package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class PhotoPoseData {
	public int photoposeid;
	public String photoposename;
	public String thumbnail;
	public String photoposeaniname;
	public static int nowversion = 0;
	
	private static ArrayList<PhotoPoseData> list = null;
	
	private static HashMap<Integer,PhotoPoseData> hash = null;
	
	public PhotoPoseData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select ppid,ppname,thumbnail,ppaniname from photopose");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				PhotoPoseData data = new PhotoPoseData();
				data.photoposeid = rs.getInt(idx++);
				data.photoposename = rs.getString(idx++);
				data.thumbnail = rs.getString(idx++);
				data.photoposeaniname = rs.getString(idx++);
				list.add(data);
				hash.put(data.photoposeid, data);
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null||hash == null){
			list = new ArrayList<PhotoPoseData>();
			hash = new HashMap<Integer,PhotoPoseData>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			PhotoPoseDataReset();
		}
	}
	
	public static void PhotoPoseDataReset(){
		list = null;
		hash = null;
	}
	
	public static PhotoPoseData getData(int ppid) throws SQLException{
		checkDataInit();
		if(hash == null||hash.size()<1)
			return null;
		return hash.get(ppid);
	}
	
	public static ArrayList<PhotoPoseData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null||list.size()<1)
			return null;
		return list;
	}
}
