package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class PhotoEffectData {
	public int photoeffectid;
	public String photoeffectname;
	public String thumbnail;
	public int type;
	public String objname;
	public static int nowversion = 0;
	
	private static ArrayList<PhotoEffectData> list = null;
	
	private static HashMap<Integer,PhotoEffectData> hash = null;
	
	public PhotoEffectData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select peid,pename,thumbnail,petype,peobjname from photoeffect");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				PhotoEffectData data = new PhotoEffectData();
				data.photoeffectid = rs.getInt(idx++);
				data.photoeffectname = rs.getString(idx++);
				data.thumbnail = rs.getString(idx++);
				data.type = rs.getInt(idx++);
				data.objname = rs.getString(idx++);
				list.add(data);
				hash.put(data.photoeffectid, data);
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null||hash == null){
			list = new ArrayList<PhotoEffectData>();
			hash = new HashMap<Integer,PhotoEffectData>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			PhotoEffectDataReset();
		}
	}
	
	public static void PhotoEffectDataReset(){
		list = null;
		hash = null;
	}
	
	public static PhotoEffectData getData(int peid) throws SQLException{
		checkDataInit();
		if(hash == null|| hash.size()<1)
			return null;
		return hash.get(peid);
	}
	
	public static ArrayList<PhotoEffectData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null||list.size()<1)
			return null;
		return list;
	}
}
