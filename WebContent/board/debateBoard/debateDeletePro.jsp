<%@page import="global03.groot.model.DebateBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자유토론 글 삭제 pro page</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="post" class="global03.groot.model.DebateBoardDTO"/>
<jsp:setProperty property="*" name="post"/>
<% 	
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String pageNum = request.getParameter("pageNum");
	String id = request.getParameter("id");
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	DebateBoardDAO dao = DebateBoardDAO.getInstance();
	dao.deleteArticle(postNo);	%>
	<script>
		alert("삭제가 완료되었습니다");
		location.href="debateBoard.jsp?pageNum=<%=pageNum%>";
	</script>
<body>
</body>
</html>