<%@page import="global03.groot.model.NanoomDAO"%>
<%@page import="global03.groot.model.NanoomRequestDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>nanoomRequestPro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");%>
	<jsp:useBean id="requestDto" class="global03.groot.model.NanoomRequestDTO"/>
	<jsp:setProperty property="*" name="requestDto"/>
	
<%

	NanoomRequestDAO requestDao = NanoomRequestDAO.getInstance();
	requestDao.insertNanoomRequest(requestDto);
	
	NanoomDAO dao = NanoomDAO.getInstance();
	dao.updateResult(requestDto);
	
%>
	<script>
		alert("나눔신청이 완료되었습니다");
		opener.document.location.reload(); /*창닫고 새로고침*/
		self.close();
	</script>
		
<body>
</body>
</html>