<%@page import="global03.groot.model.GrootUserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>아이디 중복확인</title>
	<link href="../css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%	String id = request.getParameter("id");
	GrootUserDAO dao = GrootUserDAO.getInstance();
	boolean res = dao.confirmId(id);	%>
<body>
	<h3 align="center">(☞ﾟヮﾟ)☞ 아이디 중복확인 ☜(ﾟヮﾟ☜)</h3>
<%	if(res){	%>
	<table>
		<tr>
			<td>'<%=id%>' 는 이미 사용 중인 아이디입니다 ^^;</td>
		</tr>
	</table>
	<form action="confirmId.jsp" method="post">
	<table>
		<tr>
			<td>다른 아이디를 입력하세요.<br/>
				<input type="text" name="id"/>
				<input type="submit" value="ID중복확인"/>
			</td>
		</tr>
	</table>
	</form>
<%	}else{	%>
	<table>
		<tr>
			<td>입력하신 '<%=id%>' 는 사용할 수 있는 아이디입니다.<br/>
				<input type="button" value="닫기" onclick="setId()"/>
			</td>
		</tr>
	</table>
<%	}	%>
<script>
	function setId(){
		opener.document.inputForm.id.value = "<%=id%>";
		self.close();
	}
</script>
</body>
</html>