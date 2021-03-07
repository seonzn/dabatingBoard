<%@page import="global03.groot.model.DebateBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자유토론 글 수정 pro page</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="post" class="global03.groot.model.DebateBoardDTO"/>
<jsp:setProperty property="*" name="post"/>
<% 	
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String pageNum = request.getParameter("pageNum");
	if(pageNum==null){ pageNum="1"; }
	int postNo = Integer.parseInt(request.getParameter("postNo"));

	DebateBoardDAO dao = DebateBoardDAO.getInstance();
	dao.modifyArticle(post);	%>
	<script>
		alert("수정이 완료되었습니다");
		location.href="debateContent.jsp?pageNum=<%=pageNum%>&postNo=<%=postNo%>";
	</script>
<body>
</body>
</html>