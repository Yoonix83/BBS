<%@page import="user.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="bbs.BbsDAO" %>
    <%@ page import="java.io.PrintWriter" %>
    <% request.setCharacterEncoding("UTF-8"); %>
    <jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/> <!-- java bean 사용등록, 범위: 현재 페이지 -->
    <jsp:setProperty name="bbs" property="bbsTitle" /> <!-- write.jsp 에서 넘어온 파라미터를 bbs(Bbs)객체에 넣는다. -->
    <jsp:setProperty name="bbs" property="bbsContent" /> <!-- write.jsp 에서 넘어온 파라미터를 bbs(Bbs)객체에 넣는다. -->
 
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
	if(session.getAttribute("userID") != null){ // 로그인이 안됐을 떄
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null) {
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요!')");
		script.println("location.href = 'login.jsp'"); 
		script.println("</script>");
		
	}else{ //로그인 됐을 떄
		
		// 사용자의 입력 오류 확인
		if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
			
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력 안 된 사항이 있습니다.')");
			script.println("history.back()"); 
			script.println("</script>");
			
		}else{
		
		// 사용자 게시글 입력 실패 & 성공
		BbsDAO bbsDAO = new BbsDAO();
		int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent()); // Bbs 컨테이너에 등록된 값들을 DB에 실제 등록하는 작업
		
		if(result == -1){  // 실패
				
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글쓰기에 실패했습니다.')");
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
		
	}



%>

</body>
</html>