<%@page import="global03.groot.model.TrophyDTO"%>
<%@page import="global03.groot.model.TrophyDAO"%>
<%@page import="global03.groot.model.NanoomRequestDTO"%>
<%@page import="global03.groot.model.NanoomRequestDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="global03.groot.model.NanoomDTO"%>
<%@page import="java.util.List"%>
<%@page import="global03.groot.model.QnaBoardDAO"%>
<%@page import="global03.groot.model.NanoomDAO"%>
<%@page import="global03.groot.model.TaReplyDAO"%>
<%@page import="global03.groot.model.DebateReplyDAO"%>
<%@page import="global03.groot.model.TaBoardDAO"%>
<%@page import="global03.groot.model.TaBoardDTO"%>
<%@page import="global03.groot.model.DebateBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이 페이지</title>
<link href="/global03/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	
	request.setCharacterEncoding("UTF-8");
	String currId = (String)session.getAttribute("memId");
	
	//안됨
	
	
	// 글 작성 수 추출 (게시판, 댓글, QnA)
	Integer boardCnt = 0;
	Integer replyCnt = 0;
	
	DebateBoardDAO dbDao = DebateBoardDAO.getInstance();
	boardCnt += dbDao.getCnt(currId);
	
	TaBoardDAO tbDao = TaBoardDAO.getInstance();
	boardCnt += tbDao.getCnt(currId);
	
	QnaBoardDAO qbDao = QnaBoardDAO.getInstance();
	boardCnt += qbDao.getCnt(currId);
	
	NanoomDAO nDao = NanoomDAO.getInstance();
	boardCnt += nDao.getCnt(currId);
	
	DebateReplyDAO drDao = DebateReplyDAO.getInstance();
	replyCnt += drDao.getCnt(currId);
	
	TaReplyDAO trDao = TaReplyDAO.getInstance();
	replyCnt += trDao.getCnt(currId);
	
	//나눔 현황 불러오기
	List articleList1 = null;
	List articleList2 = null;
	
	Integer count1 = 0;
	Integer count2 = 0;
	
	NanoomRequestDAO nrDao = NanoomRequestDAO.getInstance();
	
	count1 = nDao.getCnt(currId);
	count2 = nrDao.getCnt(currId);
	
	if(count1 > 0){
		articleList1 = nDao.get3Articles(currId);
	}
	
	if(count2 > 0){
		articleList2 = nrDao.get3Articles(currId);
	}
	
	SimpleDateFormat sdf = new SimpleDateFormat("yy.MM.dd");
	
	// 달성한 트로피 가져오기
	TrophyDAO tDao = TrophyDAO.getInstance();
	TrophyDTO tDto = tDao.getAllTrophy(currId);
	
%>
<body>
<div>
<jsp:include page="/header/grootHeader.jsp"/>
<br/><br/>
<div class="myInfo">
<div class="my" >
<table width="700px">
	<tr align="left">
		<td><h1>내 정보</h1> <h3><%= currId %>님</h3></td>
	</tr>
	<tr align="left">
		<td>
			<button onclick="" style="color:#00691e;background-color:#ffffff;">정보 수정</button>
			<button onclick="location.href='/global03/login/userDeleteForm.jsp'" style="color:#00691e;background-color:#ffffff;">탈퇴</button>
		</td>
	</tr>
</table>
</div>
<div class="my">
<table>
	<tr align="left">
		<td colspan="2"><h3><img src="/global03/img/article.png" width="30">&nbsp;나의글</h3></td>
	</tr>
	<tr>
		<td>게시글 작성 수</td>
		<td><a href="/global03/mypage/myPostView.jsp" class="btn1"><%=boardCnt %></a>개</td>
	</tr>
	<tr>
		<td>댓글 작성 수</td>
		<td><a href="/global03/mypage/myReplyView.jsp" class="btn1"><%=replyCnt %></a>개</td>
	</tr>
