<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 제명</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String currId = (String)session.getAttribute("memId");
	
	if(id == null || currId == null || !"admin".equals(currId)){
		%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
		<%
	}
	
	
%>
<script>
	function formCheck(){
		var input = document.adminPwForm;
		var pw = input.pw.value;
		if(pw == ""){
			alert("비밀번호를 입력해주세요.");
			return false;
		}
	}
</script>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br/>
<form action="deleteUserPro.jsp" name="adminPwForm" method="post" onsubmit="return formCheck()">
	<input type="hidden" name="id" value="<%=id %>" />
	<table>
		<tr>
			<td>관리자 비밀번호</td>
		</tr>
		<tr>
			<td><input type="password" name="pw" /></td>
		</tr>
		<tr>
			<td><input type="submit" value="제명" /></td>
		</tr>
	</table>
</form>
</div>
</body>
</html>