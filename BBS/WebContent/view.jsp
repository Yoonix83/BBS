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
		<%
			if(userID == null){
		%>
		<ul class="nav navbar-nav navbar-right"><!-- 상단 우측 관련 -->
			<li class="dropdown"><!-- dropdown 관련  -->
				<a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
			</li>
		</ul>
				
		<%
			} else {
		%>
		<ul class="nav navbar-nav navbar-right"><!-- 상단 우측 관련 -->
			<li class="dropdown"><!-- dropdown 관련  -->
				<a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>		
					</ul>
			</li>
		</ul>
		<% 
		}
		%>	
		
	</div>
</nav>
	<!-- 게시판 테이블 디자인 -->
	<div class="container">
		<div class="row">
	
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead> <!-- 게시판 첫 머리 -->
					<tr><!-- 행 -->
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>		
					</tr>
				</thead>
				<tbody> <!-- 게시판 내용 -->
					<tr>
						<td style="width: 20%;"> 글 제목 </td> 
						<td colspan="2"><%= bbs.getBbsTitle()%></td>
					</tr>
					<tr>
						<td >작성자 </td>
						<td colspan="2"><%= bbs.getUserID() %></td>
					</tr>
					<tr>
						<td >작성 일자 </td>
						<td colspan="2"><%=bbs.getBbsDate().substring(0,11) + bbs.getBbsDate().substring(11,13)+"시"+bbs.getBbsDate().substring(14,16)+"분" %>
					</td>
					</tr>
					<tr>
						<td >내용 </td> <!-- 특수문자 처리 :replaceAll() -->
						<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n",  "<br>")%></td>
					</tr>
				</tbody>		
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<%
				if(userID != null && userID.equals(bbs.getUserID())){
			%>
				
					<a href = "update.jsp?bbsID=<%= bbsID%>" class="btn btn-primary">수정</a>
					<!-- 삭제여부 확인 onclick -->
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href = "deleteAction.jsp?bbsID=<%= bbsID%>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
			
		
		</div>
	</div>


	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>