</table>
</div>
</div>
<hr/>
<div class="nanoom">
<div class="myNa">
<table class="type09" align="left">
	<tr align="left">
		<td colspan="4"><h3><img src="/global03/img/give.png" width="30">&nbsp;나눔 현황</h3></td>
	</tr>
	<tr>
		<td colspan="4" align="right">
		<a href="myNanoomView.jsp?pageType=nanoom" class="btn1">전체보기</a>
		</td>
	</tr>
	<tr>
		<td align="center">날짜</td>
		<td align="center" width="200px">도서명</td>
		<td align="center"  width="150px">글 제목</td>
		<td>상태</td>
	</tr>
		<%
		if(count1 == 0){
			%>
			<tr>
				<td colspan="5">게시글이 없습니다</td>
			</tr>
			<%
		}else{
			for(int i=0; i<articleList1.size(); i++){
				NanoomDTO nDto = (NanoomDTO)articleList1.get(i);
				Integer postNo = nDto.getPostNo();
				String bookName = nDto.getBookName();
				%>	
				<tr>
					<td><%= sdf.format(nDto.getReg())%></td>
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
								<input type="hidden" name="postNo" value="<%=nDto.getPostNo()%>" />
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
								<input type="hidden" name="bookName" value="<%=nDto.getBookName()%>" />
								<input type="hidden" name="postNo" value="<%=nDto.getPostNo() %>" />
								<input type="button" value="수신자 정보" onclick="openReceiverInfoPop(this.form)" style="color:#616161;background-color:#ffffff;width:90px;"/>
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
		}
		%>
	
</table>
</div>
<div class="myNa">
<table class="type09" align="left">
	<tr align="left">
		<td colspan="5"><h3><img src="/global03/img/receive.png" width="30">&nbsp;나눔 신청 현황</h3></td>
	</tr>
	<tr align="right">
		<td colspan="4">
		<a href="myNanoomView.jsp?pageType=nanoomRequest" class="btn1">전체보기</a>
		</td>
	</tr>
	<tr>
		<td>날짜</td>
		<td width="200px">도서명</td>
		<td width="150px">글 제목</td>
		<td colspan="2">상태</td>
	</tr>
		<%
		if(count2 == 0){
			%>
			<tr>
				<td colspan="5">게시글이 없습니다</td>
			</tr>
			<%
		}else{
			for(int i=0; i<articleList2.size(); i++){
				NanoomRequestDTO nrDto = (NanoomRequestDTO)articleList2.get(i);
				//nanoomRequest 테이블에서 postNo로 원 나눔글 정보 가져오기
				
				NanoomDTO nDto = nDao.getArticleByNo(nrDto.getPostNo());
			%>
				<tr>
					<td><%= sdf.format(nrDto.getReg())%></td>
					<td><%= nDto.getBookName() %></td>
					<td><a href="/global03/board/nanoomBoard/nanoomContent.jsp?postNo=<%=nDto.getPostNo()%>"><%= nDto.getSubject() %></a></td>
					<%
					if(nrDto.getResult() == 0){
						%>
						<td><button style="color:#1797ff;background-color:#ffffff;width:70px;">요청중</button></td>
						<%
					}else if(nrDto.getResult() == 1){
						%>
						<td><button style="color:#616161;background-color:#ffffff;width:70px;">나눔완료</button>
						<%
					}else if(nrDto.getResult() == 2){
						%>
						<td><button style="color:#ff432e;background-color:#ffffff;width:70px;">거절됨</button>
						<%
					}
					%>
				</tr>
				<%
			}
		}
				%>
	
</table>
</div>
</div>
<hr/>
<table class="type09" align="left" style="width: 700px;">
	<tr>
		<td colspan="4"><h1><img src="/global03/img/trophy/trophyIcon.png" width="40">&nbsp;내 트로피 목록</h1></td>
	</tr>
	<tr>
		<td><img src="/global03/img/trophy/nbIcon.png" width="30">&nbsp;<b>뉴비</b></td>
		<td colspan="3">
			<img src="/global03/img/trophy/trophy.png" width="40" />
		</td>
	</tr>
	<tr>
		<td><img src="/global03/img/trophy/ssaIcon.png" width="30">&nbsp;<b>싸움닭</b></td>
		<%
		if(tDto.getSsa() == 3){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<%
		}else if(tDto.getSsa() == 2){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getSsa() == 1){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getSsa() == 0){
			%>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}
		%>
	</tr>
	<tr>
		<td><img src="/global03/img/trophy/gukIcon.png" width="30">&nbsp;<b>국회의원</b></td>
		<%
		if(tDto.getGuk() == 3){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<%
		}else if(tDto.getGuk() == 2){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getGuk() == 1){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getGuk() == 0){
			%>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}
		%>
	</tr>
	<tr>
		<td><img src="/global03/img/trophy/hyeIcon.png" width="30">&nbsp;<b>혜민스님</b></td>
		<%
		if(tDto.getHye() == 3){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<%
		}else if(tDto.getHye() == 2){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getHye() == 1){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getHye() == 0){
			%>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}
		%>
	</tr>
	<tr>
		<td><img src="/global03/img/trophy/daeIcon.png" width="30">&nbsp;<b>대머리</b></td>
		<%
		if(tDto.getDae() == 3){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<%
		}else if(tDto.getDae() == 2){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getDae() == 1){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getDae() == 0){
			%>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}
		%>
	</tr>
	<tr>
		<td><img src="/global03/img/trophy/nhcIcon.png" width="30">&nbsp;<b>노홍철</b></td>
		<%
		if(tDto.getNhc() == 3){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<%
		}else if(tDto.getNhc() == 2){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getNhc() == 1){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getNhc() == 0){
			%>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}
		%>
	</tr>
	<tr>
		<td><img src="/global03/img/trophy/influIcon.png" width="30">&nbsp;<b>인플루언서</b></td>
		<%
		if(tDto.getInflu() == 3){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<%
		}else if(tDto.getInflu() == 2){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getInflu() == 1){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getInflu() == 0){
			%>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}
		%>
	</tr>
	<tr>
		<td><img src="/global03/img/trophy/sprIcon.png" width="30">&nbsp;<b>슈퍼스타</b></td>
		<%
		if(tDto.getSpr() == 3){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<%
		}else if(tDto.getSpr() == 2){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getSpr() == 1){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getSpr() == 0){
			%>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}
		%>
	</tr>
	<tr>
		<td><img src="/global03/img/trophy/ddaIcon.png" width="30">&nbsp;<b>따봉충</b></td>
		<%
		if(tDto.getDda() == 3){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<%
		}else if(tDto.getDda() == 2){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getDda() == 1){
			%>
			<td><img src="/global03/img/trophy/trophy.png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}else if(tDto.getDda() == 0){
			%>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<td><img src="/global03/img/trophy/trophy(un).png" width="40"/></td>
			<%
		}
		%>
	</tr>
</table>
</div>
</body>
</html>