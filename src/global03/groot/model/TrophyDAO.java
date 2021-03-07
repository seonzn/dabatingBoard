package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TrophyDAO {
	// 싱글턴
	private static TrophyDAO instance = new TrophyDAO();
	private TrophyDAO() {};
	public static TrophyDAO getInstance() {return instance;}
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	//커넥션 메소드
	private Connection getConn() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		
		return ds.getConnection();
	}
	
	//커넥션 close 메소드
	private void closeAll(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
		if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
		if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	}

	// 회원가입시 userid에 해당하는 레코드 삽입(by 찬물로 씻는다)
	public void insertUser(String userId) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			String sql = "insert into trophy values(?, 1, 0, 0, 0, 0, 0, 0, 0, 0)";
			
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
	
	//사용자의 트로피 정보 가져오기 [선준]
	public TrophyDTO getAllTrophy(String currId) {
		TrophyDTO tDto = null;
		
		try {
			conn = getConn();
			String sql = "select * from trophy where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, currId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				tDto = new TrophyDTO();
				tDto.setUserId(rs.getString("userId"));
				tDto.setNb(rs.getInt("nb"));
				tDto.setSsa(rs.getInt("ssa"));
				tDto.setGuk(rs.getInt("guk"));
				tDto.setHye(rs.getInt("hye"));
				tDto.setDae(rs.getInt("dae"));
				tDto.setNhc(rs.getInt("nhc"));
				tDto.setInflu(rs.getInt("influ"));
				tDto.setSpr(rs.getInt("spr"));
				tDto.setDda(rs.getInt("dda"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return tDto;
	}
	
	//dae칼럼 수정하기 [선준]
	public void updateDae(String requestId, Integer tier) {
		try {
			conn = getConn();
			String sql = "update trophy set dae=? where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, tier);
			pstmt.setString(2, requestId);
			
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}

	//gukCnt에 따른 guk트로피 수여 메서드 [윤서]
	public void gukTrophyAchieve(String userId) {
		try {
			conn = getConn();
			String sql = "select * from trophyCnt where userId=? and gukCnt=3";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set guk=1 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and gukCnt=4";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set guk=2 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and gukCnt=5";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set guk=3 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//nhcCnt에 따른 nhc트로피 수여 메서드 [윤서]
	public void nhcTrophyAchieve(String userId) {
		try {
			conn = getConn();
			String sql = "select * from trophyCnt where userId=? and nhcCnt=3";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set nhc=1 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and nhcCnt=4";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set nhc=2 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and nhcCnt=5";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set nhc=3 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//sprCnt에 따른 spr트로피 수여 메서드 [윤서]
	public void sprTrophyAchieve(String writer) {
		try {
			conn = getConn();
			String sql = "select * from trophyCnt where userId=? and sprCnt=3";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, writer);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set spr=1 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, writer);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and sprCnt=4";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, writer);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set spr=2 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, writer);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and sprCnt=5";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, writer);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set spr=3 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, writer);
				pstmt.executeUpdate();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally{
			closeAll(conn, pstmt, rs);
		}
	}
	
	//ddaCnt에 따른 dda트로피 수여 메서드 [윤서]
	public void ddaTrophyAchieve(String userId) {
		try {
			conn = getConn();
			String sql = "select * from trophyCnt where userId=? and ddaCnt=3";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set dda=1 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and ddaCnt=4";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set dda=2 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and ddaCnt=5";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set dda=3 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally{
			closeAll(conn, pstmt, rs);
		}
	}
	
	//influCnt에 따른 influ트로피 수여 메서드 [윤서]
	public void influTrophyAchieve(int postNo) {
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
			
			sql = "select * from trophyCnt where userId=? and influCnt=3";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, writer);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set influ=1 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, writer);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and influCnt=4";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, writer);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set influ=2 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, writer);
				pstmt.executeUpdate();
			}
			
			sql = "select * from trophyCnt where userId=? and influCnt=5";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, writer);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update trophy set influ=3 where userId=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, writer);
				pstmt.executeUpdate();
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//회원 삭제 [선준]
	public void deleteUser(String id) {
		try {
			conn = getConn();
			String sql = "delete from trophy where userId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}	
	
	
	// 나눔트로피 hye 값 가져오기 메서드[승목 0129] 
	public TrophyDTO trophyNum(String userId){
		TrophyDTO hye = null;
		try {
			conn = getConn();
			String sql = "select hye From trophy where userId= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				hye = new TrophyDTO();
				hye.setHye(rs.getInt("hye"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return hye;
	}//trophyNum
	
	// 나눔 hye + 1 메서드 [승목 0131]
	public void insertTrophyHye(String userId){
		try {
			conn = getConn();
			String sql = "update trophy set hye= hye + 1 where userId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}//insertTrophyHye
	

}
