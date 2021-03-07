<%@page import="global03.groot.model.QnaBoardDTO"%>
<%@page import="global03.groot.model.QnaBoardDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>문의게시판</title>
	<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	String currId = (String)session.getAttribute("memId");
	String pageType = request.getParameter("pageType");
	String qnaStatus = request.getParameter("qnaStatus");

	// 한 페이지에 보여줄 게시글 수
	int pageSize = 10;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	
	// 게시글 페이지 정보 담기
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum="1";
	}
	if(pageType == null){
		pageType="free";
	}
	if(qnaStatus == null){
		qnaStatus = "none";
	}
	
	// 현재 페이지에 보여줄 게시글의 시작과 끝 등 정보 세팅
	int currPage = Integer.parseInt(pageNum);
	int startRow = (currPage - 1) * pageSize + 1;
	int endRow = currPage * pageSize;
	int count = 0;
	int number = 0;
	
	// 게시판 글 가져오기
	QnaBoardDAO dao = QnaBoardDAO.getInstance();
	List articleList = null;
	
	// 검색 키워드
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	
	if("admin".equals(pageType) && "unanswered".equals(qnaStatus)){
		//어드민 마이페이지에서 include했고, 답변 미완료 게시글들
		if(sel != null && search != null){
			count = dao.getSearchUnAsrCnt(sel, search);
			if(count > 0){
				articleList = dao.getSearchUnAsrArticles(sel, search, startRow, endRow);
			}
		}else{
			count = dao.getUnAsrCnt();
			if(count > 0){
				articleList = dao.getUnAsrArticles(startRow, endRow);
			}
		}
	}else if("admin".equals(pageType) && "answered".equals(qnaStatus)){
		//admin 페이지에서 include했고, 답변 완료 게시글들
		if(sel != null && search != null){
			count = dao.getSearchAsrCnt(sel, search);
			if(count > 0){
				articleList = dao.getSearchAsrArticles(startRow, endRow, sel, search);
			}
		}else{
			count = dao.getAsrCnt();
			if(count > 0){
				articleList = dao.getAsrArticles(startRow, endRow);
			}
		}
	}else{
		if(sel != null && search != null){
			count = dao.getSearchArticleCount(sel, search);
			if(count > 0){
				articleList = dao.getSearchArticles(startRow, endRow, sel, search);
			}
		}else{
			count = dao.getArticleCount();
			if(count > 0){
				articleList = dao.getArticles(startRow, endRow);
			}
		}
	}
	
	
	number = count - (currPage - 1) * pageSize;
