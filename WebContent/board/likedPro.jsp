<%@page import="global03.groot.model.TaLikedDAO"%>
<%@page import="global03.groot.model.TrophyCntDAO"%>
<%@page import="global03.groot.model.TrophyDAO"%>
<%@page import="global03.groot.model.DebateLikedDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자유토론 게시글 추천 pro page</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="debateLiked" class="global03.groot.model.DebateLikedDTO"/>
<jsp:setProperty property="*" name="debateLiked"/>
<jsp:useBean id="taLiked" class="global03.groot.model.TaLikedDTO"/>
<jsp:setProperty property="*" name="taLiked"/>
<%
	String memId = (String)session.getAttribute("memId");
	if(memId==null){ memId = "null"; }
	String memPw = (String)session.getAttribute("memPw");
	String pageType = request.getParameter("pageType");
	String pageNum = request.getParameter("pageNum");
	String writer = request.getParameter("writer");
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	
	if(memId==null || memId.equals("null")){	%>
	<script>
		alert("추천은 로그인 후에 가능합니다");
		history.go(-1);
	</script>
<%	}else{
		if(pageType.equals("debate")){
			DebateLikedDAO dao = DebateLikedDAO.getInstance();
			boolean res = dao.articleLiked(postNo,memId,writer);
			if(res){
				//트로피 처리: 작성한 게시글의 좋아요 수(sprCnt) +1, 좋아요 누른 수(ddaCnt) +1
				TrophyCntDAO dao2 = TrophyCntDAO.getInstance();
				dao2.addCntSpr(writer);	//좋아요 받은 사람(writer)의 sprCnt +1
				dao2.addCntDda(memId);	//좋아요 누른 사람(memId)의 ddaCnt +1
				
				//트로피 체크: spr 개수에 따라서 트로피 티어 결정
				TrophyDAO dao3 = TrophyDAO.getInstance();
				dao3.sprTrophyAchieve(writer);
				dao3.ddaTrophyAchieve(memId);
				
				response.sendRedirect("/global03/board/debateBoard/debateContent.jsp?pageNum="+pageNum+"&postNo="+postNo);
			}else{	%>
				<script>
					alert("본인 글이거나 이미 추천한 경우에는 추천이 불가능합니다");
					history.go(-1);
				</script>
<%			}
		}else if(pageType.equals("ta")){
			TaLikedDAO dao = TaLikedDAO.getInstance();
			boolean res = dao.articleLiked(postNo,memId,writer);
			if(res){
				//트로피 처리: 작성한 게시글의 좋아요 수(sprCnt) +1, 좋아요 누른 수(ddaCnt) +1
				TrophyCntDAO dao2 = TrophyCntDAO.getInstance();
				dao2.addCntSpr(writer);	//좋아요 받은 사람(writer)의 sprCnt +1
				dao2.addCntDda(memId);	//좋아요 누른 사람(memId)의 ddaCnt +1
				
				//트로피 체크: spr 개수에 따라서 트로피 티어 결정
				TrophyDAO dao3 = TrophyDAO.getInstance();
				dao3.sprTrophyAchieve(writer);
				dao3.ddaTrophyAchieve(memId);
				
				response.sendRedirect("/global03/board/taBoard/taContent.jsp?pageNum="+pageNum+"&postNo="+postNo);
			}else{	%>
				<script>
					alert("본인 글이거나 이미 추천한 경우에는 추천이 불가능합니다");
					history.go(-1);
				</script>
<%			}
		}
	}	%>
<body>
</body>
</html>