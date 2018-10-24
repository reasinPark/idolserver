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
<%@ page import="com.wingsinus.ep.StoryManager" %>
<%
	//configuration
	int maxSize = 1024 * 1024 * 10; // 파일 용량을 10M 으로 제한.
	
	String filepath = "";
	
	//mysql
	PreparedStatement pstmt = null;
	Connection conn = ConnectionProvider.getConnection("afgt");
	ResultSet rs = null;
	MultipartRequest mr = null;
	try {
		// test
		if(ConnectionProvider.afgt_build_ver == 0) {
			filepath = "/usr/share/tomcat6/webapps/tempcsv/";
		}
		// live
		else if(ConnectionProvider.afgt_build_ver == 1) {
			filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
		}
		
		mr = new MultipartRequest(request, filepath, maxSize, "UTF-8");
		
		Enumeration files = mr.getFileNames();

		while(files.hasMoreElements()) {
			String obj = (String)files.nextElement();
			File csv = mr.getFile(obj);

			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(csv), "UTF-8"));
			
			// 1.업로드 파일 이름 체크
			if(csv.toString().equals(filepath+"story.csv")) {
				
				String line = "";
				int i = 0;
				int completeCount = 1;
				
				while((line = br.readLine()) != null) {
					
					// -1 옵션은 마지막 "," 이후 빈 공백도 읽기 위한 옵션
					String[] token = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)",-1);
					
					// 2.컬럼 갯수 체크, 현재 데이터는 맨 윗 줄 컬럼 제목 데이터.
					if(i == 0) {
						pstmt = conn.prepareStatement("select count(*) from information_schema.columns where table_name = 'story'");
						rs = pstmt.executeQuery();
						
						if(rs.next()) {
							int colcount = rs.getInt(1);
							int filecolcount = 0;
							
							for (String output: token) {
								output = output.replaceAll("\"", "");
								
								filecolcount++;
							}
							
							if(colcount != filecolcount) {
								out.print("컬럼 수가 맞지 않습니다! 정확한 파일을 올렸는지 확인해주세요!");  %> <br> <%
								break;
							}
							else {
								pstmt = conn.prepareStatement("truncate story");
								int r = pstmt.executeUpdate();
								
								if(r == 0) {
									i++;
								}
								else {
									out.print("기존 데이터 삭제 오류! 제보 부탁 드립니다!");  %> <br> <%
									break;
								}
							}
						}
						else {
							out.print("컬럼 수 체크 오류! 제보 부탁 드립니다!");  %> <br> <%
							break;
						}						
					}
					else {
						int index = 1;
						
						pstmt = conn.prepareStatement("insert into story (Story_id,csvfilename,title,writer,summary,category_id,imgname,recommend,totalcount,director,sort) values(?,?,?,?,?,?,?,?,?,?,?)");
						
						for (String output: token) {
							output = output.replaceAll("\"", "");
							
							// int
							if(index == 6 || index == 8 || index == 9 || index == 11) {
								pstmt.setInt(index, Integer.parseInt(output));
							}
							// string
							else {
								pstmt.setString(index, output);
							}
							index++;
						}
						
						if(pstmt.executeUpdate() == 1) {
							completeCount++;
						}
						else {
							out.print("데이터 삽입 중 오류! 확인해주세요!!"); %> <br> <%
							break;
						}
						
						i++;
					}
				}
				
				if(completeCount == i) {
					out.print("스토리 데이터 적용 완료!"); %> <br> <%
				}
				else {
					out.print("스토리 데이터 적용 실패! 확인해주세요."); %> <br> <%
				}
			}
			else {
				out.print("파일명이 다릅니다. 업로드한 파일이 story.csv가 맞는지 확인해주세요!"); %> <br> <%
				break;
			}
			
			br.close();
		}
	} catch(Exception e) {
		%>
		다시 확인해 주세요. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	} finally {

	}
%>