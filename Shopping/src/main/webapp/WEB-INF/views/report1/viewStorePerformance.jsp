<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	String ctxPath = request.getContextPath();
%>    

<script type="text/javascript">

	$(document).ready(function() {
		
		defaultSearch();
		
		
	}); // end of $(document).ready(function() {})--------------------------
	
	// 함수 정의
	
	// 새로고침 아이콘 클릭시 실행되는 함수
	function refresh() {
		defaultSearch();
	}
	
	// 기본 조건을 불러오는 함수
	function defaultSearch() {
		
	}
	
	// 버튼을 누르거나 검색어 입력시 값을 출력하거나 팝업창을 띄워주는 함수
	function search_popup(location) {

		// 버튼마다의 주소값을 받는다.
		var loc = location; 

		// 팝업창을 띄울 주소를 설정한다.
		const url = "<%= ctxPath%>/"+loc+".dowell"; 
		
		// 너비 800, 높이 600 인 팝업창을 화면 가운데 위치시키기
		const pop_width = 800;
		const pop_height = 600;
		const pop_left = Math.ceil( ((window.screen.width)-pop_width)/2 ) ; <%-- 정수로 만든다 --%>
		const pop_top = Math.ceil( ((window.screen.height)-pop_height)/2 ) ;
		
		window.open( url, 
					 "memberEdit"
					 , "left="+pop_left+
					 ", top="+pop_top+
					 ", width="+pop_width+
					 ", height="+pop_height+
					 ", location = no" );
		
	} // end of function search_popup(location) {})---------------------------------------
	
</script>

