package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class EpisodeList {
	public String Story_id;
	public String csvfilename;
	public int Episode_num;
	public String Episode_name;
	public int ticket;
	public int gem;
	public int purchaseinfo;
	public int reward_gem;
	public int reward_ticket;
	public int rewardinfo;
	public String writer;
	public String director;
	public String imgname;
	public int likecount;
	public String summary;
	public String subtitle;
	public static int nowversion = 0;

	private static ArrayList<EpisodeList> list = null;
	
	private static HashMap<Integer,EpisodeList> hash = null;
	
	public EpisodeList(){
		
	}
	
	private static void initData() throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select Story_id,episode_num,episode_name,csvfilename,ticket,gem,purchaseinfo,reward_gem,reward_ticket,rewardinfo,writer,director,imgname,likecount,summary,subtitle from episode");
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				int idx = 1;
				EpisodeList data = new EpisodeList();
				data.Story_id = rs.getString(idx++);
				data.Episode_num = rs.getInt(idx++);
				data.Episode_name = rs.getString(idx++);
				data.csvfilename = rs.getString(idx++);
				data.ticket = rs.getInt(idx++);
				data.gem = rs.getInt(idx++);
				data.purchaseinfo = rs.getInt(idx++);
				data.reward_gem = rs.getInt(idx++);
				data.reward_ticket = rs.getInt(idx++);
				data.rewardinfo = rs.getInt(idx++);
				data.writer = rs.getString(idx++);
				data.director = rs.getString(idx++);
				data.imgname = rs.getString(idx++);
				data.likecount = rs.getInt(idx++);
				data.summary = rs.getString(idx++);
				data.subtitle = rs.getString(idx++);
				list.add(data);
				hash.put(data.Episode_num, data);
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private static synchronized void checkDataInit() throws SQLException{
		if(list == null||hash == null){
			list = new ArrayList<EpisodeList>();
			hash = new HashMap<Integer,EpisodeList>();
			initData();
		}
	}
	
	public static void CheckStoryversion(int chversion){
		if(nowversion == 0){
			nowversion = chversion;
		}else if(nowversion <chversion){
			nowversion = chversion;
			EpisodeListReset();
		}
	}
	
	public static void EpisodeListReset(){
		list = null;
		hash = null;
	}
	
	public static ArrayList<EpisodeList> getDataAll() throws SQLException{
		checkDataInit();
		if(list == null || list.size() < 1)
			return null;
		return list;
	}
	

	public static EpisodeList getData(int epinum) throws SQLException{
		checkDataInit();
		if(hash == null || hash.size() < 1)
			return null;
		return hash.get(epinum);
	}
	
}
