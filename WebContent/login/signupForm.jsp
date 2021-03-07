<%@page import="global03.groot.model.GenreDTO"%>
<%@page import="java.util.List"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입 (❁´◡`❁)</title>
	<link href="../css/style.css" rel="stylesheet" type="text/css"/>
	<script>
		// 유효성 검사(by 찬물로 씻는다)
		function check(){
			var inputs = document.inputForm;
			if(!inputs.id.value) {
				alert("아이디을 입력하세요");
				return false;
			}
			if(!inputs.pw.value) {
				alert("비밀번호를 입력하세요");
				return false;
			}
			if(!inputs.pwCh.value) {
				alert("비밀번호 확인란을 입력하세요");
				return false;
			}
			if(!inputs.name.value) {
				alert("이름을 입력하세요");
				return false;
			}
			if(inputs.pw.value != inputs.pwCh.value) {
				alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
				return false;
			}
		}
		// id 중복확인(by 찬물로 씻는다)
		function openConfirmId(inputForm){
			console.log(inputForm.id.value);
			if(inputForm.id.value == "") {
				alert("아이디를 입력하세요");
				return;
			}
			var url = "confirmId.jsp?id="+inputForm.id.value;
			open(url, "confirm", "toolbar=no", "location=no, status=no, menubar=no, scrollbars=no, width=200, height=300");
		}
	</script>
</head>
<%	
	if(session.getAttribute("memId") != null){	%>
		<script>
			alert("로그아웃하고 가입해 주세요");
			window.location="main.jsp"
		</script>
		
<%	}else{	

	//장르 목록 가져오기
	GenreDAO gDao = GenreDAO.getInstance();
	List genreList = gDao.getAllGenre();
%>
<body>
	<div>
	<br/>
	<h1 align="center">회원가입</h1>
	<form action="signupPro.jsp" method="post" name="inputForm" onsubmit="return check()">
		<table class="type10" align="center">
			<tbody>
			<tr>
				<th>ID*</th>
				<td>
					<input type="text" name="id"/>
					<input type="button" value="중복확인" class="btn1" onclick="openConfirmId(this.form)"/>
				</td>	
			</tr>
			<tr>
				<th>PW*</th>
				<td><input type="password" name="pw"/></td>
			</tr>
			<tr>
				<th>PW 확인*</th>
				<td><input type="password" name="pwch"/></td>
			</tr>
			<tr>
				<th>E-mail</th>
				<td><input type="text" name="email"/></td>
			</tr>
			<tr>
				<th>이름*</th>
				<td><input type="text" name="name"/></td>
			</tr>
			<tr>
				<th>핸드폰</th>
				<td><input type="text" name="tel" placeholder="하이픈(-) 제외"/></td>
			</tr>
			<tr>
				<th>주소</th>
				<td><input type="text" name="addr"/></td>
			</tr>
			<tr>
				<th>선호장르1</th>
				<td colspan="2">
					<select name="favorite1">
						<%
						for(int i=0; i<genreList.size(); i++){
							GenreDTO gDto = (GenreDTO)genreList.get(i);
							%>
							<option value="<%=gDto.getNo()%>"><%=gDto.getGenre() %></option>
							<%
						}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>선호장르2</th>
				<td colspan="2">
					<select name="favorite2">
						<%
						for(int i=0; i<genreList.size(); i++){
							GenreDTO gDto = (GenreDTO)genreList.get(i);
							%>
							<option value="<%=gDto.getNo()%>"><%=gDto.getGenre() %></option>
							<%
						}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>선호장르3</th>
				<td colspan="2">
					<select name="favorite3">
						<%
						for(int i=0; i<genreList.size(); i++){
							GenreDTO gDto = (GenreDTO)genreList.get(i);
							%>
							<option value="<%=gDto.getNo()%>"><%=gDto.getGenre() %></option>
							<%
						}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" class="btn1" value="가입"/>
					<input type="reset" class="btn1" value="재작성"/>
					<input type="button" class="btn1" value="취소" onclick="location.href='/global03/main.jsp'"/>
				</td>
			</tr>
			</tbody>
		</table>
	</form>
	</div>
</body>
<%	}	%>
</html>