package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DebateBoardDAO {
	private static DebateBoardDAO instance = new DebateBoardDAO();
	private DebateBoardDAO() {}
	public static DebateBoardDAO getInstance() {return instance;}
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
		Integer res = -1;
		try {
			conn = getConn();
			String sql = "select count(*) from debateBoard where id=?";
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
			String sql = "select count(*) from debateBoard where id=? and "+sel+" like '%"+search+"%'";
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
	
	// 사용자가 작성한 게시글 가져오기 [선준]
	public List getArticles(String currId, Integer startRow, Integer endRow) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM debateBoard WHERE id=? "
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
	
	//사용자가 작성한 게시글 중 검색한 게시글 가져오기 [선준]
	public List getSearchArticles(String currId, Integer startRow, Integer endRow, String sel, String search) {
		List articleList = null;
		
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM debateBoard WHERE id=? and "+sel+" like '%"+search+"%' "
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
	public DebateBoardDTO getArticleByNo(Integer postNo) {
		DebateBoardDTO dbDto= null;
		try {
			conn = getConn();
			
			String sql = "select * from debateBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dbDto = new DebateBoardDTO();
				dbDto.setPostNo(rs.getInt("postNo"));
				dbDto.setGenre(rs.getInt("genre"));
				dbDto.setId(rs.getString("id"));
				dbDto.setBookName(rs.getString("bookName"));
				dbDto.setSubject(rs.getString("subject"));
				dbDto.setContent(rs.getString("content"));
				dbDto.setCbCheck(rs.getInt("cbCheck"));
				dbDto.setChanCnt(rs.getInt("chanCnt"));
				dbDto.setBanCnt(rs.getInt("banCnt"));
				dbDto.setReadCnt(rs.getInt("readCnt"));
				dbDto.setLiked(rs.getInt("liked"));
				dbDto.setReg(rs.getTimestamp("reg"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return dbDto;
	}
	
	//자유토론 게시글 작성 메서드 [윤서]
	public void insertArticle(DebateBoardDTO article) {
		try {
			if(article.getCbCheck()==null){
				article.setCbCheck(0);
			}	//찬반토론 체크 안하면 null로 넘어오기 때문에 0으로 먼저 set해준다.
			
			//글 저장
			conn = getConn();
			String sql = "insert into debateBoard(postNo,genre,id,bookName,subject,content,cbCheck,chanCnt,banCnt,readCnt,liked,reg) "
						+ "values(debateBoard_seq.nextVal,?,?,?,?,?,?,?,?,?,?,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, article.getGenre());
			pstmt.setString(2, article.getId());
			pstmt.setString(3, article.getBookName());
			pstmt.setString(4, article.getSubject());
			pstmt.setString(5, article.getContent());
			pstmt.setInt(6, article.getCbCheck());
			pstmt.setInt(7, 0);
			pstmt.setInt(8, 0);
			pstmt.setInt(9, 0);
			pstmt.setInt(10, 0);
			pstmt.executeUpdate();			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}
	
	//자유토론 게시글 개수 리턴하는 메서드 [윤서]
	public int getArticleCount() {
		int x = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from debateBoard";
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
			String sql = "select b.*,r from (select a.*, rownum r from (select * from debateBoard order by reg desc) a "
						+ "order by reg desc) b where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					DebateBoardDTO article = new DebateBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setGenre(rs.getInt("genre"));
					article.setId(rs.getString("id"));
					article.setBookName(rs.getString("bookName"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setCbCheck(rs.getInt("cbCheck"));
					article.setChanCnt(rs.getInt("chanCnt"));
					article.setBanCnt(rs.getInt("banCnt"));
					article.setReadCnt(rs.getInt("readCnt"));
					article.setLiked(rs.getInt("liked"));
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
	
	//자유토론 검색 결과에 부합하는 게시글 개수 리턴하는 메서드 [윤서]
	public int getSearchArticleCount(String sel, String search) {
		int x = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from debateBoard where "+sel+" like '%"+search+"%'";
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
			String sql = "select b.*,r from (select a.*, rownum r from (select * from debateBoard where "+sel+" like '%"+search+"%' "
						+ "order by reg desc) a order by reg desc) b where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					DebateBoardDTO article = new DebateBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setGenre(rs.getInt("genre"));
					article.setId(rs.getString("id"));
					article.setBookName(rs.getString("bookName"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setCbCheck(rs.getInt("cbCheck"));
					article.setChanCnt(rs.getInt("chanCnt"));
					article.setBanCnt(rs.getInt("banCnt"));
					article.setReadCnt(rs.getInt("readCnt"));
					article.setLiked(rs.getInt("liked"));
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
	
	//자유토론 게시판 최신순/인기순 정렬 처리해서 게시글들 리턴하는 메서드 [윤서]
	public List ArticlesSortedByOption(int start, int end, String sort) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "select b.*,r from (select a.*, rownum r from (select * from debateBoard "
					+ "order by "+sort+" desc) a order by "+sort+" desc) b where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					DebateBoardDTO article = new DebateBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setGenre(rs.getInt("genre"));
					article.setId(rs.getString("id"));
					article.setBookName(rs.getString("bookName"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setCbCheck(rs.getInt("cbCheck"));
					article.setChanCnt(rs.getInt("chanCnt"));
					article.setBanCnt(rs.getInt("banCnt"));
					article.setReadCnt(rs.getInt("readCnt"));
					article.setLiked(rs.getInt("liked"));
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
	
	//게시글 고유번호로 해당 글 내용을 리턴하는 메서드 [윤서]
	public DebateBoardDTO getArticle(int postNo, String id) {
		DebateBoardDTO article = null;
		try{
			conn = getConn();
			//글 내용 가져오기
			String sql = "select * from DebateBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				article = new DebateBoardDTO();
				article.setPostNo(rs.getInt("postNo"));
				article.setGenre(rs.getInt("genre"));
				article.setId(rs.getString("id"));
				article.setBookName(rs.getString("bookName"));
				article.setSubject(rs.getString("subject"));
				article.setContent(rs.getString("content"));
				article.setCbCheck(rs.getInt("cbCheck"));
				article.setChanCnt(rs.getInt("chanCnt"));
				article.setBanCnt(rs.getInt("banCnt"));
				article.setReadCnt(rs.getInt("readCnt"));
				article.setLiked(rs.getInt("liked"));
				article.setReg(rs.getTimestamp("reg"));
			}
			//조회수 1 올려주기
			if(!rs.getString("id").equals(id)) {
				sql = "update DebateBoard set readCnt=readCnt+1 where postNo=?";
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
	
	//자유토론 글 내용 수정하는 메서드 [윤서]
	public void modifyArticle(DebateBoardDTO post) {
		try {
			conn = getConn();
			String sql = "update DebateBoard set subject=?, content=? where postNo=?";
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
	
	//자유토론 글 내용 삭제하는 메서드 [윤서]
	public void deleteArticle(int postNo) {
		try {
			conn = getConn();
			String sql = "delete from debateBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
}
