<%@page import="global03.groot.model.TrophyCntDAO"%>
<%@page import="global03.groot.model.TrophyDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>트로피 정보 수정</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="tcDto" class="global03.groot.model.TrophyCntDTO"/>
<jsp:setProperty property="*" name="tcDto"/>
<%
	TrophyCntDAO tcDao = TrophyCntDAO.getInstance();
	tcDao.updateUserTrophyCnt(tcDto);
	
	%>
	<script>
		alert("수정이 완료되었습니다.");
		location.href="/global03/mypage/admin/userMgm.jsp";
	</script>
	<%
%>
<body>

</body>
</html>