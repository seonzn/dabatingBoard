<%@page import="global03.groot.model.TaChanBanDAO"%>
<%@page import="global03.groot.model.DebateChanBanDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자유토론 찬성/반대 pro page</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="debateChanBan" class="global03.groot.model.DebateChanBanDTO"/>
<jsp:setProperty property="*" name="debateChanBan"/>
<jsp:useBean id="taChanBan" class="global03.groot.model.TaChanBanDTO"/>
<jsp:setProperty property="*" name="taChanBan"/>
<%
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String cb = request.getParameter("cb");
	String pageType = request.getParameter("pageType");
	String pageNum = request.getParameter("pageNum");
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	
	if(memId==null || memId.equals("null")){	%>
	<script>
		alert("찬성 및 반대는 로그인 후에 가능합니다");
		history.go(-1);
	</script>
<%	}else{	
		if(pageType.equals("debate")){
			DebateChanBanDAO dao = DebateChanBanDAO.getInstance();
			boolean res = dao.chanOrBan(postNo,memId,cb);
			if(res){
				response.sendRedirect("/global03/board/debateBoard/debateContent.jsp?pageNum="+pageNum+"&postNo="+postNo);
			}else{	%>
				<script>
					alert("본인 글이거나 이미 찬성/반대한 경우에는 찬성/반대가 불가능합니다");
					history.go(-1);
				</script>
		<%	}
		}else if(pageType.equals("ta")){
			TaChanBanDAO dao = TaChanBanDAO.getInstance();
			boolean res = dao.chanOrBan(postNo,memId,cb);
			if(res){
				response.sendRedirect("/global03/board/taBoard/taContent.jsp?pageNum="+pageNum+"&postNo="+postNo);
			}else{	%>
				<script>
					alert("본인 글이거나 이미 찬성/반대한 경우에는 찬성/반대가 불가능합니다");
					history.go(-1);
				</script>
<%			}		
		}
	}		%>
<body>

</body>
</html>