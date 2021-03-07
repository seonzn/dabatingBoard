<%@page import="global03.groot.model.QnaBoardDTO"%>
<%@page import="global03.groot.model.QnaBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>문의 글 수정</title>
	<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	//호출한 페이지에서 작성자 또는 관리자 세션이 넘어왔는지!!!
	
	
	
	// 글 고유번호, 페이지 번호
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	String pageNum = request.getParameter("pageNum");
	
	// DB에서 글 고유 번호로 해당 글의 모든 정보를 비롯한 내용을 받아오기
	QnaBoardDAO dao = QnaBoardDAO.getInstance();
	QnaBoardDTO article = dao.getArticle(postNo);
%>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br />
	<form action="qnaModifyPro.jsp?pageNum=<%=pageNum%>" method="post">
	<%-- 글 고유번호 숨겨서 보내기 --%>
	<input type="hidden" name="postNo" value="<%=postNo%>"/>
		<table align="left" class="type10">
			<thead>
				<tr>
					<th colspan="5">QnA 수정</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>작성자</th>
					<td align="left"><%=article.getId()%></td>
				</tr>
				<tr>
					<th>문의유형</th>
					<td align="left">
						<select name="type">
							<option value="문의">문의</option>
							<option value="신고">신고</option>
							<option value="건의">건의</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>제	목</th>
					<td align="left">
						<input type="text" name="subject" height="50px" value="<%=article.getSubject()%>"/>
						<input type="checkbox" name="secret" value="1"/> 비밀글
					</td>
				</tr>
				<tr>
					<th>내  용</th>
					<td><textarea rows="20" cols="70" name="content"><%=article.getContent()%></textarea></td>
				</tr>
				<tr>
					<td colspan="5" align="right">
						<input type="submit" class="btn1" value="수정">
						<input type="button" value="취소" class="btn1" onclick="window.location='qnaBoard.jsp?pageNum=<%=pageNum%>'"/>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>
</body>
</html>