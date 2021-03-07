<%@page import="global03.groot.model.DebateReplyDTO"%>
<%@page import="java.util.List"%>
<%@page import="global03.groot.model.DebateReplyDAO"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@page import="global03.groot.model.DebateBoardDTO"%>
<%@page import="global03.groot.model.DebateBoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자유토론 글 내용</title>
	<link href="../../css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	String memId = (String)session.getAttribute("memId");
	if(memId==null){ memId = "null"; }
	String memPw = (String)session.getAttribute("memPw");
	
	int postNo = Integer.parseInt(request.getParameter("postNo"));
	String pageNum = request.getParameter("pageNum");
	if(pageNum==null){ pageNum="1"; }
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	
	DebateBoardDAO dao = DebateBoardDAO.getInstance();
	DebateBoardDTO article = dao.getArticle(postNo,memId);
	
	GenreDAO dao2 = GenreDAO.getInstance();
	
%>
<body>
<div>
	<jsp:include page="/header/grootHeader.jsp"/>
	<br/>
	<h6 style="margin-bottom: 0px;">자유토론 게시판></h6>
	<h1 style="margin-top: 0px;"><%=article.getSubject()%></h1>
	<p>작성자: <%=article.getId()%></p>
	<p>장르: <%=dao2.toGenreName(article.getGenre())%> &nbsp;&nbsp;&nbsp;&nbsp; 도서명: &lt;<%=article.getBookName()%>&gt;</p>
	<p>작성시간: <%=sdf.format(article.getReg())%> &nbsp; 조회 <%=article.getReadCnt()%> &nbsp; 추천 <%=article.getLiked()%></p>
	<hr color="#ff8000"/>
	<textarea style="width:100%; height:300px;font-size:17pt; border-color: white;" readonly><%=article.getContent()%></textarea>
	<hr color="#ff8000"/>
<%	//본인 글일 때만 수정/삭제 보이게 분기처리
	if(memId.equals(article.getId()) || memId.equals("admin")){	%>
		<button class="btn1" onclick="window.location='debateModifyForm.jsp?pageNum=<%=pageNum%>&postNo=<%=postNo%>&id=<%=article.getId()%>'">수정</button>
		<button class="btn1" onclick="window.location='debateDeletePro.jsp?pageNum=<%=pageNum%>&postNo=<%=postNo%>&id=<%=article.getId()%>'">삭제</button>
<%	}	%>
		<button class="btn1" onclick="window.location='/global03/board/likedPro.jsp?pageType=debate&pageNum=<%=pageNum%>&postNo=<%=postNo%>&writer=<%=article.getId()%>'">추천</button>
		<button class="btn1" onclick="window.location='debateBoard.jsp?pageNum=<%=pageNum%>'">리스트</button>
		<button class="btn1" onclick="window.location='/global03/board/taBoard/taWriteForm.jsp?genre=<%=article.getGenre()%>&bookName=<%=article.getBookName()%>'">타임어택 글쓰기</button>
		<br/><br/>
	<%-- 찬반 버튼과 비율 막대 --%>
<% 	if(article.getCbCheck()==1){	//찬반토론글일 경우에만 보이도록 분기처리
		double cbSum = article.getChanCnt()+article.getBanCnt();
		if(cbSum==0){ cbSum = 1; }	
		double chanCnt = article.getChanCnt();
		double banCnt = article.getBanCnt();
		double chanPer = chanCnt/cbSum*100;
		double banPer = banCnt/cbSum*100;	%>
		<table align="center" style="background-color:#ffffff; border:1px solid #ffffff;">
			<tr>
				<td>
					<div class="btn2">
					    <div class="eff-1"></div>
					    <a href="/global03/board/chanBanPro.jsp?pageType=debate&pageNum=<%=pageNum%>&postNo=<%=postNo%>&cb=Y"> 찬성 </a>
					 </div>
					 <br/><br/>
					<img src="../../img/chanIcon.png" width="35"/>
					<h3 style="color:#666664;"><%=(int)chanPer%>%</h3>
				</td>
				<td>
				<%	if(chanCnt==0 && banCnt==0){	%>
					<img src="../../img/chanBar.png" height="20" width="250"/>
					<img src="../../img/banBar.png" height="20" width="250"/>
					<br/>
				<%	}else{ %>
					<img src="../../img/chanBar.png" height="20" width="<%=500*chanCnt/cbSum%>"/>
					<img src="../../img/banBar.png" height="20" width="<%=500*banCnt/cbSum%>"/>
					<br/>				
				<%	} %>
				</td>
				<td style="width:80px">
					<div class="btn2">
					    <div class="eff-1"></div>
					    <a href="/global03/board/chanBanPro.jsp?pageType=debate&pageNum=<%=pageNum%>&postNo=<%=postNo%>&cb=N"> 반대 </a>
					 </div>
					 <br/><br/>
					<img src="../../img/banIcon.png" width="35"/>
					<h3 style="color:#666664;"><%=(int)banPer%>%</h3>
				</td>
			</tr>
		</table>
<%	} %>
	<br/>
