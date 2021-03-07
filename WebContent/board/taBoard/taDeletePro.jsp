<%@page import="global03.groot.model.TaBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>타임어택 글 삭제 pro page</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="post" class="global03.groot.model.TaBoardDTO"/>
<jsp:setProperty property="*" name="post"/>
<% 	
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String pageNum = request.getParameter("pageNum");
	String id = request.getParameter("id");
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	TaBoardDAO dao = TaBoardDAO.getInstance();
	dao.deleteArticle(postNo);	%>
	<script>
		alert("삭제가 완료되었습니다");
		location.href="taBoard.jsp?pageNum=<%=pageNum%>";
	</script>
<body>
</body>
</html>