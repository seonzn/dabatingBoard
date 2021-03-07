<%@page import="global03.groot.model.TrophyCntDTO"%>
<%@page import="global03.groot.model.TrophyCntDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 트로피 관리</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String currId = (String)session.getAttribute("memId");
	
	if(id == null || !"admin".equals(currId)){
		%>
		<script>
			alert("잘못된 접근입니다.");
			history.go(-1);
		</script>
		<%
	}
	
	//회원의 트로피 정보 가져오기
	TrophyCntDAO tcDao = TrophyCntDAO.getInstance();
	TrophyCntDTO tcDto = tcDao.getUserTrophyInfo(id);
%>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br/>
<form action="userTrophyUpdatePro.jsp">
	<input type="hidden" name="userId" value="<%=tcDto.getUserId()%>" />
	<table class="type10">
		<tr>
			<td colspan="2"><h1><%= id %>님</h1></td>
		</tr>
		<tr>
			<th>싸움닭</th>
			<td><input type="number" name="ssaCnt" placeholder="<%=tcDto.getSsaCnt()%>" value="<%=tcDto.getSsaCnt()%>" /></td>
		</tr>
		<tr>
			<th>국회의원</th>
			<td><input type="number" name="gukCnt" placeholder="<%=tcDto.getGukCnt()%>" value="<%=tcDto.getGukCnt()%>" /></td>
		</tr>
		<tr>
			<th>혜민스님</th>
			<td><input type="number" name="hyeCnt" placeholder="<%=tcDto.getHyeCnt()%>" value="<%=tcDto.getHyeCnt()%>" /></td>
		</tr>
		<tr>
			<th>대머리</th>
			<td><input type="number" name="daeCnt" placeholder="<%=tcDto.getDaeCnt()%>" value="<%=tcDto.getDaeCnt()%>" /></td>
		</tr>
		<tr>
			<th>노홍철</th>
			<td><input type="number" name="nhcCnt" placeholder="<%=tcDto.getNhcCnt()%>" value="<%=tcDto.getNhcCnt()%>" /></td>
		</tr>
		<tr>
			<th>인플루언서</th>
			<td><input type="number" name="influCnt" placeholder="<%=tcDto.getInfluCnt()%>" value="<%=tcDto.getInfluCnt()%>" /></td>
		</tr>
		<tr>
			<th>슈퍼스타</th>
			<td><input type="number" name="sprCnt" placeholder="<%=tcDto.getSprCnt()%>" value="<%=tcDto.getSprCnt()%>" /></td>
		</tr>
		<tr>
			<th>따봉충</th>
			<td><input type="number" name="ddaCnt" placeholder="<%=tcDto.getDdaCnt()%>" value="<%=tcDto.getDdaCnt()%>" /></td>
		</tr>
		<tr>
			<td colspan="2" align="right">
				<input type="submit" class="btn1" value="수정"/>
			</td>
		</tr>
	</table>
</form>
</div>
</body>
</html>