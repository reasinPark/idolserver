<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="com.wingsinus.ep.EpisodeList" %>
<%
	int maxSize = 1024*1024*10;
	
	String filepath = "";
	
	PreparedStatement pstmt = null;
	Connection conn = ConnectionProvider.getConnection("idol");
	ResultSet rs = null;
	MultipartRequest mr = null;
	try{
		//test
		if(ConnectionProvider.afgt_build_ver==0){
			filepath = "/usr/share/tomcat6/webapps/tempcsv/";
		}
		//live
		else if(ConnectionProvider.afgt_build_ver==1){
			filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
		}
		
		mr = new MultipartRequest(request,filepath,maxSize,"UTF-8");
		
		Enumeration files = mr.getFileNames();
		
		while(files.hasMoreElements()){
			String obj = (String)files.nextElement();
			File csv = mr.getFile(obj);
			
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(csv),"UTF-8"));
			
			//1. 업로드 파일 이름 체크 
			if(csv.toString().equals(filepath+"specialepisode.csv")){
				
				String line = "";
				int i=0;
				int completeCount = 1;
				
				while((line = br.readLine())!=null){
					String[] token = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)",-1);
					
					if(i==0){
						pstmt = conn.prepareStatement("select count(*) from information_schema.columns where table_name = 'specialepisode' and table_schema = 'idol'");
						rs = pstmt.executeQuery();
						
						if(rs.next()){
							int colcount = rs.getInt(1);
							int filecolcount = 0;
							
							for(String output:token){
								output = output.replaceAll("\"","");
								
								filecolcount++;
							}
							
							if(colcount != filecolcount){
								out.print("컬럼 수가 맞지 않습니다! 정확한 파일을 올렸는지 확인해주세요!"); %> <br> <%
								break;
							}else{
								pstmt = conn.prepareStatement("truncate specialepisode");
								int r = pstmt.executeUpdate();
								
								if(r ==0){
									i++;
								}else{
									out.println("기존 데이터 삭제 오류! 제보 부탁드립니다!"); %> <br> <%
									break;
								}
							}
						}else{
							out.print("컬럼 수 체크 오류! 제보 부탁 드립니다!");%> <br> <%
							break;
						}
					}
					else{
						int index = 1;
						
						pstmt = conn.prepareStatement("insert into specialepisode (Specialid,epcondition,stcondition,cool,hot,cute,texture1,texture2,texture3,detailtitle,detailcontent) values(?,?,?,?,?,?,?,?,?,?,?)");
						
						for(String output:token){
							output = output.replaceAll("\"","");
							
							if(index == 1||index == 2||index == 4||index ==5||index ==6){
								pstmt.setInt(index, Integer.parseInt(output));
							}else{
								pstmt.setString(index, output);
							}
							index++;
						}
						
						if(pstmt.executeUpdate() == 1){
							completeCount++;
						}else{
							out.println("데이터 삽입 중 오류! 확인해주세요!! "); %> <br> <%
							break;
						}
						
						i++;
					}
				}
				
				if(completeCount == i){
					out.print("스페셜 에피소드 데이터 적용 완료!"); %> <br> <%
				}else{
					out.print("스페셜 에피소드 데이터 적용 실패! 확인해주세요!"); %> <br> <%
				}
			}
			else{
				out.print("파일명이 다릅니다. 업로드한 파일이 specialepisode.csv가 맞는지 확인해주세요!"); %> <br> <%
				break;
			}
			
			br.close();
		}
	}catch(Exception e){
		%>
		다시 확인해 주세요. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	}finally{
		
	}

%>
