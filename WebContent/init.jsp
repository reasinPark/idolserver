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
<%@ page import="com.wingsinus.ep.ItemDataManager" %>
<%@ page import="com.wingsinus.ep.SelectItemData" %>
<%@ page import="com.wingsinus.ep.TutorialList" %>
<%@ page import="com.wingsinus.ep.RouletteTable" %>
<%@ page import="com.wingsinus.ep.Module" %>
<%@ page import="com.wingsinus.ep.AttendRewardInfo" %>

<%@ include file="GameVariable.jsp" %>
<%

	request.setCharacterEncoding("UTF-8");
	// test log
	PreparedStatement pstmt = null;
	Statement stmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	int Storyversion = 0;
	Module module = new Module();
	try{
			
		long now = 0;
		
		stmt = conn.createStatement(); 
		
		rs = stmt.executeQuery("select now()");
		
		if(rs.next()){
			now = rs.getTimestamp(1).getTime()/1000;
		}
		
		String userid = request.getParameter("uid");
		
		JSONObject ret = new JSONObject();
		
		rs = stmt.executeQuery("select storyversion from story_version limit 1");
		if(rs.next()){
			Storyversion = rs.getInt(1);
		}
		
		System.out.println("story version is :"+Storyversion);
		
		String cmd = request.getParameter("cmd");
		if (cmd.equals("registuser")){
			//regist user log
			JSONArray jlist = new JSONArray();
			JSONArray elist = new JSONArray();
			JSONArray blist = new JSONArray();
			JSONArray clist = new JSONArray();
			JSONArray cdlist = new JSONArray();
			JSONArray cllist = new JSONArray();
			JSONArray olist = new JSONArray();
			JSONArray slist = new JSONArray();
			JSONArray sellist = new JSONArray();
			
			pstmt = conn.prepareStatement("insert into user_regist (UUID) values(?)");		
			
			String uuid = UUID.randomUUID().toString().replaceAll("-", "");
			
			pstmt.setString(1, uuid);
			int r = pstmt.executeUpdate();
			
			// csv Test parameter by Hong-Min
			String csvserver = request.getParameter("csvserver");
			String os = request.getParameter("os");
			if(os == null) {
				os = "oldversion";
			}
			
			if(r == 1){
				pstmt = conn.prepareStatement("select * from user_regist where UUID = ?");
				pstmt.setString(1, uuid);
				rs = pstmt.executeQuery();
				int check = 0;
				String uid = null;
				while(rs.next()){
					check++;
					uid = String.valueOf(rs.getInt("UID"));
					if(check>1){
						System.out.println("-- making uid error --");
						ret.put("error", 1);
						LogManager.writeNorLog(uid, "fail", cmd, "null","null", 0);
						break;
					}else{
						pstmt = conn.prepareStatement("insert into user (uid, os) values(?,?)");
						pstmt.setString(1, uid);
						pstmt.setString(2, os);
						r = pstmt.executeUpdate();
						if(r == 1){
							ret.put("uid", uid);
							
							ArrayList<CostumeData> cmp = CostumeData.getDataAll();
							for(int i=0;i<cmp.size();i++){
								CostumeData cmpD = cmp.get(i);
								JSONObject data = new JSONObject();
								data.put("CostumeId", cmpD.CostumeId);
								data.put("CallId",cmpD.CallId);
								data.put("ChId", cmpD.ChId);
								data.put("Skinname", cmpD.Skinname);
								data.put("filename", cmpD.filename);
								data.put("thumnailname", cmpD.thumnailname);
								data.put("selectani", cmpD.selectani);
								data.put("buyani", cmpD.buyani);
								data.put("description", cmpD.description);
								data.put("price", cmpD.price);
								data.put("name", cmpD.name);
								data.put("episodeid", cmpD.episodeId);
								data.put("storyid", cmpD.StroyId);
								data.put("viewingame",cmpD.viewingame);
								data.put("BFilename",cmpD.BFilename);
								data.put("BSkinname",cmpD.BSkinname);
								data.put("FFilename",cmpD.FFilename);
								data.put("FSkinname",cmpD.FSkinname);
								data.put("HFilename",cmpD.HFilename);
								data.put("HSkinname",cmpD.HSkinname);
								data.put("AFilename",cmpD.AFilename);
								data.put("ASkinname",cmpD.ASkinname);
								clist.add(data);
							}
							
							ArrayList<CategoryList> tmp = CategoryList.getDataAll();
							System.out.println("array count is : "+tmp.size());
							for(int i=0;i<tmp.size();i++){
								CategoryList tmpD = tmp.get(i);
								JSONObject data = new JSONObject();
								data.put("categoryid", tmpD.category_id);
								data.put("categoryname",tmpD.category_name);
								data.put("ordernum", tmpD.ordernum);
								System.out.println("categoryid is : "+tmpD.category_id+", name is : "+tmpD.category_name+", num is : "+tmpD.ordernum);
								jlist.add(data);
							}
							
							ArrayList<EpisodeList> emp = EpisodeList.getDataAll();
							for(int i=0;i<emp.size();i++){
								EpisodeList tmpE = emp.get(i);
								JSONObject data = new JSONObject();
								data.put("StoryID", tmpE.Story_id);
								data.put("EpisodeNum", tmpE.Episode_num);
								data.put("EpisodeName", tmpE.Episode_name);
								data.put("filename", tmpE.csvfilename);
								data.put("ticket", tmpE.ticket);
								data.put("gem", tmpE.gem);
								data.put("purchaseinfo", tmpE.purchaseinfo);
								data.put("rewardgem", tmpE.reward_gem);
								data.put("rewardticket", tmpE.reward_ticket);
								data.put("rewardinfo", tmpE.rewardinfo);
								data.put("writer", tmpE.writer);
								data.put("director", tmpE.director);
								data.put("imgname", tmpE.imgname);
								data.put("likecount", tmpE.likecount);
								data.put("summary", tmpE.summary);
								data.put("subtitle", tmpE.subtitle);
								elist.add(data);
							}
							System.out.println("start banner manager");
							ArrayList<BannerManager> bmp = BannerManager.getDataAll();
							for(int i=0;i<bmp.size();i++){
								BannerManager tmpB = bmp.get(i);
								JSONObject data = new JSONObject();
								data.put("newmark", tmpB.newmark);
								data.put("title", tmpB.Title);
								data.put("text", tmpB.Text);
								data.put("imgname",tmpB.Imgname);
								data.put("type",tmpB.type);
								data.put("callid",tmpB.callid);
								blist.add(data);
							}
							System.out.println("start SelectItemData");
							ArrayList<SelectItemData> selmp = SelectItemData.getDataAll();
							for(int i=0;i<selmp.size();i++){
								SelectItemData selmpS = selmp.get(i);
								JSONObject data = new JSONObject();
								data.put("selectid",selmpS.SelectId);
								data.put("price",selmpS.Price);
								data.put("storyid",selmpS.StoryId);
								data.put("epinum",selmpS.Epinum);
								sellist.add(data);
							}
							
							// chdata, chlist, obdata, soundtable 를 서버에서 받아오기.
							if (csvserver.equals("on")){
								
								ArrayList<ChdataManager> chdmp = ChdataManager.getDataAll();
								for(int i=0;i<chdmp.size();i++){
									ChdataManager tmpCh = chdmp.get(i);
									JSONObject data = new JSONObject();
									data.put("id", tmpCh.id);
									data.put("type", tmpCh.type);
									data.put("spinename", tmpCh.spinename);
									data.put("skinname", tmpCh.skinname);
									data.put("describe", tmpCh.describe);
									cdlist.add(data);
								}
								
								ArrayList<ChlistManager> chlmp = ChlistManager.getDataAll();
								for(int i=0;i<chlmp.size();i++){
									ChlistManager tmpCl = chlmp.get(i);
									JSONObject data = new JSONObject();
									data.put("id", tmpCl.id);
									data.put("name", tmpCl.name);
									data.put("hid", tmpCl.hid);
									data.put("bid", tmpCl.bid);
									data.put("oid", tmpCl.oid);
									data.put("portrait", tmpCl.portrait);
									cllist.add(data);
								}
								
								ArrayList<ObdataManager> omp = ObdataManager.getDataAll();
								for(int i=0;i<omp.size();i++){
									ObdataManager tmpO = omp.get(i);
									JSONObject data = new JSONObject();
									data.put("id", tmpO.id);
									data.put("type", tmpO.type);
									data.put("name", tmpO.name);
									data.put("texture", tmpO.texture);
									data.put("image", tmpO.image);
									olist.add(data);
								}
								
								ArrayList<SoundtableManager> stmp = SoundtableManager.getDataAll();
								for(int i=0;i<stmp.size();i++){
									SoundtableManager tmpS = stmp.get(i);
									JSONObject data = new JSONObject();
									data.put("soundid", tmpS.soundid);
									data.put("timer", tmpS.timer);
									slist.add(data);
								}
		
								ret.put("chdatalist", cdlist);
								ret.put("chlistlist", cllist);
								ret.put("obdatalist", olist);
								ret.put("soundtablelist", slist);
							}// end of csvserver.equal("on")
							
							ret.put("costumedata",clist);
							ret.put("bannerlist", blist);
							ret.put("episodelist",elist);
							ret.put("categorylist",jlist);
							ret.put("selectitemlist",sellist);
							ret.put("uiversion",bundleversion);
							LogManager.writeNorLog(uid, "success_make_uid", cmd, "null","null", 0);
						}else{
							ret.put("error",2);
							LogManager.writeNorLog(uid, "fail_make_uid", cmd, "null","null", 0);
							System.out.println("--insert error -- ");
						}
					}
				}
				LogManager.writeNorLog(uid, "regist_success", cmd, "null","null", 0);
				System.out.println("-----Regi Success-----");
			}else{
				LogManager.writeNorLog("null", "regist_fail", cmd, "null","null", 0);
				System.out.println("----Regi Fail----");
			}
		}else if(cmd.equals("login")){
			//login log manager
			System.out.println("input login command");
			pstmt = conn.prepareStatement("select * from user where uid = ?");
			pstmt.setString(1, userid);
			int freeticket = 0;
			long gentime = 0;
			int cashticket = 0;
			int freegem = 0;
			int cashgem = 0;
			int ticket = 0;
			int gem = 0;
			String service = "";
			String token = "";
			
			BannerManager.CheckStoryversion(Storyversion);
			
			CategoryList.CheckStoryversion(Storyversion);
			
			EpisodeList.CheckStoryversion(Storyversion);
			
			SelectItemData.CheckStoryversion(Storyversion);
			
			CostumeData.CheckStoryversion(Storyversion);
			
			ItemDataManager.CheckStoryversion(Storyversion);
			
			JSONArray jlist = new JSONArray();
			JSONArray elist = new JSONArray();
			JSONArray blist = new JSONArray();
			JSONArray clist = new JSONArray();
			JSONArray cdlist = new JSONArray();
			JSONArray cllist = new JSONArray();
			JSONArray olist = new JSONArray();
			JSONArray slist = new JSONArray();
			JSONArray sellist = new JSONArray();
			JSONArray ilist = new JSONArray(); // itemdata list
			
			rs = pstmt.executeQuery();
			System.out.println("rs count "+userid);
			
			// csv Test parameter by Hong-Min
			String csvserver = request.getParameter("csvserver");
			
			if(rs.next()){
				System.out.print("rs count ");
				freeticket = rs.getInt("freeticket");
				gentime = rs.getTimestamp("ticketgentime").getTime()/1000;
				cashticket = rs.getInt("cashticket");
				freegem = rs.getInt("freegem");
				cashgem = rs.getInt("cashgem");
				ticket = freeticket + cashticket;
				gem = freegem + cashgem;
				service = rs.getString("service");
				token = rs.getString("token");
				
				ArrayList<CostumeData> cmp = CostumeData.getDataAll();
				for(int i=0;i<cmp.size();i++){
					CostumeData cmpD = cmp.get(i);
					JSONObject data = new JSONObject();
					data.put("CostumeId", cmpD.CostumeId);
					data.put("CallId",cmpD.CallId);
					data.put("ChId", cmpD.ChId);
					data.put("Skinname", cmpD.Skinname);
					data.put("filename", cmpD.filename);
					data.put("thumnailname", cmpD.thumnailname);
					data.put("selectani", cmpD.selectani);
					data.put("buyani", cmpD.buyani);
					data.put("description", cmpD.description);
					data.put("price", cmpD.price);
					data.put("name", cmpD.name);
					data.put("episodeid", cmpD.episodeId);
					data.put("storyid", cmpD.StroyId);
					data.put("viewingame",cmpD.viewingame);
					data.put("BFilename",cmpD.BFilename);
					data.put("BSkinname",cmpD.BSkinname);
					data.put("FFilename",cmpD.FFilename);
					data.put("FSkinname",cmpD.FSkinname);
					data.put("HFilename",cmpD.HFilename);
					data.put("HSkinname",cmpD.HSkinname);
					data.put("AFilename",cmpD.AFilename);
					data.put("ASkinname",cmpD.ASkinname);
					clist.add(data);
				}
				
				
				ArrayList<CategoryList> tmp = CategoryList.getDataAll();
				System.out.println("array count is : "+tmp.size());
				for(int i=0;i<tmp.size();i++){
					CategoryList tmpD = tmp.get(i);
					JSONObject data = new JSONObject();
					data.put("categoryid", tmpD.category_id);
					data.put("categoryname",tmpD.category_name);
					data.put("ordernum", tmpD.ordernum);
					System.out.println("categoryid is : "+tmpD.category_id+", name is : "+tmpD.category_name+", num is : "+tmpD.ordernum);
					jlist.add(data);
				}
				
				ArrayList<EpisodeList> emp = EpisodeList.getDataAll();
				for(int i=0;i<emp.size();i++){
					EpisodeList tmpE = emp.get(i);
					JSONObject data = new JSONObject();
					data.put("StoryID", tmpE.Story_id);
					data.put("EpisodeNum", tmpE.Episode_num);
					data.put("EpisodeName", tmpE.Episode_name);
					data.put("filename", tmpE.csvfilename);
					data.put("ticket", tmpE.ticket);
					data.put("gem", tmpE.gem);
					data.put("purchaseinfo", tmpE.purchaseinfo);
					data.put("rewardgem", tmpE.reward_gem);
					data.put("rewardticket", tmpE.reward_ticket);
					data.put("rewardinfo", tmpE.rewardinfo);
					data.put("writer", tmpE.writer);
					data.put("director", tmpE.director);
					data.put("imgname", tmpE.imgname);
					data.put("likecount", tmpE.likecount);
					data.put("summary", tmpE.summary);
					data.put("subtitle", tmpE.subtitle);
					elist.add(data);
				}
				System.out.println("start banner manager in login");
				ArrayList<BannerManager> bmp = BannerManager.getDataAll();
				for(int i=0;i<bmp.size();i++){
					BannerManager tmpB = bmp.get(i);
					JSONObject data = new JSONObject();
					data.put("newmark", tmpB.newmark);
					data.put("title", tmpB.Title);
					data.put("text", tmpB.Text);
					data.put("imgname",tmpB.Imgname);
					data.put("type",tmpB.type);
					data.put("callid",tmpB.callid);
					blist.add(data);
				}
				System.out.println("start Select Manager in login");
				ArrayList<SelectItemData> selmp = SelectItemData.getDataAll();
				for(int i=0;i<selmp.size();i++){
					SelectItemData smp = selmp.get(i);
					JSONObject data = new JSONObject();
					data.put("selectid",smp.SelectId);
					data.put("price",smp.Price);
					data.put("storyid",smp.StoryId);
					data.put("epinum",smp.Epinum);
					System.out.println("data is :"+smp.SelectId+","+smp.Epinum);
					sellist.add(data);
				}
				
				ArrayList<ItemDataManager> itmp = ItemDataManager.getDataAll();
				for(int i=0;i<itmp.size();i++){
					ItemDataManager imp = itmp.get(i);
					JSONObject data = new JSONObject();
					data.put("itemid",imp.itemid);
					data.put("name",imp.name);
					data.put("scope",imp.scope);
					data.put("storyid",imp.Story_id);
					data.put("img",imp.img);
					ilist.add(data);
				}
				
				// chdata, chlist, obdata, soundtable 를 서버에서 받아오기.
				if (csvserver.equals("on")){
					System.out.println("get csv from server!!");
					
					ArrayList<ChdataManager> chdmp = ChdataManager.getDataAll();
					for(int i=0;i<chdmp.size();i++){
						ChdataManager tmpCh = chdmp.get(i);
						JSONObject data = new JSONObject();
						data.put("id", tmpCh.id);
						data.put("type", tmpCh.type);
						data.put("spinename", tmpCh.spinename);
						data.put("skinname", tmpCh.skinname);
						data.put("describe", tmpCh.describe);
						System.out.println("id is : "+tmpCh.id+", type is : "+tmpCh.type+", spinename is : "+tmpCh.spinename+", skinename is : "+tmpCh.skinname+"describe is : "+tmpCh.describe);
						cdlist.add(data);
					}
					
					ArrayList<ChlistManager> chlmp = ChlistManager.getDataAll();
					for(int i=0;i<chlmp.size();i++){
						ChlistManager tmpCl = chlmp.get(i);
						JSONObject data = new JSONObject();
						data.put("id", tmpCl.id);
						data.put("name", tmpCl.name);
						data.put("hid", tmpCl.hid);
						data.put("bid", tmpCl.bid);
						data.put("oid", tmpCl.oid);
						data.put("portrait", tmpCl.portrait);
						cllist.add(data);
					}
					
					ArrayList<ObdataManager> omp = ObdataManager.getDataAll();
					for(int i=0;i<omp.size();i++){
						ObdataManager tmpO = omp.get(i);
						JSONObject data = new JSONObject();
						data.put("id", tmpO.id);
						data.put("type", tmpO.type);
						data.put("name", tmpO.name);
						data.put("texture", tmpO.texture);
						data.put("image", tmpO.image);
						olist.add(data);
					}
					
					ArrayList<SoundtableManager> stmp = SoundtableManager.getDataAll();
					for(int i=0;i<stmp.size();i++){
						SoundtableManager tmpS = stmp.get(i);
						JSONObject data = new JSONObject();
						data.put("soundid", tmpS.soundid);
						data.put("timer", tmpS.timer);
						slist.add(data);
					}
				}// end of csvserver.equal("on")
				
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
			}else{
				LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
			}
			
			System.out.println("start user skin in login");
			
			// 유저 스킨 구매 정보 로드 
			pstmt = conn.prepareStatement("select CostumeId,charid,equip from user_skindata where uid = ?");
			pstmt.setString(1, userid);
			JSONArray skinlist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("costumeid",rs.getString(1));
				data.put("charid",rs.getString(2));
				data.put("equip",rs.getString(3));
				skinlist.add(data);
			}
			
			System.out.println("start user story in login");
			
			//기간이 지난 대여권 사용 이야기가 있는지 확인해서 있다면 maxepinum 을 buynum으로 맞춰준다. 
			pstmt = conn.prepareStatement("select Story_id from user_rentalbook where uid = ? and starttime <= date_add(now(),interval -1 day)");
			pstmt.setString(1,userid);
			List<String> storyList = new ArrayList<String>();
			rs = pstmt.executeQuery();
			while(rs.next()){
				storyList.add(rs.getString(1));
			}
			
			for(int i=0;i<storyList.size();i++){
				pstmt = conn.prepareStatement("update user_story set Episode_num = buy_num where uid = ? and Story_id = ?");
				pstmt.setString(1, userid);
				pstmt.setString(2,storyList.get(i));
				pstmt.executeUpdate();
			}
			
			// 유저 이야기 읽은 정보 로드
			pstmt = conn.prepareStatement("select Story_id,Episode_num,lately_num,buy_num,likestory from user_story where UID = ?");
			pstmt.setString(1,userid);
			JSONArray storylist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryID",rs.getString(1));
				data.put("EpisodeNum",rs.getInt(2));
				data.put("LatelyNum",rs.getInt(3));
				data.put("BuyNum",rs.getInt(4));
				data.put("LikeNum", rs.getInt(5));
				storylist.add(data);
			}
			
			System.out.println("start user name in login");
			
			pstmt = conn.prepareStatement("select Story_id,likecheck from user_storylike where uid = ?");
			pstmt.setString(1, userid);
			JSONArray likelist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId",rs.getString(1));
				data.put("likecheck", rs.getInt(2));
				likelist.add(data);
			}
			/* 
			pstmt = conn.prepareStatement("select Story_id,Episode_num,likestory from user_episodelike where uid = ?");
			pstmt.setString(1, userid);
			JSONArray likelist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId", rs.getString(1));
				data.put("EpisodeNum", rs.getInt(2));
				data.put("LikeNum", rs.getInt(3));
				likelist.add(data);
			}
			 */
			//유저 이름 세팅 정보 로드
			pstmt = conn.prepareStatement("select charid,name from user_chname where uid = ?");
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			JSONArray namelist = new JSONArray();
			while(rs.next()){
				JSONObject cdata = new JSONObject();
				cdata.put("id","#"+rs.getString(1));
				cdata.put("name",rs.getString(2));
				namelist.add(cdata);
			}
			
			System.out.println("start user select item in login");
			
			//유저 선택지 구매 정보 로드
			pstmt = conn.prepareStatement("select selectid,storyid,epinum from user_selectitem where uid = ?");
			pstmt.setString(1,userid);
			rs = pstmt.executeQuery();
			JSONArray selectlist = new JSONArray();
			while(rs.next()){
				JSONObject sdata = new JSONObject();
				sdata.put("selectid", rs.getInt(1));
				sdata.put("storyid",rs.getString(2));
				sdata.put("epinum", rs.getInt(3));
				selectlist.add(sdata);
			}
			
			// chdata, chlist, obdata, soundtable 를 서버에서 받아오기.
			if (csvserver.equals("on")){
				System.out.println("csvserver : " + csvserver);
				ret.put("chdatalist", cdlist);
				ret.put("chlistlist", cllist);
				ret.put("obdatalist", olist);
				ret.put("soundtablelist", slist);
			}// end of csvserver.equals("on")
			
			// 마지막 로그인 시간 갱신
			pstmt = conn.prepareStatement("update user set lastjointime = now() where uid = ?");
			pstmt.setString(1,userid);
			
			if(pstmt.executeUpdate()==1) {
				
			}
			else {
				LogManager.writeNorLog(userid, "fail_lastjointime", cmd, "null","null", 0);
			}
			
			//기간 지난 대여권 및 기간 지난 인벤 정리 
			pstmt = conn.prepareStatement("delete from user_rentalbook where uid = ? and starttime < date_add(now(),interval -1 day)");
			pstmt.setString(1,userid);
			pstmt.executeUpdate();
			
			pstmt = conn.prepareStatement("delete from user_inven where uid = ? and expiretime <= now()");
			pstmt.setString(1,userid);
			pstmt.executeUpdate();
			
			//유저 대여권 정보 로드 
			pstmt = conn.prepareStatement("select Story_id, scope, starttime, startepisode,date_add(starttime,interval 1 day) from user_rentalbook where uid = ?");
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			JSONArray prlist = new JSONArray();
			while(rs.next()){
				JSONObject rdata = new JSONObject();
				rdata.put("storyid",rs.getString(1));
				rdata.put("scope",rs.getInt(2));
				rdata.put("starttime",rs.getTimestamp(3).getTime()/1000);
				rdata.put("startepisode",rs.getInt(4));
				rdata.put("expiretime",rs.getTimestamp(5).getTime()/1000);
				prlist.add(rdata);
			}
			
			//유저 인벤 정보 로드 
			pstmt = conn.prepareStatement("select idx,itemid, count, starttime, expiretime, title, message, img, userconfirm,DATE_FORMAT(expiretime,'%Y-%m-%d') from user_inven where uid = ? order by expiretime");
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			JSONArray pilist = new JSONArray();
			while(rs.next()){
				JSONObject idata = new JSONObject();
				idata.put("idx",rs.getInt(1));
				idata.put("itemid",rs.getInt(2));
				idata.put("count",rs.getInt(3));
				idata.put("starttime",rs.getTimestamp(4).getTime()/1000);
				idata.put("expiretime",rs.getTimestamp(5).getTime()/1000);
				idata.put("title", rs.getString(6));
				idata.put("message",rs.getString(7));
				idata.put("img",rs.getString(8));
				idata.put("userconfirm",rs.getInt(9));
				idata.put("expiredate",rs.getString(10));
				pilist.add(idata);
			}
			
			//출석부 전체 데이터 로드
			pstmt = conn.prepareStatement("select onoff from attendEvent");
			rs = pstmt.executeQuery();
			while(rs.next()) {
				if(rs.getInt(1) == 1) {
					pstmt = conn.prepareStatement("select eventName, startDate, endDate, d1itemId_1, d1count_1, d1itemId_2, d1count_2, d1itemId_3, d1count_3, d1itemId_4, d1count_4," +
												  "d2itemId_1, d2count_1, d2itemId_2, d2count_2, d2itemId_3, d2count_3, d2itemId_4, d2count_4, d3itemId_1, d3count_1, d3itemId_2, d3count_2, d3itemId_3, d3count_3, d3itemId_4, d3count_4," +
												  "d4itemId_1, d4count_1, d4itemId_2, d4count_2, d4itemId_3, d4count_3, d4itemId_4, d4count_4, d5itemId_1, d5count_1, d5itemId_2, d5count_2, d5itemId_3, d5count_3, d5itemId_4, d5count_4," +
												  "d6itemId_1, d6count_1, d6itemId_2, d6count_2, d6itemId_3, d6count_3, d6itemId_4, d6count_4, d7itemId_1, d7count_1, d7itemId_2, d7count_2, d7itemId_3, d7count_3, d7itemId_4, d7count_4 from attendEvent");
					rs = pstmt.executeQuery();
					JSONArray atlist = new JSONArray();
					while(rs.next()) {
						ret.put("eventName", rs.getString(1));
						ret.put("startDate", rs.getTimestamp(2).getTime()/1000);
						ret.put("endDate", rs.getTimestamp(3).getTime()/1000);
						
						for(int i=0;i<7;i++) {
							JSONObject atdata = new JSONObject();
							atdata.put("itemId_1", rs.getInt(4+(8*i)));
							atdata.put("count_1", rs.getInt(5+(8*i)));
							atdata.put("itemId_2", rs.getInt(6+(8*i)));
							atdata.put("count_2", rs.getInt(7+(8*i)));
							atdata.put("itemId_3", rs.getInt(8+(8*i)));
							atdata.put("count_3", rs.getInt(9+(8*i)));
							atdata.put("itemId_4", rs.getInt(10+(8*i)));
							atdata.put("count_4", rs.getInt(11+(8*i)));
							atlist.add(atdata);
						}
					}
					ret.put("attendlist", atlist);
					ret.put("attendonoff", 1);
					
					pstmt = conn.prepareStatement("select attendDate, sumAttend from user_attend where uid = ?");
					pstmt.setString(1, userid);
					rs = pstmt.executeQuery();
					
					if(rs.next()) {
						ret.put("attendDate", rs.getTimestamp(1).getTime()/1000);
						ret.put("sumAttend", rs.getInt(2));
						ret.put("myattend", 1);
					}
					else {
						ret.put("myattend", 0);
					}
				}
				else {
					ret.put("attendonoff", 0);
				}
			}
			
			ret.put("userinvenlist",pilist);
			ret.put("userrentalbooklist",prlist);
			ret.put("itemdatalist",ilist);
			
			ret.put("userstorylikelist", likelist);
			ret.put("userselectlist",selectlist);
			ret.put("namelist",namelist);
			ret.put("userstorylist",storylist);
			ret.put("userskinlist",skinlist);
			ret.put("costumelist",clist);
			ret.put("bannerlist", blist);
			ret.put("episodelist",elist);
			ret.put("categorylist",jlist);
			ret.put("selectitemlist",sellist);
			ret.put("ticket", ticket);
			ret.put("ticketgentime",gentime);
			ret.put("gem",gem);
			ret.put("nowtime",now);
			ret.put("service", service);
			ret.put("token", token);
			ret.put("uiversion",bundleversion);
			System.out.println("cli version is :"+clientversion);
			ret.put("cliversion",clientversion);
		}else if(cmd.equals("buyskin")){
			//user skin buy logaction
			
			//int cmd = request.getParameter("cmd");
			int costumeid = Integer.valueOf(request.getParameter("costumeid"));
			//int usercash = Integer.valueOf(request.getParameter("cash"));
			// check user already have this costume
			
			CostumeData data = CostumeData.getData(costumeid);
			int usercash = data.price;
			
			pstmt = conn.prepareStatement("select CostumeId from user_skindata where uid = ? and CostumeId = ?");
			pstmt.setString(1, userid);
			pstmt.setInt(2,costumeid);
			rs = pstmt.executeQuery();
			if(rs.next()){
				ret.put("already",1);
				LogManager.writeNorLog(userid, "fail_have", cmd, "null","null", 0);
			}else{
				//input costumeid
				//check cash
				//delivery result
				int freegem = 0;
				int cashgem = 0;
				int freeticket = 0;
				int cashticket = 0;
				boolean bugFlag = false;
				boolean cashorfree = false;		// cash : true , free : false
				
				pstmt = conn.prepareStatement("select freegem, cashgem, freeticket, cashticket from user where uid = ?");
				pstmt.setString(1, userid);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					freegem = rs.getInt("freegem");
					cashgem = rs.getInt("cashgem");
					freeticket = rs.getInt("freeticket");
					cashticket = rs.getInt("cashticket");
					
					if(cashgem >= usercash) {
						pstmt = conn.prepareStatement("update user set cashgem = cashgem - ? where uid = ?");
						pstmt.setInt(1, usercash);
						pstmt.setString(2, userid);
						cashgem = cashgem - usercash;
						cashorfree = true;
					}
					else {
						if(cashgem == 0) {
							if(freegem >= usercash) {
								pstmt = conn.prepareStatement("update user set freegem = freegem - ? where uid = ?");
								pstmt.setInt(1, usercash);
								pstmt.setString(2, userid);
								freegem = freegem - usercash;
								cashorfree = false;
							}
							else {
								bugFlag = true;
								ret.put("success",0);
								LogManager.writeNorLog(userid, "error", cmd, "gem", "null", usercash);
							}
						}
						else {
							pstmt = conn.prepareStatement("update user set cashgem = cashgem - ? where uid = ?");
							pstmt.setInt(1, cashgem);
							pstmt.setString(2, userid);
							
							if(pstmt.executeUpdate()==1) {
								LogManager.writeNorLog(userid, "success_decrease", cmd, "cashgem", "null", cashgem);
								usercash = usercash - cashgem;
								cashgem = cashgem - cashgem;
								LogManager.writeCashLog(userid, freeticket, cashticket, freegem, cashgem);
								pstmt = conn.prepareStatement("update user set freegem = freegem - ? where uid = ?");
								pstmt.setInt(1,	usercash);
								pstmt.setString(2, userid);
								freegem = freegem - usercash;
								cashorfree = false;
							}
							else {
								bugFlag = true;
								ret.put("success",0);
								LogManager.writeNorLog(userid, "fail_decrease", cmd, "cashgem", "null", cashgem);
							}
						}
					}
				}
				
				if(!bugFlag) {					
					if(pstmt.executeUpdate()==1){
						if(cashorfree) {
							LogManager.writeNorLog(userid, "success_decrease", cmd, "cashgem", "null", usercash);
						}
						else {
							LogManager.writeNorLog(userid, "success_decrease", cmd, "freegem", "null", usercash);
						}
						LogManager.writeCashLog(userid, freeticket, cashticket, freegem, cashgem);
						
						pstmt = conn.prepareStatement("insert into user_skindata (CostumeId,buy_Date,use_rcash,uid,charid) values(?,now(),?,?,?)");
						pstmt.setInt(1, costumeid);
						pstmt.setInt(2, usercash);
						pstmt.setString(3, userid);
						pstmt.setString(4,data.ChId);
						
						if(pstmt.executeUpdate()==1){
							ret.put("success",1);
							LogManager.writeNorLog(userid, "success", cmd, String.valueOf(costumeid), data.StroyId, 0);
						}else{
							ret.put("success",0);
							LogManager.writeNorLog(userid, "fail_insert", cmd, "null","null", 0);
						}	
					}
					else {
						ret.put("success",0);

						if(cashorfree) {
							LogManager.writeNorLog(userid, "fail_decrease", cmd, "cashgem", "null", usercash);
						}
						else {
							LogManager.writeNorLog(userid, "fail_decrease", cmd, "freegem", "null", usercash);
						}
					}
				}
			}
	
			// 유저 스킨 구매 정보 로드 
			pstmt = conn.prepareStatement("select CostumeId,charid,equip from user_skindata where uid = ?");
			pstmt.setString(1, userid);
			JSONArray skinlist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject cdata = new JSONObject();
				cdata.put("costumeid",rs.getString(1));
				cdata.put("charid",rs.getString(2));
				cdata.put("equip",rs.getString(3));
				skinlist.add(cdata);
			}
			ret.put("userskinlist",skinlist);
			
		}else if(cmd.equals("skinequip")){
			//skin equip log action
			int costumeid = Integer.valueOf(request.getParameter("costumeid"));
			ArrayList<CostumeData> cmp = CostumeData.getDataAll();
			for(int i=0;i<cmp.size();i++){
				CostumeData tdata = cmp.get(i);
				if(tdata.CostumeId==costumeid){
					pstmt = conn.prepareStatement("update user_skindata set equip = 0 where uid = ? and charid = ?");
					pstmt.setString(1, userid);
					pstmt.setString(2,tdata.ChId);
					pstmt.executeUpdate();
					break;
				}
			}
			pstmt = conn.prepareStatement("update user_skindata set equip = 1 where uid = ? and costumeId = ?");
			pstmt.setString(1, userid);
			pstmt.setInt(2,costumeid);
			if(pstmt.executeUpdate()>0){
				ret.put("success",1);
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
			}else{
				ret.put("success",0);
				LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
			}
			// 유저 스킨 구매 정보 로드 
			pstmt = conn.prepareStatement("select CostumeId,charid,equip from user_skindata where uid = ?");
			pstmt.setString(1, userid);
			JSONArray skinlist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject cdata = new JSONObject();
				cdata.put("costumeid",rs.getString(1));
				cdata.put("charid",rs.getString(2));
				cdata.put("equip",rs.getString(3));
				skinlist.add(cdata);
			}
			ret.put("userskinlist",skinlist);
		}else if(cmd.equals("setcustomname")){
			String charid = request.getParameter("charid");
			String name = request.getParameter("chname");
			pstmt = conn.prepareStatement("select idx from user_chname where uid = ? and charid = ?");
			pstmt.setString(1,userid);
			pstmt.setString(2, charid);
			rs = pstmt.executeQuery();
			if(rs.next()){
				//update
				pstmt = conn.prepareStatement("update user_chname set name = ? where uid = ? and charid = ?");
				pstmt.setString(1, name);
				pstmt.setString(2, userid);
				pstmt.setString(3, charid);
				if(pstmt.executeUpdate()>0){
					ret.put("success", 1);
					//update log
				}else{
					ret.put("success", 0);
					//update fail log
				}
			}else{
				//insert
				pstmt = conn.prepareStatement("insert into user_chname (uid,charid,name) values(?,?,?)");
				pstmt.setString(1, userid);
				pstmt.setString(2, charid);
				pstmt.setString(3, name);
				if(pstmt.executeUpdate()>0){
					ret.put("success",1);
					//insert log
				}else{
					ret.put("success",0);
					//insert fail log
				}
			}
			//유저 이름 세팅 정보 로드
			pstmt = conn.prepareStatement("select charid,name from user_chname where uid = ?");
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			JSONArray namelist = new JSONArray();
			while(rs.next()){
				JSONObject cdata = new JSONObject();
				cdata.put("id","#"+rs.getString(1));
				cdata.put("name",rs.getString(2));
				namelist.add(cdata);
			}
			ret.put("namelist",namelist);
		}
		else if(cmd.equals("skinunequip")){
			//skin un equip log action
			String charid = request.getParameter("charid");
			pstmt = conn.prepareStatement("update user_skindata set equip = 0 where charid = ? and uid = ?");
			pstmt.setString(1,charid);
			pstmt.setString(2, userid);
			if(pstmt.executeUpdate()>0){
				ret.put("success",1);
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
			}else{
				ret.put("success",0);
				LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
			}	
		}
		else if(cmd.equals("cashrefresh")){
			pstmt = conn.prepareStatement("select freeticket,cashticket,freegem,cashgem from user where uid = ?");
			pstmt.setString(1,userid);
			rs = pstmt.executeQuery();
			if(rs.next()){
				ret.put("gem",(rs.getInt(3)+rs.getInt(4)));
				ret.put("ticket",(rs.getInt(1)+rs.getInt(2)));
				ret.put("success",1);
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
			}else{
				ret.put("success",0);
				LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
			}		
		}
		else if(cmd.equals("episodestart")){
			String Storyid = request.getParameter("StoryId");
			int episodenum = Integer.valueOf(request.getParameter("episodenum"));
			pstmt = conn.prepareStatement("select buy_num from user_story where uid = ? and story_id = ?");
			pstmt.setString(1, userid);
			pstmt.setString(2, Storyid);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				int buynum = rs.getInt(1);
				
				// 처음 구매해서 buy_num 값 갱신 
				if(buynum < episodenum) {
					pstmt = conn.prepareStatement("update user_story set lately_num = ?, buy_num = ? where UID = ? and Story_id = ?");
					pstmt.setInt(1,episodenum);
					pstmt.setInt(2,episodenum);
					pstmt.setString(3, userid);
					pstmt.setString(4, Storyid);
					if(pstmt.executeUpdate()==1) {
						ret.put("success", 1);
						LogManager.writeNorLog(userid, "success_buyepi", cmd, "null","null", 0);	
					}
					else {
						ret.put("success", 0);
						LogManager.writeNorLog(userid, "fail_buyepi", cmd, "null","null", 0);
					}
				}
				// 이미 구매해서 lately_num 값만 갱신
				else {
					pstmt = conn.prepareStatement("update user_story set lately_num = ? where UID = ? and Story_id = ?");
					pstmt.setInt(1,episodenum);
					pstmt.setString(2, userid);
					pstmt.setString(3, Storyid);
					if(pstmt.executeUpdate()==1) {
						ret.put("success", 1);
						LogManager.writeNorLog(userid, "success_lately", cmd, "null","null", 0);	
					}
					else {
						ret.put("success", 0);
						LogManager.writeNorLog(userid, "fail_lately", cmd, "null","null", 0);
					}
				}
			}else{
				//lately insert
				pstmt = conn.prepareStatement("insert into user_story (UID,Story_id,Episode_num,dir_num,view_date,lately_num,buy_num) values(?,?,0,0,now(),?,?)");
				pstmt.setString(1, userid);
				pstmt.setString(2, Storyid);
				pstmt.setInt(3, episodenum);
				pstmt.setInt(4, episodenum);
				if(pstmt.executeUpdate()==1) {
					ret.put("success", 1);
					LogManager.writeNorLog(userid, "success_buyepi", cmd, "null","null", 0);	
				}
				else {
					ret.put("success", 0);
					LogManager.writeNorLog(userid, "fail_buyepi", cmd, "null","null", 0);
				}
			}

			pstmt = conn.prepareStatement("select readcount from episoderead where Story_id = ? and Episode_num = ? ");
			pstmt.setString(1, Storyid);
			pstmt.setInt(2, episodenum);
			rs = pstmt.executeQuery();
			if(rs.next()){
				pstmt = conn.prepareStatement("update episoderead set readcount = readcount + 1 where Story_id = ? and Episode_num = ?");
				pstmt.setString(1, Storyid);
				pstmt.setInt(2, episodenum);
				pstmt.executeUpdate();
			}else{
				pstmt = conn.prepareStatement("insert into episoderead (Story_id,Episode_num) values(?,?)");
				pstmt.setString(1, Storyid);
				pstmt.setInt(2, episodenum);
				pstmt.executeUpdate();
			}
			
			LogManager.writeNorLog(userid, "readcount", cmd, Storyid, String.valueOf(episodenum), 0);
			
			// 유저 이야기 읽은 정보 로드
			pstmt = conn.prepareStatement("select Story_id,Episode_num,lately_num,buy_num,likestory from user_story where UID = ?");
			pstmt.setString(1,userid);
			JSONArray storylist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryID",rs.getString(1));
				data.put("EpisodeNum",rs.getInt(2));
				data.put("LatelyNum",rs.getInt(3));
				data.put("BuyNum",rs.getInt(4));
				data.put("LikeNum", rs.getInt(5));
				storylist.add(data);
			}
					
			ret.put("userstorylist",storylist);
		}
		else if(cmd.equals("episodeend")){
			//episode 다 읽음 처리 log action
			//user의 해당 스토리의 해당 에피소드 다 읽음 처리
			//get user story의 lastepisode
			//if nowepisode > lastepisode
			//insert into episodenum
			String Storyid = request.getParameter("StoryId");
			int episodenum = Integer.valueOf(request.getParameter("episodenum"));
			System.out.println("Story id is :"+Storyid+", episodenum is :"+episodenum);
			pstmt = conn.prepareStatement("select Episode_num from user_story where uid = ? and story_id = ?");
			pstmt.setString(1, userid);
			pstmt.setString(2, Storyid);
			rs = pstmt.executeQuery();
			int counter = 0;
			
			if(rs.next()){
				System.out.println("flow input here");
				counter++;
				int tmpepisode = rs.getInt(1);
				if(tmpepisode<episodenum){
					//episode update
					pstmt = conn.prepareStatement("update user_story set Episode_num = ? where UID = ? and Story_id = ?");
					pstmt.setInt(1,episodenum);
					pstmt.setString(2, userid);
					pstmt.setString(3, Storyid);
					int checker = pstmt.executeUpdate();
					System.out.println("upd ate checker is :"+checker+ "uid is :"+userid);
					if(checker==1){
						System.out.println("step 1");
						EpisodeList data = EpisodeList.getData(episodenum);
						System.out.println("reward ticket is :"+data.reward_ticket+", gem is :"+data.reward_gem);
						pstmt = conn.prepareStatement("update user set freeticket = freeticket + ?, freegem = freegem + ? where uid = ?");
						pstmt.setInt(1, data.reward_ticket);
						pstmt.setInt(2, data.reward_gem);
						pstmt.setString(3, userid);
						if(pstmt.executeUpdate()==1){
							if (data.reward_ticket > 0) {
								LogManager.writeNorLog(userid, "success_increase", cmd, "freeticket", "null", data.reward_ticket);
								ret.put("getticket", 1);
							}
							if (data.reward_gem > 0) {
								LogManager.writeNorLog(userid, "success_increase", cmd, "freegem", "null", data.reward_gem);
							}
							ret.put("success", 1);
							ret.put("reward", 1);
							
							pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
							pstmt.setString(1, userid);
							rs = pstmt.executeQuery();
							if(rs.next()){
								LogManager.writeCashLog(userid, rs.getInt("freeticket"), rs.getInt("cashticket"), rs.getInt("freegem"), rs.getInt("cashgem"));
							}
							else {
								if(data.reward_ticket > 0) {
									LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freeticket", "null", data.reward_ticket);
								}
								if(data.reward_gem > 0) {
									LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freegem", "null", data.reward_gem);
								}
							}
						}else{
							if (data.reward_ticket > 0) {
								LogManager.writeNorLog(userid, "fail_increase", cmd, "freeticket", "null", data.reward_ticket);
								ret.put("getticket", 1);
							}
							if (data.reward_gem > 0) {
								LogManager.writeNorLog(userid, "fail_increase", cmd, "freegem", "null", data.reward_gem);
							}
							ret.put("success", 0);
						}
					}else{
						LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
						ret.put("success",0);
					}
				}else{
					LogManager.writeNorLog(userid, "fail_already", cmd, "null","null", 0);
					ret.put("already",1);
				}
			}else{
				//episode insert
				System.out.println("rs is not here Story id is :"+Storyid+", episodenum is :"+episodenum);
				pstmt = conn.prepareStatement("insert into user_story (UID,Story_id,Episode_num,dir_num,view_date,lately_num) values(?,?,?,0,now(),?)");
				pstmt.setString(1, userid);
				pstmt.setString(2, Storyid);
				pstmt.setInt(3, episodenum);
				pstmt.setInt(4, episodenum);
				int checker = pstmt.executeUpdate();
				System.out.println("checker is :"+checker+ "uid is :"+userid);
				if(checker==1){
					EpisodeList data = EpisodeList.getData(episodenum);
					pstmt = conn.prepareStatement("update user set freeticket = freeticket + ?, freegem = freegem + ? where uid = ?");
					pstmt.setInt(1, data.reward_ticket);
					pstmt.setInt(2, data.reward_gem);
					pstmt.setString(3, userid);
					checker = pstmt.executeUpdate();
					System.out.println("input another checker : "+checker);
					if(checker==1){
						if (data.reward_ticket > 0) {
							LogManager.writeNorLog(userid, "success_increase", cmd, "freeticket", "null", data.reward_ticket);
							ret.put("getticket", 1);
						}
						if (data.reward_gem > 0) {
							LogManager.writeNorLog(userid, "success_increase", cmd, "freegem", "null", data.reward_gem);
						}
						ret.put("success", 1);
						ret.put("reward", 1);
						
						pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
						pstmt.setString(1, userid);
						rs = pstmt.executeQuery();
						if(rs.next()){
							LogManager.writeCashLog(userid, rs.getInt("freeticket"), rs.getInt("cashticket"), rs.getInt("freegem"), rs.getInt("cashgem"));
						}
						else {
							if(data.reward_ticket > 0) {
								LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freeticket", "null", data.reward_ticket);
							}
							if(data.reward_gem > 0) {
								LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freegem", "null", data.reward_gem);
							}
						}
					}else{
						if (data.reward_ticket > 0) {
							LogManager.writeNorLog(userid, "fail_increase", cmd, "freeticket", "null", data.reward_ticket);
							ret.put("getticket", 1);
						}
						if (data.reward_gem > 0) {
							LogManager.writeNorLog(userid, "fail_increase", cmd, "freegem", "null", data.reward_gem);
						}
						ret.put("success", 0);
					}
				}else{
					LogManager.writeNorLog(userid, "fail_insert", cmd, "null","null", 0);
					ret.put("success",0);
				}
			}
			
			// 유저 이야기 읽은 정보 로드
			pstmt = conn.prepareStatement("select Story_id,Episode_num,lately_num,buy_num,likestory from user_story where UID = ?");
			pstmt.setString(1,userid);
			JSONArray storylist = new JSONArray();
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryID",rs.getString(1));
				data.put("EpisodeNum",rs.getInt(2));
				data.put("LatelyNum",rs.getInt(3));
				data.put("BuyNum",rs.getInt(4));
				data.put("LikeNum", rs.getInt(5));
				storylist.add(data);
			}
			
			ret.put("userstorylist",storylist);
		}
		else if(cmd.equals("buyepisode")){
			String Storyid = request.getParameter("StoryId");
			int episodenum = Integer.valueOf(request.getParameter("episodenum"));
			int ticketValue = -1;
			System.out.println("input buyepisode"+Storyid+","+(episodenum+1));
			
			pstmt = conn.prepareStatement("select ticket from episode where Story_id = ? and episode_num = ?");
			pstmt.setString(1,Storyid);
			pstmt.setInt(2,episodenum+1);
			rs = pstmt.executeQuery();
			if(rs.next()){
				ticketValue = rs.getInt(1);
			}
			if(ticketValue<0){
				ret.put("error",1);
			}else{
				long ticketGenTime = 0;
				int buynum = 0;
				
				pstmt = conn.prepareStatement("select buy_num from user_story where uid = ? and Story_id = ?");
				pstmt.setString(1, userid);
				pstmt.setString(2, Storyid);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					buynum = rs.getInt(1);
				}
			
				pstmt = conn.prepareStatement("select freeticket, cashticket, freegem, cashgem from user where uid = ?");
				pstmt.setString(1, userid);
				rs = pstmt.executeQuery();
				
				int freeticket = 0;
				int cashticket = 0;
				int freegem = 0;	
				int cashgem = 0;
				boolean bugFlag = false;
				boolean cashorfree = false;		// cash : true , free : false
				
				if(buynum >= episodenum + 1) {
					LogManager.writeNorLog(userid, "already_buy", cmd, "null","null", 0);
					ret.put("success",1);
					ret.put("myticket",(freeticket+cashticket));
					System.out.println("story check is already");
				}
				else {
					System.out.println("story check is not already");
	
					if(rs.next()){
						freeticket = rs.getInt(1);
						cashticket = rs.getInt(2);
						freegem = rs.getInt(3);
						cashgem = rs.getInt(4);
						
						if(cashticket+freeticket<ticketValue){
							ret.put("success",0);
							ret.put("myticket",(freeticket+cashticket));
							System.out.println("not enough ticket");
						}else{
							System.out.println("enough ticket"+cashticket+","+freeticket+","+ticketValue);						
							if(cashticket >= ticketValue){
								System.out.println("Case :1");
								pstmt = conn.prepareStatement("update user set cashticket = cashticket - ? where uid = ?");
								pstmt.setInt(1,ticketValue);
								pstmt.setString(2, userid);
								cashorfree = true;;
							}else{
								System.out.println("Case :2");
								int minusT = ticketValue - cashticket;
								pstmt = conn.prepareStatement("update user set cashticket = 0, freeticket = freeticket -? where uid = ?");
								pstmt.setInt(1, minusT);
								pstmt.setString(2, userid);
								cashorfree = true;
								if(cashticket == 0)cashorfree = false;
							}
						}
					}
					
					if(pstmt.executeUpdate() == 1) {
						if(cashorfree) {
							LogManager.writeNorLog(userid, "success_decrease", cmd, "cashticket", "null", ticketValue);
						}
						else {
							LogManager.writeNorLog(userid, "success_decrease", cmd, "freeticket", "null", ticketValue);
						}
						
						LogManager.writeCashLog(userid, freeticket, cashticket, freegem, cashgem);

						ret.put("success",1);
						
						pstmt = conn.prepareStatement("select freeticket, cashticket from user where uid = ?");
						pstmt.setString(1,userid);
			
						rs = pstmt.executeQuery();
						
						while(rs.next()){
							int myticket = rs.getInt(1)+rs.getInt(2);
							
							ret.put("myticket", myticket);
							
							if (myticket == 0) {
								pstmt = conn.prepareStatement("update user set ticketgentime = date_add(now(), interval 2 day) where uid = ?");
								pstmt.setString(1, userid);
								
								if(pstmt.executeUpdate()==1){
									
									pstmt = conn.prepareStatement("select ticketgentime,now() from user where uid = ?");
									pstmt.setString(1,userid);
									
									rs = pstmt.executeQuery();
									
									if(rs.next()){
										ticketGenTime = rs.getTimestamp(1).getTime()/1000;
										now = rs.getTimestamp(2).getTime()/1000;
										ret.put("ticketgentime", ticketGenTime);
										ret.put("nowtime", now);
										ret.put("timecheck", 1);
									}
									LogManager.writeNorLog(userid, "success_set_gentime", cmd, "null","null", 0);
								}
								else {
									LogManager.writeNorLog(userid, "fail_set_gentime", cmd, "null","null", 0);
								}
							}
							else {
								ret.put("timecheck", 0);
							}
						}
					}
					else {
						ret.put("error",1);
						if(cashorfree) {
							LogManager.writeNorLog(userid, "fail_decrease", cmd, "cashticket", "null", ticketValue);
						}
						else {
							LogManager.writeNorLog(userid, "fail_decrease", cmd, "freeticket", "null", ticketValue);
						}
					}
				}
			}
		}
		else if(cmd.equals("writeuserchoice")){
			String Storyid = request.getParameter("StoryId");
			int episodenum = Integer.valueOf(request.getParameter("episodenum"));
			int selectid = Integer.valueOf(request.getParameter("selectid"));
			
			System.out.println("input write user choice"+Storyid+","+episodenum+","+selectid);
			
			//이미 구매한 내역인지 확인한다.
			pstmt = conn.prepareStatement("select * from user_selectitem where uid = ? and selectid = ? and storyid = ? and epinum = ?");
			pstmt.setString(1, userid);
			pstmt.setInt(2, selectid);
			pstmt.setString(3, Storyid);
			pstmt.setInt(4, episodenum);
			rs = pstmt.executeQuery();
			if(rs.next()){
				ret.put("result",3);
				ret.put("already",1);
			}else{
	
				//먼저 구매내용을 처리한다. 
				//가격을 가져온다.
				//감소를 처리한다.
				//감소에 성공했으면 이후 처리를 시작한다.
				
				List<SelectItemData> slist = SelectItemData.getDataAll();
				SelectItemData data = new SelectItemData();
				for(int i=0;i<slist.size();i++){
					System.out.println("selid is :"+slist.get(i).SelectId+", "+selectid+","+Storyid+","+slist.get(i).StoryId+","+episodenum+","+slist.get(i).Epinum);
					if(slist.get(i).SelectId == selectid&&slist.get(i).StoryId.equals(Storyid)&&slist.get(i).Epinum == episodenum){
						data = slist.get(i);
					}
				}
				System.out.println("data is :"+data.Price+", user is :"+userid);
				if(data.Price == 0){
					System.out.println("no data");
					ret.put("result",2);
				}else{
					pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
					pstmt.setString(1, userid);
					int aftercashgem = 0;
					int afterfreegem = 0;
					int cashtype = 0;
					int beshort = 0;
					int freegem = 0;
					int cashgem = 0;
					int freeticket = 0;
					int cashticket = 0;
					System.out.println("price is :"+data.Price+", "+userid);
					rs = pstmt.executeQuery();
					if(rs.next()){
						freegem = rs.getInt(1);
						cashgem = rs.getInt(2);
						freeticket = rs.getInt(3);
						cashticket = rs.getInt(4);
						System.out.println("price is :"+data.Price+", "+freegem+","+cashgem);
						if(data.Price >freegem+cashgem){
							ret.put("result", 0);//not enough gem
							LogManager.writeNorLog(userid,"not enough gem",cmd,"null","null",0);
						}else{
							if(cashgem >=data.Price){ // first use cashgem
								cashtype = 1;
								aftercashgem = cashgem - data.Price;
							}else{ // first cash after free
								beshort = data.Price - cashgem;
								cashtype = 2;
								
								afterfreegem = freegem - beshort;
							}
						}
					}
					
					System.out.println("cash is :"+afterfreegem+", "+beshort+","+aftercashgem);
					
					int upresult = 0;
					
					if(cashtype==1){
						pstmt = conn.prepareStatement("update user set cashgem = ? where uid = ?");
						pstmt.setInt(1, aftercashgem);
						pstmt.setString(2, userid);
						upresult = pstmt.executeUpdate();
					}else if(cashtype==2){
						pstmt = conn.prepareStatement("update user set freegem = ? , cashgem = 0 where uid = ?");
						pstmt.setInt(1,afterfreegem);
						pstmt.setString(2, userid);
						upresult = pstmt.executeUpdate();
					}
					
					System.out.println("result is :"+upresult);
					
					if(upresult == 1){
						if(cashtype == 1) {
							LogManager.writeNorLog(userid,"success_decrease",cmd,"cashgem","null",data.Price);
							LogManager.writeCashLog(userid, freeticket, cashticket, freegem, aftercashgem);
						}
						else if(cashtype == 2) {
							LogManager.writeNorLog(userid,"success_decrease",cmd,"cashgem","null",cashgem);
							LogManager.writeNorLog(userid,"success_decrease",cmd,"freegem","null",beshort);
							LogManager.writeCashLog(userid, freeticket, cashticket, afterfreegem, 0);
						}
						
						System.out.println("insert data is :"+userid+","+selectid+","+Storyid+","+episodenum);
						pstmt = conn.prepareStatement("insert into user_selectitem (uid,selectid,storyid,epinum) values(?,?,?,?)");
						pstmt.setString(1, userid);
						pstmt.setInt(2, selectid);
						pstmt.setString(3, Storyid);
						pstmt.setInt(4,episodenum);
						
						if(pstmt.executeUpdate()==1){
							//get user_selectitem
							//유저 선택지 구매 정보 로드
							pstmt = conn.prepareStatement("select selectid,storyid,epinum from user_selectitem where uid = ?");
							pstmt.setString(1,userid);
							rs = pstmt.executeQuery();
							JSONArray selectlist = new JSONArray();
							while(rs.next()){
								JSONObject sdata = new JSONObject();
								sdata.put("selectid", rs.getInt(1));
								sdata.put("storyid",rs.getString(2));
								sdata.put("epinum", rs.getInt(3));
								System.out.println("my data is :"+rs.getInt(1)+", "+rs.getString(2)+","+rs.getInt(3));
								selectlist.add(sdata);
							}
							LogManager.writeNorLog(userid,"success_write_userchoice",cmd,Storyid,String.valueOf(episodenum),data.Price);
							ret.put("userselectlist",selectlist);
							ret.put("result",1);
							
						}else{
							ret.put("result",2);
							LogManager.writeNorLog(userid,"fail_buy_choice",cmd,"null","null",0);
						}
					}
					else {
						if(cashtype == 1) {
							LogManager.writeNorLog(userid,"fail_decrease",cmd,"cashgem","null",data.Price);
						}
						else if(cashtype == 2) {
							LogManager.writeNorLog(userid,"fail_decrease",cmd,"cashgem","null",cashgem);
							LogManager.writeNorLog(userid,"fail_decrease",cmd,"freegem","null",beshort);
						}
					}
				}
			}
			
		}
		else if(cmd.equals("ticketcharge")) {
			
			long ticketGenTime = 0;
			
			pstmt = conn.prepareStatement("select ticketgentime,now() from user where uid = ?");
			pstmt.setString(1,userid);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				ticketGenTime = rs.getTimestamp(1).getTime()/1000;
				now = rs.getTimestamp(2).getTime()/1000;
				
				if(ticketGenTime < now) {
					
					pstmt = conn.prepareStatement("select freeticket, cashticket from user where uid = ?");
					pstmt.setString(1, userid);
					rs = pstmt.executeQuery();
					
					if(rs.next()) {
						int myticket = 0;
						myticket = rs.getInt(1) + rs.getInt(2);
						
						if(myticket > 0) {
							LogManager.writeNorLog(userid, "fail_increase", cmd, "freeticket", "already_have_ticket", 1);
							ret.put("nocharge", 0);
							ret.put("success", 0);
						}
						else {
							System.out.println("charge success");
							pstmt = conn.prepareStatement("update user set freeticket = freeticket + 1 where uid = ?");
							pstmt.setString(1, userid);
							
							if(pstmt.executeUpdate()>0){
								LogManager.writeNorLog(userid, "success_increase", cmd, "freeticket","null", 1);
								ret.put("nocharge", 1);
								ret.put("success", 1);
								
								pstmt = conn.prepareStatement("select freegem,cashgem,freeticket,cashticket from user where uid = ?");
								pstmt.setString(1, userid);
								rs = pstmt.executeQuery();
								
								if(rs.next()) {
									LogManager.writeCashLog(userid, rs.getInt("freeticket"), rs.getInt("cashticket"), rs.getInt("freegem"), rs.getInt("cashgem"));
								}
								else {
									LogManager.writeNorLog(userid, "fail_cashlog", cmd, "freeticket","null", 1);
								}
							}
							else {
								LogManager.writeNorLog(userid, "fail_increase", cmd, "freeticket","null", 1);
								ret.put("nocharge", 1);
								ret.put("success", 0);
							}
						}
					}
				}
				else {
					System.out.println("need more time");
					ret.put("nocharge", 0);
					ret.put("now", now);
				}
			}
		}
		else if(cmd.equals("checkgem")) {
			int costumeid = Integer.valueOf(request.getParameter("costumeid"));
	
			CostumeData data = CostumeData.getData(costumeid);
			int price = data.price;
	
			pstmt = conn.prepareStatement("select freegem, cashgem from user where uid = ?");
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int mygem = rs.getInt(1)+rs.getInt(2);
				
				if (mygem < price) {
					ret.put("success", 0);
				}
				else {
					ret.put("success", 1);
				}
			}
		}
		else if(cmd.equals("tutorial")) {
	
			JSONArray tlist = new JSONArray();
			
			ArrayList<TutorialList> emp = TutorialList.getDataAll();
			for(int i=0;i<emp.size();i++){
				TutorialList tmpE = emp.get(i);
				JSONObject data = new JSONObject();
				data.put("StoryID", tmpE.Story_id);
				data.put("EpisodeNum", tmpE.episode_num);
				data.put("Summary", tmpE.summary);
				tlist.add(data);
			}
			
			ret.put("tutoriallist", tlist);
		}
		else if(cmd.equals("buyadpass")){
			boolean freepass = true;
			
			if(!freepass){
				// check adpass count and date
				int passprice = 10;
				
				pstmt = conn.prepareStatement("select adpass,adpasscount,freegem,cashgem,freeticket,cashticket from user where uid = ?");
				pstmt.setString(1, userid);
				
				boolean passlive = false;
				long livetime = 24*31*60*60;			
				int freegem = 0;
				int cashgem = 0;
				int freeticket = 0;
				int cashticket = 0;
				
				rs = pstmt.executeQuery();
				if(rs.next()){
					long adpasstime = rs.getTimestamp(1).getTime()/1000;
					int adpasscount = rs.getInt(2);
					freegem = rs.getInt(3);
					cashgem = rs.getInt(4);
					freeticket = rs.getInt(5);
					cashticket = rs.getInt(6);
					
					if(adpasscount==1&&adpasstime+livetime>=now){
						passlive = true;
					}
					LogManager.writeNorLog(userid,"checkadpass",cmd,"null","null",0);
				}
				
				if(!passlive){
					//check user gem
					boolean cashorfree = false;			// cash : true, free : false
					if(freegem+cashgem>=passprice){
						int aftercash = 0;
						int afterfree = 0;
						if(cashgem>=passprice){
							aftercash = cashgem-passprice;
							afterfree = freegem;
							cashorfree = true;
						}else{
							aftercash = 0;
							afterfree = freegem - (passprice - cashgem);
							cashorfree = false;
						}
						pstmt = conn.prepareStatement("update user set adpass = now(), adpasscount = 1, cashgem = ?, freegem = ? where uid = ?");
						pstmt.setInt(1, aftercash);
						pstmt.setInt(2, afterfree);
						pstmt.setString(3, userid);
						if(pstmt.executeUpdate()==1){
							ret.put("result", 1);
							
							if(cashorfree) {
								LogManager.writeNorLog(userid,"success_decrease",cmd,"cashgem","null",passprice);
							}
							else {
								LogManager.writeNorLog(userid,"success_decrease",cmd,"cashgem","null",cashgem);
								LogManager.writeNorLog(userid,"success_decrease",cmd,"freegem","null",passprice-cashgem);
							}
							
							LogManager.writeCashLog(userid, freeticket, cashticket, afterfree, aftercash);
						}
						else {
							if(cashorfree) {
								LogManager.writeNorLog(userid,"fail_decrease",cmd,"cashgem","null",passprice);
							}
							else {
								LogManager.writeNorLog(userid,"fail_decrease",cmd,"cashgem","null",cashgem);
								LogManager.writeNorLog(userid,"fail_decrease",cmd,"freegem","null",passprice-cashgem);
							}
						}
					}else{
						LogManager.writeNorLog(userid,"fail_money",cmd,"null","null",0);
						ret.put("result",0);//not enough money
					}
				}else{
					LogManager.writeNorLog(userid,"fail_already",cmd,"null","null",0);
					ret.put("already", 1);
				}
				
				// update adpass and date
				// send result
			}else{
				ret.put("result",1);
				ret.put("already",1);
			}
		}
		else if(cmd.equals("checkadpass")){
			// check adpass count and date
			pstmt = conn.prepareStatement("select adpass,adpasscount from user where uid = ?");
			pstmt.setString(1, userid);
			
			boolean passlive = true; // turn off check adpass
			long livetime = 24*31*60*60;
			rs = pstmt.executeQuery();
			if(rs.next()){
				long adpasstime = rs.getTimestamp(1).getTime()/1000;
				int adpasscount = rs.getInt(2);
				if(adpasscount==1&&adpasstime+livetime>=now){
					passlive = true;
				}
			}
			if(passlive){
				ret.put("result",1);
			}else{
				ret.put("result",0);
			}
			// update adpass
			// send result
		}
		else if(cmd.equals("likestory")){
			String storyid = request.getParameter("storyid");
			
			pstmt = conn.prepareStatement("select likecheck from user_storylike where uid = ? and Story_id = ?");
			pstmt.setString(1, userid);
			pstmt.setString(2, storyid);
			rs = pstmt.executeQuery();
			boolean result = false;
			if(rs.next()){ //update
				int likecheck = rs.getInt(1);
				if(likecheck==0){ //update 1
					pstmt = conn.prepareStatement("update user_storylike set likecheck = 1 where uid = ? and Story_id = ?");
					pstmt.setString(1, userid);
					pstmt.setString(2, storyid);
					if(pstmt.executeUpdate()==1){
						result = true;
					}
				}else{ //update 0
					pstmt = conn.prepareStatement("update user_storylike set likecheck = 0 where uid = ? and Story_id = ?");
					pstmt.setString(1, userid);
					pstmt.setString(2, storyid);
					if(pstmt.executeUpdate()==1){
						result = true;
					}
				}
			}else{ //insert 1
				pstmt = conn.prepareStatement("insert into user_storylike (Story_id,uid,likecheck) values(?,?,1)");
				pstmt.setString(1, storyid);
				pstmt.setString(2, userid);
				if(pstmt.executeUpdate()==1){
					result = true;
				}
			}
			
			pstmt = conn.prepareStatement("select Story_id,likecheck from user_storylike where uid = ?");
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();

			JSONArray Playerlikelist = new JSONArray();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId",rs.getString(1));
				data.put("likecheck", rs.getInt(2));
				Playerlikelist.add(data);
			}
			
			pstmt = conn.prepareStatement("select Story_id,sum(likecheck) from user_storylike group by Story_id");
			rs = pstmt.executeQuery();
			
			JSONArray likelist = new JSONArray();
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId",rs.getString(1));
				data.put("LikeCount", rs.getInt(2));
				likelist.add(data);
			}
			
			ret.put("likelist",likelist);
			ret.put("Playerlikelist", Playerlikelist);
			
			if(result){
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
				ret.put("result",1);
			}else{
				LogManager.writeNorLog(userid, "fail", cmd, "null","null", 0);
				ret.put("result", 0);
			}
			
		}
		else if(cmd.equals("getresourceversion")){
			JSONArray rlist = new JSONArray();
						
			pstmt = conn.prepareStatement("select AssetBundleName,version from AssetBundleVersion");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				JSONObject data = new JSONObject();
				System.out.println("name is :"+rs.getString(1)+", version is :"+rs.getInt(2));
				data.put("AssetBundleName",rs.getString(1));
				data.put("version",rs.getInt(2));
				rlist.add(data);
			}
			
			ret.put("cliversion",clientversion);
			ret.put("resourceversion",rlist);
		}

		else if(cmd.equals("question")) {
			//send question
			String email = request.getParameter("email");
			String subject = request.getParameter("subject");
			String contents = request.getParameter("contents");
			
			pstmt = conn.prepareStatement("insert into question (uid,email,subject,contents,date) values(?,?,?,?,now())");
			pstmt.setString(1, userid);
			pstmt.setString(2, email);
			pstmt.setString(3, subject);
			pstmt.setString(4, contents);
			
			int checker = pstmt.executeUpdate();
			
			if(checker==1){
				ret.put("success", 1);
				LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
			}
			else {
				ret.put("success", 0);
				LogManager.writeNorLog(userid,"fail",cmd,"null","null",0);
			}
		}
		
		else if(cmd.equals("likerefresh")) {
			JSONArray likecountlist = new JSONArray();
			
			pstmt = conn.prepareStatement("select Story_id, sum(likecheck) from user_storylike group by Story_id");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				JSONObject data = new JSONObject();
				data.put("StoryId",rs.getString(1));
				data.put("LikeCount", rs.getInt(2));
				likecountlist.add(data);
			}
			
			ret.put("likecountlist", likecountlist);
			
			ret.put("result", 1);//normal progress
			LogManager.writeNorLog(userid, "success", cmd, "null","null", 0);
		}
		else if(cmd.equals("checkuiversion")){
			ret.put("uiversion",bundleversion);
			ret.put("cliversion",clientversion);
		}
		
		else if(cmd.equals("roulette")) {
			//All user is 24 hour waiting
			//String service = request.getParameter("service");
			String service = "Guest";
			long gentime = 0;
			boolean nextflag = false;
			boolean alreadyflag = false;
			int count = 0;
			
			pstmt = conn.prepareStatement("select gentime,count from user_roulette where uid = ?");
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				alreadyflag = true;
				gentime = rs.getTimestamp(1).getTime()/1000;
				count = rs.getInt(2);
				
				if(gentime > now) {
					nextflag = false;
				}
				else {
					nextflag = true;
				}
			}
			else {
				alreadyflag = false;
				nextflag = true;
			}
			
			if(nextflag) {
				pstmt = conn.prepareStatement("select item, rand, count from roulette_table");
				rs = pstmt.executeQuery();
				
				ArrayList<RouletteTable> table = new ArrayList<RouletteTable>();
				Random random = new Random();
				int value = 0;
				int res = 0;
				
				while(rs.next()) {
					RouletteTable data = new RouletteTable();
					data.item = rs.getString(1);
					data.rand = rs.getInt(2);
					data.count = rs.getInt(3);
					table.add(data);
				}
				
				value = random.nextInt(table.get(table.size()-1).rand);
				System.out.println("random value : " + value);
				
				for(int i=0;i<table.size();i++) {
					if(value < table.get(i).rand) {
						res = i;
						System.out.println("res value : " + (res+1));
						break;
					}
				}
				
				if(service.equals("Guest")) {
					if(alreadyflag) {
						pstmt = conn.prepareStatement("update user_roulette set gentime = date_add(now(), interval 1 day), itemidx = ?, count = count + 1 where uid = ?");
						if(count == 1) {
							res = 0;
							System.out.println("2nd is bonus");	
						}						
						pstmt.setInt(1, res+1);
						pstmt.setString(2, userid);
					}
					else {
						pstmt = conn.prepareStatement("insert into user_roulette (uid,gentime,itemidx) values(?,date_add(now(), interval 1 day),?)");
						pstmt.setString(1, userid);
						pstmt.setInt(2, res+1);
					}
				}
				else {
					if(alreadyflag) {
						pstmt = conn.prepareStatement("update user_roulette set gentime = date_add(now(), interval 12 hour), itemidx = ?, count = count + 1 where uid = ?");
						if(count == 1) {
							res = 0;
							System.out.println("2nd is bonus");
						}
						pstmt.setInt(1, res+1);
						pstmt.setString(2, userid);
					}
					else {
						pstmt = conn.prepareStatement("insert into user_roulette (uid,gentime,itemidx) values(?,date_add(now(), interval 12 hour),?)");
						pstmt.setString(1, userid);
						pstmt.setInt(2, res+1);
					}
				}
				
				if(pstmt.executeUpdate() > 0) {
					LogManager.writeNorLog(userid, "success_settime", cmd, "null","null", res+1);
					
					if(table.get(res).item.equals("ticket")) {
						pstmt = conn.prepareStatement("update user set freeticket = freeticket + ? where uid = ?");
					}
					else if(table.get(res).item.equals("gem")) {
						pstmt = conn.prepareStatement("update user set freegem = freegem + ? where uid = ?");
					}
					else if(table.get(res).item.equals("vote")) {
						pstmt = conn.prepareStatement("update user set freevote = freevote + ? where uid = ?");
					}
					
					pstmt.setInt(1, table.get(res).count);
					pstmt.setString(2, userid);
					
					if(pstmt.executeUpdate() > 0) {
						LogManager.writeNorLog(userid, "success_increase", cmd, "free"+table.get(res).item,"null",table.get(res).count);
						ret.put("result", 3);
						
						pstmt = conn.prepareStatement("select gentime,itemidx from user_roulette where uid = ?");
						pstmt.setString(1, userid);
						rs = pstmt.executeQuery();
						
						if(rs.next()) {
							ret.put("gentime", rs.getTimestamp(1).getTime()/1000);
							ret.put("itemidx", rs.getInt(2));
							ret.put("nowtime", now);
						}
						else {
							LogManager.writeNorLog(userid, "fail_gettime", cmd, "null","null", 0);
							ret.put("result", 2);
						}
					}
					else {
						LogManager.writeNorLog(userid, "fail_increase", cmd, "free"+table.get(res).item,"null",table.get(res).count);
						ret.put("result", 1);
					}
				}
				else {
					LogManager.writeNorLog(userid, "fail_settime", cmd, "null","null", 0);
					ret.put("result", 0);
				}
				
			}
			else {
				LogManager.writeNorLog(userid, "not_enough_time", cmd, "null","null", 0);
				ret.put("result", 0);
			}
		}		
		else if(cmd.equals("getroulette")) {
			pstmt = conn.prepareStatement("select gentime,itemidx from user_roulette where uid = ?");
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				long gentime = 0;
				gentime = rs.getTimestamp(1).getTime()/1000;
				
				if(gentime > now) {
					ret.put("result", 1);
					ret.put("gentime", gentime);
					ret.put("itemidx", rs.getInt(2));
					ret.put("nowtime", now);
				}
				else {
					ret.put("result", 0);
				}
			}
			else {
				ret.put("result", 0);
			}
		}
		else if(cmd.equals("checkrentalbook")){ // 모든 대여권 및 인벤 정보
			//인벤에서 시간 지난거 지워버리기 
			pstmt = conn.prepareStatement("delete from user_inven where uid = ? and expiretime <= now()");
			pstmt.setString(1,userid);
			pstmt.executeUpdate();
			
			//목록 추출해서 보내기 
			pstmt = conn.prepareStatement("select idx,itemid,count,starttime,expiretime,title,message,img,userconfirm,DATE_FORMAT(expiretime,'%Y-%m-%d') from user_inven where uid = ? order by expiretime");
			pstmt.setString(1,userid);
			rs = pstmt.executeQuery();
			JSONArray invenlist = new JSONArray();
			while(rs.next()){
				JSONObject idata = new JSONObject();
				int idx = rs.getInt(1);
				int itemid = rs.getInt(2);
				int count = rs.getInt(3);
				long starttime = rs.getTimestamp(4).getTime()/1000;
				long expiretime = rs.getTimestamp(5).getTime()/1000;
				String title = rs.getString(6);
				String message = rs.getString(7);
				String img = rs.getString(8);
				int userconfirm = rs.getInt(9);
				String expiredate = rs.getString(10);
				
				idata.put("invenid",idx);
				idata.put("itemid",itemid);
				idata.put("count",count);
				idata.put("starttime",starttime);
				idata.put("expiretime",expiretime);
				idata.put("title",title);
				idata.put("message",message);
				idata.put("userconfirm",userconfirm);
				idata.put("expiredate",expiredate);
				invenlist.add(idata);
			}
			
			//적용중인 대여권 목록에서 시간 지나간건 지워버리기
			pstmt = conn.prepareStatement("delete from user_rentalbook where uid = ? and starttime < date_add(now(),interval -1 day)");
			pstmt.setString(1,userid);
			pstmt.executeUpdate();
			
			//목록 추출해서 보내기 
			pstmt = conn.prepareStatement("select Story_id, scope, starttime, startepisode,date_add(starttime,interval 1 day) from user_rentalbook where uid = ?");
			pstmt.setString(1,userid);
			
			rs = pstmt.executeQuery();
			JSONArray rlist = new JSONArray();
			while(rs.next()){
				JSONObject rdata = new JSONObject();
				String Story_id = rs.getString(1);
				int scope = rs.getInt(2);
				long starttime = rs.getTimestamp(3).getTime()/1000;
				int startepisode = rs.getInt(4);
				long expiretime = rs.getTimestamp(5).getTime()/1000;
				
				rdata.put("storyid",Story_id);
				rdata.put("scope",scope);
				rdata.put("starttime",starttime);
				rdata.put("startepisode",startepisode);
				rdata.put("expiretime",expiretime);
				rlist.add(rdata);
			}

			ret.put("invenlist",invenlist);
			ret.put("myrentalbook",rlist);	
		}
		else if(cmd.equals("checkinven")){//인벤 아이템 확인

			//인벤에서 시간 지난거 지워버리기 
			pstmt = conn.prepareStatement("delete from user_inven where uid = ? and expiretime <= now()");
			pstmt.setString(1,userid);
			pstmt.executeUpdate();

			//적용중인 대여권 목록에서 시간 지나간건 지워버리기
			pstmt = conn.prepareStatement("delete from user_rentalbook where uid = ? and starttime < date_add(now(),interval -1 day)");
			pstmt.setString(1,userid);
			pstmt.executeUpdate();
			
			// 체크 해서 0 만들기 
			pstmt = conn.prepareStatement("update user_inven set userconfirm = 0 where uid = ?");
			pstmt.setString(1,userid);
			pstmt.executeUpdate();
			
			//inven 목록 추출해서 보내기 
			pstmt = conn.prepareStatement("select idx,itemid,count,starttime,expiretime,title,message,img,userconfirm,DATE_FORMAT(expiretime,'%Y-%m-%d') from user_inven where uid = ? order by expiretime");
			pstmt.setString(1,userid);
			rs = pstmt.executeQuery();
			JSONArray invenlist = new JSONArray();
			while(rs.next()){
				JSONObject idata = new JSONObject();
				int idx = rs.getInt(1);
				int itemid = rs.getInt(2);
				int count = rs.getInt(3);
				long starttime = rs.getTimestamp(4).getTime()/1000;
				long expiretime = rs.getTimestamp(5).getTime()/1000;
				String title = rs.getString(6);
				String message = rs.getString(7);
				String img = rs.getString(8);
				int userconfirm = rs.getInt(9);
				String expiredate = rs.getString(10);
				
				idata.put("invenid",idx);
				idata.put("itemid",itemid);
				idata.put("count",count);
				idata.put("starttime",starttime);
				idata.put("expiretime",expiretime);
				idata.put("title",title);
				idata.put("message",message);
				idata.put("userconfirm",userconfirm);
				idata.put("expiredate",expiredate);
				invenlist.add(idata);
			}
			
			//rental book 목록 추출해서 보내기 
			pstmt = conn.prepareStatement("select Story_id, scope, starttime, startepisode,date_add(starttime,interval 1 day) from user_rentalbook where uid = ?");
			pstmt.setString(1,userid);
			
			rs = pstmt.executeQuery();
			JSONArray rlist = new JSONArray();
			while(rs.next()){
				JSONObject rdata = new JSONObject();
				String Story_id = rs.getString(1);
				int scope = rs.getInt(2);
				long starttime = rs.getTimestamp(3).getTime()/1000;
				int startepisode = rs.getInt(4);
				long expiretime = rs.getTimestamp(5).getTime()/1000;
				
				rdata.put("storyid",Story_id);
				rdata.put("scope",scope);
				rdata.put("starttime",starttime);
				rdata.put("startepisode",startepisode);
				rdata.put("expiretime",expiretime);
				rlist.add(rdata);
			}

			ret.put("invenlist",invenlist);
			ret.put("myrentalbook",rlist);
		}
		else if(cmd.equals("userentalbook")){//대여권 사용하기			
			String storyid = request.getParameter("storyid");
			//int costumeid = Integer.valueOf(request.getParameter("costumeid"));
			int invenidx = Integer.valueOf(request.getParameter("invenidx")); 
			//적용중인 대여권 시간 지나간거 지우기, 가방 시간 지난거 지우기
			pstmt = conn.prepareStatement("delete from user_rentalbook where uid = ? and starttime < date_add(now(),interval -1 day)");
			pstmt.setString(1,userid);
			pstmt.executeUpdate();
			
			pstmt = conn.prepareStatement("delete from user_inven where uid = ? and expiretime <= now()");
			pstmt.setString(1,userid);
			pstmt.executeUpdate();
			
			//이미 사용한 해당화의 대여권있는지 확인하고 
			pstmt = conn.prepareStatement("select scope from user_rentalbook where uid = ? and Story_id = ?");
			pstmt.setString(1, userid);
			pstmt.setString(2, storyid);
			rs = pstmt.executeQuery();
			boolean exist = false;
			if(rs.next()){
				exist = true;
				ret.put("already",1);
			}else{
				int itemid = 0;
				//일단 해당 idx에 있는걸 가져오고 
				pstmt = conn.prepareStatement("select itemid from user_inven where uid = ? and idx = ?");
				pstmt.setString(1, userid);
				pstmt.setInt(2, invenidx);
				rs = pstmt.executeQuery();
				if(rs.next()){
					itemid = rs.getInt(1);
				}			
				
				//해당 아이템 아이디의 스토리 데이터를 가져오고, 유저가 몇화까지 봤는지도 가져온다.  
				if(itemid > 0){
					ItemDataManager itemdata = ItemDataManager.getData(itemid);
					
					pstmt = conn.prepareStatement("select Episode_num, buy_num from user_story where uid = ? and Story_id = ?");
					pstmt.setString(1, userid);
					pstmt.setString(2, itemdata.Story_id);
					rs = pstmt.executeQuery();				
					
					if(rs.next()){
						int epnum = rs.getInt(1);
						int bnum = rs.getInt(2);
						if(epnum>=bnum){
							//inven에 있는걸 지우고
							pstmt = conn.prepareStatement("delete from user_inven where uid = ? and idx = ?");
							pstmt.setString(1, userid);
							pstmt.setInt(2, invenidx);
							int check = pstmt.executeUpdate();
							if(check==1&&itemid>0){
								//rental에 기록하고	
								pstmt = conn.prepareStatement("insert into user_rentalbook (uid, Story_id, scope, starttime, startepisode) values(?,?,?,now(),?)");
								pstmt.setString(1, userid);
								pstmt.setString(2, itemdata.Story_id);
								pstmt.setInt(3, itemdata.scope);
								pstmt.setInt(4, epnum);
								int result = pstmt.executeUpdate();
								if(result==1){
									// 내 갱신된 인벤과 대여권 정보 전달

									//목록 추출해서 보내기 
									pstmt = conn.prepareStatement("select idx,itemid,count,starttime,expiretime,title,message,img,userconfirm,DATE_FORMAT(expiretime,'%Y-%m-%d') from user_inven where uid = ? order by expiretime");
									pstmt.setString(1,userid);
									rs = pstmt.executeQuery();
									JSONArray invenlist = new JSONArray();
									while(rs.next()){
										JSONObject idata = new JSONObject();
										int idx = rs.getInt(1);
										int item_id = rs.getInt(2);
										int count = rs.getInt(3);
										long starttime = rs.getTimestamp(4).getTime()/1000;
										long expiretime = rs.getTimestamp(5).getTime()/1000;
										String title = rs.getString(6);
										String message = rs.getString(7);
										String img = rs.getString(8);
										int userconfirm = rs.getInt(9);
										String expiredate = rs.getString(10);
										
										idata.put("invenid",idx);
										idata.put("itemid",item_id);
										idata.put("count",count);
										idata.put("starttime",starttime);
										idata.put("expiretime",expiretime);
										idata.put("title",title);
										idata.put("message",message);
										idata.put("userconfirm",userconfirm);
										idata.put("expiredate",expiredate);
										invenlist.add(idata);
									}
									
									//목록 추출해서 보내기 
									pstmt = conn.prepareStatement("select Story_id, scope, starttime, startepisode,date_add(starttime,interval 1 day) from user_rentalbook where uid = ?");
									pstmt.setString(1,userid);
									
									rs = pstmt.executeQuery();
									JSONArray rlist = new JSONArray();
									while(rs.next()){
										JSONObject rdata = new JSONObject();
										String Story_id = rs.getString(1);
										int scope = rs.getInt(2);
										long starttime = rs.getTimestamp(3).getTime()/1000;
										int startepisode = rs.getInt(4);
										long expiretime = rs.getTimestamp(5).getTime()/1000;
										
										rdata.put("storyid",Story_id);
										rdata.put("scope",scope);
										rdata.put("starttime",starttime);
										rdata.put("startepisode",startepisode);
										rdata.put("expiretime",expiretime);
										rlist.add(rdata);
									}

									ret.put("invenlist",invenlist);
									ret.put("myrentalbook",rlist);	
									
									ret.put("result",1);
								}else{
									ret.put("result",0);
								}
							}else{
								ret.put("result",0);	
							}
						}else{
							ret.put("result",2);//not ready
						}						
					}else{
						ret.put("result",0);
					}
				}else{
					//error
					ret.put("result",0);
				}				
				ret.put("already",0);
			}	
		}
		else if(cmd.equals("checkattend")) {//출석 확인
			int nowattend = 0;
			long startdate = 0;
			long nowdate = 0;
			long myattenddate = 0;
			int myattend = 0;
			boolean nextstep = false;
			
			pstmt = conn.prepareStatement("select onoff,startDate,endDate,now() from attendEvent");
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				// 1) on/off 확인
				if(rs.getInt(1) == 1) {
					// 2) 이벤트 일정 이내인지 확인
					if((rs.getTimestamp(2).getTime() < rs.getTimestamp(4).getTime()) && (rs.getTimestamp(3).getTime() > rs.getTimestamp(4).getTime())) {
						startdate = rs.getTimestamp(2).getTime()/1000;
						nowdate = rs.getTimestamp(4).getTime()/1000;
						
						while(startdate+(nowattend*86400) < nowdate) {
							nowattend++;
						}
						
						// 3) 이미 받았는지 안받았는지 체크
						pstmt = conn.prepareStatement("select attendDate, sumAttend from user_attend where uid = ?");
						pstmt.setString(1, userid);
						rs = pstmt.executeQuery();
						
						if(rs.next()) {
							System.out.println("i have attend info");
							myattenddate = rs.getTimestamp(1).getTime()/1000;
							myattend = rs.getInt(2);
							
							// 현재 보상 회차보다 회차가 작고, 그 회차 내에 보상을 받았는지
							if((nowattend > myattend) && (startdate+((nowattend-1)*86400) > myattenddate) && (myattend <= 6)) {

								pstmt = conn.prepareStatement("update user_attend set attendDate = now(), sumAttend = ? where uid = ?");
								pstmt.setInt(1,myattend+1);
								pstmt.setString(2,userid);
								
								if(pstmt.executeUpdate()==1){
									LogManager.writeNorLog(userid, "success_attend", cmd, "null", "null", myattend+1);
									nextstep = true;
								}
								else {
									//error
									System.out.println("attend event update error");
									ret.put("result", -1);
								}
							}
							else {
								//error
								System.out.println("already get attend reward");
								ret.put("result", -2);
							}
						}
						else {
							System.out.println("i don't have attend info");
							pstmt = conn.prepareStatement("insert into user_attend (uid, attendDate, sumAttend) values(?,now(),?)");
							pstmt.setString(1, userid);
							pstmt.setInt(2, myattend+1);
							
							if(pstmt.executeUpdate()==1){
								LogManager.writeNorLog(userid, "success_attend", cmd, "null", "null", myattend+1);
								nextstep = true;
							}
							else {
								//error
								System.out.println("attend event insert error");
								ret.put("result", -1);
							}
						}
					}
					else {
						System.out.println("Event OFF");
						ret.put("result", 0);
					}
				}
				else {
					System.out.println("Event OFF");
					ret.put("result", 0);
				}
			}
			else {
				//error
				System.out.println("attend event error");
				ret.put("result", -1);
			}
			
			// 유저 출석 정보 올리고 난 후 동작.
			if(nextstep) {
				pstmt = conn.prepareStatement("select " + module.attendReward(myattend+1) +" from attendEvent");
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					ArrayList<AttendRewardInfo> rewardlist = new ArrayList<AttendRewardInfo>();
					int idx = 1;
					for(int i=0;i<4;i++) {
						AttendRewardInfo data = new AttendRewardInfo();
						data.itemid = rs.getInt(idx);
						idx++;
						data.count = rs.getInt(idx);
						idx++;
						rewardlist.add(data);
					}
					
					for(int i=0;i<rewardlist.size();i++) {
						System.out.println("reward:"+rewardlist.get(i).itemid+"/"+rewardlist.get(i).count);
					}
					
					for(int i=0;i<rewardlist.size();i++) {
						if(rewardlist.get(i).itemid != 0) {
							if(rewardlist.get(i).itemid == 100001) {
								pstmt = conn.prepareStatement("update user set freeticket = freeticket + ? where uid = ?");
								pstmt.setInt(1, rewardlist.get(i).count);
								pstmt.setString(2, userid);
								
								if(pstmt.executeUpdate()==1){
									LogManager.writeNorLog(userid, "success_increase", cmd, "freeticket", "null", rewardlist.get(i).count);
									LogManager.writeNorLog(userid, "success_reward", cmd, String.valueOf(rewardlist.get(i).itemid), "null", rewardlist.get(i).count);
								}
								else {
									LogManager.writeNorLog(userid, "fail_increase", cmd, "freeticket", "null", rewardlist.get(i).count);
									LogManager.writeNorLog(userid, "fail_reward", cmd, String.valueOf(rewardlist.get(i).itemid), "null", rewardlist.get(i).count);
								}
							}
							else if(rewardlist.get(i).itemid == 100002) {
								pstmt = conn.prepareStatement("update user set freegem = freegem + ? where uid = ?");
								pstmt.setInt(1, rewardlist.get(i).count);
								pstmt.setString(2, userid);
								
								if(pstmt.executeUpdate()==1){
									LogManager.writeNorLog(userid, "success_increase", cmd, "freegem", "null", rewardlist.get(i).count);
									LogManager.writeNorLog(userid, "success_reward", cmd, String.valueOf(rewardlist.get(i).itemid), "null", rewardlist.get(i).count);
								}
								else {
									LogManager.writeNorLog(userid, "fail_increase", cmd, "freegem", "null", rewardlist.get(i).count);
									LogManager.writeNorLog(userid, "fail_reward", cmd, String.valueOf(rewardlist.get(i).itemid), "null", rewardlist.get(i).count);
								}
							}
							else {
								// 젬과 티켓이 아닐 때
								pstmt = conn.prepareStatement("insert into user_inven (uid,itemid,count,starttime,expiretime,title,message,img) "+
															  "values(?,?,?,now(),date_add(now(),interval 7 day),?,?,?)");
								pstmt.setString(1, userid);
								pstmt.setInt(2,rewardlist.get(i).itemid);
								pstmt.setInt(3,rewardlist.get(i).count);
								pstmt.setString(4,ItemDataManager.getData(rewardlist.get(i).itemid).name);
								pstmt.setString(5,"출석 보상 대여권입니다.");
								pstmt.setString(6,ItemDataManager.getData(rewardlist.get(i).itemid).img);
								
								if(pstmt.executeUpdate()==1){
									LogManager.writeNorLog(userid, "success_reward", cmd, String.valueOf(rewardlist.get(i).itemid), "null", rewardlist.get(i).count);
								}
								else {
									LogManager.writeNorLog(userid, "fail_reward", cmd, String.valueOf(rewardlist.get(i).itemid), "null", rewardlist.get(i).count);
								}
							}
						}
					}
					
					//인벤에서 시간 지난거 지워버리기 
					pstmt = conn.prepareStatement("delete from user_inven where uid = ? and expiretime <= now()");
					pstmt.setString(1,userid);
					pstmt.executeUpdate();
					
					//유저 인벤 정보 로드 
					pstmt = conn.prepareStatement("select idx,itemid, count, starttime, expiretime, title, message, img, userconfirm,DATE_FORMAT(expiretime,'%Y-%m-%d') from user_inven where uid = ? order by expiretime");
					pstmt.setString(1, userid);
					rs = pstmt.executeQuery();
					JSONArray pilist = new JSONArray();
					while(rs.next()){
						JSONObject idata = new JSONObject();
						idata.put("idx",rs.getInt(1));
						idata.put("itemid",rs.getInt(2));
						idata.put("count",rs.getInt(3));
						idata.put("starttime",rs.getTimestamp(4).getTime()/1000);
						idata.put("expiretime",rs.getTimestamp(5).getTime()/1000);
						idata.put("title", rs.getString(6));
						idata.put("message",rs.getString(7));
						idata.put("img",rs.getString(8));
						idata.put("userconfirm",rs.getInt(9));
						idata.put("expiredate",rs.getString(10));
						pilist.add(idata);
					}

					ret.put("userinvenlist",pilist);
					
					//유저 재화 정보 로드
					pstmt = conn.prepareStatement("select freeticket,cashticket,freegem,cashgem from user where uid = ?");
					pstmt.setString(1,userid);
					rs = pstmt.executeQuery();
					if(rs.next()){
						ret.put("gem",(rs.getInt(3)+rs.getInt(4)));
						ret.put("ticket",(rs.getInt(1)+rs.getInt(2)));
					}
					
					//유저 출석 정보 로드
					pstmt = conn.prepareStatement("select attendDate, sumAttend from user_attend where uid = ?");
					pstmt.setString(1, userid);
					rs = pstmt.executeQuery();
					if(rs.next()) {
						ret.put("attendDate", rs.getTimestamp(1).getTime()/1000);
						ret.put("sumAttend", rs.getInt(2));
					}
					
					ret.put("result", 1);
				}
				else {
					//error
					System.out.println("attend event select error");
					ret.put("result", -1);
				}
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