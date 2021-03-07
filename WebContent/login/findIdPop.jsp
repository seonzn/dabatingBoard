<%@page import="global03.groot.model.GrootUserDTO"%>
<%@page import="global03.groot.model.GrootUserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ID 찾기</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	
	GrootUserDAO guDao = GrootUserDAO.getInstance();
	GrootUserDTO guDto = guDao.userCheck(name, email);
	System.out.println(guDto);
%>
<body>
	<%
	if(guDto != null){
		%>
		<table align="center">
			<tr>
				<td>
				<h2 align="center">회원님의 아이디는</h2>
				<h3 align="center"><%=guDto.getId() %> 입니다.</h3>
				</td>
			</tr>
			<tr>
				<td align="center">
				<button onclick="setId()" align="center">닫기</button>
				</td>
			</tr>
		</table>
		<script>
			function setId(){
				opener.document.findPwForm.id.value = "<%=guDto.getId()%>";
				self.close();
			}
		</script>
		<%
	}else{
		%>
		<table align="center">
			<tr>
				<td>
				<h2 align="center">정보가 일치하지 않습니다</h2>
				</td>
			</tr>
			<tr>
				<td align="center">
				<button onclick="closePop()" align="center">닫기</button>
				</td>
			</tr>
		</table>
		<script>
			function closePop(){
				self.close();
			}
		</script>
		<%
	}
	%>
</body>
</html>