<div>
	
	<div id="contentContainer">
	
		<div style="margin: auto 0; padding: 0px 10px 5px 10px;">
			<i class="far fa-star fa-2x"></i>
			<span style="font-size: 30px; padding-left: 10px;">매장월별실적조회</span>&nbsp;&nbsp;
			<button type="button" style="margin-bottom: 5px; width: 40px; height: 40px; padding: 0 0 0 7px;" id="btnSearch" class="btn btn-secondary" onclick="">
				<span style="padding-right: 10px;"><i class="fa fa-redo-alt" aria-hidden="true" style="font-size:25px;"></i></span>
			</button>
		</div>
		
		<form>
			<table id="tbl_searchCustmor">
				<thead>
					<tr>
						<td class="pd_left" style="float:right; padding-bottom: 20px;">
							<strong style="color:red;">*&nbsp;</strong>
							매출월
							<select>
							
							</select>
						</td>
						<td>
							<span style="padding: 0 60px;" />
						</td>
						<td class="pd_td" style="float: left; padding-top: 20px; ">
							매장
							<input type="text" class="dark medium" />
							<button type="button" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" id="btnSearch_prt" class="btn btn-secondary" onclick="search_popup('search_prt')">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
							</button>
							<input type="text" class="large" autofocus />
						</td>
						<td style="float:right; padding-right: 20px;">
							<button type="button" style="margin: 5px 0; width: 50px; height: 50px; padding: 0 0 0 7px;" id="btnSearch" class="btn btn-secondary" onclick="">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
							</button>
						</td>
					</tr>
				</thead>
			</table>	
		</form>
		
		<div class="view">
		  <div class="wrapper">
		    <table id="tbl_css_header" class="table">
		      <thead>
		        <tr>
			          <th class="sticky-col first-col border">매장코드</th>
			          <th class="sticky-col second-col border">매장명</th>
			          <th class="border">Last Name</th>
			          <th class="border">Employer</th>
			          <th class="border">Last Name</th>
			          <th class="border">Employer</th>
			          <th class="border">Last Name</th>
			          <th class="border">Employer</th>
			          <th class="border">Last Name</th>
			          <th class="border">Employer</th>
			          <th class="border">Last Name</th>
			          <th class="sticky-col last-col border">합계</th>
		        </tr>
		      </thead>
		      <tbody>
		        <c:forEach begin="1" end="5">
		        <tr>
			          <td class="sticky-col first-col">3</td>
			          <td class="sticky-col second-col">Larry</td>
			          <td class="border_td">Wen</td>
			          <td class="border_td">Goog Goog Goog GoogGoog Goog Goog Goog Goog Goog</td>
			          <td class="border_td">Wen</td>
			          <td class="border_td">Goog Goog Goog GoogGoog Goog Goog Goog Goog Goog</td>
			          <td class="border_td">Wen</td>
			          <td class="border_td">Goog Goog Goog GoogGoog Goog Goog Goog Goog Goog</td>
			          <td class="border_td">Wen</td>
			          <td class="border_td">Goog Goog Goog GoogGoog Goog Goog Goog Goog Goog</td>
			          <td class="border_td">Wen</td>
			          <td class="sticky-col last-col">Goog</td>
		        </tr>
		       	</c:forEach>
		       	<tr>
		       		  <td class="sticky-col first-col" colspan="2">합계</td>
			          <td class="border_td">Wen</td>
			          <td class="border_td">Goog Goog Goog GoogGoog Goog Goog Goog Goog Goog</td>
			          <td class="border_td">Wen</td>
			          <td class="border_td">Goog Goog Goog GoogGoog Goog Goog Goog Goog Goog</td>
			          <td class="border_td">Wen</td>
			          <td class="border_td">Goog Goog Goog GoogGoog Goog Goog Goog Goog Goog</td>
			          <td class="border_td">Wen</td>
			          <td class="border_td">Goog Goog Goog GoogGoog Goog Goog Goog Goog Goog</td>
			          <td class="border_td">Wen</td>
			          <td class="sticky-col last-col">Goog</td>
		       	</tr>
		      </tbody>
		    </table>
		  </div>
		</div>
		
		<!--  
		
		<div id="sticky_both">
			<table id="tbl_css"  class="both_scroll fixed">
				<thead id="tbl_css_header" style="width: 100%;">
					<tr>
						<th class="center pd_td" style="min-width: 150px;">고객번호</th>
						<th class="center" style="min-width: 150px;">고객이름</th>
						<th class="center">휴대폰번호</th>
						<th class="center">고객상태</th>
						<th class="center">가입일자</th>
						<th class="center">가입매장</th>
						<th class="center">등록자</th>
						<th class="center">수정일자</th>
						
						<th class="center">고객상태</th>
						<th class="center">가입일자</th>
						<th class="center">가입매장</th>
						<th class="center">등록자</th>
						<th class="center">수정일자</th>
						<th class="center">고객상태</th>
						<th class="center">가입일자</th>
						<th class="center">가입매장</th>
						<th class="center">등록자</th>
						<th class="center">수정일자</th>
						
						<th class="center">1</th>
						<th class="center">2</th>
						<th class="center">3</th>
						<th class="center">4</th>
						<th class="center">5</th>
						<th class="center">6</th>
						<th class="center">7</th>
						<th class="center">8</th>
						<th class="center">9</th>
						<th class="center">10</th>
					</tr>
				</thead>
			
				<tbody>
					<c:forEach begin="1" end="30">
					<tr style="width: 90%;">
						<th class="left" style="min-width: 150px; max-width: 150px;">1</td>
						<th class="left" style="min-width: 150px; max-width: 150px;">2</td>
						<td class="center">3</td>
						<td class="center">4</td>
						<td class="center">5</td>
						<td class="left">6</td>
						<td class="left">7</td>
						<td class="center">8</td>
						
						<td class="center">고객상태</td>
						<td class="center">가입일자</td>
						<td class="center">가입매장</td>
						<td class="center">등록자</td>
						<td class="center">수정일자</td>
						<td class="center">고객상태</td>
						<td class="center">가입일자</td>
						<td class="center">가입매장</td>
						<td class="center">등록자</td>
						<td class="center">수정일자</td>
						
						<td class="center">1</td>
						<td class="center">2</td>
						<td class="center">3</td>
						<td class="center">4</td>
						<td class="center">5</td>
						<td class="center">6</td>
						<td class="center">7</td>
						<td class="center">8</td>
						<td class="center">9</td>
						<td class="center">10</td>
					</tr>
					</c:forEach>
					<tr>
						<th colspan="2" class="center"> 합계</td>
						<td class="center">3</td>
						<td class="center">4</td>	
						<td class="center">5</td>
						<td class="left">6</td>
						<td class="left">7</td>
						<td class="center">8</td>
						
						<td class="center">고객상태</td>
						<td class="center">가입일자</td>
						<td class="center">가입매장</td>
						<td class="center">등록자</td>
						<td class="center">수정일자</td>
						<td class="center">고객상태</td>
						<td class="center">가입일자</td>
						<td class="center">가입매장</td>
						<td class="center">등록자</td>
						<td class="center">수정일자</td>
						
						<td class="center">1</td>
						<td class="center">2</td>
						<td class="center">3</td>
						<td class="center">4</td>
						<td class="center">5</td>
						<td class="center">6</td>
						<td class="center">7</td>
						<td class="center">8</td>
						<td class="center">9</td>
						<td class="center">10</td>
					</tr>
				</tbody>
			
			</table>
			
			-->
		</div>
	</div>

</div>