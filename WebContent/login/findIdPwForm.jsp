<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>id/pw 찾기</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
if(session.getAttribute("memId") != null){
	%>
	<script>
		alert("이미 로그인 되었습니다.");
		location.href="/global03/main.jsp";
	</script>
	<%
}
%>
<script>
	function openFindId(){
		var input = document.findIdForm;
		var name = input.name.value;
		var email = input.email.value;
		if(name==""){
			alert("이름을 입력하세요!");
			return;
		}
		if(pw==""){
			alert("이메일을 입력하세요!");
			return;
		}
		
		window.open("" , "popup", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=400, height=200");
		input.target ="popup";
		input.action = "/global03/login/findIdPop.jsp";
		input.submit();
	}
	
	function checkForm(){
		var input = document.findPwForm;
		var id = input.id.value;
		var name = input.name.value;
		var email = input.email.value;
		
		if(id == ""){
			alert("아이디를 입력하세요!");
			return false;
		}
		if(name == ""){
			alert("아이디를 입력하세요!");
			return false;
		}
		if(email == ""){
			alert("아이디를 입력하세요!");
			return false;
		}
	}
</script>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br/>
	<form name="findIdForm" method="post">
		<table align="center">
			<tr>
				<td colspan="2">
					<h3>ID 찾기</h3>
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td><input type="text" name="name"/></td>
			</tr>
			<tr>
				<td>이메일</td>
				<td><input type="email" name="email"/></td>
			</tr>
			<tr>
				<td colspan="2" align="right"><input type="button" value="찾기" onclick="openFindId()"/></td>
			</tr>
		</table>
	</form>
	<br/><br/><br/>
	<form action="/global03/login/editPwForm.jsp" name="findPwForm" method="post" onsubmit="return checkForm()">
		<table align="center">
			<tr>
				<td colspan="2">
					<h3>PW 찾기</h3>
				</td>
			</tr>
			<tr>
				<td>아이디</td>
				<td><input type="text" name="id"/></td>
			</tr>
			<tr>
				<td>이름</td>
				<td><input type="text" name="name"/></td>
			</tr>
			<tr>
				<td>이메일</td>
				<td><input type="email" name="email"/></td>
			</tr>
			<tr>
				<td colspan="2" align="right"><input type="submit" value="찾기"/></td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>