package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class GenreDAO {
	private static GenreDAO instance = new GenreDAO();
	private GenreDAO() {};
	public static GenreDAO getInstance() { return instance; }
	
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
	
	// 번호로 장르 찾기 메소드 [선준]
	public GenreDTO findGenre(Integer no) {
		GenreDTO gDto = null;
		try {
			conn = getConn();
			String sql = "select genre from genre where no=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, no);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				gDto = new GenreDTO();
				gDto.setNo(no);
				gDto.setGenre(rs.getString("genre"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		
		return gDto;
	}
	
	//전체 장르 가져오기
	public List getAllGenre() {
		List genreList = null;
		try {
			conn = getConn();
			String sql = "select * from genre";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				genreList = new ArrayList();
				do {
					GenreDTO gDto = new GenreDTO();
					gDto.setNo(rs.getInt("no"));
					gDto.setGenre(rs.getString("genre"));
					
					genreList.add(gDto);
				}while(rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return genreList;
	}

	//장르 번호 넘겨 받아 장르 String 타입의 장르명으로 리턴하는 메서드 [윤서]
	public String toGenreName(int genreNo) {
		String genreName = null;
		try {
			conn = getConn();
			String sql = "select genre from genre where no=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, genreNo);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				genreName = rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return genreName;
	}
	

	// 장르 string 불러오기 메서드[승목 0118]
	public String stringGenre(int num) {
		String stringGenre = null;
		try {
			conn = getConn();
			String sql = "SELECT * FROM GENRE WHERE NO=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				stringGenre = rs.getString("genre");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return stringGenre;
	}//stringGenre
	
	// 장르 리스트 불러오기 메서드[승목 0120]
	public List genreArticles() {
		List genreList = null;
		try {
			conn = getConn();
			String sql = "select * from genre";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				genreList = new ArrayList();
				do {
					GenreDTO genre = new GenreDTO();
					genre.setNo(rs.getInt("no"));
					genre.setGenre(rs.getString("genre"));
					genreList.add(genre);
				} while (rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return genreList;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
