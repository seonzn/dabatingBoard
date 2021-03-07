<%@page import="global03.groot.model.GrootUserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>탈퇴 pro.</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	if(session.getAttribute("memId") == null || id == null || pw == null){
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	
	if("".equals(pw)){
		%>
		<script>
			alert("비밀번호를 입력해 주세요");
			history.go(-1);
		</script>
		<%
	}else{
		GrootUserDAO guDao = GrootUserDAO.getInstance();
		Integer res = guDao.deleteUser(id,pw);
		if(res > 0){
			session.invalidate();
			%>
			<script>
				alert("탈퇴가 완료되었습니다");
				location.href="/global03/main.jsp";
			</script>
			<%
		}else{
			%>
			<script>
				alert("비밀번호가 맞지 않습니다");
				history.go(-1);
			</script>
			<%
		}
	}
%>
<body>

</body>
</html>