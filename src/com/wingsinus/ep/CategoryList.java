package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class CategoryList {
	//카테고리 리스트
	public int category_id;
	public String category_name;
	public int ordernum;
	public static int nowversion = 0;
	
	private static ArrayList<CategoryList> list = null;
	
	private static HashMap<Integer,CategoryList> hash = null;
	
	public CategoryList(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select category_id,categoryname,ordernum from categorylist where ordernum > 0 order by ordernum");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				CategoryList data = new CategoryList();
				data.category_id = rs.getInt(idx++);
				data.category_name = rs.getString(idx++);
				data.ordernum = rs.getInt(idx++);
				list.add(data);
				hash.put(data.category_id, data);
			}
		}finally{
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
			JdbcUtil.close(conn);
		}
	}
		
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null||hash == null){
			list = new ArrayList<CategoryList>();
			hash = new HashMap<Integer,CategoryList>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			CategoryReset();
		}
	}
	
	public static void CategoryReset(){
		list = null;
		hash = null;
	}
	
	public static CategoryList getData(int Category_id) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(Category_id);
	}
	
	public static ArrayList<CategoryList> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
	
}
