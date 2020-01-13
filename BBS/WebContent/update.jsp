<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ page import="java.io.PrintWriter" %>
    <%@ page import="bbs.Bbs" %>
    <%@ page import="bbs.BbsDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- 부트 스트랩 페이지는 반응형 탬플릿이므로 추가 meta택이 필요하다 -->
<meta name="viewport" content="width=device-width", initail-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">

<title>JSP 게시판 웹 사이트</title>
</head>
<body>

<%	
	String userID = null; // 세션에 유지한 userID 값
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
	
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'login.jsp'"); 
		script.println("</script>");
	}
	
	int bbsID = 0; // 게시글 번호 값
	if(request.getParameter("bbsID") != null){
		bbsID = Integer.parseInt(request.getParameter("bbsID"));		
	}
	if(bbsID == 0){ // 
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글 입니다.!')");
		script.println("location.href = 'bbs.jsp'"); 
		script.println("</script>");
		
	}
	Bbs bbs = new BbsDAO().getBbs(bbsID);
	
	if(!userID.equals(bbs.getUserID())){ // 접속된 세션 아이디와 게시판 유저 아이디 비교
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href = 'bbs.jsp'"); 
		script.println("</script>");
	}
	%>

<nav class="navbar navbar-default">
	<div class="navbar-header">
		<button type="button" class="navbar-toggle collapsed"
		data-toggle="collapse" data-tartget="#bs-example-navbar-collapse-1"
		aria-expanded="false">
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>
		<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a><!-- brand 는 log 같은 역할 -->
	</div>
	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		<ul class="nav navbar-nav">
			<li><a href="main.jsp">메인</a></li><!-- active=현재 홈페이지를 의미 -->
			<li class="active"><a href="bbs.jsp">게시판</a></li>
		</ul>
	</div>
</nav>
	<!-- 게시판 테이블 디자인 -->
	<div class="container">
		<div class="row">
		<form method="post" action="updateAction.jsp?bbsID=<%=bbsID%>">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead> <!-- 게시판 첫 머리 -->
					<tr><!-- 행 -->
						<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>		
					</tr>
				</thead>
				<tbody> <!-- 게시판 내용 -->
					<tr>
						<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%=bbs.getBbsTitle() %>"></td>
					</tr>
					<tr>
						<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;">value="<%=bbs.getBbsContent() %>"</textarea></td>
					</tr>
				</tbody>		
			</table>
			<input type="submit" class="btn btn-primary pull-right" value="글 수정">
			</form>
		</div>
	</div>


	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>