<%@page import="global03.groot.model.GrootUserDAO"%>
<%@page import="global03.groot.model.TrophyCntDAO"%>
<%@page import="global03.groot.model.TrophyDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>signup pro</title>
</head>
<% request.setCharacterEncoding("UTF-8");
	
	if(session.getAttribute("memId") != null){	%>
		<script>
			alert("로그아웃하고 이용해주세요 ^^;");
			window.location="main.jsp";
		</script>

<%	}else{
	
		if(request.getParameter("id") == null){	%>
			<script>
				alert("올바르지 않은 접근입니다 ^^;");
				window.location="main.jsp";
			</script>
			
<%	}else{	%>
<jsp:useBean id="dto" class="global03.groot.model.GrootUserDTO"/>
<jsp:setProperty property="*" name="dto"/>
<%
		GrootUserDAO dao = GrootUserDAO.getInstance();
		dao.insertMember(dto);
		
		TrophyDAO tDao = TrophyDAO.getInstance();
		tDao.insertUser(dto.getId());
		
		TrophyCntDAO tcDao = TrophyCntDAO.getInstance();
		tcDao.insertUser(dto.getId());
		
		%>
		<script>
			alert("회원가입을 축하합니다~~");
			location.href="/global03/main.jsp";
		</script>
		<%
		}
	}
%>
<body>
</body>
</html>