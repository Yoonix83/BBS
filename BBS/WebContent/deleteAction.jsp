<%@page import="user.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="bbs.BbsDAO" %>
    <%@ page import="bbs.Bbs" %>
    <%@ page import="java.io.PrintWriter" %>
    <% request.setCharacterEncoding("UTF-8"); %>
    
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
	// 로그인 된 유저만 게시글 작성하게 하는 로직
	String userID = null;
	if(session.getAttribute("userID") != null){ //세션 userID 값을 String userID 담아둔다.
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null) { // 로그인이 안됐을 떄
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요!')");
		script.println("location.href = 'login.jsp'"); 
		script.println("</script>");
		
	}
	int bbsID = 0; // 게시글 번호 값
	if(request.getParameter("bbsID") != null){
		bbsID = Integer.parseInt(request.getParameter("bbsID"));		
	}
	if(bbsID == 0){ // bbsID가 0 값이면 접근 불가
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글 입니다.!')");
		script.println("location.href = 'bbs.jsp'"); 
		script.println("</script>");
		
	}
	Bbs bbs = new BbsDAO().getBbs(bbsID);
	
	// 접속된 세션 아이디와 게시판 유저 아이디 비교
	if(!userID.equals(bbs.getUserID())){  // 서로 다른 ID일 경우
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href = 'bbs.jsp'"); 
		script.println("</script>");
	
	} else { // ID가 동일한 경우
		
		// 게시글 삭제 수행 로직
		BbsDAO bbsDAO = new BbsDAO();
		int result = bbsDAO.delete(bbsID); 
		
		if(result == -1){  // 실패
				
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글 삭제에 실패했습니다.')");
			script.println("history.back()"); 
			script.println("</script>");
			
		}
		else { 		// 성공

			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
			
			}
	}



%>

</body>
</html>