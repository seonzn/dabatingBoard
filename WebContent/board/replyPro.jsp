<%@page import="global03.groot.model.TaReplyDAO"%>
<%@page import="global03.groot.model.TrophyDAO"%>
<%@page import="global03.groot.model.TrophyCntDAO"%>
<%@page import="global03.groot.model.DebateReplyDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>댓글 작성 pro page</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="debateReply" class="global03.groot.model.DebateReplyDTO"/>
<jsp:setProperty property="*" name="debateReply"/>
<jsp:useBean id="taReply" class="global03.groot.model.TaReplyDTO"/>
<jsp:setProperty property="*" name="taReply"/>
<%
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String pageType = request.getParameter("pageType");
	String pageNum = request.getParameter("pageNum");
	int postNo = Integer.parseInt(request.getParameter("postNo"));

	if(memId==null || memId.equals("null")){	%>
		<script>
			alert("댓글은 로그인 후에 작성 가능합니다");
			history.go(-1);
		</script>
<%	}else{
		if(pageType.equals("debate")){
			DebateReplyDAO dao = DebateReplyDAO.getInstance();
			dao.insertReply(debateReply);
			
			TrophyCntDAO dao2 = TrophyCntDAO.getInstance();
			//댓글 작성자 nhc 1 올려주기
			dao2.addCntNhc(memId);
			//원글 작성자 influ 1 올려주기
			dao2.addCntInflu(debateReply.getPostNo());
			
			TrophyDAO dao3 = TrophyDAO.getInstance();
			dao3.nhcTrophyAchieve(memId);
			dao3.influTrophyAchieve(debateReply.getPostNo());
			
			response.sendRedirect("/global03/board/debateBoard/debateContent.jsp?postNo="+postNo+"&pageNum="+pageNum);

		}else if(pageType.equals("ta")){
			TaReplyDAO dao = TaReplyDAO.getInstance();
			dao.insertReply(taReply);
			
			TrophyCntDAO dao2 = TrophyCntDAO.getInstance();
			//댓글 작성자 nhc 1 올려주기
			dao2.addCntNhc(memId);
			//원글 작성자 influ 1 올려주기
			dao2.addCntInflu(taReply.getPostNo());
			
			TrophyDAO dao3 = TrophyDAO.getInstance();
			dao3.nhcTrophyAchieve(memId);
			dao3.influTrophyAchieve(taReply.getPostNo());
			
			response.sendRedirect("/global03/board/taBoard/taContent.jsp?postNo="+postNo+"&pageNum="+pageNum);
		}
	}
%>
<body>
</body>
</html>