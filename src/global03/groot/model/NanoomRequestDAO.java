package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class NanoomRequestDAO {
	private static NanoomRequestDAO instance = new NanoomRequestDAO();
	private NanoomRequestDAO() {}
	public static NanoomRequestDAO getInstance() {return instance;}
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
	
	//내가 요청한 나눔글 개수 가져오기 [선준]
	public Integer getCnt(String currId) {
		Integer res = 0;
		try {
			conn = getConn();
			
			String sql = "select count(*) from nanoomRequest where requestId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, currId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				res = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return res;
	}
	
	//내가 요청한 나눔글 상위 3개 가져오기 [선준]
	public List get3Articles(String currId) {
		List articleList = null;
		try {
			conn = getConn();
			String sql = "SELECT b.* FROM" + 
					"(SELECT a.* , rownum r FROM" + 
					"(SELECT * FROM nanoomRequest WHERE requestId=? "
					+ "ORDER BY reg DESC) a ORDER BY reg DESC) b WHERE r>=1 AND r<=3";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, currId);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					NanoomRequestDTO nrDto = new NanoomRequestDTO();
					nrDto.setNo(rs.getInt("no"));
					nrDto.setPostNo(rs.getInt("postNo"));
					nrDto.setId(rs.getString("id"));
					nrDto.setRequestId(rs.getString("requestId"));
					nrDto.setName(rs.getString("name"));
					nrDto.setAddr(rs.getString("addr"));
					nrDto.setTel(rs.getString("tel"));
					nrDto.setResult(rs.getInt("result"));
					nrDto.setReg(rs.getTimestamp("reg"));
					
					articleList.add(nrDto);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return articleList;
	}
	
	//postNo로 수신자 정보 가져오기 [선준]
	public NanoomRequestDTO getReceiverInfo(Integer postNo) {
		NanoomRequestDTO nrDto = null;
		
		try {
			conn = getConn();
			String sql = "select * from nanoomRequest where postNo=? and not result=2";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				nrDto = new NanoomRequestDTO();
				
				nrDto.setNo(rs.getInt("no"));
				nrDto.setPostNo(rs.getInt("postNo"));
				nrDto.setId(rs.getString("id"));
				nrDto.setRequestId(rs.getString("requestId"));
				nrDto.setName(rs.getString("name"));
				nrDto.setAddr(rs.getString("addr"));
				nrDto.setTel(rs.getString("tel"));
				nrDto.setResult(rs.getInt("result"));
				nrDto.setReg(rs.getTimestamp("reg"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return nrDto;
	}
	
	//신청자 아이디로 나눔글 postNo 가져오기
	public List getPostNo(String currId) {
		NanoomRequestDTO nrDto = null;
		List postNoList = null;
		try {
			conn = getConn();
			String sql = "select * from nanoomRequest where requestId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, currId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				postNoList = new ArrayList();
				do {
					nrDto = new NanoomRequestDTO();
					nrDto.setPostNo(rs.getInt("postNo"));
					postNoList.add(nrDto);
				}while(rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return postNoList;
	}
	
	//나눔 요청이 수락되었을 때 result 값 수정 메소드 [선준]
	public void acceptedNanoom(Integer postNo) {
		try {
			conn = getConn();
			String sql = "update nanoomRequest set result=1 where postNo=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}
	
	//나눔 요청이 거절되었을 때 result 값 수정 메소드 [선준]
	public void rejectedNanoom(Integer postNo) {
		try {
			conn = getConn();
			String sql = "update nanoomRequest set result=2 where postNo =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNo);
			pstmt.executeQuery();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
	}

	// 나눔요청 정보 입력 메서드[승목 0126]
	public void insertNanoomRequest(NanoomRequestDTO dto){
		try {
			conn = getConn();
			String sql = "INSERT INTO nanoomrequest VALUES(nanoomRequest_seq.nextVal, ?, ?, ?, ?, ?, ?, 0, sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getPostNo());
			pstmt.setString(2, dto.getId());
			pstmt.setString(3, dto.getRequestId());
			pstmt.setString(4, dto.getName());
			pstmt.setString(5, dto.getAddr());
			pstmt.setString(6, dto.getTel());
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, null);
		}
	}//insertNanoomRequest
	
	
	
	
	
	
	
	
}
