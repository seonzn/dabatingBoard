<%@page import="global03.groot.model.QnaBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>QnA Modify Pro</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="article" class="global03.groot.model.QnaBoardDTO" />
<jsp:setProperty property="*" name="article"/>

<%
	String pageNum = request.getParameter("pageNum");

	// DB 접속해서 수정
	QnaBoardDAO dao = QnaBoardDAO.getInstance();
	dao.updateArticle(article);
	%>
		<script>
			alert("수정하였습니다");
			location.href="qnaContent.jsp?postNo=<%=article.getPostNo()%>"
		</script>	
	<%
%>

<body>

</body>
</html>