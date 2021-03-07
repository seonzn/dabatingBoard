<%@page import="java.util.ArrayList"%>
<%@page import="global03.groot.model.NanoomRequestDTO"%>
<%@page import="global03.groot.model.NanoomRequestDAO"%>
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
<title>나의 나눔</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String pageType = request.getParameter("pageType");
	String currId = (String)session.getAttribute("memId");
	
	if(currId == null || pageType == null){
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	
	//한 페이지에 보여줄 게시글의 수
	int pageSize = 5;
	SimpleDateFormat sdf = new SimpleDateFormat("yy.MM.dd");
	
	//게시글 페이지 번호
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null ){	// myPostView.jsp만 실행했을때
		pageNum = "1";
	}
	
	//현재 페이지에 보여줄 게시글의 시작과 끝 등등 정보 세팅
	int currPage = Integer.parseInt(pageNum);
	int startRow = (currPage - 1) * pageSize +1;
	int endRow = currPage * pageSize;
	int count = 0; //DB에 저장된 전체 글의 개수를 저장할 변수
	int number = 0; //게시판 상의 가상글번호
	
	List articleList = null;
	List postNoList = null;
	
	//검색을 사용 했을 때
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	
	if("nanoom".equals(pageType)){
		NanoomDAO nDao = NanoomDAO.getInstance();
		
		if(sel != null && search != null){
			count = nDao.getCnt(currId,sel,search);
			
			if(count > 0){
				articleList = nDao.getSearchArticles(currId, sel, search, startRow, endRow);
			}
		}else{
			count = nDao.getCnt(currId);
			if(count>0){
				articleList = nDao.getArticles(currId,startRow,endRow);
			}
		}
	}else if("nanoomRequest".equals(pageType)){
		NanoomRequestDAO nrDao = NanoomRequestDAO.getInstance();
		NanoomRequestDTO nrDto = null;
		NanoomDAO nDao = NanoomDAO.getInstance();
		NanoomDTO nDto = null;
		
		if(sel != null && search != null){
			postNoList = nrDao.getPostNo(currId);
			articleList = new ArrayList();
			for(int i=0; i<postNoList.size(); i++){
				nrDto = (NanoomRequestDTO)postNoList.get(i);
				nDto = nDao.getSearchArticleByNo(nrDto.getPostNo(),sel,search);
				if( nDto != null){
					articleList.add(nDto);
				}
			}
			if(articleList.size()>0){
				count = 1;
			}
		}else{
			count = nrDao.getCnt(currId);
			if(count>0){
				postNoList = nrDao.getPostNo(currId);
				articleList = new ArrayList();
				for(int i=0; i<postNoList.size(); i++){
					nrDto = (NanoomRequestDTO)postNoList.get(i);
					nDao = NanoomDAO.getInstance();
					nDto = nDao.getArticleByNo(nrDto.getPostNo());
					articleList.add(nDto);
				}
			}
		}
	}
	
	number = count - (currPage-1)*pageSize;
	
%>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br/>
<table class="type10">
<thead>
	<tr align="left">
		<th colspan="5">
			<%
			if("nanoom".equals(pageType)){
				%>
				<h3 style="margin: 0;">나눔 현황</h3>
				<%
			}else if("nanoomRequest".equals(pageType)){
				%>
				<h3 style="margin: 0;">나눔 신청 현황</h3>
				<%
			}
			%>
		</th>
	</tr>