%>
<body>
<div>
<%
if("free".equals(pageType)){
	%>
	<jsp:include page="/header/grootHeader.jsp"/>
	<br/><br/>
	<h1 style="margin: 0px 0px 0px 20px;" align="left">문의 게시판</h1>
	<%
}
%>
	<%-- 게시글이 없을때 --%>
	<%if(count == 0){ %>
		<table class="type09" align="left">
			<tr>
				<td colspan="6" align="left"><button onclick="window.location='/global03/board/qnaBoard/qnaWriteForm.jsp'">글쓰기</button></td>
			</tr>
			<tr>
				<td align="center">게시글이 없습니다</td>
			</tr>
		</table>
	<%}else{ %>
		<table align="center" class="type09">
		<thead>
			<tr>
				<td colspan="7" align="right"><button class="btn1" onclick="window.location='/global03/board/qnaBoard/qnaWriteForm.jsp?pageNum=<%=pageNum%>'">글쓰기</button></td>
			</tr>
		</thead>
		<thead>
			<tr align="center">
				<th>No.</th>
				<th>유	형</th>
				<th>제	목</th>
				<th>작성자</th>
				<th>작성시간</th>
				<th>조회수</th>
				<th>상태</th>
			</tr>
		</thead>
			<%-- 게시글 목록 tr/td 반복해서 뿌려주기 --%>
			<% for(int i = 0; i < articleList.size(); i++){
				QnaBoardDTO article = (QnaBoardDTO)articleList.get(i);	%>
				<tr>
					<td><%= number-- %></td>
					<td><%=article.getType() %>
					<td align="left" width="350px">
						<%
							int wid = 0;
							if(article.getRe_level() > 0) {
								wid = 8*(article.getRe_level()); %>
								<img src="/global03/img/tabImg.png" width="<%=wid%>" />
								<img src="/global03/img/replyImg.png" width="10" />
						<%	}
							if(article.getSecret() == 1 && (!article.getId().equals(currId) && !"admin".equals(currId))){
								%>
								<img src="/global03/img/lock.png" width="15"/>비밀글입니다
								<%
							}else{
								if(article.getSecret() == 1 && (article.getId().equals(currId) || "admin".equals(currId))){
									%>
									<img src="/global03/img/lock.png" width="15"/>
									<%
								}
								%>
								<a href="/global03/board/qnaBoard/qnaContent.jsp?postNo=<%=article.getPostNo()%>&pageNum=<%=pageNum%>"><%= article.getSubject() %></a>
								<%
							}
							%>
					</td>
					<td><%= article.getId() %></td>
					<td><%= sdf.format(article.getReg()) %></td>
					<td align="center"><%= article.getReadCnt() %></td>
					<td>
					<%
					if(article.getStatus() == 0){
						%>
						답변미완료
						<%
					}else if(article.getStatus() == 1){
						%>
						답변완료
						<%
					}
					%>
					</td>
				</tr>
			<%	}	%>
			<tr>
				<td colspan="7" align="right" >
				<button class="btn1" onclick="<%if("admin".equals(pageType)){%>location.href='/global03/mypage/adminMyPage.jsp'<%}else{ %>window.location='/global03/board/qnaBoard/qnaBoard.jsp'<%}%>">전체 글 보기</button>
				</td>
			</tr>
		</table>
		<br/>
		<%-- 페이지 번호 뷰어 --%>
		<div align="center">
			<h4> 현재페이지 : <%=pageNum%> </h4>
		<%
			int pageCount = count/pageSize + (count%pageSize == 0 ? 0 : 1);
			int pageBlock = 5;
			int startPage = (int)(((currPage - 1)/pageBlock) * pageBlock + 1);
			int endPage = startPage + pageBlock - 1;
			if(endPage > pageCount) {endPage = pageCount;}
			
			// 앞으로 가는 기호 (6~10 보고 있을 때 1~5 로 이동하는 버튼)
			if(startPage > pageBlock) {	%>
				<a href="/global03/board/qnaBoard/qnaBoard.jsp?pageNum=<%=startPage-pageBlock%>" class="pageNums"> &lt; </a>
			<%	}
			
			// 검색했을 때 페이지 숫자 찍기
			if(sel != null && search != null){
				for(int i = startPage; i <= endPage; i++) { %>
					<a href="/global03/board/qnaBoard/qnaBoard.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>" class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
			<%	}
			}else{
			// 일반 페이지 숫자 찍기
				for(int i = startPage; i <= endPage; i++) {	%>
					<a href="/global03/board/qnaBoard/qnaBoard.jsp?pageNum=<%=i%>" class="pageNums"> &nbsp; <%= i %> &nbsp; </a>
			<% 	}
			}				
			// 뒤로 가는 기호 (1~5 보고 있을 때 6~10 찍힌 페이지로 이동하는 버튼)
			if(endPage < pageCount) { %>
				<a href="/global03/board/qnaBoard/qnaBoard.jsp?pageNum=<%=startPage+pageBlock%>" class="pageNums"> &gt; </a>
			<%	}	%>
			<br />
			<%-- 작성자/내용 검색 --%>
			<form action="<%if("free".equals(pageType)){ %>/global03/board/qnaBoard/qnaBoard.jsp <%}else if("admin".equals(pageType)){%>/global03/mypage/adminMyPage.jsp<%}%>">
				<%
				if(!"free".equals(pageType)){
					%>
					<input type="hidden" name="pageType" value="<%=pageType %>" />
					<%
				}
				if(!"none".equals(qnaStatus)){
					%>
					<input type="hidden" name="qnaStatus" value="<%=qnaStatus %>" />
					<%
				}
				%>
				<select name="sel">
					<option value="null">선택하세요</option>
					<option value="id">아이디</option>
					<option value="subject">제목</option>
					<option value="content">내용</option>
				</select>
				<input type="text" name="search"/>
				<input type="submit" value="검색"/>
			</form>
	<%	}	%>
	<br/>
	</div>
</div>
</body>
</html>