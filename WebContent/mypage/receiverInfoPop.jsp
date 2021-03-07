<%@page import="global03.groot.model.NanoomRequestDAO"%>
<%@page import="global03.groot.model.NanoomRequestDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나눔요청</title>
<link href="/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	request.setCharacterEncoding("UTF-8");

	Integer postNo = Integer.parseInt(request.getParameter("postNo"));
	String bookName = request.getParameter("bookName");
	
	if(session.getAttribute("memId") == null || postNo == null || bookName == null){
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	//postNo로 nanoomRequest테이블에서 수신자 정보 받아오기
	NanoomRequestDAO nrDao = NanoomRequestDAO.getInstance();
	
	NanoomRequestDTO nrDto = nrDao.getReceiverInfo(postNo);
%>
<script>
	function closePop(){
		self.close();
	}
</script>
<body>
	<table class="type09" align="center">
		<tr align="center">
			<td><h2>수신인 정보</h2></td>
		</tr>
		<tr>
			<td>신청자 ID</td>
			<td><%= nrDto.getRequestId() %></td>
		</tr>
		<tr>
			<td>이름</td>
			<td><%= nrDto.getName() %></td>
		</tr>
		<tr>
			<td>전화번호</td>
			<td><%= nrDto.getTel() %></td>
		</tr>
		<tr>
			<td>주소</td>
			<td><%= nrDto.getAddr() %></td>
		</tr>
		<tr align="center">
			<td><button onclick="closePop()" style="color:#00691e;background-color:#ffffff;">닫기</button></td>
		</tr>
	</table>
</body>
</html>