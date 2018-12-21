package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class PhotobookData {
	public int photobookid;
	public String photobookname;
	public String col1;
	public String col1content;
	public String col2;
	public String col2content;
	public String col3;
	public String col3content;
	public String col4;
	public String col4content;
	public String col5;
	public String col5content;
	public int photopage1id;
	public int photopage2id;
	public int photopage3id;
	public String chid;
	public int chnum;
	public static int nowversion = 0;
	
	private static ArrayList<PhotobookData> list = null;
	
	private static HashMap<Integer,PhotobookData> hash = null;
	
	public PhotobookData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select photobookid,photobookname,col1,col1content,col2,col2content,col3,col3content,col4,col4content,col5,col5content,photopage1id,photopage2id,photopage3id,chid,chnum from photobook");			
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				PhotobookData data = new PhotobookData();
				data.photobookid = rs.getInt(idx++);
				data.photobookname = rs.getString(idx++);
				data.col1 = rs.getString(idx++);
				data.col1content = rs.getString(idx++);
				data.col2 = rs.getString(idx++);
				data.col2content = rs.getString(idx++);
				data.col3 = rs.getString(idx++);
				data.col3content = rs.getString(idx++);
				data.col4 = rs.getString(idx++);
				data.col4content = rs.getString(idx++);
				data.col5 = rs.getString(idx++);
				data.col5content = rs.getString(idx++);
				data.photopage1id = rs.getInt(idx++);
				data.photopage2id = rs.getInt(idx++);
				data.photopage3id = rs.getInt(idx++);
				data.chid = rs.getString(idx++);
				data.chnum = rs.getInt(idx++);
				list.add(data);
				hash.put(data.photobookid, data);
			}
			
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null ||hash == null){
			list = new ArrayList<PhotobookData>();
			hash = new HashMap<Integer,PhotobookData>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			PhotobookDataReset();
		}
	}
	
	public static void PhotobookDataReset(){
		list = null;
		hash = null;
	}
	
	public static PhotobookData getData(int ptid) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size()<1)
			return null;
		return hash.get(ptid);
	}
	
	public static ArrayList<PhotobookData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null||list.size()<1)
			return null;
		return list;
	}
}
