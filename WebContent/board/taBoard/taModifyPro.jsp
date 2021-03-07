<%@page import="global03.groot.model.TaBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>타임어택 글 수정 pro page</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="post" class="global03.groot.model.TaBoardDTO"/>
<jsp:setProperty property="*" name="post"/>
<% 	
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String pageNum = request.getParameter("pageNum");
	if(pageNum==null){ pageNum="1"; }
	int postNo = Integer.parseInt(request.getParameter("postNo"));

	TaBoardDAO dao = TaBoardDAO.getInstance();
	dao.modifyArticle(post);	%>
	<script>
		alert("수정이 완료되었습니다");
		location.href="taContent.jsp?pageNum=<%=pageNum%>&postNo=<%=postNo%>";
	</script>
<body>
</body>
</html>