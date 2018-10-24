package com.wingsinus.ep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LogManager {
	
	public static boolean writeNorLog(String uid,String action_type, String action_name, String itemname, String pointname, int count) throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("logdb");
			
			pstmt = conn.prepareStatement("insert into log_action (uid,action_type,action_name,item,point,count) values(?,?,?,?,?,?)");
			
			pstmt.setString(1, uid);
			pstmt.setString(2, action_type);
			pstmt.setString(3, action_name);
			pstmt.setString(4, itemname);
			pstmt.setString(5, pointname);
			pstmt.setInt(6, count);
			
			int r = pstmt.executeUpdate();
			if(r == 1){
				return true;
			}else{
				return false;
			}
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	public static boolean writeCashLog(String uid, int have_fticket, int have_cticket, int have_fgem,int have_cgem) throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("logdb");
			
			pstmt = conn.prepareStatement("insert into log_cash (uid,have_freeticket,have_cashticket,have_freegem,have_cashgem) values(?,?,?,?,?)");
			
			pstmt.setString(1, uid);
			pstmt.setInt(2, have_fticket);
			pstmt.setInt(3, have_cticket);
			pstmt.setInt(4, have_fgem);
			pstmt.setInt(5, have_cgem);
			
			int r = pstmt.executeUpdate();
			if(r == 1){
				return true;
			}else{
				return false;
			}
			
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);			
		}
	}
	
	public static boolean writeReceipt(String uid, String pid, String ident) throws SQLException{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection("logdb");
			
			pstmt = conn.prepareStatement("insert into payment_receipt (uid,productid,ident) values(?,?,?)");
			
			pstmt.setString(1, uid);
			pstmt.setString(2, pid);
			pstmt.setString(3, ident);
			
			int r = pstmt.executeUpdate();
			if(r == 1){
				return true;
			}else{
				return false;
			}
			
		}finally{
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);			
		}
	}
}