<%---------------------------------댓글---------------------------------%>
<% 	int replyPageSize = 10;
	SimpleDateFormat sdf2 = new SimpleDateFormat("MM.dd HH:mm");
	String replyPageNum = request.getParameter("replyPageNum");
	if(replyPageNum==null){ replyPageNum="1"; }
	int replyCurrPage = Integer.parseInt(replyPageNum);
	int replyStartRow = (replyCurrPage-1)*replyPageSize+1;
	int replyEndRow = replyCurrPage*replyPageSize;
	int replyCount = 0;
	int replyNumber = 0;
	
	DebateReplyDAO dao3 = DebateReplyDAO.getInstance();
	List replyList = null;
	replyCount = dao3.getReplyCount(postNo);	//게시글번호 주고 해당 게시글의 댓글 개수 리턴
	if(replyCount>0){
		replyList = dao3.getReplies(postNo, replyStartRow, replyEndRow);
	}
	replyNumber = replyStartRow;	%>
	<br/><br/>
<%	if(replyCount==0){ %>
		<table align="left">
			<tr>
				<td colspan="6" align="center">아직 작성된 댓글이 없습니다</td>
			</tr>
		</table>
<%	}else{ %>
		<table align="center" style="width:70%;">
		<tr>
			<td colspan="7">댓글 <%=replyCount %>개</td>
		</tr>
		<%for(int i=0 ; i<replyList.size() ; i++){ 
			DebateReplyDTO reply = (DebateReplyDTO)replyList.get(i);	%>
			<tr>
				<td><%=replyNumber++%></td>
				<td align="left">
				<%
					int wid = 0;
					if(reply.getRe_level()>0){
						wid = 8*(reply.getRe_level());	%>
						<img src="../../img/tabImg.png" width="<%=wid%>"/>
						<img src="../../img/replyImg.png" width="10"/>
				<%	}	%>
					<%if(reply.getType()==0){	%>
						[기타의견]
					<%}else if(reply.getType()==1){	%>
						[찬성]
					<%}else if(reply.getType()==2){ %>
						[반대]
					<%} %>
					<%=reply.getContent()%>
				</td>
				<td><%=reply.getId()%></td>
				<td><%=sdf2.format(reply.getReg())%></td>
				<td>
					<img src="../../img/likeImg.png" width="10"/>
					<%=reply.getLiked()%>
				</td>
				<td>
					<div class="btn2">
					    <div class="eff-1"></div>
					    <a href="/global03/board/replyLikedPro.jsp?pageType=debate&pageNum=<%=pageNum%>&postNo=<%=postNo%>&replyNo=<%=reply.getReplyNo()%>&replyPageNum=<%=replyPageNum%>"> 좋아요 </a>
					</div>
				</td>
				<td>
					<div class="btn2">
					    <div class="eff-1"></div>
					    <a href="debateContent.jsp?postNo=<%=postNo%>&replyNo=<%=reply.getReplyNo()%>&re_level=<%=reply.getRe_level()%>"> 대댓글 </a>
					</div>
				</td>
			</tr>
		<%}%>
		<%-- 댓글 페이지 보는 곳 --%>
			<tr><td colspan="7" align="center">
			<%
				int replyPageCount = (replyCount/replyPageSize)+(replyCount%replyPageSize==0?0:1);
				int replyPageBlock = 5;
				int replyStartPage = (int)(((replyCurrPage-1)/replyPageBlock)*replyPageBlock+1);
				int replyEndPage = replyStartPage+replyPageBlock-1;
				if(replyEndPage>replyPageCount){ replyEndPage = replyPageCount; }
				if(replyStartPage>replyPageBlock){	%>
					<a href="debateContent.jsp?pageNum=<%=pageNum%>&postNo=<%=postNo%>&replyPageNum=<%=replyStartPage-replyPageBlock%>">&lt;</a>
			<%	}
				for(int i=replyStartPage ; i<=replyEndPage ; i++){		%>
					<a href="debateContent.jsp?pageNum=<%=pageNum%>&postNo=<%=postNo%>&replyPageNum=<%=i%>">&nbsp;<%=i%>&nbsp;</a>
			<%	}
				if(replyEndPage<replyPageCount){	%>
					<a href="debateContent.jsp?pageNum=<%=pageNum%>&postNo=<%=postNo%>&replyPageNum=<%=replyStartPage+replyPageBlock%>">&gt;</a>
			<%	} %>
			</td></tr>
		</table>
<%	} %>
<%-- 댓글 작성란 --%>
	<% 
	String reply_No = request.getParameter("replyNo");
	int re_level = 0;
	if(reply_No==null || reply_No.equals("null")){ reply_No="0"; }else{		
		re_level = Integer.parseInt(request.getParameter("re_level"));
	}
	int replyNo = Integer.parseInt(reply_No);
	int ref=0, liked=0;
	%>
	<br/><br/>
	<form action="/global03/board/replyPro.jsp" method="post">
		<input type="hidden" name="pageType" value="debate"/>
		<input type="hidden" name="replyNo" value="<%=replyNo%>"/>
		<input type="hidden" name="id" value="<%=memId%>"/>
		<input type="hidden" name="postNo" value="<%=postNo%>"/>
		<input type="hidden" name="ref" value="<%=ref%>"/>
		<input type="hidden" name="re_level" value="<%=re_level%>"/>
		<input type="hidden" name="liked" value="<%=liked%>"/>
		<input type="hidden" name="pageNum" value="<%=pageNum%>"/>
		<table align="center">
			<tr>
				<td width="30">
					<select name="type" style="height: 36px;">
						<option value="0" selected>기타의견</option>
						<option value="1">찬성</option>
						<option value="2">반대</option>
					</select>
				</td>
				<td align="left"><input type="text" name="content" style="height: 30px; width:800px;"/></td>
				<td width="20"><input type="submit" class="btn1"  value="작성"/></td>
			</tr>
		</table>
	</form>
	<br/><br/><br/>
</div>
</body>
</html>