<%@page import="global03.groot.model.NanoomDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="global03.groot.model.GenreDTO"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@page import="com.sun.org.apache.xalan.internal.xsltc.compiler.sym"%>
<%@page import="global03.groot.model.NanoomDTO"%>
<%@page import="global03.groot.model.NanoomDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>nanoomBoard(나눔게시판))</title>
	<link href="/css/style.css" rel="stylesheet" type="text/css">
</head>
<%
	int pageSize = 8; //현재 페이지 보여줄 게시글 수
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	int currPage = Integer.parseInt(pageNum);	// 현재 페이지 int형 변환
	int startRow = (currPage -1) * pageSize + 1; // 페이지 게시물 시작 번호
	int endRow = currPage * pageSize;	// 페이지 게시물 끝번호
	int number = 0;	// 게사판상 보여줄 가상의 글번호
	int count = 0; // DB에 저장된 전체 글 갯수
	
	// 나눔가능글 보기 누르면 possible = 1 넘겨준다
	String possible = request.getParameter("possible");
	
	List articleList = null; // 게시글 리스트
	NanoomDAO dao = NanoomDAO.getInstance();
	
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	
	//System.out.println(sel);
	//System.out.println(search);

	List genreList = null; // 장르 옵션 리스트
	GenreDAO genredao = GenreDAO.getInstance();
	genreList = genredao.genreArticles();
	
	if(sel != null && search != null){ // 검색기능
		for(int i = 0; i < genreList.size(); i++){
			GenreDTO genrearticle = (GenreDTO) genreList.get(i);
			if(sel.equals(genrearticle.getNo())){ // 장르검색
				count = dao.getsearchArticlCount(sel, search); // 검색된 글 전체 개수
				if(count > 0){
					articleList = dao.getSearchArticles(startRow, endRow, sel, search);
				}
			} else{ // 책제목 검색
					count = dao.getsearchArticlCount(sel, search);
					if(count > 0){
						articleList = dao.getSearchArticles(startRow, endRow, sel, search);
					}
				}
		}
	}else{
		count = dao.getArticleCount();
		if(count > 0){
			articleList = dao.getarticles(startRow, endRow);
		}
	}
	number = count - (currPage-1) * pageSize; // 게시글 넘버링
