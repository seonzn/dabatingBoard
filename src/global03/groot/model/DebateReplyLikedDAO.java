package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DebateReplyLikedDAO {
	
	//싱글턴 [윤서]
	private static DebateReplyLikedDAO instance = new DebateReplyLikedDAO();
	private DebateReplyLikedDAO() {}
	public static DebateReplyLikedDAO getInstance() { return instance; }
	
	//커넥션 메서드 [윤서]
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	//객체 닫는 메서드 [윤서]
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private void closeAll(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if(rs!=null)try { rs.close(); }catch(Exception e) { e.printStackTrace(); }
		if(pstmt!=null)try { pstmt.close(); }catch(Exception e) { e.printStackTrace(); }
		if(conn!=null)try { conn.close(); }catch(Exception e) { e.printStackTrace(); }
	}

	//자유토론 댓글 좋아요 메서드 [윤서]
	public boolean replyLiked(String memId, int postNo, int replyNo) {
		boolean res = false;
		try {
			conn = getConnection();
			String sql = "select * from debateReply where replyNo=? and id=?";	//본인 댓글 좋아요 방지
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, replyNo);
			pstmt.setString(2, memId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return res;
			}
			
			sql = "select * from debateReplyLiked where replyNo=? and userId=?";	//중복 좋아요 방지
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, replyNo);
			pstmt.setString(2, memId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return res;
			}
			
			sql = "update debateReply set liked=liked+1 where replyNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, replyNo);
			pstmt.executeUpdate();
			
			sql = "insert into debateReplyLiked values(?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, replyNo);
			pstmt.setString(2, memId);
			pstmt.executeUpdate();
			res = true;
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return res;
	}
	
	
	
	
	
}
