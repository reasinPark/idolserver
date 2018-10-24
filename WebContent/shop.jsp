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
<%@ page import="com.wingsinus.ep.LogManager" %>
<%@ page import="com.wingsinus.ep.shopManager" %>
<%@ include file="checkReceipt.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
	// test log
	PreparedStatement pstmt = null;
	Statement stmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	long now = 0;
	
	try{
		
		stmt = conn.createStatement(); 
		
		rs = stmt.executeQuery("select now()");
		
		if(rs.next()){
			now = rs.getTimestamp(1).getTime()/1000;
		}
		
		String userid = request.getParameter("uid");
		
		JSONObject ret = new JSONObject();
		
		String cmd = request.getParameter("cmd");
		System.out.println("system out println in shop");
		if (cmd.equals("loadshop")){
			JSONArray slist = new JSONArray();
			ArrayList<shopManager> smp = shopManager.getDataAll();
			for(int i=0;i<smp.size();i++){
				shopManager smpD = smp.get(i);
				JSONObject data = new JSONObject();
				data.put("shopid", smpD.shop_id);
				data.put("type", smpD.type);
				data.put("title", smpD.title);
				data.put("price",smpD.price);
				data.put("gem",smpD.gem);
				data.put("ticket", smpD.ticket);
				data.put("PID_android", smpD.PID_android);
				data.put("PID_ios", smpD.PID_ios);
				data.put("price_ios",smpD.price_ios);
				slist.add(data);
			}
			ret.put("shopdata", slist);
			pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			System.out.println("update query and return checker");
			if(rs.next()){
				int gemsum = rs.getInt(1)+rs.getInt(2);
				int ticketsum = rs.getInt(3)+rs.getInt(4);
				System.out.println("gem is :"+gemsum+", ticket is :"+ticketsum);
				ret.put("ticket",ticketsum);
				ret.put("gem",gemsum);
			}
			LogManager.writeNorLog(userid, "success", cmd, "null", "null", 0);
		}
		else if(cmd.equals("buyitem")){
			int shopid = Integer.valueOf(request.getParameter("shopid"));
			String ident = request.getParameter("ident");
			String item = request.getParameter("item");
			int market = 2;
			if(request.getParameter("market")!=null)market = Integer.parseInt(request.getParameter("market").toString());
			String receipt = "fake receipt";
			if(request.getParameter("receipt")!=null)receipt = request.getParameter("receipt");
			System.out.println("receipt is :"+receipt+","+market);
			
			JSONObject payResult = newCheckreceipt(receipt,market);
			if((ConnectionProvider.afgt_build_ver==0&&market==0)||(payResult != null && payResult.get("productId")!=null)){
				shopManager data = shopManager.getData(shopid);
				int getgem = data.gem;
				int getticket = data.ticket;
				
				// 유저 아이템 증가
				pstmt = conn.prepareStatement("update user set cashticket = cashticket + ?, cashgem = cashgem + ? where uid = ?");
				pstmt.setInt(1, getticket);
				pstmt.setInt(2, getgem);
				pstmt.setString(3, userid);

				if(pstmt.executeUpdate()>0){
					if(getgem != 0) {
						if(payResult==null)payResult.put("market",0);
						LogManager.writeNorLog(userid, "success_increase", cmd,payResult.get("market").toString()+item, ident, getgem);
						LogManager.writeReceipt(userid, item, ident);
					}
					if(getticket != 0) {
						if(payResult==null)payResult.put("market",0);
						LogManager.writeNorLog(userid, "success_increase", cmd, payResult.get("market").toString()+item, ident, getticket);
						LogManager.writeReceipt(userid, item, ident);
					}
					
					pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
					pstmt.setString(1, userid);
					rs = pstmt.executeQuery();
					if(rs.next()){
						LogManager.writeCashLog(userid, rs.getInt("freeticket"), rs.getInt("cashticket"), rs.getInt("freegem"), rs.getInt("cashgem"));
						
						int gemsum = rs.getInt(1)+rs.getInt(2);
						int ticketsum = rs.getInt(3)+rs.getInt(4);
						if (ticketsum > 0) {
							ret.put("getticket", 1);
						}
						ret.put("getticket",0);
						ret.put("ticket",ticketsum);
						ret.put("gem",gemsum);
						ret.put("addticket",getticket);
						ret.put("addgem",getgem);
						ret.put("success", 1);
					}
					else {
						if(getgem != 0) {
							LogManager.writeNorLog(userid, "fail_cashlog", cmd, item, ident, getgem);
						}
						if(getticket != 0) {
							LogManager.writeNorLog(userid, "fail_cashlog", cmd, item, ident, getticket);
						}
						ret.put("success", 0);
					}
				}else{
					if(getgem != 0) {
						LogManager.writeNorLog(userid, "fail_increase", cmd, item, ident, getgem);
					}
					if(getticket != 0) {
						LogManager.writeNorLog(userid, "fail_increase", cmd, item, ident, getticket);
					}
					ret.put("success", 0);
				}		
			}else{
				ret.put("success",0);
				LogManager.writeNorLog(userid, "fail_unverifyPaying", cmd, item, ident, 0);
			}
		}
		out.print(ret.toString());
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		JdbcUtil.close(pstmt);
		JdbcUtil.close(stmt);
		JdbcUtil.close(rs);
		JdbcUtil.close(conn);
	}
%>