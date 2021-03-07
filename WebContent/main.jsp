<%@page import="global03.groot.model.BooksDTO"%>
<%@page import="global03.groot.model.BooksDAO"%>
<%@page import="global03.groot.model.GenreDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="global03.groot.model.GenreDAO"%>
<%@page import="global03.groot.model.GrootUserDTO"%>
<%@page import="global03.groot.model.GrootUserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>We Are Groot</title>
<link href="css/style.css" rel="stylesheet" type="text/css"/>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String currId = (String)session.getAttribute("memId");
%>
<body>
<div>
<jsp:include page="header/grootHeader.jsp"/>
<br/><br/>
<%
	if(currId != null){
		//선호장르 가져오기
		GrootUserDAO guDao = GrootUserDAO.getInstance();
		GrootUserDTO guDto = guDao.getUserInfo(currId);
		
		GenreDAO gDao = GenreDAO.getInstance();
		
		List genreList = gDao.getAllGenre();
		List<Integer> userGenreList = new ArrayList<Integer>();
		
		Integer favorite1 = guDto.getFavorite1();
		Integer favorite2 = guDto.getFavorite2();
		Integer favorite3 = guDto.getFavorite3();
		
		for(int i=0; i<genreList.size(); i++){
			GenreDTO gDto = (GenreDTO)genreList.get(i);
			if(favorite1 == gDto.getNo()){
				genreList.remove(i);
				userGenreList.add(favorite1);
				break;
			}
		}
		for(int i=0; i<genreList.size(); i++){
			GenreDTO gDto = (GenreDTO)genreList.get(i);
			if(favorite2 == gDto.getNo()){
				genreList.remove(i);
				userGenreList.add(favorite2);
				break;
			}
		}
		for(int i=0; i<genreList.size(); i++){
			GenreDTO gDto = (GenreDTO)genreList.get(i);
			if(favorite3 == gDto.getNo()){
				genreList.remove(i);
				userGenreList.add(favorite3);
			}
		}
		for(int i=0; i<genreList.size(); i++){
			GenreDTO gDto = (GenreDTO)genreList.get(i);
			userGenreList.add(gDto.getNo());
		}
		
		%>
		<div class = "tabmenu">
		<ul>
			<%
			for(int i=0; i<userGenreList.size(); i++){
				GenreDTO gDto = (GenreDTO)gDao.findGenre(userGenreList.get(i));
				if(gDto.getNo() == 0){
					continue;
				}
				%>
				<li> 
			      <input type="radio" name="tabmenu" id="tabmenu<%=i+1%>">
			      <label for="tabmenu<%=i+1%>"><%=gDto.getGenre() %></label>
			      <div class="tabCon" >
			      <%
			      BooksDAO bDao = BooksDAO.getInstance();
			      List bookList = bDao.getBooks(gDto.getNo());
				 if(bookList==null){	%>
					책이 없습니다
			<%   }else{
					for(int j=0; j<bookList.size(); j++){
						BooksDTO bDto = (BooksDTO)bookList.get(j);
						%>
						<div class="mainTab">
						<div class="btn3">
						    <div class="eff-2"></div>
							<a class="btn3" href="/global03/board/debateBoard/debateBoard.jsp?sel=bookName&search=<%=bDto.getBookName()%>"><%=bDto.getBookName()%></a>
						 </div>
						</div>
						<%
					}
				}
				%>

			      
				</div>
		    </li>
				<%
			}
			%>
		</ul>
	  	</div>
	  	<br/><br/>
		<%
	}else{
		GenreDAO gDao = GenreDAO.getInstance();
		List genreList = gDao.getAllGenre();
		%>
			<div class = "tabmenu">
		<ul>
			<%
			for(int i=0; i<genreList.size(); i++){
				GenreDTO gDto = (GenreDTO)genreList.get(i);
				if(gDto.getNo() == 0){
					continue;
				}
				%>
				<li> 
			      <input type="radio" name="tabmenu"  id="tabmenu<%=i+1%>">
			      <label for="tabmenu<%=i+1%>"><%=gDto.getGenre() %></label>
			      <div class="tabCon" >
			      <%
			      BooksDAO bDao = BooksDAO.getInstance();
			      List bookList = bDao.getBooks(gDto.getNo());
			     if(bookList==null){	%>
					책이 없습니다
			<%   }else{
				for(int j=0; j<bookList.size(); j++){
					BooksDTO bDto = (BooksDTO)bookList.get(j);
					%>
					<div class="mainTab">
					<div class="btn3">
					    <div class="eff-2"></div>
						<a class="btn3" href="/global03/board/debateBoard/debateBoard.jsp?sel=bookName&search=<%=bDto.getBookName()%>"><%=bDto.getBookName()%></a>
					 </div>
					</div>
					<%
					}
				}
				%>
				</div>
		    </li>
				<%
			}
			%>
		</ul>
	  	</div>
		<%
	}
%>
</div>
</body>
</html>