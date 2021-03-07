package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class GrootUserDAO {
	private static GrootUserDAO instance = new GrootUserDAO();
	private GrootUserDAO() {};
	public static GrootUserDAO getInstance() {return instance;}
	
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
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
	
	// 로그인 메소드 [선준]
	public boolean idPwCheck(String id, String pw) {
		boolean res = false;
		try {
			conn = getConn();
			String sql = "select * from grootUser where id=? and pw=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				res = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return res;
	}
	
	// 회원정보 찾기 메소드 (이름, 이메일로) [선준]
	public GrootUserDTO userCheck(String name, String email) {
		GrootUserDTO guDto = null;
		
		try {
			conn = getConn();
			
			String sql = "select * from grootUser where name = ? and email=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, email);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				guDto = new GrootUserDTO();
				guDto.setId(rs.getString("id"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return guDto;
	}
	
	// 회원정보 찾기 메소드 (아이디, 이름, 이메일로) [선준]
	public boolean userCheck(String id, String name, String email) {
		boolean res = false;
		
		try {
			conn = getConn();
			
			String sql = "select * from grootUser where id=? and name=? and email=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, name);
			pstmt.setString(3, email);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				res = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return res;
	}
	
	// 비밀번호 수정 메소드 (pw찾기) [선준]
	public Integer editPw(String id, String newPw) {
		int res = -1;
		try {
			conn = getConn();
			
			String sql = "update grootUser set pw=? where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, newPw);
			pstmt.setString(2, id);
			res = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return res;
	}
	
	// 회원 탈퇴 메소드 [선준]
	public Integer deleteUser(String id, String pw) {
		Integer res=-1;
		try {
			conn = getConn();
			
			String sql = "delete from grootUser where id=? and pw=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			
			res = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return res;
	}
	
	//회원 아이디로 삭제 (관리자) [선준]
	public void deleteUser(String id) {
		try {
			conn = getConn();
			String sql = "delete from grootUser where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//아이디로 회원 정보가져오기
	public GrootUserDTO getUserInfo(String id) {
		GrootUserDTO guDto = null;
		try {
			conn = getConn();
			String sql = "select * from grootUser where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				guDto = new GrootUserDTO();
				guDto.setNo(rs.getInt("no"));
				guDto.setId(rs.getString("id"));
				guDto.setPw(rs.getString("pw"));
				guDto.setName(rs.getString("name"));
				guDto.setEmail(rs.getString("email"));
				guDto.setTel(rs.getString("tel"));
				guDto.setAddr(rs.getString("addr"));
				guDto.setFavorite1(rs.getInt("favorite1"));
				guDto.setFavorite2(rs.getInt("favorite2"));
				guDto.setFavorite3(rs.getInt("favorite3"));
				guDto.setReg(rs.getTimestamp("reg"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return guDto;
	}
	
	//전체 회원 수 가져오기 [선준]
	public Integer getUserCnt() {
		Integer cnt = 0;
		
		try {
			conn = getConn();
			String sql = "select count(*) from grootUser where not id='admin'";
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
	
	//전체 회원 목록 가져오기 (관리자 제외)
	public List getUserList(Integer startRow, Integer endRow) {
		List userList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM grootUser where not id='admin' "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				userList = new ArrayList();
				do {
					GrootUserDTO guDto = new GrootUserDTO();
					guDto.setNo(rs.getInt("no"));
					guDto.setId(rs.getString("id"));
					guDto.setPw(rs.getString("pw"));
					guDto.setName(rs.getString("name"));
					guDto.setEmail(rs.getString("email"));
					guDto.setTel(rs.getString("tel"));
					guDto.setAddr(rs.getString("addr"));
					guDto.setFavorite1(rs.getInt("favorite1"));
					guDto.setFavorite2(rs.getInt("favorite2"));
					guDto.setFavorite3(rs.getInt("favorite3"));
					guDto.setReg(rs.getTimestamp("reg"));
					
					userList.add(guDto);
				}while(rs.next());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return userList;
	}
	
	//검색한 회원의 수 가져오기 [선준]
	public Integer getSearchUserCnt(String sel, String search) {
		Integer cnt = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from grootUser where not id='admin' and "+sel+" like '%"+search+"%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				cnt = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return cnt;
	}
	
	//검색한 회원 목록 가져오기
	public List getSearchUserList(String sel, String search, Integer startRow, Integer endRow) {
		List userList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM grootUser where not id='admin' and "+sel+" like '%"+search+"%' "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				userList = new ArrayList();
				do {
					GrootUserDTO guDto = new GrootUserDTO();
					guDto.setNo(rs.getInt("no"));
					guDto.setId(rs.getString("id"));
					guDto.setPw(rs.getString("pw"));
					guDto.setName(rs.getString("name"));
					guDto.setEmail(rs.getString("email"));
					guDto.setTel(rs.getString("tel"));
					guDto.setAddr(rs.getString("addr"));
					guDto.setFavorite1(rs.getInt("favorite1"));
					guDto.setFavorite2(rs.getInt("favorite2"));
					guDto.setFavorite3(rs.getInt("favorite3"));
					guDto.setReg(rs.getTimestamp("reg"));
					
					userList.add(guDto);
				}while(rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return userList;
	}

	// 회원가입 메서드입니다만?(by 찬물로 씻는다)
	public void insertMember(GrootUserDTO dto) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			String sql = "insert into grootUser values(grootUser_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate)";
			conn = getConn();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPw());
			pstmt.setString(3, dto.getName());
			pstmt.setString(4, dto.getEmail());
			pstmt.setString(5, dto.getTel());
			pstmt.setString(6, dto.getAddr());
			pstmt.setInt(7, dto.getFavorite1());
			pstmt.setInt(8, dto.getFavorite2());
			pstmt.setInt(9, dto.getFavorite3());
			
			pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	// id 중복체크입니다만?(by 찬물로 씻는다)
	public boolean confirmId(String id) {
		boolean result = false;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String sql = "select id from grootUser where id=?";
			conn = getConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
