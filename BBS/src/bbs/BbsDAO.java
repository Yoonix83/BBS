package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {

	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
		
		try {
			
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "1324";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL,dbID, dbPassword);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 현재 시간 구하는 함수
	public String getDate() {
		String SQL = "SELECT NOW()";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	// 게시글 번호 구하는 함수
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1; //다음 게시물
			}
			return 1; // 첫 번째 게시물
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터 베이스 오류
	}
	
	// 게시글 작성 함수
	public int write(String bbsTitle, String userID, String bbsContent) {
			String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1); // 게시글 삭제된 여부 <0:삭제o , 1:삭제x>
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터 베이스 오류	
	}
	
	public ArrayList<Bbs> getList(int pageNumber){ // 페이지에 뿌려줄 게시물 함수
		
		// 페이지당 10개의 게시물을 보여주는 Query
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		
		ArrayList<Bbs> list = new ArrayList<Bbs>(); // 함수 return type 에 담을 list 함수
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1)*10);  // select query 에 반영되는 조건 기준 값
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
		
	}
	
	
	//DB에 게시물이 10개이고 페이지가 2페이지면 존재하는 게시물이 없어야하기 때문에 다음 페이지 여부를 위한 함수
	public boolean nextPage(int pageNumber) { 
		// 게시물 의 존재 여부 Query
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1)*10); 
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return true;				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
		
	}
	
	public Bbs getBbs(int bbsID) {
		
		
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID); 
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				
				return bbs;
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		
	}
	
	// 게시글 수정 함수
	public int update(int bbsID, String bbsTitle, String bbsContent ) {
		
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터 베이스 오류	
		
	}
	
	
	
	// 게시글 삭제 함수
	public int delete(int bbsID) {
		
		//bbsAvailable 값을 0 으로 바꿔 게시판에 출력되지 않게 한다. 실제 데이터 값은 남아있다.
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return -1;
	}
	
}