%>
<body>
<div>
	<jsp:include page="/header/grootHeader.jsp"/>
	<br />
	<h1 align="left">나눔 방</h1>
	<%if(count == 0) { // 게시글 없는경우%>
	<table>
		<tr>
			<td colspan="2" align="right">
				<input type="button" value="글쓰기" onclick="window.location='/global03/board/nanoomBoard/nanoomWriteForm.jsp'" />
			</td>
		</tr>
		<tr>
			<td align="center">게시글이 없습니다</td>
		</tr>

	</table>
	<%} else{ // 게시글 있는경우%>
	<table style="width: 99%;">
		<tr>
			<td align="left">
				<button class="btn1" onclick="location.href='nanoomBoard.jsp'">전체보기</button>
			</td>
			<td align="right">
				<form action="/global03/board/nanoomBoard/nanoomBoard.jsp?">
					<input type="checkbox" name="sel" value="result" hidden="" checked="checked">
					<input type="checkbox" name="search" value="0" hidden="" checked="checked">
					<input type="checkbox" name="possible" value="1" hidden="" checked="checked">
					<%if(possible == null){%>
						<input type="submit" class="btn1" value="나눔가능 글 보기" />
					<%}%>
					<input type="button" class="btn1" value="글쓰기" onclick="window.location='/global03/board/nanoomBoard/nanoomWriteForm.jsp?pageNum=<%=pageNum %>'" />
				</form>
			</td>
		</tr>
	</table>
	<% 
		for(int i = 0; i < articleList.size(); i++){
			NanoomDTO article = (NanoomDTO)articleList.get(i);
			int result = article.getResult();
	%>
			<div class="nanoomdiv">
				<table border="0" style="width: 100%;">
				<tr>
					<td align="left">
						No. <%= number-- %>
					</td>
					<td align="right">
						(<%=article.getId() %>)
					</td>
				</tr>
				<tr>
					<td style="height: 200px" align="center" colspan="2">
						<%if(article.getImg() == null){%>
							<img src="/global03/img/book(default).png" style="border-radius: 7px" width="250px" height="200px">
						<%}else{%>
							<img src="/global03/save/<%=article.getImg() %>" width="250px" height="200px">
						<%} %>
					</td>
				</tr>
				<tr>
					<td align="left" colspan="2">
						<% if(article.getResult() == 0){%>
						<button class="naStatBtn">신청가능</button>
						<%}else if(article.getResult() == 1){%>
						<button class="naStatBtn">신청중</button>
						<%} else {%>
						<button class="naStatBtn">나눔완료</button>
						<%}%>
						<br/>
						<a href="/global03/board/nanoomBoard/nanoomContent.jsp?postNo=<%=article.getPostNo()%>&pageNum=<%=pageNum %>&number=<%=number%>" style="font-size: 17pt; font-weight: bold;"><%=article.getBookName() %></a>
						<p style="font-size: 13pt; font-weight: bold; color: #a6a6a6;"><%=genredao.stringGenre(article.getGenre()) %></p>
						<p style="font-size: 13pt; font-weight: bold;"><%=article.getSubject()%></p><br/><br/>
					</td>
				<tr/>
				</table>
			</div>
		<%} %>
	
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	<div align="center"> <%-- 페이지 넘버, 페이지 넘버 찍기, 페이지 앞.뒤로가기 기호 넣기 --%>
		<h4>현재 페이지 : <%=pageNum %></h4>
	<%
		int pageBlock = 5; // 보여줄 페이지 번호의 갯수 지정
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		int startPage = (((currPage -1)/pageBlock) * pageBlock) + 1;
		int endPage = startPage + pageBlock - 1;
		if(endPage > pageCount)endPage = pageCount;
		
		if(startPage > pageBlock){ // 앞으로 가는 기호
			if(sel != null || search != null || possible != null){%>
				<a href="nanoomBoard.jsp?pageNum=<%=startPage-pageBlock %>&sel=<%=sel %>&search=<%=search %>&possible=<%=possible %>" class="pageNums"> &lt; </a>
		<%}else{%>
				<a href="nanoomBoard.jsp?pageNum=<%=startPage-pageBlock %>" class="pageNums"> &lt; </a>
			<%}
		}
		
		if(sel != null && search != null){
			for(int i = startPage;i <= endPage; i++){ // 검색 페이지 숫자 찍기%>
				<a href="nanoomBoard.jsp?pageNum=<%=i %>&sel=<%=sel %>&search=<%=search %>&possible=<%=possible %>" class="pageNums"> &nbsp; <%=i %> &nbsp; </a>	
		<%	}
		}else{
			for(int i = startPage;i <=  endPage; i++){ // 일반페이지 숫자 찍기%>
				<a href="nanoomBoard.jsp?pageNum=<%=i %>" class="pageNums"> &nbsp; <%=i %> &nbsp; </a>	
		<%	}		
		}
		
		if(endPage < pageCount){ // 뒤로 가는 기호
			if(sel != null || search != null || possible != null){%>
				<a href="nanoomBoard.jsp?pageNum=<%=startPage+pageBlock %>&sel=<%=sel %>&search=<%=search %>&possible=<%=possible %>" class="pageNums"> &gt; </a>
			<%}else{%>
				<a href="nanoomBoard.jsp?pageNum=<%=startPage+pageBlock %>" class="pageNums"> &gt; </a>
			<%} 
		} %> 
		<br/>
		<%-- 책제목/장르 검색 --%>
		<form action="/global03/board/nanoomBoard/nanoomBoard.jsp">
			<select name="sel">
				<option value="bookName">책제목</option>
			<%
				for(int i = 1; i <genreList.size(); i++){
				GenreDTO genrearticle = (GenreDTO) genreList.get(i);%>
				<option value="<%=genrearticle.getNo() %>"><%=genrearticle.getGenre() %> </option>	
			<%}	%>
			</select>
				<input type="text" name="search">
				<input type="submit" value="검색">
		</form>
	<%} //else 게시글 있을 경우%>
	<br/>
	</div>
</div>
</body>

</html>