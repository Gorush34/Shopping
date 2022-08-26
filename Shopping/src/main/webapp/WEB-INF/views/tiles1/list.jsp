<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<%
	String ctxPath = request.getContextPath();
%>    

<style type="text/css">

	ul, li {
		list-style-type: none;
		display: inline-block;
	}
</style>



<script type="text/javascript">

	$(document).ready(function(){

		$(function(){
	        $('#searchBtn').click(function() {
	          self.location = "list.dowell" + '${pageMaker.makeQuery(1)}' + "&searchType=" + $("select option:selected").val() + "&keyword=" + encodeURIComponent($('#keywordInput').val());
	        });
     	});   
		
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
				   	"left="+pop_left+", top="+pop_top+", width="+pop_width+", height="+pop_height );
		
		
	} // end of testPopup()---------------------
	
	
	
</script>

<div class="listContainer">
  
	<form role="form" method="get">
	
		<div>
			  <table border='1'>
				  <thead>
				    <th style="width: 70px;  text-align: center;">순번</th>
					<th style="width: 70px;  text-align: center;">이름</th>
			        <th style="width: 360px; text-align: center;">나이</th>
				  </thead>
				  <tbody>
				    <c:forEach items="${list}" var="list">
				    
					    <tr>
					      	<td style="width: 70px;  text-align: center;">${list.chg_seq}</td>
							<td style="width: 70px;  text-align: center;"><a href="detail.dowell?chg_seq=${list.chg_seq}&page=${scri.page}&perPageNum=${scri.perPageNum}&searchType=${scri.searchType}&keyword=${scri.keyword}"><fmt:formatNumber value="${list.cust_no}" pattern="#,###"/></a></td>
							<td style="width: 360px; text-align: center;">${list.chg_aft_cnt}</td>
					    </tr>
				    </c:forEach>
				  </tbody>
			  </table>
		</div>
		
		<div>
			<ul>
			    <c:if test="${pageMaker.prev}">
			      <li id="page"><a href="list.dowell${pageMaker.makeSearch(pageMaker.startPage - 1)}">이전</a></li>
			    </c:if> 
			
			    <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
			      <li id="page"><a href="list.dowell${pageMaker.makeSearch(idx)}">${idx}</a></li>
			    </c:forEach>
			
			    <c:if test="${pageMaker.next && pageMaker.endPage > 0}">
			      <li id="page"><a href="list.dowell${pageMaker.makeSearch(pageMaker.endPage + 1)}">다음</a></li>
			    </c:if> 
			</ul>
		
		</div>
		
		<br>
		<br>
		
		<div class="search">
		    <select name="searchType">
		      <option value="n"<c:out value="${scri.searchType == null ? 'selected' : ''}"/>>-----</option>
		      <option value="t"<c:out value="${scri.searchType eq 't' ? 'selected' : ''}"/>>순번</option>
		      <option value="c"<c:out value="${scri.searchType eq 'c' ? 'selected' : ''}"/>>이름</option>
		      <option value="w"<c:out value="${scri.searchType eq 'w' ? 'selected' : ''}"/>>나이</option>
		      <option value="tc"<c:out value="${scri.searchType eq 'tc' ? 'selected' : ''}"/>>순번+이름</option>
		    </select>
		
		    <input type="text" name="keyword" id="keywordInput" value="${scri.keyword}"/>
		
		    <button id="searchBtn" type="button">검색</button>
		    
		</div>
		  
		<div>
		  <a href='form'>새 글</a>
		</div>
	  
	  
	</form>
</div>