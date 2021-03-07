<%@page import="java.util.Date"%>
<%@page import="global03.groot.model.TaBoardDTO"%>
<%@page import="global03.groot.model.TaReplyDAO"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@page import="java.util.List"%>
<%@page import="global03.groot.model.TaBoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>타임어택 게시판</title>
	<link href="../../css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%	
	request.setCharacterEncoding("UTF-8");
	String memId = (String)session.getAttribute("memId");
	String memPw = (String)session.getAttribute("memPw");
	
	int pageSize = 10;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum==null){ pageNum="1"; }
	
	int currPage = Integer.parseInt(pageNum);
	int startRow = (currPage-1)*pageSize+1;
	int endRow = currPage*pageSize;
	int count = 0;
	int number = 0;
	
	TaBoardDAO dao = TaBoardDAO.getInstance();
	List articleList = null;
	//검색 분기처리
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	if(sel!=null && search!=null){
		count = dao.getSearchArticleCount(sel, search);
		if(count>0){
			articleList = dao.getSearchArticles(startRow,endRow,sel,search);
		}
	}else{
		count = dao.getArticleCount();
		if(count>0){
			articleList = dao.getArticles(startRow,endRow);
		}		
	}
	//정렬 분기처리
	String sort = request.getParameter("sort");
	if(sort!=null){
		count = dao.getArticleCount();
		if(count>0){
			articleList = dao.ArticlesSortedByOption(startRow, endRow, sort);
		}
	}
	
	number = count - (currPage-1)*pageSize;
	
	GenreDAO dao2 = GenreDAO.getInstance();
	TaReplyDAO dao3 = TaReplyDAO.getInstance();
	
