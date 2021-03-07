<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>문의 글 작성</title>
	<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	if(session.getAttribute("memId") == null){
		%>
		<script>
			alert("로그인 먼저 해주세요.");
			history.go(-1);
		</script>
		<%
	}

	String pageNum = request.getParameter("pageNum");
	if(pageNum == null) {pageNum = "1";}
	int postNo = 0, ref = 1, re_level = 0;

	// 답글일때 처리
	if(request.getParameter("postNo") != null) {
		postNo = Integer.parseInt(request.getParameter("postNo"));
		ref = Integer.parseInt(request.getParameter("ref"));
		re_level = Integer.parseInt(request.getParameter("re_level"));
	}
%>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br />
	<form action="qnaWritePro.jsp?pageNum=<%=pageNum%>" method="post">
		<%-- 숨겨서 글 속성 전송 --%>
		<input type="hidden" name="postNo" value="<%=postNo%>"/>
		<input type="hidden" name="ref" value="<%=ref%>"/>
		<input type="hidden" name="re_level" value="<%=re_level%>"/>
		<input type="hidden" name="id" value="<%=(String)session.getAttribute("memId")%>"/>
		<table align="left" class="type10">
			<thead>
				<tr>
					<th colspan="3">QnA 글 작성</th>
				</tr>
			</thead>
			<tr>
				<th>유	형</th>
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
					<input type="text" name="subject">
					<input type="checkbox" name="secret" value="1"/> 비밀글
				</td>
			</tr>
			<tr>
				<th>내	용</th>
				<td><textarea rows="20" cols="70" name="content"></textarea></td>
			</tr>
			<tr>
				<td colspan="3" align="right">
					<input type="submit" class="btn1" value="저장">
					<input type="reset" class="btn1" value="재작성">
					<input type="button" class="btn1" value="리스트 보기" onclick="window.location='qnaBoard.jsp?pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>