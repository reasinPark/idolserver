package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class ItemDataManager {
	public int itemid;
	public String name;
	public String Story_id;
	public int scope;
	public String img;
	public static int nowversion = 0;
	
	private static ArrayList<ItemDataManager> list = null;
	
	private static HashMap<Integer,ItemDataManager> hash = null;
	
	public ItemDataManager(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select itemid,name,Story_id,scope,img from itemdata");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				ItemDataManager data = new ItemDataManager();
				data.itemid = rs.getInt(idx++);
				data.name = rs.getString(idx++);
				data.Story_id = rs.getString(idx++);
				data.scope = rs.getInt(idx++);
				data.img = rs.getString(idx++);
				list.add(data);
				hash.put(data.itemid, data);
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null||hash == null){
			list = new ArrayList<ItemDataManager>();
			hash = new HashMap<Integer, ItemDataManager>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			ItemDataReset();
		}
	}
	
	public static void ItemDataReset(){
		list = null;
		hash = null;
	}
	
	public static ArrayList<ItemDataManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
	
	public static ItemDataManager getData(int itemId) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1){
			return null;
		}
		return hash.get(itemId);
	}
}
