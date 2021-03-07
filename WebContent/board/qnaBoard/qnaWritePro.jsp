<%@page import="global03.groot.model.QnaBoardDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>QnA Write Pro</title>
</head>

<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="article" class="global03.groot.model.QnaBoardDTO"/>
<jsp:setProperty property="*" name="article"/>

<%
	String currId = (String)session.getAttribute("memId");
 	// 새글 article.getPostNo() == 0이면 새글, 답글은 1 이상
 	String pageNum = null;
 	if(article.getPostNo() != 0) {
 		pageNum = request.getParameter("pageNum");
 	}else{ 
 		pageNum = "1";
 	}
 	article.setReg(new Timestamp(System.currentTimeMillis()));
%>
 
<%
 	// 데이터 저장
 	QnaBoardDAO dao = QnaBoardDAO.getInstance();
 	dao.insertArticle(article);
 	
 	//관리자가 답글을 달면 status -> 1
 	if(article.getPostNo() > 0 && "admin".equals(currId)){
 		dao.updateStatus(article.getPostNo());
 	}
 	response.sendRedirect("qnaBoard.jsp?pageNum=" + pageNum);
 %>
<body>

</body>
</html>