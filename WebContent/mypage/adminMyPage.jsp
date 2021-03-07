<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link href="/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	String currId = (String)session.getAttribute("memId");
	
	if(!"admin".equals(currId) || currId == null){
		%>
		<script>
			alert("관리자가 아닙니다.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	
%>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<h1>관리자 페이지</h1>
<button class="btn1" onclick="location.href='/global03/mypage/admin/userMgm.jsp'">회원관리</button>
<br/><hr/><br/>
<h3 style="margin: 0px 0px 0px 100px;">답변 미완료</h3>
<jsp:include page="/board/qnaBoard/qnaBoard.jsp">
	<jsp:param value="admin" name="pageType"/>
	<jsp:param value="unanswered" name="qnaStatus" />
</jsp:include>
<br/><hr/><br/>
<h3 style="margin: 0px 0px 0px 100px;">답변 완료</h3>
<jsp:include page="/board/qnaBoard/qnaBoard.jsp">
	<jsp:param value="admin" name="pageType"/>
	<jsp:param value="answered" name="qnaStatus" />
</jsp:include>
</div>
</body>
</html>