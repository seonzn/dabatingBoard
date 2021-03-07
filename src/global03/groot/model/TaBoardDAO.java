package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TaBoardDAO {
	private static TaBoardDAO instance = new TaBoardDAO();
	private TaBoardDAO() {};
	public static TaBoardDAO getInstance() { return instance; }
	
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
	
	//사용자가 작성한 게시글의 수 메소드 [선준]
	public Integer getCnt(String id) {
		Integer res = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from taBoard where id=?";
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
	
	//사용자가 작성한 특정 게시글의 수 메소드 [선준]
	public Integer getCnt(String currId, String sel, String search) {
		Integer res = -1;
		try {
			conn = getConn();
			String sql = "select count(*) from taBoard where id=? and "+sel+" like '%"+search+"%'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, currId);
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
	
	//사용자가 작성한 게시글 가져오기 [선준]
	public List getArticles(String currId, Integer startRow, Integer endRow) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM taBoard WHERE id=? "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, currId);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					TaBoardDTO taDto = new TaBoardDTO();
					taDto.setPostNo(rs.getInt("postNo"));
					taDto.setGenre(rs.getInt("genre"));
					taDto.setId(rs.getString("id"));
					taDto.setBookName(rs.getString("bookName"));
					taDto.setSubject(rs.getString("subject"));
					taDto.setReadCnt(rs.getInt("readCnt"));
					taDto.setLiked(rs.getInt("liked"));
					taDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(taDto);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return articleList;
	}
	
	//사용자가 작성한 게시글 중 검색한 게시글 가져오기 [선준]
	public List getSearchArticles(String currId, Integer startRow, Integer endRow, String sel, String search) {
		List articleList = null;
		
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM taBoard WHERE id=? and "+sel+" like '%"+search+"%' "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, currId);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					DebateBoardDTO dbDto = new DebateBoardDTO();
					dbDto.setPostNo(rs.getInt("postNo"));
					dbDto.setGenre(rs.getInt("genre"));
					dbDto.setId(rs.getString("id"));
					dbDto.setBookName(rs.getString("bookName"));
					dbDto.setSubject(rs.getString("subject"));
					dbDto.setReadCnt(rs.getInt("readCnt"));
					dbDto.setLiked(rs.getInt("liked"));
					dbDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(dbDto);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return articleList;
	}
	
	//게시글 번호로 게시글 찾기
	public TaBoardDTO getArticleByNo(Integer postNo) {
		TaBoardDTO tbDto= null;
		try {
			conn = getConn();
			
			String sql = "select * from taBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				tbDto = new TaBoardDTO();
				tbDto.setPostNo(rs.getInt("postNo"));
				tbDto.setGenre(rs.getInt("genre"));
				tbDto.setBookName(rs.getString("bookName"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return tbDto;
	}

	//타임어택 게시글 작성 메서드 [윤서]
	public void insertArticle(TaBoardDTO article) {
		try {
			conn = getConn();
			String sql = "insert into taBoard values(taBoard_seq.nextVal,?,?,?,?,?,0,0,0,0,0,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, article.getGenre());
			pstmt.setString(2, article.getId());
			pstmt.setString(3, article.getBookName());
			pstmt.setString(4, article.getSubject());
			pstmt.setString(5, article.getContent());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}
	
	//타임어택 게시글 개수 리턴하는 메서드 [윤서]
	public int getArticleCount() {
		int x = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from taBoard";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				x = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return x;
	}
	
	//범위 내의 게시글들을 가져오는 메서드 [윤서]
	public List getArticles(int start, int end) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "select b.*,r from (select a.*, rownum r from (select * from taBoard order by reg desc) a "
						+ "order by reg desc) b where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					TaBoardDTO article = new TaBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setGenre(rs.getInt("genre"));
					article.setId(rs.getString("id"));
					article.setBookName(rs.getString("bookName"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setChanCnt(rs.getInt("chanCnt"));
					article.setBanCnt(rs.getInt("banCnt"));
					article.setReadCnt(rs.getInt("readCnt"));
					article.setLiked(rs.getInt("liked"));
					article.setStatus(rs.getInt("status"));
					article.setReg(rs.getTimestamp("reg"));
					articleList.add(article);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return articleList;
	}
	
	//타임어택 검색 결과에 부합하는 게시글 개수 리턴하는 메서드 [윤서]
	public int getSearchArticleCount(String sel, String search) {
		int x = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from taBoard where "+sel+" like '%"+search+"%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				x = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return x;
	}
	
	//검색결과에 부합하는, 범위 내의 게시글들을 가져오는 메서드 [윤서]
	public List getSearchArticles(int start, int end, String sel, String search) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "select b.*,r from (select a.*, rownum r from (select * from taBoard where "+sel+" like '%"+search+"%' "
						+ "order by reg desc) a order by reg desc) b where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					TaBoardDTO article = new TaBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setGenre(rs.getInt("genre"));
					article.setId(rs.getString("id"));
					article.setBookName(rs.getString("bookName"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setChanCnt(rs.getInt("chanCnt"));
					article.setBanCnt(rs.getInt("banCnt"));
					article.setReadCnt(rs.getInt("readCnt"));
					article.setLiked(rs.getInt("liked"));
					article.setStatus(rs.getInt("status"));
					article.setReg(rs.getTimestamp("reg"));
					articleList.add(article);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return articleList;
	}
		
	//타임어택 게시판 최신순/인기순 정렬 처리해서 게시글들 리턴하는 메서드 [윤서]
	public List ArticlesSortedByOption(int start, int end, String sort) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "select b.*,r from (select a.*, rownum r from (select * from taBoard "
					+ "order by "+sort+" desc) a order by "+sort+" desc) b where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					TaBoardDTO article = new TaBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setGenre(rs.getInt("genre"));
					article.setId(rs.getString("id"));
					article.setBookName(rs.getString("bookName"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setChanCnt(rs.getInt("chanCnt"));
					article.setBanCnt(rs.getInt("banCnt"));
					article.setReadCnt(rs.getInt("readCnt"));
					article.setLiked(rs.getInt("liked"));
					article.setStatus(rs.getInt("status"));
					article.setReg(rs.getTimestamp("reg"));
					articleList.add(article);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return articleList;
	}
	
	//게시글 고유번호로 해당 글 내용 리턴하는 메서드 [윤서]
	public TaBoardDTO getArticle(int postNo, String id) {
		TaBoardDTO article = null;
		try{
			conn = getConn();
			//글 내용 가져오기
			String sql = "select * from taBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				article = new TaBoardDTO();
				article.setPostNo(rs.getInt("postNo"));
				article.setGenre(rs.getInt("genre"));
				article.setId(rs.getString("id"));
				article.setBookName(rs.getString("bookName"));
				article.setSubject(rs.getString("subject"));
				article.setContent(rs.getString("content"));
				article.setChanCnt(rs.getInt("chanCnt"));
				article.setBanCnt(rs.getInt("banCnt"));
				article.setReadCnt(rs.getInt("readCnt"));
				article.setLiked(rs.getInt("liked"));
				article.setStatus(rs.getInt("status"));				
				article.setReg(rs.getTimestamp("reg"));
			}
			//조회수 1 올려주기
			if(!rs.getString("id").equals(id)) {
				sql = "update taBoard set readCnt=readCnt+1 where postNo=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, postNo);
				pstmt.executeUpdate();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return article;
	}
	
	//타임어택 글 내용 수정하는 메서드 [윤서]
	public void modifyArticle(TaBoardDTO post) {
		try {
			conn = getConn();
			String sql = "update taBoard set subject=?, content=? where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, post.getSubject());
			pstmt.setString(2, post.getContent());
			pstmt.setInt(3, post.getPostNo());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}
	
	//타임어택 글 내용 삭제하는 메서드 [윤서]
	public void deleteArticle(int postNo) {
		try {
			conn = getConn();
			String sql = "delete from taBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//타임어택 종료시 상태 변경하는 메소드 [선준]
	public void updateStatus(Integer postNo) {
		try {
			conn = getConn();
			String sql = "update taBoard set status = 1 where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
}
