<%@page import="global03.groot.model.GenreDAO"%>
<%@page import="global03.groot.model.DebateBoardDTO"%>
<%@page import="global03.groot.model.DebateBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자유토론 글 수정</title>
	<link href="../../css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	String pageNum = request.getParameter("pageNum");
	if(pageNum==null){ pageNum="1"; }
	String id = request.getParameter("id");
	
	DebateBoardDAO dao = DebateBoardDAO.getInstance();
	DebateBoardDTO article = dao.getArticle(postNo, memId);
	
	GenreDAO dao2 = GenreDAO.getInstance();
%>
<body>
<div>
	<jsp:include page="/header/grootHeader.jsp"/>
	<br/>
	<form action="debateModifyPro.jsp" method="post">
	<input type="hidden" name="id" value="<%=article.getId()%>"/>
	<input type="hidden" name="genre" value="<%=article.getGenre()%>"/>
	<input type="hidden" name="cbCheck" value="<%=article.getCbCheck()%>"/>
	<input type="hidden" name="bookName" value="<%=article.getBookName()%>"/>
	<input type="hidden" name="postNo" value="<%=postNo%>"/>
		<table align="left" class="type10">
			<thead>
				<tr>
					<th colspan="3">자유토론 글 수정</th>
				</tr>
			</thead>
			<tbody>
			<tr>
				<th>작성자</th>
				<td colspan="2" align="left"><%=article.getId()%></td>
			</tr>
			<tr>
				<th>장르</th>
				<td align="left"><%=dao2.toGenreName(article.getGenre())%></td>
				<td align="left">* 찬반토론 여부는 수정할 수 없습니다. </td>
			</tr>
			<tr>
				<th>도서명</th>
				<td colspan="2" align="left"><%=article.getBookName()%></td>
			</tr>
			<tr>
				<th>제목</th>
				<td colspan="2" align="left"><input type="text" name="subject" value=<%=article.getSubject()%> style="height: 30px; width:500px"/></td>
			</tr>
			<tr>
				<th>내용</th>
				<td colspan="2" align="left"><textarea cols="100" rows="40" name="content" style="resize: none;"><%=article.getContent()%></textarea></td>
			</tr>
			<tr>
				<td colspan="3" align="right">
					<input type="submit" class="btn1" value="수정"/>
					<button class="btn1" onclick="window.location='debateContent.jsp?postNo=<%=postNo%>&pageNum=<%=pageNum%>">취소</button>
				</td>
			</tr>
			</tbody>
		</table>
	</form>
</div>
</body>
</html>