package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class shopManager {

	public int shop_id;
	public String type;
	public String title;
	public int price;
	public int gem;
	public int ticket;
	public String PID_android;
	public String PID_ios;
	public float price_ios;
	public static int nowversion = 0;
	
	private static ArrayList<shopManager> list = null;
	
	private static HashMap<Integer,shopManager> hash = null;
	
	public shopManager(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select id,type,title,price,gem,ticket,PID_android,PID_ios,price_ios from shop_item");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				shopManager data = new shopManager();
				data.shop_id = rs.getInt(idx++);
				data.type = rs.getString(idx++);
				data.title = rs.getString(idx++);
				data.price = rs.getInt(idx++);
				data.gem = rs.getInt(idx++);
				data.ticket = rs.getInt(idx++);
				data.PID_android = rs.getString(idx++);
				data.PID_ios = rs.getString(idx++);
				data.price_ios = rs.getFloat(idx++);
				list.add(data);
				hash.put(data.shop_id, data);
			}
		}
		finally{
			JdbcUtil.close(rs);
			JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(hash == null||list == null){
			list = new ArrayList<shopManager>();
			hash = new HashMap<Integer,shopManager>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			shopManagerReset();
		}
	}
	
	public static void shopManagerReset(){
		list = null;
		hash = null;
	}
	
	public static shopManager getData(int shop_id) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(shop_id);
	}
	
	public static ArrayList<shopManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
}
