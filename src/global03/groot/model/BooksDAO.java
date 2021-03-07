package global03.groot.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BooksDAO {
	private static BooksDAO instance = new BooksDAO();
	private BooksDAO() {};
	public static BooksDAO getInstance() { return instance; }
	
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
	
	//장르 번호로 도서개수 가져오는 메소드 [선준]
	public Integer getCnt(Integer genreNo) {
		Integer count = 0;
		try {
			conn = getConn();
			String sql = "select count(*) from books where genre =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, genreNo);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return count;
	}
	
	//장르별 도서목록 가져오는 메소드 [선준]
	public List getBooks(Integer genreNo) {
		List bookList = null;
		BooksDTO bDto = null;
		try {
			conn = getConn();
			String sql = "select * from books where genre=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, genreNo);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bookList = new ArrayList();
				do {
					bDto = new BooksDTO();
					bDto.setNo(rs.getInt("no"));
					bDto.setBookName(rs.getString("bookName"));
					bDto.setGenre(rs.getInt("genre"));
					
					bookList.add(bDto);
				}while(rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(conn, pstmt, rs);
		}
		return bookList;
	}
	
	//글 작성했을 때 책 정보 저장시키는 메서드 [윤서]
	public boolean insertBookInfo(String bookName, Integer genre) {
		boolean res = false;
		try {
			conn = getConn();
			
			String sql = "select * from books where bookName=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bookName);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return res;
			}
			
			sql = "insert into books values(books_seq.nextVal,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bookName);
			pstmt.setInt(2, genre);
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
