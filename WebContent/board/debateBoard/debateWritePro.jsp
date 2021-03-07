<%@page import="global03.groot.model.TrophyDAO"%>
<%@page import="global03.groot.model.TrophyCntDAO"%>
<%@page import="global03.groot.model.BooksDAO"%>
<%@page import="global03.groot.model.DebateBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자유토론 글 쓰기 pro page</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="article" class="global03.groot.model.DebateBoardDTO"/>
<jsp:setProperty property="*" name="article"/>
<%
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String pageNum = request.getParameter("pageNum");
	if(pageNum==null || pageNum.equals("null")){
		pageNum="1";
	}
	
	//글 저장
	DebateBoardDAO dao = DebateBoardDAO.getInstance();
	dao.insertArticle(article);
	
	//책 정보 저장
	BooksDAO dao2 = BooksDAO.getInstance();
	dao2.insertBookInfo(article.getBookName(), article.getGenre());
	
	//트로피 처리: 작성한 게시글(guk) +1
	TrophyCntDAO dao3 = TrophyCntDAO.getInstance();
	dao3.addCntGuk(article.getId());
	
	//트로피 체크: guk 개수에 따라서 트로피 티어 결정
	TrophyDAO dao4 = TrophyDAO.getInstance();
	dao4.gukTrophyAchieve(article.getId());
	
	response.sendRedirect("debateBoard.jsp?pageNum="+pageNum);
	
%>
<body>

</body>
</html>