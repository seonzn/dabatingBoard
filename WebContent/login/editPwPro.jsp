<%@page import="global03.groot.model.GrootUserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>pw 변경</title>
</head>
<%

	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String newPw = request.getParameter("newPw");
	
	if(session.getAttribute("memId") != null || id == null || newPw == null){
		%>
		<script>
			alert("잘못된 접근입니다");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	
	GrootUserDAO guDao = GrootUserDAO.getInstance();
	int res = guDao.editPw(id,newPw);
	
	if(res > 0){
		response.sendRedirect("/global03/main.jsp");
	}else{
		%>
		<script>
			alert("pw 변경 실패");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
%>
<body>

</body>
</html>