<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.File" %>
<%@ page import="com.wingsinus.ep.ConnectionProvider" %>
<%@ page import="com.wingsinus.ep.JdbcUtil" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>

<H2>&nbsp;&nbsp;&nbsp;&nbsp;에셋 번들 버전</H2>
<section>
	<H3 style="font-size:100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;에셋 번들 버전</H3>
</section>

<section>
	<H3 style="font-size:30">&nbsp;&nbsp; 1. 먼저 csv를 다운받아 주세요.</H3>
</section>
			
<form action="csvupload_assetbundleversion.jsp" method="post">
	<input type="hidden" name="param" value="Download">
	<input type ="submit" value ="다운로드">
</form>

<section>
	<H3 style="font-size:30">&nbsp;&nbsp; 2. 다운받은 csv 파일을 수정 후에 올려주세요.</H3>
</section>
			
<form target="result_frame" action="csvupload_assetbundleversion_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
	<table border = "1" style="border-style:solid;">
		<tr>
			<td> 적용할 AssetBundleVersion.csv 파일 </td>
			<td><input type="file" name="AssetBundleVersion" /></td>
		</tr>
		<tr>
			<td colspan = "2" align="center">
			<input type="submit" value="적용하기" /> </td>
		</tr>
	</table>
</form>

<%
	PreparedStatement pstmt = null;
	Connection conn = null;
	ResultSet rs = null;
	String param = request.getParameter("param");
	BufferedInputStream fin = null;
	BufferedOutputStream outs = null;
	
	String filepath = "";
	String filename = "";
	FileWriter fw = null;
	String today = "";
	
	try {
		if(param!=null && param.equals("Download")) {
			if(ConnectionProvider.afgt_build_ver == 0) {
				filepath = "/usr/share/tomcat6/webapps/tempcsv/";
			}
			// live
			else if(ConnectionProvider.afgt_build_ver == 1) {
				filepath = "/usr/local/tomcat7/apache-tomcat-7.0.82/webapps/tempcsv/";
			}
			
			// 1. 서버에 저장
			filename = "AssetBundleVersion.csv";
			fw = new FileWriter(filepath+filename);
			conn = ConnectionProvider.getConnection("afgt");
			
			pstmt = conn.prepareStatement("select AssetBundleName, version from AssetBundleVersion");
			
			rs = pstmt.executeQuery();
			
			fw.append("AssetBundleName");
			fw.append(',');
			fw.append("version");
			fw.append('\n');
			
			while(rs.next()) {
				fw.append(rs.getString(1));
				fw.append(',');
				fw.append(rs.getString(2));
				fw.append('\n');
			}
			
			fw.flush();
			fw.close();
			
			// 2. 서버에서 부터 다운로드.
			File file = new File(filepath+filename);
			byte b[]=new byte[(int)file.length()];
			
			response.setHeader("Content-Disposition","attachment;filename="+filename);
			response.setHeader("Content-Length",String.valueOf(file.length()));
			
			if(file.isFile()) {
				 fin = new BufferedInputStream(new FileInputStream(file));
				 outs = new BufferedOutputStream(response.getOutputStream());
				 int read=0;
				 while((read=fin.read(b))!=-1){outs.write(b,0,read);}
			}
			
			outs.close();
			fin.close();
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

<table border="1" style="border-style: solid;" width="90%">
	<tr>
		<td width="100%" height="200">
			<iframe name="result_frame" width="100%" height="200"></iframe>
		</td>
	</tr>
</table>