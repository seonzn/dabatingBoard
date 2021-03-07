<%@page import="global03.groot.model.NanoomDAO"%>
<%@page import="global03.groot.model.QnaBoardDTO"%>
<%@page import="global03.groot.model.QnaBoardDAO"%>
<%@page import="global03.groot.model.GenreDTO"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@page import="global03.groot.model.TaBoardDTO"%>
<%@page import="global03.groot.model.TaBoardDAO"%>
<%@page import="global03.groot.model.DebateBoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="global03.groot.model.DebateBoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 작성 글</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	if(session.getAttribute("memId")==null){
		%>
		<script>
			alert("로그인을 먼저 해주세요.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	request.setCharacterEncoding("UTF-8");
	String currId = (String)session.getAttribute("memId");
	
	//한 페이지에 보여줄 게시글의 수
	int pageSize = 5;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	
	//게시글 페이지 번호
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null ){	// myPostView.jsp만 실행했을때
		pageNum = "1";
	}
	
	//일반토론 탭인지 ta탭인지 구분
	String pageType = request.getParameter("pageType");
	if(pageType == null){
		pageType = "debate";
	}
	
	//현재 페이지에 보여줄 게시글의 시작과 끝 등등 정보 세팅
	int currPage = Integer.parseInt(pageNum);
	int startRow = (currPage - 1) * pageSize +1;
	int endRow = currPage * pageSize;
	int count = 0; //DB에 저장된 전체 글의 개수를 저장할 변수
	int number = 0; //게시판 상의 가상글번호
	
	//DB에 저장된 글 개수
	List articleList = null;
	
	//검색을 사용 했을 때
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	
	//일반토론 타임어택 탭을 각각 눌렀을 때 식별할 수 있는 pageType 파라미터
	if("debate".equals(pageType)){
		DebateBoardDAO dbDao = DebateBoardDAO.getInstance();
		
		//검색 파라미터가 있을때
		if(sel != null && search != null){
			count = dbDao.getCnt(currId,sel,search);
			if(count > 0){
				articleList = dbDao.getSearchArticles(currId,startRow,endRow,sel,search);
			}
		}else{
			count = dbDao.getCnt(currId);
			if(count > 0){
				articleList = dbDao.getArticles(currId,startRow,endRow);
			}
		}		
	}else if("ta".equals(pageType)){
		TaBoardDAO tbDao = TaBoardDAO.getInstance();
		
		if(sel != null && search != null){
			count = tbDao.getCnt(currId,sel,search);
			if(count > 0){
				articleList = tbDao.getSearchArticles(currId, startRow, endRow, sel, search);
			}
		}else{
			count = tbDao.getCnt(currId);
			if(count > 0){
				articleList = tbDao.getArticles(currId, startRow, endRow);
			}
		}
	}else if("qna".equals(pageType)){
		QnaBoardDAO qbDao = QnaBoardDAO.getInstance();
		
		if(sel != null && search != null){
			count = qbDao.getCnt(currId, sel, search);
			
			if(count > 0){
				articleList = qbDao.getSearchArticles(currId, startRow, endRow, sel, search);
			}
		}else{
			count = qbDao.getCnt(currId);
			if(count > 0){
				articleList = qbDao.getArticles(currId,startRow,endRow);
			}
		}
	}
	
	number = count - (currPage-1)*pageSize;
%>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br/>
<h1 align="center"> 내 작성글 </h1>
	<table class="type09">
		<tr>
			<td colspan="8" align="left">
			<a href="myPostView.jsp?pageType=debate" class="btn1">일반토론</a> 
			<a href="myPostView.jsp?pageType=ta" class="btn1">타임어택</a> 
			<a href="myPostView.jsp?pageType=qna" class="btn1">QnA</a>
			</td>
		</tr>
		<tr>
			<%
			if("qna".equals(pageType)){
				%>
				<td width="50">No.</td>
				<td width="80">종류</td>
				<td width="250">제  목</td>
				<td width="80">작성자</td>
				<td width="60">조회수</td>
				<td width="80">답변상태</td>
				<td width="100">작성일</td>
				<%
			}else{
				%>
				<td width="50">No.</td>
				<td width="100">장르</td>
				<td width="200">도서명</td>
				<td width="250">제  목</td>
				<td width="80">작성자</td>
				<td width="60">조회수</td>
				<td width="60">추천수</td>
				<td width="100">작성일</td>
				<%
			}
				%>
		</tr>
		<%-- 게시글 목록 --%>
		<%
		if(count == 0){
			%>
		<tr>
			<td align="center" colspan="8">게시글이 없습니다.</td>
		</tr>
			<%
		}else{
			//일반토론 내 작성글
			if("debate".equals(pageType)){
				for(int i=0; i<articleList.size(); i++){
					DebateBoardDTO dbDto = (DebateBoardDTO)articleList.get(i);
					
					//장르번호로 장르명 가져오기
					GenreDAO gDao = GenreDAO.getInstance();
					GenreDTO gDto = gDao.findGenre(dbDto.getGenre());
					%>
					<tr>
						<td><%= number-- %></td>
						<td><%= gDto.getGenre() %></td>
						<td align="left"><%= dbDto.getBookName() %>
						<td align="left">
							<a href="/global03/board/debateBoard/debateContent.jsp?postNo=<%= dbDto.getPostNo()%>&pageNum=<%= pageNum %>"><%= dbDto.getSubject() %></a>
						</td>
						<td><a><%= dbDto.getId() %></a></td>
						<td align="center"><%= dbDto.getReadCnt() %></td>
						<td align="center"><%= dbDto.getLiked() %></td>
						<td><%= sdf.format(dbDto.getReg()) %></td>
					</tr>
					<%
				}
			//타임어택 내 작성글
			}else if("ta".equals(pageType)){
				for(int i=0; i<articleList.size(); i++){
					TaBoardDTO taDto = (TaBoardDTO)articleList.get(i);
					
					//장르번호로 장르명 가져오기
					GenreDAO gDao = GenreDAO.getInstance();
					GenreDTO gDto = gDao.findGenre( taDto.getGenre());
					%>
					<tr>
						<td><%= number-- %></td>
						<td><%= gDto.getGenre() %></td>
						<td align="left"><%= taDto.getBookName() %>
						<td align="left">
							<a href="/global03/board/taBoard/taContent.jsp?postNo=<%= taDto.getPostNo()%>&pageNum=<%= pageNum %>"><%= taDto.getSubject() %></a>
						</td>
						<td><a><%= taDto.getId() %></a></td>
						<td align="center"><%= taDto.getReadCnt() %></td>
						<td align="center"><%= taDto.getLiked() %></td>
						<td><%= sdf.format(taDto.getReg()) %></td>
					</tr>
					<%
				}
			//qna 내 작성글
			}else if("qna".equals(pageType)){
				for(int i=0; i<articleList.size(); i++){
					QnaBoardDTO qbDto = (QnaBoardDTO)articleList.get(i);
					
					%>
					<tr>
						<td><%= number-- %></td>
						<td><%= qbDto.getType() %></td>
						<td align="left">
							<a href="/global03/board/qnaBoard/qnaContent.jsp?postNo=<%= qbDto.getPostNo()%>&pageNum=<%= pageNum %>"><%= qbDto.getSubject() %></a>
						</td>
						<td align="left"><%= qbDto.getId() %>
						<td align="center"><%= qbDto.getReadCnt() %></td>
						<td><% if(qbDto.getStatus() == 0){ %>답변미완료<%}else %>답변완료</td>
						<td><%= sdf.format(qbDto.getReg()) %></td>
					</tr>
					<%
				}
			}
		}
		%>
		
	</table>
	<h3 align="center"><%= pageNum %></h3>
	<%-- 페이지 번호 뷰어  --%>
	<div align = "center">
		<%
		//총 페이지 개수
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		//보여줄 페이지 번호의 개수
		int pageBlock = 3;// 1~10 > 11~20 > 21~30
		//현재 위치한 페이지에서 페이지 뷰어 첫번째 숫자가 무엇인지 찾기
		int startPage = (int)((currPage - 1) / pageBlock) * pageBlock + 1;
		//현재 위치한 페이지에서 페이지뷰어 마지막 숫자가 무엇인지 찾기
		int endPage = startPage + pageBlock -1;
		// 마지막에 보여지는 페이지 뷰어에, 페이지 개수가 10개 미만일 경우
		// 마지막 페이지 번호가 총 페이지 수가 되게 만들어줌.
		if(endPage > pageCount){
			endPage = pageCount;
		}
		// 이전 페이지 리스트 버튼
		if(startPage > pageBlock){
			%>
			<a href="myPostView.jsp?pageNum=<%= startPage-pageBlock %>&pageType=<%=pageType %>">&lt;</a>
			<%
		}
		
		//페이지 숫자 출력
		for(int i = startPage; i<= endPage; i++){
			%>
			<a href="myPostView.jsp?pageNum=<%=i%>&pageType=<%=pageType %>" class="pageNums">&nbsp;<%= i %>&nbsp;</a>
			
			<%
		}
		
		// 다음 페이지 리스트 버튼
		if(endPage < pageCount){
			%>
			<a href="myPostView.jsp?pageNum=<%= startPage+pageBlock %>&pageType=<%=pageType %>">&gt;</a>
			
			<%
		}
		%>
		<%-- 작성자/내용 검색 --%>
		<br/><br/><br/>
		<form action="myPostView.jsp">
			<input type="hidden" name="pageType" value="<%=pageType%>"/>
			<select name="sel">
				<option value="subject" <%if(sel != null && sel.equals("subject")){%>selected<%} %>>제목</option>
				<option value="content" <%if(sel != null && sel.equals("content")){%>selected<%} %>>내용</option>
			</select>
			<input type="text" name="search" value="<%if(search == null) {%><%}else{%><%=search %><%}%>"/>
			<input type="submit" value="검색해버리지!!" style="color:#00691e;background-color:#ffffff;"/>
		</form>
		<br/>
		<button onClick="location.href='myPostView.jsp?pageType=<%=pageType%>'" style="color:#00691e;background-color:#ffffff;">전체 글 보기</button>
		
	</div>
</div>
</body>
</html>