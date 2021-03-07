<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Logout Pro.</title>
</head>
<%
	if(session.getAttribute("memId") == null && session.getAttribute("memPw") == null){
		%>
		<script>
			alert("로그인 상태가 아닙니다");
			history.go(-1);
		</script>
		<%
	}

	if(session.getAttribute("memId") != null){
		session.invalidate();
		response.sendRedirect("/global03/main.jsp");
	}
%>
<body>

</body>
</html>