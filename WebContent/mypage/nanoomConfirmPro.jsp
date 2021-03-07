<%@page import="global03.groot.model.TrophyCntDTO"%>
<%@page import="global03.groot.model.TrophyDTO"%>
<%@page import="global03.groot.model.TrophyDAO"%>
<%@page import="global03.groot.model.TrophyCntDAO"%>
<%@page import="global03.groot.model.NanoomRequestDAO"%>
<%@page import="global03.groot.model.NanoomDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수락/거절 pro.</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");

	//안됨
	if(session.getAttribute("memId") == null){
		%>
		<script>
			alert("로그인 먼저 해주세요");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	
	//전 페이지에서 "수락"했는지 "거절"했는지
	String action = request.getParameter("action");
	Integer postNo = Integer.parseInt(request.getParameter("postNo"));
	String requestId = request.getParameter("requestId");
	
	if(session.getAttribute("memId") == null || action == null || postNo == null || requestId == null){
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href="/global03/main.jsp";
		</script>
		<%
	}
	
	
	NanoomDAO nDao = NanoomDAO.getInstance();
	NanoomRequestDAO nrDao = NanoomRequestDAO.getInstance();
	//수락했다면
	if("수락".equals(action)){
		//nanoom테이블 result 값 수정
		nDao.acceptNanoom(postNo);
		
		//nanoomRequest테이블 result 수정
		nrDao.acceptedNanoom(postNo);
		
		//나눔 요청자의 trophyCnt테이블의 daeCnt칼럼 +1
		TrophyCntDAO tcDao = TrophyCntDAO.getInstance();
		tcDao.updateDaeCnt(requestId);
		
		//나눔 요청자의 trophyCnt테이블의 dae칼럼 검사
		TrophyCntDTO tcDto = tcDao.getDaeCnt(requestId);
		Integer daeCnt = tcDto.getDaeCnt();
		
		//trophy테이블에 dae칼럼 수정
		TrophyDAO tDao = TrophyDAO.getInstance();
		if(daeCnt<3){
			tDao.updateDae(requestId,0);
		}else if(daeCnt >= 3 && daeCnt <4){
			tDao.updateDae(requestId,1);
		}else if(daeCnt >=4 && daeCnt <5){
			tDao.updateDae(requestId,2);
		}else if(daeCnt >=5 && daeCnt <6){
			tDao.updateDae(requestId,3);
		}
		%>
		<script>
			alert("나눔요청을 수락했습니다.");
			opener.document.location.reload();
			self.close();
		</script>
		<%
	}else if("거절".equals(action)){
		//nanoom테이블 result 값 수정
		nDao.rejectNanoom(postNo);
		
		//nanoomRequest테이블 result 값 수정
		nrDao.rejectedNanoom(postNo);
		%>
		<script>
			alert("나눔요청을 거절했습니다.");
			opener.document.location.reload();
			self.close();
		</script>
		<%
	}
	
	
%>
<body>

</body>
</html>