<%@page import="global03.groot.model.NanoomDTO"%>
<%@page import="java.util.List"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@page import="global03.groot.model.NanoomDTO"%>
<%@page import="global03.groot.model.NanoomDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>nanoomContent</title>
	<link href="/../../css/style.css" rel="stylesheet" type="text/css">
</head>
<%
	request.setCharacterEncoding("UTF-8");
	int postNo = Integer.parseInt(request.getParameter("postNo")); // 게시글 고유번호
	String pageNum = request.getParameter("pageNum");	// 리스트로 돌아갈때 보던 페이지로 돌아가기위해
	String strNumber = request.getParameter("number");
	int number=0;
	if(strNumber != null){
		number = Integer.parseInt(request.getParameter("number"));
	}
	if(pageNum == null) pageNum = "1";
	

	NanoomDAO dao = NanoomDAO.getInstance();
	NanoomDTO article = dao.getarticle(postNo);
	
	GenreDAO genredao = GenreDAO.getInstance();
%>

	<script> // 나눔요청 popUp
		function openNanoomRequest(){
		var url = "/global03/board/nanoomBoard/nanoomRequestForm.jsp?postNo="+<%=postNo%>+"&pageNum="+<%=pageNum%>+"&number="+<%=number%>+"&result="+<%=article.getResult()%>;
			open(url, "nanoomRequest", "location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=800, height=400");
	}
	</script>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
		<table align="center">
			<tr>
				<td align="center" style="width: 500px; height: 300px">
					<%if(article.getImg() == null){%>
						<img src="/global03/img/book(default).png"  width="500px" height="300px">
					<%}else{%>
						<img src="/global03/save/<%=article.getImg() %>" width="350px">
					<%} %> 
				</td>
			</tr>
			<tr align="left">
				<td><h3 style="margin:0 0 0 0;"><%=article.getId() %></h3><hr /></td>
			</tr>
			<tr>
				<td align="left">
					<p style="font-size: 17pt; font-weight: bold; color: #000000;"><%=article.getBookName() %></p>
					<p style="font-size: 13pt; font-weight: bold; color: #a6a6a6;"><%=genredao.stringGenre(article.getGenre()) %></p> 
					<p style="font-size: 13pt; font-weight: bold;"><%=article.getSubject()%></p><br/><br/>
					<p><%=article.getContent() %></p>
					<br/><hr/>
				</td>	
			</tr>			
			<tr>
				<%
					// 앞/뒤로가기 기호 넣기
					int frontStart = number + 1;
					int frontEnd = number + 1;
					
					int backStart = number - 1;
					int backEnd = number - 1;
					NanoomDTO frontArticle = dao.frontBackArticle(frontStart, frontEnd);
					NanoomDTO backArticle = dao.frontBackArticle(backStart, backEnd);
				%>
				<td colspan="2" align="center">
					<h1>
						<%if(dao.getArticleCount() > frontStart){ //앞글보기%>
							<a href="/global03/board/nanoomBoard/nanoomContent.jsp?postNo=<%=frontArticle.getPostNo()%>&pageNum=<%=pageNum %>&number=<%=frontStart%>"> &lt; </a>		
						<%}

						if(article.getResult() == 0){%>
							<button class="naStatBtn" style="width: 120pt; height: 40pt; font-size: 15pt;" onclick="openNanoomRequest(this.form)" >나눔 신청하기</button>
						<%}else if(article.getResult() == 1){%>
							<button class="naStatBtn" style="width: 120pt; height: 40pt; font-size: 15pt;">신청중</button>
						<%}else{%>
							<button class="naStatBtn" style="width: 120pt; height: 40pt; font-size: 15pt;">나눔완료</button>
						<%}
						
						if(backStart > 0){ // 뒷글보기%>
							<a href="/global03/board/nanoomBoard/nanoomContent.jsp?postNo=<%=backArticle.getPostNo()%>&pageNum=<%=pageNum %>&number=<%=backStart%>"> &gt; </a>		
						<%} %>
					</h1>
				</td>
			</tr>
			<tr>
				<td align="right">
					<button class="btn1" onclick="location.href='/global03/board/nanoomBoard/nanoomDeletePro.jsp?postNo=<%=article.getPostNo()%>&pageNum=<%=pageNum%>'">글 삭제</button>
					<button class="btn1" onclick="location.href='nanoomBoard.jsp?pageNum=<%=pageNum%>'">전체 글보기</button>
				</td>
			</tr>
		
		</table>
</div>
</body>
</html>