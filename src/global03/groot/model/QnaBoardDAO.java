package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class QnaBoardDAO {
	private static QnaBoardDAO instance = new QnaBoardDAO();
	private QnaBoardDAO() {};
	public static QnaBoardDAO getInstance() { return instance; }
	
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
	
	//사용자가 작성한 게시글 수 반환 [선준]
	public Integer getCnt(String id) {
		Integer res = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from qnaBoard where id=?";
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
	
	//사용자가 작성한 게시글 가져오기 [선준]
	public List getArticles(String currId, Integer startRow, Integer endRow) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM qnaBoard WHERE id=? "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, currId);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					QnaBoardDTO qbDto = new QnaBoardDTO();
					qbDto.setPostNo(rs.getInt("postNo"));
					qbDto.setId(rs.getString("id"));
					qbDto.setType(rs.getString("type"));
					qbDto.setSubject(rs.getString("subject"));
					qbDto.setContent(rs.getString("content"));
					qbDto.setRef(rs.getInt("ref"));
					qbDto.setRe_level(rs.getInt("re_level"));
					qbDto.setSecret(rs.getInt("secret"));
					qbDto.setStatus(rs.getInt("status"));
					qbDto.setReadCnt(rs.getInt("readCnt"));
					qbDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(qbDto);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return articleList;
	}
	
	//사용자가 작성한 특정 게시글의 수 메소드 [선준]
	public Integer getCnt(String currId, String sel, String search) {
		Integer res = -1;
		try {
			conn = getConn();
			String sql = "select count(*) from qnaBoard where id=? and "+sel+" like '%"+search+"%'";
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
					QnaBoardDTO qbDto = new QnaBoardDTO();
					qbDto.setPostNo(rs.getInt("postNo"));
					qbDto.setId(rs.getString("id"));
					qbDto.setType(rs.getString("type"));
					qbDto.setSubject(rs.getString("subject"));
					qbDto.setContent(rs.getString("content"));
					qbDto.setRef(rs.getInt("ref"));
					qbDto.setRe_level(rs.getInt("re_level"));
					qbDto.setSecret(rs.getInt("secret"));
					qbDto.setStatus(rs.getInt("status"));
					qbDto.setReadCnt(rs.getInt("readCnt"));
					qbDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(qbDto);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return articleList;
	}
	
	// 게시글 저장 [찬환]
	public void insertArticle(QnaBoardDTO article) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int number = 0;
		int postNo = article.getPostNo();
		int ref = article.getRef();
		int re_level = article.getRe_level();
		if(article.getSecret() == null) {
			article.setSecret(0);
		}
		try {
			conn = getConn();
			String sql = "select max(postNo) from qnaBoard";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				number = rs.getInt(1) + 1;
			}else {
				number = 1;
			}
	
			// 답글
			if(postNo != 0) {
					sql = "update qnaBoard set re_level=re_level+1 where ref=? and re_level > ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, re_level);
				pstmt.executeUpdate();
				re_level = re_level + 1;
			}else {
				ref = number;
				re_level = 0;
			}
			
			// 글 저장 쿼리문
			sql = "insert into qnaBoard(postNo,type,subject,id,content,reg,ref,re_level,secret) "
					+ "values(qnaboard_seq.nextVal,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getType());
			pstmt.setString(2, article.getSubject());
			pstmt.setString(3, article.getId());
			pstmt.setString(4, article.getContent());
			pstmt.setTimestamp(5, article.getReg());
			pstmt.setInt(6, ref);
			pstmt.setInt(7, re_level);
			pstmt.setInt(8, article.getSecret());
			
			pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 전체 글 개수 리턴 메서드 [찬환]
	public int getArticleCount() {
		int x = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConn();
			String sql = "select count(*) from qnaBoard";
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
	
	// 검색된 글의 개수 리턴 메서드 [찬환]
	public int getSearchArticleCount(String sel, String search) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConn();
			String sql = "select count(*) from qnaBoard where " + sel + " like '%" + search + "%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return count;
	}
	
	// 검색 + 범위 주고 게시글 가져오기 [찬환]
	public List getSearchArticles(int start, int end, String sel, String search) {
		List articleList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConn();
			String sql = "SELECT postNo,type,subject,id,content,reg,ref,re_level,secret,status,readCnt,r "
					+ "FROM (SELECT postNo,type,subject,id,content,reg,ref,re_level,secret,status,readCnt,rownum r " 
					+ "FROM (SELECT postNo,type,subject,id,content,reg,ref,re_level,secret,status,readCnt " 
					+"FROM qnaBoard where "+sel+" like '%" +search+ "%' ORDER BY ref DESC, re_level ASC) "
					+ "ORDER BY REF DESC, re_level ASC) WHERE r >= ? AND r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					QnaBoardDTO article = new QnaBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setId(rs.getString("id"));
					article.setType(rs.getString("type"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setRef(rs.getInt("ref"));
					article.setRe_level(rs.getInt("re_level"));
					article.setSecret(rs.getInt("secret"));
					article.setStatus(rs.getInt("status"));
					article.setReadCnt(rs.getInt("readCnt"));
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
	
	// 범위주고 게시글 가져오기 [찬환]
	public List getArticles(int start, int end) {
		List articleList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConn();
			String sql = "SELECT B.*, r FROM "
		               + "(SELECT A.*, rownum r FROM"
		               + "(SELECT * FROM qnaBoard ORDER BY ref DESC, re_level ASC) A "
		               + "ORDER BY ref DESC, re_level ASC) B WHERE r >= ? AND r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					QnaBoardDTO article = new QnaBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setId(rs.getString("id"));
					article.setType(rs.getString("type"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setRef(rs.getInt("ref"));
					article.setRe_level(rs.getInt("re_level"));
					article.setSecret(rs.getInt("secret"));
					article.setStatus(rs.getInt("status"));
					article.setReadCnt(rs.getInt("readCnt"));
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
	
	// 글 고유번호로 해당 글 내용 가져오는 메서드
	public QnaBoardDTO getArticle(int postNo) {
		QnaBoardDTO article = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConn();
			String sql = "update qnaBoard set readCnt=readCnt+1 where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.executeUpdate();
			
			// 글 가져오기
			sql = "select * from qnaBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				article = new QnaBoardDTO();
				article.setPostNo(postNo);
				article.setId(rs.getString("id"));
				article.setType(rs.getString("type"));
				article.setSubject(rs.getString("subject"));
				article.setContent(rs.getString("content"));
				article.setRef(rs.getInt("ref"));
				article.setRe_level(rs.getInt("re_level"));
				article.setSecret(rs.getInt("secret"));
				article.setStatus(rs.getInt("status"));
				article.setReadCnt(rs.getInt("readCnt"));
				article.setReg(rs.getTimestamp("reg"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return article;
	}
	
	// postno, pw 체크 메서드
	/*public boolean postnoSecretCheck(int postno, String secret) {
		boolean result = false;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConn();
			String sql = "select * from board where postno=? and secret=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postno);
			pstmt.setString(2, secret);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return result;
	}*/
	
	// 글 삭제
	public void deleteArticle(int postNo) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConn();
			String sql = "delete from qnaBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 글 수정
	public void updateArticle(QnaBoardDTO article) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConn();
			String sql = "update qnaBoard set type=?, subject=?, content=? where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getType());
			pstmt.setString(2, article.getSubject());
			pstmt.setString(3, article.getContent());
			pstmt.setInt(4, article.getPostNo());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//답변완료 처리 [선준]
	public void updateStatus(Integer postNo) {
		try {
			conn = getConn();
			String sql = "update qnaBoard set status=1 where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}

	//답변 미완료 게시글의 수 [선준]
	public Integer getUnAsrCnt() {
		Integer cnt = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from qnaBoard where postNo=ref and status=0";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return cnt;
	}
	
	//답변 미완료 게시글 가져오기 [선준]
	public List getUnAsrArticles(Integer startRow, Integer endRow) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT B.*, r FROM "
		               + "(SELECT A.*, rownum r FROM"
		               + "(SELECT * FROM qnaBoard where postNo=ref and status=0 ORDER BY ref DESC, re_level ASC) A "
		               + "ORDER BY ref DESC, re_level ASC) B WHERE r >= ? AND r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					QnaBoardDTO article = new QnaBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setId(rs.getString("id"));
					article.setType(rs.getString("type"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setRef(rs.getInt("ref"));
					article.setRe_level(rs.getInt("re_level"));
					article.setSecret(rs.getInt("secret"));
					article.setStatus(rs.getInt("status"));
					article.setReadCnt(rs.getInt("readCnt"));
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

	//답변 미완료 게시글중 검색한 게시글의 수 [선준]
	public Integer getSearchUnAsrCnt(String sel, String search) {
		Integer cnt = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from qnaBoard where postNo=ref and status=0 and "+
			sel+ " like '%"+search+"%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return cnt;
	}
	
	//답변 미완료 게시글중 검색한 게시글 가져오기 [선준]
	public List getSearchUnAsrArticles(String sel, String search, Integer startRow, Integer endRow) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT postNo,type,subject,id,content,reg,ref,re_level,secret,status,readCnt,r "
					+ "FROM (SELECT postNo,type,subject,id,content,reg,ref,re_level,secret,status,readCnt,rownum r " 
					+ "FROM (SELECT postNo,type,subject,id,content,reg,ref,re_level,secret,status,readCnt " 
					+"FROM qnaBoard where postNo=ref and status=0 and "+sel+" like '%" +search+ "%' ORDER BY ref DESC, re_level ASC) "
					+ "ORDER BY REF DESC, re_level ASC) WHERE r >= ? AND r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					QnaBoardDTO article = new QnaBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setId(rs.getString("id"));
					article.setType(rs.getString("type"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setRef(rs.getInt("ref"));
					article.setRe_level(rs.getInt("re_level"));
					article.setSecret(rs.getInt("secret"));
					article.setStatus(rs.getInt("status"));
					article.setReadCnt(rs.getInt("readCnt"));
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
	
	//답변 완료된 게시글 수 [선준]
	public Integer getAsrCnt() {
		Integer cnt = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from qnaBoard where postNo=ref and status=1";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return cnt;
	}
	
	//답변 완료된 게시글 가져오기 [선준]
	public List getAsrArticles(Integer startRow, Integer endRow) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT B.*, r FROM "
		               + "(SELECT A.*, rownum r FROM"
		               + "(SELECT * FROM qnaBoard where postNo=ref and status=1 ORDER BY ref DESC, re_level ASC) A "
		               + "ORDER BY ref DESC, re_level ASC) B WHERE r >= ? AND r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					QnaBoardDTO article = new QnaBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setId(rs.getString("id"));
					article.setType(rs.getString("type"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setRef(rs.getInt("ref"));
					article.setRe_level(rs.getInt("re_level"));
					article.setSecret(rs.getInt("secret"));
					article.setStatus(rs.getInt("status"));
					article.setReadCnt(rs.getInt("readCnt"));
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
	
	//답변완료 게시글중 검색한 게시글 수 [선준]
	public Integer getSearchAsrCnt(String sel, String search) {
		Integer cnt = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from qnaBoard where postNo=ref and status=1 and "+
			sel+ " like '%"+search+"%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return cnt;
	}
	
	//답변완료 게시글중 검색한 게시글 가져오기 [선준]
	public List getSearchAsrArticles(Integer startRow, Integer endRow, String sel, String search) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT postNo,type,subject,id,content,reg,ref,re_level,secret,status,readCnt,r "
					+ "FROM (SELECT postNo,type,subject,id,content,reg,ref,re_level,secret,status,readCnt,rownum r " 
					+ "FROM (SELECT postNo,type,subject,id,content,reg,ref,re_level,secret,status,readCnt " 
					+"FROM qnaBoard where postNo=ref and status=1 and "+sel+" like '%" +search+ "%' ORDER BY ref DESC, re_level ASC) "
					+ "ORDER BY REF DESC, re_level ASC) WHERE r >= ? AND r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					QnaBoardDTO article = new QnaBoardDTO();
					article.setPostNo(rs.getInt("postNo"));
					article.setId(rs.getString("id"));
					article.setType(rs.getString("type"));
					article.setSubject(rs.getString("subject"));
					article.setContent(rs.getString("content"));
					article.setRef(rs.getInt("ref"));
					article.setRe_level(rs.getInt("re_level"));
					article.setSecret(rs.getInt("secret"));
					article.setStatus(rs.getInt("status"));
					article.setReadCnt(rs.getInt("readCnt"));
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
	
	
	
	
}
