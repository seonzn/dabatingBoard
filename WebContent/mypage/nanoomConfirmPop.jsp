<%@page import="global03.groot.model.NanoomRequestDAO"%>
<%@page import="global03.groot.model.NanoomRequestDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나눔요청</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
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
<body>
	<table class="type09">
		<tr>
			<td>나눔요청이 있습니다<h2 align="center"><img src="/global03/img/book.png" width="40"/><br/><%= bookName %></h2></td>
		</tr>
	</table>
	<form>
		<table class="type09">
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
		</table>
	</form>
	
	<table class="type09">
		<tr>
			<td>
				<form action="nanoomConfirmPro.jsp">
					<input type="hidden" name="requestId" value="<%= nrDto.getRequestId() %>"/>
					<input type="hidden" name="postNo" value="<%= postNo %>" />
					<input type="submit" name="action" value="수락" style="color:#1797ff;background-color:#ffffff;width:70px;border-top-left-radius:5px;border-bottom-left-radius:5px;margin-right:-3px;"/>
					<input type="submit" name="action" value="거절" style="color:#ff432e;background-color:#ffffff;width:70px;border-top-right-radius:5px;border-bottom-right-radius:5px;margin-left:-3px;"/>
				</form>
			</td>
		</tr>
	</table>
	
</body>
</html>