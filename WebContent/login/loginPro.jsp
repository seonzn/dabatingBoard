<%@page import="global03.groot.model.GrootUserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Pro.</title>
</head>
<%

	boolean res = false;
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	if(session.getAttribute("memId") != null || id == null || pw == null){
		%>
		<script>
			alert("잘못된 접근입니다");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	request.setCharacterEncoding("UTF-8");
	
	//아이디 패스워드 체크
	GrootUserDAO guDao = GrootUserDAO.getInstance();
	res = guDao.idPwCheck(id, pw);
	
	if(res){
		session.setAttribute("memId", id);
		session.setAttribute("memPw", pw);
		
		response.sendRedirect("/global03/main.jsp");
	}else{
		%>
		<script>
			alert("회원정보가 일치하지 않습니다!");
			history.go(-1);
		</script>
		<%
	}
	
%>
<body>

</body>
</html>