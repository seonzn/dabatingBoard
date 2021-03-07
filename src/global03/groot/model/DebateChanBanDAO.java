package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DebateChanBanDAO {
	
	//싱글턴 [윤서]
	private static DebateChanBanDAO instance = new DebateChanBanDAO();
	private DebateChanBanDAO() {}
	public static DebateChanBanDAO getInstance() { return instance; }
	
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

	//자유토론 게시글 찬성/반대 처리 메서드 [윤서]
	public boolean chanOrBan(int postNo, String memId, String cb) {
		String writer = null;	//글 작성자
		boolean res = false;
		try {
			conn = getConnection();
			String sql = "select id from debateBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				writer = rs.getString(1);
			}
			
			if(!memId.equals(writer)) {
				sql = "select * from debateChanBan where postNo=? and userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, postNo);
				pstmt.setString(2, memId);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					return res;
				}
				sql = "insert into debateChanBan values(?,?,?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, postNo);
				pstmt.setString(2, memId);
				pstmt.setString(3, cb);
				pstmt.executeUpdate();
				if(cb.equals("Y")) {
					sql = "update debateBoard set chanCnt=chanCnt+1 where postNo=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, postNo);
					pstmt.executeUpdate();
				}else if(cb.equals("N")) {
					sql = "update debateBoard set banCnt=banCnt+1 where postNo=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, postNo);
					pstmt.executeUpdate();
				}
				res = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return res;
	}
	
	
	
	
	
	
	
	
	
	
}
