package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class SelectItemData {
	public int SelectId;
	public String StoryId;
	public int Price;
	public int Epinum;
	public static int nowversion;
	
	private static ArrayList<SelectItemData> list = null;
	
	public SelectItemData(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select selectid,price,storyid,epinum from SelectItem");
			
			rs = pstmt.executeQuery();
			System.out.println("get select item");
			while(rs.next()){
				int idx = 1;
				SelectItemData data = new SelectItemData();
				System.out.println("get select item in to while");
				data.SelectId = rs.getInt(idx++);
				System.out.println("test sel id "+data.SelectId);
				data.Price = rs.getInt(idx++);
				System.out.println("price is :"+data.Price);
				data.StoryId = rs.getString(idx++);
				System.out.println("story id is :"+data.StoryId);
				data.Epinum = rs.getInt(idx++);
				System.out.println("data from class cash is :"+data.SelectId+","+data.Price+", "+data.StoryId+","+data.Epinum);
				list.add(data);
			}
		}finally{
			JdbcUtil.close(rs);
			JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null){
			list = new ArrayList<SelectItemData>();
			initData();
		}
	}
	
	public static ArrayList<SelectItemData> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() <1)
			return null;
		return list;
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			SelectItemDataReset();
		}
	}
	
	public static void SelectItemDataReset(){
		list = null;
	}
}
