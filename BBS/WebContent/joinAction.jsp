<%@page import="user.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="user.UserDAO" %>
    <%@ page import="java.io.PrintWriter" %>
    <% request.setCharacterEncoding("UTF-8"); %>
    <jsp:useBean id="user" class="user.User" scope="page"/> <!-- java bean 사용등록, 범위: 현재 페이지 -->
    <jsp:setProperty name="user" property="userID" />
    <jsp:setProperty name="user" property="userPassword" />
     <jsp:setProperty name="user" property="userName" />
      <jsp:setProperty name="user" property="userGender" />
       <jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
	// join.jsp 에서 넘어올 때 null 값이 있었는지 확인
	if(user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null
	|| user.getUserGender() == null || user.getUserEmail() == null) {
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력 안 된 사항이 있습니다.')");
		script.println("history.back()"); 
		script.println("</script>");
		
	}else{

	UserDAO userDAO = new UserDAO();
	int result = userDAO.join(user);
	
	// DAO login 함수의 return 값 비교
	if(result == -1){  // 조인 실패
			
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 존재하는 아이디입니다.')");
		script.println("history.back()"); //이전 페이지로 되돌리기
		script.println("</script>");
		
	}
	else { // 조인 성공
		session.setAttribute("userID", user.getUserPassword()); // 유저에서 세션 값 부여.
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
		
		}
	}

%>

</body>
</html>