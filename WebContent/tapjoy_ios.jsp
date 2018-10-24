<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC_KR"%>
<%@ page import="java.net.URLEncoder" %>
<%@	page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@	page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.security.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="com.wingsinus.ep.LogManager" %>
<%
	request.setCharacterEncoding("UTF-8");
	PreparedStatement pstmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	
	try {
		String secretkey = "yx3lP9fviywkSZOeYARs";
		String id = request.getParameter("id");
		String snuid = request.getParameter("snuid");
		String currency = request.getParameter("currency");
		String verifier = request.getParameter("verifier");
				
		MessageDigest md = MessageDigest.getInstance("MD5");
		String key = id + ":" + snuid + ":" + currency + ":" + secretkey;
		
		md.update(key.getBytes());
		byte messageDigest[] = md.digest();
		
		StringBuffer hexString = new StringBuffer();
		for(int i =0; i< messageDigest.length; i++) {
			String h = Integer.toHexString(0XFF & messageDigest[i]);
			while(h.length() < 2)
				h = "0" + h;
			hexString.append(h);
		}
		
		if(verifier.equals(hexString.toString())) {
			pstmt = conn.prepareStatement("update user set freegem = freegem + ? where uid = ?");
			pstmt.setInt(1, Integer.valueOf(currency));
			pstmt.setString(2, snuid);
			
			if(pstmt.executeUpdate()>0){
				System.out.println("success reward gem .. id: " + snuid + " / currency: " + currency + " in iOS");
				LogManager.writeNorLog(snuid, "success_offerwall", "tapjoy_ios", "freegem", "null", Integer.valueOf(currency));
			
				pstmt = conn.prepareStatement("select freeticket, cashticket, freegem, cashgem from user where uid = ?");
			
				pstmt.setString(1, snuid);
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					LogManager.writeCashLog(snuid, rs.getInt("freeticket"), rs.getInt("cashticket"), rs.getInt("freegem"), rs.getInt("cashgem"));
				}
				else {
					LogManager.writeNorLog(snuid, "fail_cashlog", "tapjoy_ios", "freegem", "null", Integer.valueOf(currency));
				}
			}
			else {
				System.out.println("failed reward gem .. id: " + snuid + " / currency: " + currency+ " in iOS");
				LogManager.writeNorLog(snuid, "fail_offerwall", "tapjoy_ios", "freegem","null", Integer.valueOf(currency));
			}
		}
		else {
			System.out.println("verifier error.. id : " + snuid + " in iOS");
			LogManager.writeNorLog(snuid, "error", "tapjoy_ios", "gem", "null", Integer.valueOf(currency));
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>