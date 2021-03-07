<%@page import="global03.groot.model.TaBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ta End Pro.</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	Integer postNo = Integer.parseInt(request.getParameter("postNo"));
	
	TaBoardDAO tDao = TaBoardDAO.getInstance();
	tDao.updateStatus(postNo);
	
	response.sendRedirect("taContent.jsp?postNo="+postNo);
%>
<body>

</body>
</html>