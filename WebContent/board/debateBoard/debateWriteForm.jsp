<%@page import="global03.groot.model.GenreDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자유토론 방 글쓰기</title>
	<link href="../../css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String pageNum = request.getParameter("pageNum");
	if(pageNum==null){ pageNum="1"; }
	
	GenreDAO dao = GenreDAO.getInstance();
	
	if(memId==null || memId.equals("null")){	%>
		<script>
			alert("로그인 후 이용해주세요");
			history.go(-1);
		</script>
<%	}else{	%>
	<body>
	<div>
		<jsp:include page="/header/grootHeader.jsp"/>
		<br/>
		<form action="debateWritePro.jsp" method="post">
			<input type="hidden" name="id" value="<%=memId%>"/>
			<table align="left" class="type10" >
				<thead>
					<tr>
						<th colspan="4">자유토론 글 쓰기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>작성자</th>
						<td align="left" width="100" colspan="3"><%=memId%></td>
					</tr>
					<tr>
						<th>장르</th>
						<td align="left" width="100">
							<select name="genre">
								<option value="1" selected><%=dao.toGenreName(1)%></option>
								<option value="2"><%=dao.toGenreName(2)%></option>
								<option value="3"><%=dao.toGenreName(3)%></option>
								<option value="4"><%=dao.toGenreName(4)%></option>
								<option value="5"><%=dao.toGenreName(5)%></option>
								<option value="6"><%=dao.toGenreName(6)%></option>
							</select>
						</td>
						<td align="left">
							<input type="checkbox" name="cbCheck" value="1"/>찬반토론
						</td>
					</tr>
					<tr>
						<th>도서명</th>
						<td align="left" width="100" colspan="3"><input type="text" name="bookName"/></td>
					</tr>
					<tr>
						<th>제목</th>
						<td align="left" colspan="2"><input type="text" name="subject" style="width:300px"/></td>
					</tr>
					<tr>
						<th>내용</th>
						<td colspan="3"><textarea cols="90" rows="40" name="content" style="resize: none;"></textarea></td>
					</tr>
					<tr>
						<td colspan="3" align="right">
							<input type="submit" class="btn1" value="작성"/>
							<input type="button" class="btn1" value="취소" onclick="window.location='debateBoard.jsp?pageNum=<%=pageNum%>'"/>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		</div>
	</body>
	
<%	} %>
</html>