<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
   
<%
	boolean iscorrect = false;
	int countnum = 0;
	String param = request.getParameter("countnum");
	
	if(param == null) {
		
	}
	else {
		countnum = Integer.parseInt(param);
		
		if(countnum > 0 && countnum <= 10) {
			iscorrect = true;
		}
		else {
			iscorrect = false;
			%>
			<script type="text/javascript">alert("정확한 숫자를 입력해주세요.");</script>
			<%
		}
	}
%>
   
	<H2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;스토리 파일 업로드</H2>
	
	<form method="post" name="search_form" id="item_form" action="storyupload.jsp">
		<input type="hidden" name="command" value="search">
		<table border="1" style="border-style:solid;">
		<tr height="10">
			<td colspan="3"> 아래에 추가할 파일 갯수를 입력 후 확인을 누르면 됩니다. (최대 10개까지)
		</tr>
		<tr height="30">
			<td><input type="text" name="countnum" size="30" value="<%=((iscorrect)? countnum : "0")%>"></td>
			<td><input type="submit" value="확인"></td>
		</tr>
		</table>
	</form>
	<br>
	<%if(iscorrect) { %>
	<form target="result_frame" action="storyupload_update.jsp" method="post" id="item_form" enctype="Multipart/form-data">
		<table border = "1" style="border-style:solid;">
		<% 
			for(int i=0;i<countnum;i++) {
				%>
				<tr>
					<td> 업로드 파일 <%=i+1%> </td>
					<td><input type="file" name="fileName<%=i%>" /></td>
				</tr>
				<%
			}
			%>
			<tr>
				<td colspan = "2" align="center">
				<input type="submit" value="전송" /> </td>
			</tr>
		</table>
	</form>
	<table border="1" style="border-style: solid;" width="90%">
	<tr>
		<td width="100%" height="200">
			<iframe name="result_frame" width="100%" height="200"></iframe>
		</td>
	</tr>
	</table>
	<%} %>