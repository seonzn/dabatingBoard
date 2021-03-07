<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>We Are Groot</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<%
	//현재 세션 아이디
	String currId = (String)session.getAttribute("memId");
%>
<table align="center" style="width: 100%">
	<tr>
		<td align="left" colspan="2">
			<a href="/global03/main.jsp" >
				<img src="/global03/img/logo.png" width="200px"/>
			</a>
		</td>
		<td align="right" colspan="2">
			<%
			if(currId == null){
			%>
			<button class="login" onclick="location.href='/global03/login/loginForm.jsp'" style="width:206px; height:50px;">로그인</button><br/>
			<a href="/global03/login/findIdPwForm.jsp">id/pw 찾기</a>
			<a href="/global03/login/signupForm.jsp">회원가입</a>
			<%
			}else if(!"admin".equals(currId)){
			%>
			<h3><%= currId %>님</h3>
			<button class="btn1" onclick="location.href='/global03/mypage/myPage.jsp'">마이페이지</button>
			<button class="btn1" onclick="location.href='/global03/login/logoutPro.jsp'">로그아웃</button>
			<%
			}else if("admin".equals(currId)){
				%>
				<h3><%= currId %>님</h3>
				<button class="btn1" onclick="location.href='/global03/mypage/adminMyPage.jsp'">마이페이지</button>
				<button class="btn1" onclick="location.href='/global03/login/logoutPro.jsp'">로그아웃</button>
				<%
			}
			%>
		</td>
	</tr>
	<tr>
	<td colspan="4"><hr/></td>
	</tr>
	<tr>
		<td>
			<button class="btn1" onclick="location.href='/global03/board/debateBoard/debateBoard.jsp'">전체 토론방</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
		<td>
			<button class="btn1" onclick="location.href='/global03/board/taBoard/taBoard.jsp'">타임 어택</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
		<td>
			<button class="btn1" onclick="location.href='/global03/board/nanoomBoard/nanoomBoard.jsp'">나눔방</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
		<td>
			<button class="btn1" onclick="location.href='/global03/board/qnaBoard/qnaBoard.jsp'">QnA</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
	<tr><td colspan="4"><hr/></td></tr>
</table>
</body>
</html>