package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class BannerManager {
	public int newmark;
	public String Title;
	public String Text;
	public String Imgname;
	public String type;
	public String callid;
	public static int nowversion = 0;
	
	private static ArrayList<BannerManager> list = null;
	
	public BannerManager(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select Newmark,Title,Text,imgname,type,callid from bannerdata where Sort > 0 order by Sort");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				BannerManager data = new BannerManager();
				data.newmark = rs.getInt(idx++);
				data.Title = rs.getString(idx++);
				data.Text = rs.getString(idx++);
				data.Imgname = rs.getString(idx++);
				data.type = rs.getString(idx++);
				data.callid = rs.getString(idx++);
				list.add(data);
			}
		}finally{
			JdbcUtil.close(rs);
			JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list==null){
			list = new ArrayList<BannerManager>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion < chversion){
			nowversion = chversion;
			BannerReset();
		}
	}
	
	public static void BannerReset(){
		list = null;
	}
	
	public static ArrayList<BannerManager> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null||list.size() < 1)
			return null;
		return list;
	}
}
