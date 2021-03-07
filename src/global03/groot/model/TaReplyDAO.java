package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TaReplyDAO {
	private static TaReplyDAO instance = new TaReplyDAO();
	private TaReplyDAO() {};
	public static TaReplyDAO getInstance() { return instance; }
	
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
	
	//사용자가 작성한 댓글 수 반환 [선준]
	public Integer getCnt(String id) {
		Integer res = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from taReply where id=?";
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
	
	//사용자가 작성한 댓글 중 검색 조건에 맞는 댓글 수 메소드 [선준]
	public Integer getCnt(String currId, String sel, String search) {
		Integer res = -1;
		try {
			conn = getConn();
			String sql = "select count(*) from taReply where id=? and "+sel+" like '%"+search+"%'";
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
	
	//사용자가 작성한 댓글 가져오기 [선준]
	public List getReplies(String currId, Integer startRow, Integer endRow) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM taReply WHERE id=? "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, currId);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					TaReplyDTO trDto = new TaReplyDTO();
					trDto.setPostNo(rs.getInt("postNo"));
					trDto.setId(rs.getString("id"));
					trDto.setContent(rs.getString("content"));
					trDto.setPostNo(rs.getInt("postNo"));
					trDto.setRef(rs.getInt("ref"));
					trDto.setRe_level(rs.getInt("re_level"));
					trDto.setLiked(rs.getInt("liked"));
					trDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(trDto);
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
	public List getSearchReplies(String currId, Integer startRow, Integer endRow, String sel, String search) {
		List articleList = null;
		
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM taReply WHERE id=? and "+sel+" like '%"+search+"%' "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, currId);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					TaReplyDTO trDto = new TaReplyDTO();
					trDto.setPostNo(rs.getInt("postNo"));
					trDto.setId(rs.getString("id"));
					trDto.setContent(rs.getString("content"));
					trDto.setPostNo(rs.getInt("postNo"));
					trDto.setRef(rs.getInt("ref"));
					trDto.setRe_level(rs.getInt("re_level"));
					trDto.setLiked(rs.getInt("liked"));
					trDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(trDto);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return articleList;
	}

	//게시글번호 받아서 해당 게시글의 댓글 개수 리턴하는 메서드 [윤서]
	public int getReplyCount(int postNo) {
		int x = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from taReply where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
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
	
	//범위 내의 댓글들을 리턴하는 메서드 [윤서]
	public List getReplies(int postNo, int start, int end) {
		List replyList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.*, r FROM (SELECT a.*, rownum r FROM (SELECT * FROM taReply WHERE postNo=? "
						+ "ORDER BY ref ASC, re_level ASC, reg ASC) a ORDER BY ref ASC, re_level ASC, reg ASC) b where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				replyList = new ArrayList();
				do {
					TaReplyDTO reply = new TaReplyDTO();
					reply.setReplyNo(rs.getInt("replyNo"));
					reply.setType(rs.getInt("type"));
					reply.setId(rs.getString("id"));
					reply.setContent(rs.getString("content"));
					reply.setPostNo(rs.getInt("postNo"));
					reply.setRef(rs.getInt("ref"));
					reply.setRe_level(rs.getInt("re_level"));
					reply.setLiked(rs.getInt("liked"));
					reply.setReg(rs.getTimestamp("reg"));
					replyList.add(reply);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return replyList;
	}
	
	//타임어택 댓글 입력(저장)하는 메서드 [윤서]
	public void insertReply(TaReplyDTO reply) {
		int number = 0;
		int replyNo = reply.getReplyNo();
		int ref = reply.getRef();
		int re_level = reply.getRe_level();
		try {
			conn = getConn();
			String sql = "select max(replyNo) from taReply";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				number = rs.getInt(1)+1;
				System.out.println("rs이프문 number:"+number);
			}else {
				number = 1;
			}
			
			if(replyNo!=0) {
				ref = reply.getReplyNo();
				re_level = re_level+1;
				System.out.println("if replyNo가 0이 아닐 때 re_level은 "+re_level);
			}else {
				ref = number;
				re_level = 0;				
				System.out.println("else replyNo가 0일 때 re_level은 "+re_level+", ref는"+ref);
			}
			sql = "insert into taReply values(taReply_seq.nextVal,?,?,?,?,?,?,?,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, reply.getType());
			pstmt.setString(2, reply.getId());
			pstmt.setString(3, reply.getContent());
			pstmt.setInt(4, reply.getPostNo());
			pstmt.setInt(5, ref);
			pstmt.setInt(6, re_level);
			pstmt.setInt(7, reply.getLiked());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
}
