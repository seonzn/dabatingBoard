<%@page import="global03.groot.model.GrootUserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>pw 수정</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	if(session.getAttribute("memId") != null){
		%>
		<script>
			alert("이미 로그인된 회원입니다.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}

	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	
	if(id == null || name == null || email == null){
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	
	GrootUserDAO guDao = GrootUserDAO.getInstance();
	boolean res = guDao.userCheck(id, name, email);
%>
<body>
<div>
	<jsp:include page="/header/grootHeader.jsp"/>
	<%
	if(!res){
		%>
		<script>
			alert("회원정보가 맞지 않습니다!");
			history.go(-1);
		</script>
		<%
	}else{
		%>
		<br/><br/>
		<script>
			function pwFormCheck(){
				var input = document.pwForm;
				var newPw = input.newPw.value;
				var newPwCh = input.newPwCh.value;
				
				if(newPw == ""){
					alert("새 비밀번호를 입력하세요!");
					return false;
				}
				if(newPwCh == ""){
					alert("새 비밀번호 확인을 입력하세요!");
					return false;
				}
				if(newPw != newPwCh){
					alert("비밀번호가 서로 다릅니다!");
					return false;
				}
			}
		</script>
		<form action="/global03/login/editPwPro.jsp" name="pwForm" method="post" onsubmit="return pwFormCheck()">
			<input type="hidden" name="id" value="<%=id%>"/>
			<table>
				<tr>
					<td colspan="2"><h2>비밀번호 변경</h2></td>
				</tr>
				<tr>
					<td>새 비밀번호</td>
					<td><input type="password" name="newPw"/></td>
				</tr>
				<tr>
					<td>새 비밀번호 확인</td>
					<td><input type="password" name="newPwCh"/></td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="submit" value="변경하기"/>
						<input type="button" onclick="" value="취소"/>
					</td>
				</tr>
			</table>
		</form>
		<%
	}
%>
</div>
</body>
</html>