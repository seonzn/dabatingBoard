<%@page import="global03.groot.model.TrophyDTO"%>
<%@page import="global03.groot.model.TrophyDAO"%>
<%@page import="global03.groot.model.TrophyCntDTO"%>
<%@page import="global03.groot.model.TrophyCntDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="global03.groot.model.NanoomDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>nanoomWritePro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	if(session.getAttribute("memId") == null){%>
		<script>
			alret("올바르지 않은 접근입니다.");
			window.location="/global03/main.jsp";
		</script>
		
<%	} 
	
	String path = request.getRealPath("save"); // 사진업로드 저장할 폴더
	System.out.println(path);
	int max = 1024*1024*10; // 업로드할 파일 최대 크기
	String enc = "UTF-8"; // 인코딩 타입
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy(); // 파일 이름 중복식 이름뒤에 1,2,3 붙이기
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	String pageNum = request.getParameter("pageNum");	
	// 파라미터 한개씩 꺼내기
	int genre = Integer.parseInt(mr.getParameter("genre"));
	String id = (String) session.getAttribute("memId");
	String bookName = mr.getParameter("bookName");
	String subject = mr.getParameter("subject");
	String content = mr.getParameter("content");
	String sysName = mr.getFilesystemName("img");
	Timestamp reg = new Timestamp(System.currentTimeMillis());
	
	// 트로피카운트에 숫자 올리기
	TrophyCntDAO trophyCntDao = TrophyCntDAO.getInstance();
	trophyCntDao.insertTrophyCnt(id);
	TrophyCntDTO hyeTrophyCnt =trophyCntDao.getHyeCnt(id);
	
	// 트로피카운트에 따른 트로피 획득 설정
	TrophyDAO trophyDao = TrophyDAO.getInstance();
	TrophyDTO hyeTrophy = trophyDao.trophyNum(id);
	int bronze = 3; //첫번째 퀘스트
	int silver = 4; // 두번째 퀘스트
	int gold = 5;	// 세번쨰 퀘스트
	int trophyHye = hyeTrophy.getHye(); // 나눔 트로피
	int trophyHyeCnt = hyeTrophyCnt.getHyeCnt();
	
	if(trophyHyeCnt <= gold){
		if(trophyHyeCnt%bronze == 0 || trophyHyeCnt%silver == 0 || trophyHyeCnt%gold == 0) {
			trophyDao.insertTrophyHye(id);	
		}
	}
	
	// 데이터 저장
	NanoomDAO dao = NanoomDAO.getInstance();
	dao.insertNanoomArticle(genre, id, bookName, subject, content, sysName, reg);
	
	response.sendRedirect("/global03/board/nanoomBoard/nanoomBoard.jsp?pageNum=" + pageNum);
%>

<body>

</body>
</html>