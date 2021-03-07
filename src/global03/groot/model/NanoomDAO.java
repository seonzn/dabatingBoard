package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class NanoomDAO {
	private static NanoomDAO instance = new NanoomDAO();
	private NanoomDAO() {};
	public static NanoomDAO getInstance() { return instance; }
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	//커넥션 메소드 [선준]
	private Connection getConn() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		
		return ds.getConnection();
	}
	
	//커넥션 close 메소드 [선준]
	private void closeAll(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
		if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
		if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	}
	
	//사용자가 작성한 글 수 반환 [선준]
	public Integer getCnt(String id) {
		Integer res = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from nanoom where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				res = rs.getInt(1);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return res;
	}
	
	//사용자가 작성한 글 수 반환 [선준]
	public Integer getCnt(String id, String sel, String search) {
		Integer res = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from nanoom where id=? and "+sel+ " like '%"+search+"%'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				res = rs.getInt(1);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return res;
	}
	
	// 사용자가 작성한 게시글 상위3개 가져오기 [선준]
	public List get3Articles(String currId) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM nanoom WHERE id=? "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=1 AND r<=3";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, currId);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					NanoomDTO nDto = new NanoomDTO();
					nDto.setPostNo(rs.getInt("postNo"));
					nDto.setGenre(rs.getInt("genre"));
					nDto.setId(rs.getString("id"));
					nDto.setBookName(rs.getString("bookName"));
					nDto.setSubject(rs.getString("subject"));
					nDto.setContent(rs.getString("content"));
					nDto.setImg(rs.getString("img"));
					nDto.setResult(rs.getInt("result"));
					nDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(nDto);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return articleList;
	}
	
	// 사용자가 작성한 나눔글 검색 [선준]
	public List getSearchArticles(String currId, String sel, String search, Integer startRow, Integer endRow) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM nanoom WHERE id=? and "+sel+" like '%"+search+"%'"
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, currId);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					NanoomDTO nDto = new NanoomDTO();
					nDto.setPostNo(rs.getInt("postNo"));
					nDto.setGenre(rs.getInt("genre"));
					nDto.setId(rs.getString("id"));
					nDto.setBookName(rs.getString("bookName"));
					nDto.setSubject(rs.getString("subject"));
					nDto.setContent(rs.getString("content"));
					nDto.setImg(rs.getString("img"));
					nDto.setResult(rs.getInt("result"));
					nDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(nDto);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return articleList;
	}
	
	//postNo로 나눔글 가져오기
	public NanoomDTO getArticleByNo(Integer postNo) {
		NanoomDTO nDto = null;
		
		try {
			conn = getConn();
			String sql = "select * from nanoom where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				nDto = new NanoomDTO();
				nDto.setPostNo(rs.getInt("postNo"));
				nDto.setGenre(rs.getInt("genre"));
				nDto.setId(rs.getString("id"));
				nDto.setBookName(rs.getString("bookName"));
				nDto.setSubject(rs.getString("subject"));
				nDto.setContent(rs.getString("content"));
				nDto.setImg(rs.getString("img"));
				nDto.setResult(rs.getInt("result"));
				nDto.setReg(rs.getTimestamp("reg"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return nDto;
	}
	
	//postNo와 검색한 문자로 나눔글 가져오기
	public NanoomDTO getSearchArticleByNo(Integer postNo, String sel, String search) {
		NanoomDTO nDto = null;
		
		try {
			conn = getConn();
			String sql = "select * from nanoom where postNo=? and "+sel+" like '%"+search+"%'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				nDto = new NanoomDTO();
				nDto.setPostNo(rs.getInt("postNo"));
				nDto.setGenre(rs.getInt("genre"));
				nDto.setId(rs.getString("id"));
				nDto.setBookName(rs.getString("bookName"));
				nDto.setSubject(rs.getString("subject"));
				nDto.setContent(rs.getString("content"));
				nDto.setImg(rs.getString("img"));
				nDto.setResult(rs.getInt("result"));
				nDto.setReg(rs.getTimestamp("reg"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return nDto;
	}
	
	// 나눔 요청을 수락했을때 result처리 메소드 [선준]
	public void acceptNanoom(Integer postNo) {
		try {
			conn = getConn();
			String sql = "update nanoom set result = 2 where postNo =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	// 나눔 요청을 거절했을때 result처리 메소드 [선준]
	public void rejectNanoom(Integer postNo) {
		try {
			conn = getConn();
			String sql = "update nanoom set result = 0 where postNo =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//사용자가 작성한 게시글 가져오기
	public List getArticles(String currId, Integer startRow, Integer endRow) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM nanoom WHERE id=? "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, currId);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					NanoomDTO nDto = new NanoomDTO();
					nDto.setPostNo(rs.getInt("postNo"));
					nDto.setGenre(rs.getInt("genre"));
					nDto.setId(rs.getString("id"));
					nDto.setBookName(rs.getString("bookName"));
					nDto.setSubject(rs.getString("subject"));
					nDto.setContent(rs.getString("content"));
					nDto.setImg(rs.getString("img"));
					nDto.setResult(rs.getInt("result"));
					nDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(nDto);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return articleList;
	}

	// 나눔게시글 저장 메서드[승목 0118]
	public void insertNanoomArticle(int genre, String id, String bookName, String subject, String content, String img, Timestamp reg){
		try {
			conn = getConn();
			String sql = "INSERT INTO NANOOM(POSTNO, genre, id, BOOKNAME, SUBJECT, CONTENT, IMG, REG)"
						+ "VALUES (nanoom_seq.nextVal, ?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, genre);
			pstmt.setString(2, id);
			pstmt.setString(3, bookName);
			pstmt.setString(4, subject);
			pstmt.setString(5, content);
			pstmt.setString(6, img);
			pstmt.setTimestamp(7, reg);
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}//insertNanoomArticle
	
	// 나눔게시글 저장된 전체 갯수 메서드[승목 0118]
	public int getArticleCount() {
		int count = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from nanoom";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return count;
	}//getArticleCount
	
	//게시글 리스트 가져오기[승목 0118]
	public List getarticles(int start, int end){
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT B.*, r FROM " + 
						"(SELECT A.*,rownum r FROM " + 
						"(SELECT * FROM NANOOM ORDER BY POSTNO DESC)A) B WHERE r >= ? AND r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					NanoomDTO article = new NanoomDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setGenre(rs.getInt("genre"));
					article.setId(rs.getString("id"));
					article.setBookName(rs.getString("bookName"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setImg(rs.getString("img"));
					article.setResult(rs.getInt("result"));
					article.setReg(rs.getTimestamp("reg"));
					articleList.add(article);
				} while (rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return articleList;
	}//getarticles
	

	
	// 게시글 검색 글의 갯수 메서드[승목 0119 - > 수정 0201] 
	public int getsearchArticlCount(String sel, String search){
		int searchCount = 0;
		GenreDAO dao = GenreDAO.getInstance();
		List genreList = dao.genreArticles();
		
		for(int i = 1; i < genreList.size() ; i++) {
			GenreDTO dto = (GenreDTO)genreList.get(i);
			String genreNo = String.valueOf(dto.getNo());
			if(sel.equals(genreNo)) {
				return Integer.parseInt(sel);
			}
		}
		try {
			conn = getConn();
			String sql = null;
			if(sel instanceof String) {
				sql = "SELECT count(*) FROM nanoom WHERE " + sel + " LIKE '%" + search + "%'";
			}else {
				for(int i = 1; i < genreList.size() ; i++) {
					GenreDTO dto = (GenreDTO)genreList.get(i);
					String genreNo = String.valueOf(dto.getNo());
					if(sel.equals(genreNo)) {
						sql = "select count(*) from nanoom where genre="+ sel + " and bookName Like '%"+ search + "%'";
					}
				}
			}
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				searchCount = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return searchCount;
	}//getsearchArticlCount
	
	// 검색된 게시글 글 목록 가져오기[승목 0119]
	public List getSearchArticles(int start, int end, String sel, String search){
		List getSearchArticles = null;
		try {
			conn = getConn();
			String sql;
			if(sel.equals("1") || sel.equals("2") || sel.equals("3") || sel.equals("4") || sel.equals("5") || sel.equals("6")) {
				sql = "SELECT B.*, r FROM " + 
						"(SELECT A.*,rownum r FROM " + 
						"(SELECT * FROM NANOOM WHERE genre=" + sel + "and bookName LIKE '%" + search + "%' ORDER BY POSTNO DESC)A) B WHERE r >= ? AND r <= ?";
			}else {
				sql = "SELECT B.*, r FROM " + 
					"(SELECT A.*,rownum r FROM " + 
					"(SELECT * FROM NANOOM WHERE " + sel + " LIKE '%" + search + "%' ORDER BY POSTNO DESC)A) B WHERE r >= ? AND r <= ?";
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				getSearchArticles = new ArrayList();
				do {
					NanoomDTO article = new NanoomDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setGenre(rs.getInt("genre"));
					article.setId(rs.getString("id"));
					article.setBookName(rs.getString("bookName"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setImg(rs.getString("img"));
					article.setResult(rs.getInt("result"));
					article.setReg(rs.getTimestamp("reg"));
					getSearchArticles.add(article);
				} while (rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return getSearchArticles;
	}//getSearchArticles
	
	// 글 고유번호로 해당 글 내용 1개 가져오기 메서드[승목 0121]
	public NanoomDTO getarticle(int num){
		NanoomDTO article = null;
		try {
			conn = getConn();
			String sql = " select * from nanoom where postNo = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				article = new NanoomDTO();
				article.setPostNo(rs.getInt("postNo"));
				article.setGenre(rs.getInt("genre"));
				article.setId(rs.getString("id"));
				article.setBookName(rs.getString("bookName"));
				article.setSubject(rs.getString("subject"));
				article.setContent(rs.getString("content"));
				article.setImg(rs.getString("img"));
				article.setResult(rs.getInt("result"));
				article.setReg(rs.getTimestamp("reg"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return article;
	}
	
	// postNo, id 체크[승목 0122]
	public boolean numIdCheck(int num, String id) {
		boolean result = false;
		try {
			conn = getConn();
			String sql = "select * from nanoom where postNo =? and id =? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.setString(2, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	// 글삭제 메서드[승목 0122]
	public boolean deleteAtricle(int num, String id){
		boolean result = false;
		try {
			result = numIdCheck(num, id);
			if(!result) {
				return result;
			}
			conn = getConn();
			String sql = "delete from nanoom where postNo =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			int check = pstmt.executeUpdate(); // 글이 잘 삭제 되었는지 확인
			if(check > 0) {
				result = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return result;
	}//deleteAtricle
	
	// 나눔글번호(postNo) 받아서 result 값 변환 메서드 [승목 0126]
	public void updateResult(NanoomRequestDTO dto){
		try {
			conn = getConn();
			String sql = "update nanoom set result = 1 where postNo = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getPostNo());
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}//updateResultd
	// 앞 뒤 글 보기 메서드 [승목 0131] 
	public NanoomDTO frontBackArticle(int start, int end){
		NanoomDTO article = null;
		try {
			conn = getConn();
			String sql = "SELECT B.*, r FROM " + 
					"(SELECT A.*,rownum r FROM " + 
					"(SELECT * FROM NANOOM ORDER BY POSTNO aSC)A) B WHERE r >= ? AND r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				article = new NanoomDTO();
				article.setPostNo(rs.getInt("postNo"));
				article.setGenre(rs.getInt("genre"));
				article.setId(rs.getString("id"));
				article.setBookName(rs.getString("bookName"));
				article.setSubject(rs.getString("subject"));
				article.setContent(rs.getString("content"));
				article.setImg(rs.getString("img"));
				article.setResult(rs.getInt("result"));
				article.setReg(rs.getTimestamp("reg"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return article;
	}//frontBackArticle
}
