	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<%@ page import="java.net.URLEncoder" %>
<%@	page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@	page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.cashtester" %>
<%@ page import="com.wingsinus.ep.StoryManager" %>
<%@ page import="com.wingsinus.ep.CategoryList" %>
<%@ page import="com.wingsinus.ep.EpisodeList" %>
<%@ page import="com.wingsinus.ep.CostumeData" %>
<%@ page import="com.wingsinus.ep.BannerManager" %>
<%@ page import="com.wingsinus.ep.LogManager" %>
<%@ page import="com.wingsinus.ep.ChdataManager" %>
<%@ page import="com.wingsinus.ep.ChlistManager" %>
<%@ page import="com.wingsinus.ep.ObdataManager" %>
<%@ page import="com.wingsinus.ep.SoundtableManager" %>
<%
	request.setCharacterEncoding("UTF-8");
	// test log
	PreparedStatement pstmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;

	try{
			
		String userid = request.getParameter("uid");
		
		JSONObject ret = new JSONObject();
		
		String cmd = request.getParameter("cmd");
		
		if(cmd.equals("account_login")){
			System.out.println("OAUTH login command");
			
			String token = request.getParameter("token");
			String service = request.getParameter("service");
			String email = request.getParameter("email");
			String os = request.getParameter("os");
			if(os == null) {
				os = "oldversion";
			}
					
			pstmt = conn.prepareStatement("select uid from user where token = ? and service = ?");
			pstmt.setString(1, token);
			pstmt.setString(2, service);
			
			rs = pstmt.executeQuery();
	
			if(rs.next()){
				System.out.println("existing user linked "+service+" login start");
				
				// 이전에 연동을 한 유저라면
				String exist_uid = rs.getString(1);
				
				pstmt = conn.prepareStatement("update user set token = ?, service = ?, email = ?, os = ? where uid = ?");
				pstmt.setString(1, token);
				pstmt.setString(2, service);
				pstmt.setString(3, email);
				pstmt.setString(4, os);
				pstmt.setString(5, exist_uid);
				
				if(pstmt.executeUpdate()>0){
					LogManager.writeNorLog(exist_uid, "link_success_"+service, cmd, "null","null", 0);
					System.out.println(service + " login link success");
				}else{
					LogManager.writeNorLog(exist_uid, "link_fail_"+service, cmd, "null","null", 0);
					System.out.println(service + " login link fail");
				}
				
				pstmt = conn.prepareStatement("update user set active = ?, existinguid = ? where uid = ?");
				pstmt.setInt(1, 0);
				pstmt.setString(2, exist_uid);
				pstmt.setString(3, userid);
				
				if(pstmt.executeUpdate()>0) {
					LogManager.writeNorLog(userid, "inactive_success_"+service, cmd, "null","null", 0);
					System.out.println(service + " login inactive success");
				}
				else {
					LogManager.writeNorLog(userid, "inactive_success_"+service, cmd, "null","null", 0);
					System.out.println(service + " login inactive fail");
				}
				
				// 기존에 uid를 가져온다.
				ret.put("uid", exist_uid);
				System.out.println("existing user linked "+service+" login end");
			}
			else {
				System.out.println("first start user linked "+service+" login start");
				// 이전에 facebook 연동을 한 적 없는 유저라면
				if(userid.equals("nil")){
					// 신규 유저 라면 
					pstmt = conn.prepareStatement("insert into user_regist (UUID) values(?)");
	
					String uuid = UUID.randomUUID().toString().replaceAll("-", "");
					
					pstmt.setString(1, uuid);
	
					int r = pstmt.executeUpdate();
					if(r==1){
						pstmt = conn.prepareStatement("select * from user_regist where UUID = ?");
						pstmt.setString(1, uuid);
						rs = pstmt.executeQuery();
						int check = 0;
						while(rs.next()){
							check++;
							String uid = String.valueOf(rs.getInt("UID"));
							if(check>1){
								System.out.println("-- making uid error --");
								ret.put("error", 1);
								LogManager.writeNorLog(uid, "make_uid_fail_" + service, cmd, "null","null", 0);
								break;
							}else{
								pstmt = conn.prepareStatement("insert into user (uid,token,service,email,os) values(?,?,?,?,?)");
								pstmt.setString(1, uid);
								pstmt.setString(2, token);
								pstmt.setString(3, service);
								pstmt.setString(4, email);
								pstmt.setString(5, os);
								r = pstmt.executeUpdate();
								if(r == 1){
									ret.put("uid", uid);
									LogManager.writeNorLog(uid, "make_success_" + service, cmd, "null","null", 0);
								}else{
									ret.put("error",2);
									LogManager.writeNorLog(uid, "make_fail_" + service, cmd, "null","null", 0);
									System.out.println("--insert error -- ");
								}
							}
						}
					}
					else {
						LogManager.writeNorLog("null", "make_uuid_fail", cmd, "null","null", 0);
					}
					
				}else{
					// Guest 일 때
					pstmt = conn.prepareStatement("update user set token = ?, service = ?, email = ?, os = ? where uid = ?");
					pstmt.setString(1, token);
					pstmt.setString(2, service);
					pstmt.setString(3, email);
					pstmt.setString(4, os);
					pstmt.setString(5, userid);
					
					if(pstmt.executeUpdate()>0){
						LogManager.writeNorLog(userid, "login_success_" + service, cmd, "null","null", 0);
					}else{
						LogManager.writeNorLog(userid, "login_fail_" + service, cmd, "null","null", 0);
					}
				}
				System.out.println("first user linked "+service+" login end");
			}
		}
		
		else if(cmd.equals("email_check")){
			System.out.println("email check command");
			
			pstmt = conn.prepareStatement("select uid from user where token = ? and service = 'Facebook'");
			
			String email = request.getParameter("email");
			
			pstmt = conn.prepareStatement("select uid from user where email = ? and service = 'Email'");
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				ret.put("exist", 1);
			}
			else {
				ret.put("exist", 0);
			}
		}
		
		else if(cmd.equals("email_login")) {
			System.out.println("email login command");
	
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			
			pstmt = conn.prepareStatement("select service from user where uid = ?");
			
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
	
			// 이전에 게스트로 가입한 유저라면
			if(rs.next()){
				pstmt = conn.prepareStatement("update user set service = 'Email', email = ?, password = ? where uid = ?");
				pstmt.setString(1, email);
				pstmt.setString(2, password);
				pstmt.setString(3, userid);
				
				if(pstmt.executeUpdate()>0){
					LogManager.writeNorLog(userid, "link_success", cmd, "null","null", 0);
				}else{
					LogManager.writeNorLog(userid, "link_fail", cmd, "null","null", 0);
				}
	
				ret.put("uid", userid);
			}
			// 처음 가입하는 유저
			else {
				pstmt = conn.prepareStatement("insert into user_regist (UUID) values(?)");
	
				String uuid = UUID.randomUUID().toString().replaceAll("-", "");
				
				pstmt.setString(1, uuid);
				
				int r = pstmt.executeUpdate();
				if(r==1){
					pstmt = conn.prepareStatement("select * from user_regist where UUID = ?");
					pstmt.setString(1, uuid);
					rs = pstmt.executeQuery();
					int check = 0;
					while(rs.next()){
						check++;
						String uid = String.valueOf(rs.getInt("UID"));
						if(check>1){
							System.out.println("-- making uid error --");
							ret.put("error", 1);
							LogManager.writeNorLog(uid, "emmake_fail", cmd, "null","null", 0);
							break;
						}else{
							pstmt = conn.prepareStatement("insert into user (uid,email,password,service) values(?,?,?,'Email')");
							pstmt.setString(1, uid);
							pstmt.setString(2, email);
							pstmt.setString(3, password);
							r = pstmt.executeUpdate();
							if(r == 1){
								ret.put("uid", uid);
								LogManager.writeNorLog(uid, "emmake_success", cmd, "null","null", 0);
								LogManager.writeNorLog(uid, "success", "login", "null","null", 0);
							}else{
								ret.put("error",2);
								LogManager.writeNorLog(uid, "emmake_fail2", cmd, "null","null", 0);
								System.out.println("--insert error -- ");
							}
						}
					}
				}
				else {
					
				}
			}
		}

		out.print(ret.toString());
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>