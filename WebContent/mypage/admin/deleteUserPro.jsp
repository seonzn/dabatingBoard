<%@page import="global03.groot.model.TrophyDAO"%>
<%@page import="global03.groot.model.TrophyCntDAO"%>
<%@page import="global03.groot.model.GrootUserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 제명 pro.</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String currId = (String)session.getAttribute("memId");
	String pw = request.getParameter("pw");
	
	if(id == null || currId == null || !"admin".equals(currId) || pw == null){
		%>
		<script>
			alert("잘못된 접근입니다.");
			history.go(-1);
		</script>
		<%
	}
	
	boolean res = false;
	GrootUserDAO guDao = GrootUserDAO.getInstance();
	res = guDao.idPwCheck(currId, pw);
	
	if(!res){
		%>
		<script>
			alert("비밀번호가 맞지 않습니다.");
			history.go(-1);
		</script>
		<%
	}else{
		//유저 삭제
		//1) grootUser 에서 레코드 삭제
		guDao.deleteUser(id);
		//2) trophyCnt 에서 레코드 삭제
		TrophyCntDAO tcDao = TrophyCntDAO.getInstance();
		tcDao.deleteUser(id);
		//3) trophy 에서 레코드 삭제
		TrophyDAO tDao = TrophyDAO.getInstance();
		tDao.deleteUser(id);
		
		%>
		<script>
			alert("해당 회원이 제명 되었습니다");
			location.href="userMgm.jsp";
		</script>
		<%
	}
	
%>
<body>

</body>
</html>