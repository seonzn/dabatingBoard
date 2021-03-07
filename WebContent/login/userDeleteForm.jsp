<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
if(session.getAttribute("memId") == null){
	%>
	<script>
		alert("로그인 먼저 해주세요.");
		location.href="/global03/main.jsp";
	</script>
	<%
}
%>
<script>
	function deleteConfirm(){
		if(confirm("탈퇴하시겠습니까?") == true){
			document.deleteForm.submit();
		}else{
			return false;
		}
	}
</script>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br/>
<form action="userDeletePro.jsp" name="deleteForm" method="post" name="pwForm">
	<input type="hidden" name="id" value="<%=session.getAttribute("memId") %>"/>
	<table class="type09" width="400px">
		<tr>
			<td colspan="2" align="center"><h1>탈퇴하기</h1></td>
		</tr>
		<tr align="center">
			<td>비밀번호</td>
			<td><input type="password" name="pw"/></td>
		</tr>
		<tr align="center">
			<td colspan="2">
			<input type="button" value="탈퇴하기" style="color:#00691e;background-color:#ffffff;" onclick="deleteConfirm()"/>
			<input type="button" value="취소" style="color:#00691e;background-color:#ffffff;" onclick="location.href='/global03/mypage/myPage.jsp'"/>
			</td>
		</tr>
	</table>
</form>
</div>
</body>
</html>