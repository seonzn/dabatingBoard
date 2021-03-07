<%@page import="global03.groot.model.GenreDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>타임어택 글쓰기</title>
	<link href="../../css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	String pageNum = request.getParameter("pageNum");
	if(pageNum==null){ pageNum="1"; }
	int genre = Integer.parseInt(request.getParameter("genre"));
	String bookName = request.getParameter("bookName");
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
			<form action="taWritePro.jsp" method="post">
				<input type="hidden" name="id" value="<%=memId%>"/>
				<input type="hidden" name="bookName" value="<%=bookName%>"/>
				<input type="hidden" name="genre" value="<%=genre%>"/>
				<input type="hidden" name="cbCheck" value="1"/>	<%-- 타임어택방은 찬반토론 필수임 --%>
				<table align="left" class="type10">
					<thead>
						<tr>
							<th colspan="3">타임어택 글 쓰기</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th>작성자</th>
							<td align="left" width="100"><%=memId%></td>
						</tr>
						<tr>
							<th>장르</th>
							<td align="left" width="100"><%=dao.toGenreName(genre)%></td>
						</tr>
						<tr>
							<th>도서명</th>
							<td align="left" width="100"><%=bookName%></td>
						</tr>
						<tr>
							<th>제목</th>
							<td align="left"><input type="text" name="subject" style="height:20px; width:500px"/></td>
						</tr>
						<tr>
							<th>내용</th>
							<td colspan="2"><textarea cols="100" rows="40" name="content" style="resize: none;"></textarea></td>
						</tr>
						<tr>
							<td colspan="3" align="right">
								<input type="submit" class="btn1" value="작성"/>
								<input type="button" class="btn1" value="취소" onclick="window.location='taBoard.jsp?pageNum=<%=pageNum%>'"/>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
			</div>
		</body>
<%	} %>
<body>
</body>
</html>