</thead>
<tbody>
	<tr>
		<th>번호</th>
		<th>날짜</th>
		<th>도서명</th>
		<th>글 제목</th>
		<th colspan="2">상태</th>
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
		//내 나눔글
		if("nanoom".equals(pageType)){
			for(int i=0; i<articleList.size(); i++){
				NanoomDTO nDto = (NanoomDTO)articleList.get(i);
				Integer postNo = nDto.getPostNo();
				String bookName = nDto.getBookName();
				%>
				<tr>
					<td><%= number -- %></td>
					<td><%= sdf.format(nDto.getReg()) %></td>
					<td><%= nDto.getBookName() %></td>
					<td><a href="/global03/board/nanoomBoard/nanoomContent.jsp?postNo=<%=nDto.getPostNo()%>"><%= nDto.getSubject() %></a></td>
					<%
					if(nDto.getResult() == 0){
						%>
						<td><button style="color:#ff432e;background-color:#ffffff;width:80px;">요청없음</button></td>
						<%
					}else if(nDto.getResult() == 1){
						%>
						<td>
							<form name="nanoomConfirmForm" method="post">
								<input type="hidden" name="postNo" value="<%=nDto.getPostNo()%>"/>
								<input type="hidden" name="bookName" value="<%=nDto.getBookName() %>" />
								<input type="button" style="color:#1797ff;background-color:#ffffff;width:80px;" value="요청있음" onclick="openNanoomConfirmPop(this.form)"/>
							</form>
							<script>
								function openNanoomConfirmPop(form){
									var postNo = form.postNo.value;
									var bookName = form.bookName.value;
									window.open("/global03/mypage/nanoomConfirmPop.jsp?postNo="+postNo+"&bookName="+bookName , "popup", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=400, height=400");
								}
							</script>
						</td>
						<%
					}else if(nDto.getResult() == 2){
						%>
						<td>
							<form name="receiverInfo" method="post">
								<button type="button" style="color:#616161;background-color:#ffffff;width:80px;">나눔 완료</button>
								<input type="hidden" name="bookName" value="<%=nDto.getBookName() %>"/>
								<input type="hidden" name="postNo" value="<%=nDto.getPostNo() %>"/>
								<input type="button" style="color:#616161;background-color:#ffffff;width:90px;" value="수신자 정보" onclick="openReceiverInfoPop(this.form)"/>
							</form>
							<script>
								function openReceiverInfoPop(form){
									var postNo = form.postNo.value;
									var bookName = form.bookName.value;
									window.open("/global03/mypage/receiverInfoPop.jsp?postNo="+postNo+"&bookName="+bookName , "popup", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=400, height=400");
								}
							</script>
						</td>
						<%
					}
					%>
				</tr>
				<%
			}
		}else if("nanoomRequest".equals(pageType)){
			for(int i=0; i<articleList.size(); i++){
				NanoomDTO nDto = (NanoomDTO)articleList.get(i);
				NanoomRequestDAO nrDao = NanoomRequestDAO.getInstance();
				NanoomRequestDTO nrDto = nrDao.getReceiverInfo(nDto.getPostNo());
				
				%>
				<tr>
					<td><%= number -- %></td>
					<td><%= sdf.format(nDto.getReg()) %></td>
					<td><%= nDto.getBookName() %></td>
					<td><%= nDto.getSubject() %></td>
					<%
					if(nrDto.getResult() == 0){
						%>
						<td><button>요청중</button></td>
						<%
					}else if(nrDto.getResult() == 1){
						%>
						<td><button>나눔완료</button>
						<%
					}else if(nrDto.getResult() == 2){
						%>
						<td><button>거절됨</button>
						<%
					}
					%>
				</tr>
				<%
			}
		}
	}
	%>
</tbody>
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
			<a href="myNanoomView.jsp?pageNum=<%= startPage-pageBlock %>&pageType=<%=pageType %>">&lt;</a>
			<%
		}
		
		//페이지 숫자 출력
		for(int i = startPage; i<= endPage; i++){
			%>
			<a href="myNanoomView.jsp?pageNum=<%=i%>&pageType=<%=pageType %>" class="pageNums">&nbsp;<%= i %>&nbsp;</a>
			
			<%
		}
		
		// 다음 페이지 리스트 버튼
		if(endPage < pageCount){
			%>
			<a href="myNanoomView.jsp?pageNum=<%= startPage+pageBlock %>&pageType=<%=pageType %>">&gt;</a>
			
			<%
		}
		%>
		<%-- 작성자/내용 검색 --%>
		<br/><br/>
		<form action="myNanoomView.jsp">
			<input type="hidden" name="pageType" value="<%=pageType%>"/>
			<select name="sel">
				<option value="bookName" <%if(sel != null && sel.equals("bookName")){%>selected<%} %>>도서명</option>
			</select>
			<input type="text" name="search" value="<%if(search == null) {%><%}else{%><%=search %><%}%>"/>
			<input type="submit" value="검색해버리지!!"/>
		</form>
		<br/>
		<button onClick="location.href='myNanoomView.jsp?pageType=<%=pageType%>'">전체 글 보기</button>
		
	</div>
</div>
</body>
</html>