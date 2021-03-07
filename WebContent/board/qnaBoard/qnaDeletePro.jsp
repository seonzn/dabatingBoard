<%@page import="global03.groot.model.QnaBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>QnA Delete Pro</title>
</head> 
<%	request.setCharacterEncoding("UTF-8");	%>

<%
	//호출한 페이지에서 작성자 또는 관리자 아이디가 넘어왔는지
	
	
	
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	String pageNum = request.getParameter("pageNum");
	
	// DAO 통해서 글 삭제
	QnaBoardDAO dao = QnaBoardDAO.getInstance();
	dao.deleteArticle(postNo);
	
	%>
	<script>
		alert("삭제하였습니다.");
		location.href="qnaBoard.jsp";
	</script>
	<%
%>
	
<body>

</body>
</html>