<%@page import="global03.groot.model.TaReplyDAO"%>
<%@page import="global03.groot.model.TaBoardDTO"%>
<%@page import="global03.groot.model.TaBoardDAO"%>
<%@page import="global03.groot.model.TaReplyDTO"%>
<%@page import="global03.groot.model.DebateBoardDTO"%>
<%@page import="global03.groot.model.DebateBoardDAO"%>
<%@page import="global03.groot.model.GenreDTO"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@page import="global03.groot.model.DebateReplyDTO"%>
<%@page import="global03.groot.model.DebateReplyDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 댓글</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String currId = (String)session.getAttribute("memId");
	if(currId == null){
		%>
		<script>
			alert("로그인 먼저 해주세요.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	
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
		DebateReplyDAO dbrDao = DebateReplyDAO.getInstance();
		
		//검색 파라미터가 있을때
		if(sel != null && search != null){
			count = dbrDao.getCnt(currId,sel,search);
			if(count > 0){
				articleList = dbrDao.getSearchReplies(currId,startRow,endRow,sel,search);
			}
		}else{
			count = dbrDao.getCnt(currId);
			if(count > 0){
				articleList = dbrDao.getReplies(currId,startRow,endRow);
			}
		}		
	}else if("ta".equals(pageType)){
		TaReplyDAO trDao = TaReplyDAO.getInstance();
		
		if(sel != null && search != null){
			count = trDao.getCnt(currId,sel,search);
			if(count > 0){
				articleList = trDao.getSearchReplies(currId, startRow, endRow, sel, search);
			}
		}else{
			count = trDao.getCnt(currId);
			if(count > 0){
				articleList = trDao.getReplies(currId, startRow, endRow);
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
			<a href="myReplyView.jsp?pageType=debate" class="btn1">일반토론</a> 
			<a href="myReplyView.jsp?pageType=ta" class="btn1">타임어택</a> 
			</td>
		</tr>
		<tr>
			<td colspan="8" align="right">
			<button onClick = "location.href='writeForm.jsp?pageNum=<%= pageNum %>'" style="color:#00691e;background-color:#ffffff;"> 글을 쓰겠니! </button>
			</td>
		</tr>
		<tr>
			<td width="50">No.</td>
			<td width="80">장르</td>
			<td width="200">도서명</td>
			<td width="250">댓글</td>
			<td width="100">작성일</td>
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
					DebateReplyDTO dbrDto = (DebateReplyDTO)articleList.get(i);
					
					//postNo로 원글 찾아내기
					DebateBoardDAO dbDao = DebateBoardDAO.getInstance();
					DebateBoardDTO dbDto = dbDao.getArticleByNo(dbrDto.getPostNo());
					
					// 원글의 장르번호로 장르명 가져오기
					GenreDAO gDao = GenreDAO.getInstance();
					GenreDTO gDto = gDao.findGenre(dbDto.getGenre());
					%>
					<tr>
						<td><%= number-- %></td>
						<td><%= gDto.getGenre() %></td>
						<td align="left"><%= dbDto.getBookName() %>
						<td align="left">
							<a href="/global03/board/debateBoard/debateContent.jsp?postNo=<%= dbrDto.getPostNo() %>&pageNum=<%= pageNum %>"><%= dbrDto.getContent() %></a>
						</td>
						<td><%= sdf.format(dbrDto.getReg()) %></td>
					</tr>
					<%
				}
			//타임어택 내 작성글
			}else if("ta".equals(pageType)){
				for(int i=0; i<articleList.size(); i++){
					TaReplyDTO trDto = (TaReplyDTO)articleList.get(i);
		
					//postNo로 원글 찾아내기
					TaBoardDAO tbDao = TaBoardDAO.getInstance();
					TaBoardDTO tbDto = tbDao.getArticleByNo(trDto.getPostNo());
					
					// 원글의 장르번호로 장르명 가져오기
					GenreDAO gDao = GenreDAO.getInstance();
					GenreDTO gDto = gDao.findGenre(tbDto.getGenre());
					%>
					<tr>
						<td><%= number-- %></td>
						<td><%= gDto.getGenre() %></td>
						<td align="left"><%= tbDto.getBookName() %>
						<td align="left">
							<a href="/global03/board/taBoard/taContent.jsp?postNo=<%= trDto.getPostNo() %>&pageNum=<%= pageNum %>"><%= trDto.getContent() %></a>
						</td>
						<td><%= sdf.format(trDto.getReg()) %></td>
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
			<a href="myReplyView.jsp?pageNum=<%= startPage-pageBlock %>&pageType=<%=pageType %>">&lt;</a>
			<%
		}
		
		//페이지 숫자 출력
		for(int i = startPage; i<= endPage; i++){
			%>
			<a href="myReplyView.jsp?pageNum=<%=i%>&pageType=<%=pageType %>" class="pageNums">&nbsp;<%= i %>&nbsp;</a>
			
			<%
		}
		
		// 다음 페이지 리스트 버튼
		if(endPage < pageCount){
			%>
			<a href="myReplyView.jsp?pageNum=<%= startPage+pageBlock %>&pageType=<%=pageType %>">&gt;</a>
			
			<%
		}
		%>
		<%-- 작성자/내용 검색 --%>
		<br/><br/><br/>
		<form action="myReplyView.jsp">
			<input type="hidden" name="pageType" value="<%=pageType%>"/>
			<select name="sel">
				<option value="content" <%if(sel != null && sel.equals("content")){%>selected<%} %>>내용</option>
			</select>
			<input type="text" name="search" value="<%if(search == null) {%><%}else{%><%=search %><%}%>"/>
			<input type="submit" value="검색해버리지!!" style="color:#00691e;background-color:#ffffff;"/>
		</form>
		<br/>
		<button onClick="location.href='myReplyView.jsp?pageType=<%= pageType%>'" style="color:#00691e;background-color:#ffffff;">전체 글 보기</button>
		
	</div>
</div>
</body>
</html>