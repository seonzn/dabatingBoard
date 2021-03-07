<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login Form</title>
<link href="/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	if(session.getAttribute("memId") != null && session.getAttribute("memPw") != null){
		%>
		<script>
			alert("이미 로그인 되었습니다.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
%>
<script>
	function formCheck(){
		var input = document.loginForm;
		var id = input.id.value;
		var pw = input.pw.value;
		
		if(id == ""){
			alert("아이디를 입력하세요");
			return false;
		}
		
		if(pw == ""){
			alert("비밀번호를 입력하세요");
			return false;
		}
	}
</script>
<body>
<div>
<form action="loginPro.jsp" name="loginForm" method="post" onsubmit="return formCheck()">
	<br/><br/><br/><br/><br/><br/><br/>
	<table align="center" border="0" >
		<tr align="center">
			<td colspan="2">
				<a href="/global03/main.jsp">
					<img src="/global03/img/logo.png" width="200px"/>
				</a>
				<br/><br/><br/><br/>
			</td>
		</tr>
		<tr>
			<td><input type="text" name="id" style="width: 250px; height: 30px;" placeholder="아이디"/><br/></td>
		</tr>
		<tr>
			<td><input type="password" name="pw" style="width: 250px; height: 30px;" placeholder="비밀번호"/></td>
		</tr>
		<tr>
			<td>
				<input type="submit" value="로그인" style="width: 257px; height: 40px; font-size: 18pt; font-weight: bold; border: none; background-color: #ff8000; color: #ffffff;"/>
			</td>
		</tr>
		<tr>
			<td align="right">
				<a href="/global03/login/findIdPwForm.jsp" style="text-decoration: none; color: #000000;">id/pw찾기</a>&nbsp;&nbsp;/&nbsp;&nbsp;
				<a href="/global03/login/signupForm.jsp" style="text-decoration: none; color: #000000;">회원가입</a>
			</td>
		</tr>
	</table>
</form>
</div>
</body>
</html>
