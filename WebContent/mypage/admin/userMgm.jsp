<%@page import="global03.groot.model.GenreDTO"%>
<%@page import="global03.groot.model.GrootUserDTO"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@page import="global03.groot.model.GrootUserDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	request.setCharacterEncoding("UTF-8");

	String currId = (String)session.getAttribute("memId");
	if(currId == null || !"admin".equals(currId)){
		%>
		<script>
			alert("페이지에 대한 권한이 없습니다.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	
	//한 페이지에 보여줄 게시글의 수
	int pageSize = 5;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	
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
	
	List userList = null;
	
	//검색을 사용 했을 때
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	
	GrootUserDAO guDao = GrootUserDAO.getInstance();
	
	if(sel != null && search != null){
		count = guDao.getSearchUserCnt(sel, search);
		
		if(count > 0){
			userList = guDao.getSearchUserList(sel, search, startRow, endRow);
		}
	}else{
		count = guDao.getUserCnt();
		
		if(count > 0){
			//회원 목록 가져오기
			userList = guDao.getUserList(startRow, endRow);
		}
	}
	
	number = count - (currPage-1)*pageSize;
%>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br/>
<table class="type09">
	<thead>
		<tr>
			<th colspan="11">회원관리</th>
		</tr>
	</thead>
	<thead>
		<tr>
			<th>No.</th>
			<th>아이디</th>
			<th>이름</th>
			<th>이메일</th>
			<th>전화번호</th>
			<th>주소</th>
			<th colspan="3">선호장르</th>
			<th>가입시간</th>
			<th>관리</th>
		</tr>
	</thead>
	<%
	if(count == 0){
		%>
		<tr>
			<td colspan = "11">회원이라고 부를 사람이 아무도 없습니다 ㅠㅠㅠ</td>
		</tr>
		<%
	}else{
		for(int i=0; i<userList.size(); i++){
			GenreDAO gDao = GenreDAO.getInstance();
			GrootUserDTO guDto = (GrootUserDTO)userList.get(i);
			
			GenreDTO gDto = gDao.findGenre(guDto.getFavorite1());
			String favorite1 = gDto.getGenre();
			
			gDto = gDao.findGenre(guDto.getFavorite2());
			String favorite2 = gDto.getGenre();
			gDto = gDao.findGenre(guDto.getFavorite3());
			String favorite3 = gDto.getGenre();
			%>
			<tr>
				<td><%= number-- %></td>
				<td><%= guDto.getId() %></td>
				<td><%= guDto.getName() %></td>
				<td><%= guDto.getEmail()%></td>
				<td><%= guDto.getTel() %></td>
				<td><%= guDto.getAddr() %></td>
				<td><%= favorite1 %></td>
				<td><%= favorite2 %></td>
				<td><%= favorite3 %></td>
				<td><%= sdf.format(guDto.getReg()) %></td>
				<td align="center">
					<form action="userTrophyUpdate.jsp" method="post">
						<input type="hidden" name="id" value="<%=guDto.getId() %>"/>
						<input type="submit" class="btn1" value="트로피관리"/>
					</form>
					<form action="deleteUserByAdmin.jsp" method="post">
						<input type="hidden" name="id" value="<%=guDto.getId() %>"/>
						<input type="submit" class="btn1" value="제명"/>
					</form>
				</td>
			</tr>
			<%
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
		if(sel!=null&&search!=null){
			if(startPage > pageBlock){	%>
				<a href="userMgm.jsp?pageNum=<%=startPage-pageBlock%>&sel=<%=sel%>&search=<%=search%>">&lt;</a>
	<%		}
		}else{
			if(startPage > pageBlock){	%>
				<a href="userMgm.jsp?pageNum=<%=startPage-pageBlock%>">&lt;</a>			
	<%		}
		}
		
		//페이지 숫자 출력
		if(sel!=null&&search!=null){
			for(int i = startPage; i<= endPage; i++){	%>
				<a href="userMgm.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>" class="pageNums">&nbsp;<%= i %>&nbsp;</a>
	<%		}
		}else{
			for(int i = startPage; i<= endPage; i++){	%>
				<a href="userMgm.jsp?pageNum=<%=i%>" class="pageNums">&nbsp;<%= i %>&nbsp;</a>
	<%		}
		}
		
		// 다음 페이지 리스트 버튼
		if(sel!=null&&search!=null){
			if(endPage < pageCount){	%>
				<a href="userMgm.jsp?pageNum=<%=startPage+pageBlock%>&sel=<%=sel%>&search=<%=search%>">&gt;</a>
			}
	<%	}else{
			if(endPage < pageCount){	%>
				<a href="userMgm.jsp?pageNum=<%=startPage+pageBlock%>">&gt;</a>			
	<%		}
		}
	}
		%>
		<%-- 작성자/내용 검색 --%>
		<br/><br/><br/>
		<form action="userMgm.jsp" method="post">
			<select name="sel">
				<option value="id" >아이디</option>
			</select>
			<input type="text" name="search"/>
			<input type="submit" value="검색해버리지!!"/>
		</form>
		<br/>
		<button onClick="location.href='userMgm.jsp'">전체 회원 보기</button>
		
	</div>
</div>
</body>
</html>