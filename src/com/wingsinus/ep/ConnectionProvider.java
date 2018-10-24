package com.wingsinus.ep;

//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.SQLException;
import java.sql.*;


//DB연결을 담당하는 클래스입니다.
public class ConnectionProvider {
	
	// 0 이면 test, 1이면 live
	public static int afgt_build_ver = 0;
	
	public static Connection getConnection(String dbname) throws SQLException {
		 try {
             Class.forName("com.mysql.jdbc.Driver");
//             System.out.println("드라이버 로딩");
	     } catch(ClassNotFoundException e) {
	         System.out.println("Driver Loading Fail!");
	     }
		
		Connection conn = null;		
		
		String dbUser = "wings";
		String dbPass = "";
		String DB_URL = "";
		
		// test
		if(afgt_build_ver == 0) {
			DB_URL = "jdbc:mysql://localhost:3306/"+dbname;
			dbPass = "WingS00!";
		}
		// live
		else if(afgt_build_ver == 1){
			DB_URL = "jdbc:mysql://10.33.4.205:3306/"+dbname;	
			dbPass = "wings00";
		}
		
		conn = DriverManager.getConnection(DB_URL, dbUser, dbPass);
			
		return conn;
	    
	}
}
