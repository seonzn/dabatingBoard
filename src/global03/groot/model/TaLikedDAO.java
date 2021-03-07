package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TaLikedDAO {

	//싱글턴 [윤서]
	private static TaLikedDAO instance = new TaLikedDAO();
	private TaLikedDAO() {}
	public static TaLikedDAO getInstance() { return instance; }
	
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
	
	//타임어택 게시글 추천 메서드 [윤서]
	public boolean articleLiked(int postNo, String memId, String writer) {
		boolean res = false;
		try {
			conn = getConnection();
			String sql = "select count(*) from taLiked where postNo=? and userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.setString(2, memId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getInt(1)==0 && !writer.equals(memId)) {
					sql = "insert into taLiked values(?,?)";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, postNo);
					pstmt.setString(2, memId);
					pstmt.executeUpdate();
					
					sql = "update taBoard set liked=liked+1 where postNo=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, postNo);
					pstmt.executeUpdate();
					res = true;
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return res;
	}
}
