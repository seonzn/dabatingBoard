<%@page import="global03.groot.model.TaReplyLikedDAO"%>
<%@page import="global03.groot.model.DebateReplyLikedDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>댓글 좋아요 pro page</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="debateLiked" class="global03.groot.model.DebateLikedDTO"/>
<jsp:setProperty property="*" name="debateLiked"/>
<jsp:useBean id="taLiked" class="global03.groot.model.TaLikedDTO"/>
<jsp:setProperty property="*" name="taLiked"/>
<%
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String pageType = request.getParameter("pageType");
	String pageNum = request.getParameter("pageNum");
	String replyPageNum = request.getParameter("replyPageNum");
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	int replyNo = Integer.parseInt(request.getParameter("replyNo"));
	
	if(memId == null || memId.equals("null")){	%>
		<script>
			alert("댓글 좋아요는 로그인 후에 가능합니다");
			history.go(-1);
		</script>
<%	}else{
		if(pageType.equals("debate")){
			DebateReplyLikedDAO dao = DebateReplyLikedDAO.getInstance();
			boolean res = dao.replyLiked(memId,postNo,replyNo);
			if(res){
				response.sendRedirect("/global03/board/debateBoard/debateContent.jsp?pageNum="+pageNum+"&postNo="+postNo+"&replyPageNum="+replyPageNum);
			}else{	%>
				<script>
					alert("본인 댓글이거나 이미 좋아요 한 경우에는 좋아요가 불가능합니다");
					history.go(-1);
				</script>
<%			}
		}else if(pageType.equals("ta")){
			TaReplyLikedDAO dao = TaReplyLikedDAO.getInstance();
			boolean res = dao.replyLiked(memId,postNo,replyNo);
			if(res){
				response.sendRedirect("/global03/board/taBoard/taContent.jsp?pageNum="+pageNum+"&postNo="+postNo+"&replyPageNum="+replyPageNum);
			}else{	%>
				<script>
					alert("본인 댓글이거나 이미 좋아요 한 경우에는 좋아요가 불가능합니다");
					history.go(-1);
				</script>
<%			}
		}
	}		%>
<body>
</body>
</html>