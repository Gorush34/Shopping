<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
	String ctxPath = request.getContextPath();
%>    


<script type="text/javascript">

	$(document).ready(function(){

		
	}); // end of $(document).ready(function(){------------
	
	// Function Declaration
	function goView(seq) {
		
		  location.href="<%= ctxPath%>/view.dowell?seq="+seq; 
	}// end of function goView(seq){}----------------------------------------------
		
	// 팝업창 테스트
	function testPopup() {
		// 주소
		const url = "<%= ctxPath%>/testPopup.dowell";
		
		// 너비 800, 높이 600 인 팝업창을 화면 가운데 위치시키기
		const pop_width = 800;
		const pop_height = 600;
		const pop_left = Math.ceil( ((window.screen.width)-pop_width)/2 ) ; <%-- 정수로 만든다 --%>
		const pop_top = Math.ceil( ((window.screen.height)-pop_height)/2 ) ;
		
		window.open(url, "memberEdit",
				   	"left="+pop_left+", top="+pop_top+", width="+pop_width+", height="+pop_height+", location = no" );
		
		
	} // end of testPopup()---------------------
	
	// 자바스크립트 모듈화 연습
	function testModule() {
		alert(welcome());
	} // end of function testModule()------------
	
</script>

<!DOCTYPE html>
<html>
<head>
	<title>Home</title>
</head>
<body>
	<h1>Hello world!<span id="module">안녕~</span></h1>
	
	<div id="boardContainer">
		<table id="boardList">
			<thead>
				<tr>
					<th style="width: 70px;  text-align: center;">순번</th>
					<th style="width: 70px;  text-align: center;">이름</th>
			        <th style="width: 360px; text-align: center;">나이</th>
				</tr>
			</thead>
			<tbody id="allDisplay">
				<c:if test="${not empty requestScope.boardList}">
					<c:forEach var="board" items="${requestScope.boardList}" varStatus="i">
						<tr>
							<td style="width: 70px;  text-align: center;"><span class="subject" onclick="goView('${board.chg_seq}')">${board.chg_seq}</span></td>
							<td style="width: 70px;  text-align: center;"><span class="subject" onclick="goView('${board.chg_seq}')">${board.cust_no}</span></td>
							<td style="width: 360px; text-align: center;"><span class="subject" onclick="goView('${board.chg_seq}')">${board.chg_aft_cnt}</span></td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty requestScope.boardList}">
					<tr>
						<td colspan='2'>글이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>

	<form  action="<%= ctxPath%>/write.dowell" method="post"> 	
		<div id="button" style="margin-top:10px;">
			<input id="write" class="btn btn-primary" style="border:none;" type="submit" value="글쓰기" />
		</div>
	</form>
		<input type="text" id="parent"/>
		<button type="button" class="btn btn-dark" onclick="testPopup()">팝업창 시험</button>
		<button type="button" class="btn btn-warning" onclick="testModule()">모듈 시험</button>
		
</body>
</html>