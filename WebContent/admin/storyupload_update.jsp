<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%	
	// configuration
	int maxSize = 1024 * 1024 * 10; // 파일 용량을 10M 으로 제한.
	
	long fileSize = 0;				// 파일 사이즈
	String fileType = "";			// 파일 타입
	
	MultipartRequest mr = null;
	
	try {
		// test
		if(ConnectionProvider.afgt_build_ver == 0) {
			mr = new MultipartRequest(request, "/usr/share/tomcat6/webapps/story/", maxSize, "utf-8");
		}
		// live
		else if(ConnectionProvider.afgt_build_ver == 1) {
			mr = new MultipartRequest(request, "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/story/", maxSize, "utf-8");
		}
		
		Enumeration files = mr.getFileNames();
		
		while(files.hasMoreElements()) {
			String file = (String)files.nextElement();
			String systemName = mr.getFilesystemName(file);
			fileSize = file.length();
			fileType = mr.getContentType(file);
			
			%> <%=systemName%> 업로드 완료! <br> <%
		}
		
	} catch(Exception e) {
		%>
		데이터가 잘못 되었습니다. 다시 확인해 주세요. error!<br>
		<%=e.toString()%><br>
		<%
		for(int i = 0; i < e.getStackTrace().length; i++) {
			%><%=e.getStackTrace()[i]%><br><%
		}
	} finally {

	}
%>
	