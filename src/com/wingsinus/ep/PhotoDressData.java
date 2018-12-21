package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class PhotoDressData {
	public int photodressid;
	public String photodressname;
	public String thumbnail;
	public String pdbodyfile;
	public String pdbodyskin;
	public String pdarmfile;
	public String pdarmskin;
	public String pdheadfile;
	public String pdheadskin;
	public String pdhairfile;
	public String pdhairskin;
	public int selectitemid;
	public static int nowversion;
	
	private static ArrayList<PhotoDressData> list = null;
	
	private static HashMap<Integer,PhotoDressData> hash = null;
	
	public PhotoDressData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("idol");
			
			pstmt = conn.prepareStatement("select pdid,pdname,thumbnail,pdbodyfile,pdbodyskin,pdarmfile,pdarmskin,pdheadfile,pdheadskin,pdhairfile,pdhairskin,selectitemid from photodress");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int idx = 1;
				PhotoDressData data = new PhotoDressData();
				data.photodressid = rs.getInt(idx++);
				data.photodressname = rs.getString(idx++);
				data.thumbnail = rs.getString(idx++);
				data.pdbodyfile = rs.getString(idx++);
				data.pdbodyskin = rs.getString(idx++);
				data.pdarmfile = rs.getString(idx++);
				data.pdarmskin = rs.getString(idx++);
				data.pdheadfile = rs.getString(idx++);
				data.pdheadskin = rs.getString(idx++);
				data.pdhairfile = rs.getString(idx++);
				data.pdhairskin = rs.getString(idx++);
				data.selectitemid = rs.getInt(idx++);
				list.add(data);
				hash.put(data.photodressid, data);
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null||hash == null){
			list = new ArrayList<PhotoDressData>();
			hash = new HashMap<Integer,PhotoDressData>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			PhotoDressDataReset();
		}
	}
	
	public static void PhotoDressDataReset(){
		list = null;
		hash = null;
	}
	
	public static PhotoDressData getData(int pdid) throws SQLException{
		checkDataInit();
		if(hash == null||hash.size()<1){
			return null;
		}
		return hash.get(pdid);
	}
	
	public static ArrayList<PhotoDressData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null||list.size()<1){
			return null;
		}
		return list;
	}
	
}
