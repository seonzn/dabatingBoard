<%@page import="global03.groot.model.GenreDTO"%>
<%@page import="java.util.List"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>nanoomWriteForm</title>
	<link href="../../css/style.css" rel="stylesheet" type="text/css">
	<script>
	//유효성검사
	function check(){
		var inputs = document.inputForm;
		if(inputs.genre.value == ""){
			alert("장르를 선택하세요.");
			return false;
		}
		if(!inputs.bookName.value){
			alert("도서명을 입력하세요.");
			return false;
		}
		if(!inputs.subject.value){
			alert("제목을 입력하세요.");
			return false;
		}
	}
	</script>
</head>
<%
	if(session.getAttribute("memId") == null){%>
		<script>
			alert("로그인 후 사용 가능합니다.");
			window.location="/global03/board/nanoomBoard/nanoomBoard.jsp";
		</script>
	<%}else{
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null) pageNum = "1";	
	
	
	GenreDAO genreDao = GenreDAO.getInstance();
	List genreList = genreDao.genreArticles();
	
%>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
	<br/>
	<form action="/global03/board/nanoomBoard/nanoomWritePro.jsp?pageNum=<%=pageNum %>" method="post" enctype="multipart/form-data" name="inputForm" onsubmit="return check()">
		<table class="type10" align="center" style="width: 900px;">
			<thead>
				<tr>
					<th colspan="2">나눔글 작성</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>책 사진 첨부</th>
					<td align="left" ><input type="file" name="img"></td>
				</tr>
				<tr>
					<th>작성자</th>
					<td align="left">&nbsp;<b><%=session.getAttribute("memId")%></b></td>
				</tr>
				<tr>
					<th>장르*</th>
					<td align="left">
						<select name ="genre">
							<option value="">장르선택</option>
				<%
						for(int i = 1; i < genreList.size() ; i++){
						GenreDTO genreArticle = (GenreDTO) genreList.get(i);
						%>
							<option value="<%=genreArticle.getNo() %>" ><%=genreArticle.getGenre() %></option>
				<%		}%>		
						</select>
					</td>
				</tr>
				<tr>
					<th>도서명*</th>
					<td align="left"><input type="text" name="bookName" /></td>
				</tr>
				<tr>
					<th>제목(최대 15자)*</th>
					<td align="left"><input type="text" name="subject" maxlength="15"/></td>
				</tr>
				<tr>
					<th>내용(최대 100자)*</th>
					<td align="left"><textarea rows="25" cols="90" name="content" maxlength="100"></textarea> </td>
				</tr>
				<tr>
					<td colspan="2" align="right"  style="border: none;">
						<input type="submit" class="btn1" value="작성">
						<input type="button" class="btn1" value="취소" onclick="window.location='/global03/board/nanoomBoard/nanoomBoard.jsp?pageNum=<%=pageNum%>'" />
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	<%} %>
</div>
</body>
</html>