package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TrophyCntDAO {
	private static TrophyCntDAO instance = new TrophyCntDAO();
	private TrophyCntDAO() {}
	public static TrophyCntDAO getInstance() {return instance;}
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
	
	// 회원가입시 userId에 해당하는 레코드 삽입(by 찬물로 씻는다)
	public void insertUser(String userId) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			String sql = "insert into trophyCnt values(?, 1, 0, 0, 0, 0, 0, 0, 0, 0)";
			
			conn = getConn();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, userId);
			
			pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}	
	
	//나눔 요청이 수락되었을때 dae칼럼 증가 [선준]
	public void updateDaeCnt(String requestId) {
		try {
			conn = getConn();
			String sql = "update trophyCnt set daeCnt=daeCnt+1 where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, requestId);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//dae칼럼 데이터 가져오기 [선준]
	public TrophyCntDTO getDaeCnt(String requestId) {
		TrophyCntDTO tcDto = null;
		try {
			conn = getConn();
			String sql = "select daeCnt from trophyCnt where userId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, requestId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				tcDto = new TrophyCntDTO();
				tcDto.setDaeCnt(rs.getInt("daeCnt"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return tcDto;
	}
	
	//회원의 트로피 정보 가져오기 [선준]
	public TrophyCntDTO getUserTrophyInfo(String id) {
		TrophyCntDTO tcDto = null;
		try {
			conn = getConn();
			String sql = "select * from trophyCnt where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				tcDto = new TrophyCntDTO();
				tcDto.setUserId(rs.getString("userId"));
				tcDto.setSsaCnt(rs.getInt("ssaCnt"));
				tcDto.setGukCnt(rs.getInt("gukCnt"));
				tcDto.setHyeCnt(rs.getInt("hyeCnt"));
				tcDto.setDaeCnt(rs.getInt("daeCnt"));
				tcDto.setNhcCnt(rs.getInt("nhcCnt"));
				tcDto.setInfluCnt(rs.getInt("influCnt"));
				tcDto.setSprCnt(rs.getInt("sprCnt"));
				tcDto.setDdaCnt(rs.getInt("ddaCnt"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			closeAll(conn, pstmt, rs);
		}
		return tcDto;
	}
	
	//회원 삭제 [선준]
	public void deleteUser(String id) {
		try {
			conn = getConn();
			String sql = "delete from trophyCnt where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}

	//gukCnt에 +1 더해주는 메서드 [윤서]
	public void addCntGuk(String userId) {
		try {
			conn = getConn();
			String sql = "update trophyCnt set gukCnt=gukCnt+1 where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}
	
	//nhcCnt에 +1 더해주는 메서드 [윤서]
	public void addCntNhc(String userId) {
		try {
			conn = getConn();
			String sql = "update trophyCnt set nhcCnt=nhcCnt+1 where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}
	
	//sprCnt에 +1 더해주는 메서드 [윤서]
	public void addCntSpr(String writer) {
		try {
			conn = getConn();
			String sql = "update trophyCnt set sprCnt=sprCnt+1 where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, writer);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}
	
	//ddaCnt에 +1 더해주는 메서드 [윤서]
	public void addCntDda(String userId) {
		try {
			conn = getConn();
			String sql = "update trophyCnt set ddaCnt=ddaCnt+1 where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}
	
	//influCnt에 +1 더해주는 메서드 [윤서]
	public void addCntInflu(int postNo) {
		String writer = null;
		try {
			conn = getConn();
			String sql = "select id from debateBoard where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				writer = rs.getString(1);
			}
			sql = "update trophyCnt set influCnt=influCnt+1 where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, writer);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	// 나눔 hyeCnt + 1 메서드 [승목 0131]
	public void insertTrophyCnt(String userId){
		try {
			conn = getConn();
			String sql = "update trophyCnt set hyeCnt = hyeCnt + 1 where userId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}//insertTrophyCnt
	
	//(admin) 회원의 cnt 업데이트 [선준]
	public void updateUserTrophyCnt(TrophyCntDTO tcDto) {
		try {
			conn = getConn();
			String sql = "update trophyCnt set ssaCnt=?, gukCnt=?, hyeCnt=?, daeCnt=?, nhcCnt=?, influCnt=?, sprCnt=?, ddaCnt=? where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, tcDto.getSsaCnt());
			pstmt.setInt(2, tcDto.getGukCnt());
			pstmt.setInt(3, tcDto.getHyeCnt());
			pstmt.setInt(4, tcDto.getDaeCnt());
			pstmt.setInt(5, tcDto.getNhcCnt());
			pstmt.setInt(6, tcDto.getInfluCnt());
			pstmt.setInt(7, tcDto.getSprCnt());
			pstmt.setInt(8, tcDto.getDdaCnt());
			pstmt.setString(9, tcDto.getUserId());
			
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//나눔 hyeCnt 값 가져오기 메서드 [승목 0131]
	public TrophyCntDTO getHyeCnt(String userId){
		TrophyCntDTO hyeCnt= null;
		try {
			conn = getConn();
			String sql = "select hyeCnt from trophyCnt where userId= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				hyeCnt = new TrophyCntDTO();
				hyeCnt.setHyeCnt(rs.getInt("hyeCnt"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return hyeCnt;
	}
	
}
