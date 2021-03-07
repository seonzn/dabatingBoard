<%@page import="global03.groot.model.NanoomDTO"%>
<%@page import="global03.groot.model.NanoomDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deletePro</title>
</head>
<%
	if(session.getAttribute("memId") == null){%>
		<script>
			alert("로그인 후 사용하세요.");
			window.location="/global03/login/loginForm.jsp";
		</script>
	<%} 

	int postNo = Integer.parseInt(request.getParameter("postNo"));
	String pageNum = request.getParameter("pageNum");
	String currId = (String)session.getAttribute("memId");
	NanoomDAO dao = NanoomDAO.getInstance();
	
	// 나눔 요청 result = 1 인경우 삭제 못함
	NanoomDTO article = dao.getarticle(postNo);
	if(article.getResult() == 1){%>
		<script>
			alert("나눔 요청 중인 글은 삭제 할 수 없습니다.");
			history.go(-1);
		</script>
	<%}else{
		// 글 삭제
		boolean res = dao.deleteAtricle(postNo, currId);
		if(res){%>
			<script>
				alert("삭제 되었습니다.")
				window.location = "/global03/board/nanoomBoard/nanoomBoard.jsp?pageNum=" + <%=pageNum%>;
			</script>
		<%}else{%>
			<script>
				alert("작성자만 삭제가 가능합니다.")
				history.go(-1);
			</script>
		<%} 
	}
%>
<body>
</body>
</html>