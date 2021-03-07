<%@page import="global03.groot.model.QnaBoardDTO"%>
<%@page import="global03.groot.model.QnaBoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>문의 내용</title>
	<link href="/global03//css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	String currId = (String)session.getAttribute("memId");
	// 게시판 목록에서 글제목을 클릭하면, 글 본문 내용이 보여지는 content 페이지로 이동.
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null) {pageNum = "1";}
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	
	// 글 고유번호로 해당 글에 대한 전체 내용을 DB에서 가져오기
	QnaBoardDAO dao = QnaBoardDAO.getInstance();
	QnaBoardDTO article = dao.getArticle(postNo);
%>
<script>
	function deleteConfirm(){
	    var deleteReally = confirm("정말 삭제하시겠어요?");
	 
	    if ( deleteReally == true ) {
	    	
	    	location.href='qnaDeletePro.jsp?pageNum=<%=pageNum%>&postNo=<%=article.getPostNo()%>';
	    } else if ( deleteReally == false ) {
	    	return;
	    }
	}
</script>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
	<br /><br/>
	<table class="type10" align="left">
		<thead>
			<tr>
				<th colspan="2"><%= article.getSubject() %> > QnA</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>문의유형</th>
				<td><%=article.getType()%></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><%=article.getId()%></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea style="width:800px;height:300px;font-size:17pt; border-color: white;" readonly><%=article.getContent()%></textarea></td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<%
					if(article.getId().equals(currId) || "admin".equals(currId)){
						%>
						<button class="btn1" onclick="window.location='qnaModifyForm.jsp?pageNum=<%=pageNum%>&postNo=<%=article.getPostNo()%>'">수  정</button>
						<button class="btn1" onclick="deleteConfirm()">삭  제</button>
						<%
					}
					
					if("admin".equals(currId)){
						%>
						<button class="btn1" onclick="window.location='qnaWriteForm.jsp?pageNum=<%=pageNum%>&postNo=<%=article.getPostNo()%>&ref=<%=article.getRef()%>&re_level=<%=article.getRe_level()%>'">답  글</button>
						<%
					}
					%>
					<button class="btn1" onclick="window.location='qnaBoard.jsp?pageNum=<%=pageNum%>'">리스트</button>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</body>
</html>