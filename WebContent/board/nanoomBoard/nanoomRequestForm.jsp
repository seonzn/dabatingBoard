<%@page import="global03.groot.model.NanoomDAO"%>
<%@page import="global03.groot.model.NanoomDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>nanoomRequestForm(pop-up)</title>
	<link href="/css/style.css" rel="stylesheet" type="text/css">
	<script>
	// 유효성검사
	function check(){
		var inputs = document.inputForm;
		if(!inputs.name.value){
			alert("이름을 입력하세요.")
			return false;
		}
		if(!inputs.addr.value){
			alert("주소를 입력하세요.")
			return false;
		}
		if(!inputs.tel.value){
			alert("전화번호를 입력하세요.")
			return false;
		}
	}
	
	</script>
</head>
<%
	request.setCharacterEncoding("UTF-8");

	int result = Integer.parseInt(request.getParameter("result"));
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	
	String currId = (String) session.getAttribute("memId");
	
	NanoomDAO dao = NanoomDAO.getInstance();
	NanoomDTO article = dao.getarticle(postNo);

	if(currId == null){%>
		<script>
			alert("로그인 후 이용해주세요.");
			self.close()
		</script>
	<%}else if(result == 1){%>
		<script>
			alert("이미 나눔 신청 중에 있습니다.");
			self.close()
		</script>
	<%}else if(result == 2){%>
			<script>
				alert("나눔이 완료된 글입니다.");
				self.close()
			</script>
	<%}else if(currId != null){
		if(currId.equals(article.getId())){%>
			<script>
				alert("본인글에는 나눔을 받을 수 없습니다.");
				self.close()
			</script>
		<%}
	}%>
		
	
<body>
	<br/><br/>
	<form action="/global03/board/nanoomBoard/nanoomRequestPro.jsp" name="inputForm" onsubmit="return check()">
	<br>
		<input type="hidden" name="postNo" value="<%=article.getPostNo()%>">
		<input type="hidden" name="id" value="<%=article.getId()%>">
		<input type="hidden" name="requestId" value="<%=session.getAttribute("memId")%>">
		<%if(article.getResult() == 0){%>
			<input type="hidden" name="result" value="1">
		<%} %>
		<div align="center">
		<table>
			<thead>
				<tr>
					<th colspan="2">아래의 정보로 나눔을 요청합니다</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>이름</th>
					<td><input type="text" name="name"></td>
				</tr>
				<tr>
					<th>주소</th>
					<td><input type="text" name="addr"></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td><input type="text" name="tel"></td>
				</tr>
				<tr>
					<td align="right" colspan="2">
						<input type="submit" class="btn1" value="나눔요청하기">	
						<input type="button" class="btn1" value="취소" onclick="self.close()" />	
					</td>
				</tr>
			</tbody>
		</table>
		</div>
	</form>
</body>

</html>