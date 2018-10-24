<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%
	String filepath = "";
	String filename = request.getParameter("filename");
	BufferedInputStream fin = null;
	BufferedOutputStream outs = null;

	try {
		if(ConnectionProvider.afgt_build_ver == 0) {
			filepath = "/usr/share/tomcat6/webapps/tempcsv/";
		}
		// live
		else if(ConnectionProvider.afgt_build_ver == 1) {
			filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
		}
		
		File file = new File(filepath+filename+".csv");
		byte b[]=new byte[(int)file.length()];
		
		response.setHeader("Content-Disposition","attachment;filename="+filename+".csv");
		response.setHeader("Content-Length",String.valueOf(file.length()));
		
		if(file.isFile()) {
			 fin = new BufferedInputStream(new FileInputStream(file));
			 outs = new BufferedOutputStream(response.getOutputStream());
			 int read=0;
			 while((read=fin.read(b))!=-1){outs.write(b,0,read);}
		}

		outs.close();
		fin.close();
	
	}catch(Exception e){
		
	}finally{
		
	}		
%>