%>
<body>
<div>
	<jsp:include page="/header/grootHeader.jsp"/>
	<br/>
	<h1 align="left">타임어택 게시판</h1>
	<%if(count==0){ %>
		<table class="type09">
			<tr>
				<td colspan="9" align="center">게시글이 없습니다</td>
			</tr>
		</table>
	<%}else{ %>
			<table class="type09">
			<thead>
			<tr>
				<td colspan="9" align="right">
					<form action="taBoard.jsp">
						<select name="sort">								<%--정렬의 name값은 sort--%>
							<option value="reg" selected>최신순</option>
							<option value="liked">인기순</option>
						</select>
						<input type="submit" value="정렬"/>
					</form>
				</td>
			</tr>
			</thead>
			<thead>
			<tr>
				<th>No.</th>
				<th>장르</th>
				<th>도서명</th>
				<th>제목</th>
				<th>상태</th>
				<th>작성자</th>
				<th>작성시간</th>
				<th>조회수</th>
				<th>추천수</th>
			</tr>
			</thead>
			<%for(int i=0 ; i<articleList.size() ; i++){ 
				TaBoardDTO article = (TaBoardDTO)articleList.get(i);	
				//articleList.getReg() 의 시간을 비교해서 taBoard테이블 status반영
				//글이 쓰여진 시간 가져오기
				Date date = article.getReg();
				long writenTime = date.getTime();
				
				//현재시간 가져오기
				Date date1 = new Date();
				long currTime = date1.getTime();
				
				//남은시간 = 기준시간(15분) - (현재시간-작성시간)
				long remainTime = (60 * 5) - ((currTime - writenTime)/1000);
				
				if(remainTime < 0){
					dao.updateStatus(article.getPostNo());
					article.setStatus(1);
				}
			%>
				<tr>
					<td><%=number--%></td>
					<td><a href="taBoard.jsp?sel=genre&search=<%=article.getGenre()%>"><%=dao2.toGenreName(article.getGenre())%></a></td>
					<td width="200px"><a href="taBoard.jsp?sel=bookName&search=<%=article.getBookName()%>"><%=article.getBookName()%></a></td>
					<td width="350px"><a href="taContent.jsp?postNo=<%=article.getPostNo()%>&pageNum=<%=pageNum%>&replyPageNum=1"><%=article.getSubject()%>&nbsp;[<%=dao3.getReplyCount(article.getPostNo())%>]</a></td>
					<td>
						<%if(article.getStatus()==0){ %> 진행중
						<%}else if(article.getStatus()==1){ %> 종료됨	<%} %>
					</td>
					<td><%=article.getId()%></td>
					<td><%=sdf.format(article.getReg())%></td>
					<td align="center"><%=article.getReadCnt()%></td>
					<td align="center"><%=article.getLiked()%></td>
				</tr>
			<%} %>
			<tr>
				<td colspan="9" align="right">
					<button class="btn1" onclick="window.location='taBoard.jsp'">전체보기</button>
				</td>
			</tr>
		</table>
		<br/><br/>
		<div align="center">
			<h4>현재 페이지: <%=pageNum%></h4>
		<%
			int pageCount = (count/pageSize)+(count%pageSize==0?0:1);
			int pageBlock = 5;
			int startPage = (int)(((currPage-1)/pageBlock)*pageBlock+1);
			int endPage = startPage+pageBlock-1;
			if(endPage>pageCount){ endPage = pageCount; }
			
			//앞으로 가는 기호 "<"
			if(sel!=null && search!=null){
				if(startPage>pageBlock){	%>
					<a href="taBoard.jsp?pageNum=<%=startPage-pageBlock%>&sel=<%=sel%>&search=<%=search%>"> &lt; </a>
		<%		}
			}
			if(sort!=null){
				if(startPage>pageBlock){	%>
					<a href="taBoard.jsp?pageNum=<%=startPage-pageBlock%>&sort=<%=sort%>"> &lt; </a>
		<%		}
			}
			if(sel==null && search==null && sort==null){
				if(startPage>pageBlock){	%>				
					<a href="taBoard.jsp?pageNum=<%=startPage-pageBlock%>"> &lt; </a>
		<%		}
			}
			//페이지 숫자
			if(sel!=null && search!=null){	
				for(int i = startPage ; i<=endPage ; i++){	%>
				<a href="taBoard.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>"> &nbsp; <%=i%> &nbsp; </a>
		<%		}
			}
			if(sort!=null){
				for(int i = startPage ; i<=endPage ; i++){	%>
				<a href="taBoard.jsp?pageNum=<%=i%>&sort=<%=sort%>"> &nbsp; <%=i%> &nbsp; </a>
		<%		}
			}
			if(sel==null && search==null && sort==null){
				for(int i = startPage ; i<=endPage ; i++){	%>
				<a href="taBoard.jsp?pageNum=<%=i%>"> &nbsp; <%=i%> &nbsp; </a>
		<%		}
			}
			//뒤로 가는 기호 ">"
			if(sel!=null && search!=null){
				if(endPage<pageCount){	%>
					<a href="taBoard.jsp?pageNum=<%=startPage+pageBlock%>&sel=<%=sel%>&search=<%=search%>"> &gt; </a>
		<%		}
			}
			if(sort!=null){
				if(endPage<pageCount){	%>
					<a href="taBoard.jsp?pageNum=<%=startPage+pageBlock%>&sort=<%=sort%>"> &gt; </a>
		<%		}
			}
			if(sel==null && search==null && sort==null){
				if(endPage<pageCount){	%>				
					<a href="taBoard.jsp?pageNum=<%=startPage+pageBlock%>"> &gt; </a>
		<%		}
			}%>
		<br/>
			<form action="taBoard.jsp">
				<select name="sel">										<%--검색의 name값은 sel--%>
					<option value="bookName" selected>도서명</option>
					<option value="id">작성자</option>
					<option value="subject">제목</option>
					<option value="content">내용</option>
				</select>
				<input type="text" name="search"/>
				<input type="submit" value="검색"/>
			</form>
		</div>
	<%} %>
</div>
</body>
</html>