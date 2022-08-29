<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	String ctxPath = request.getContextPath();
%>    

<script type="text/javascript">
	
	var prt_nm = "";
	var se_prt_cd = "";
	var se_prt_nm = "";
	var se_user_dt_cd = "";

	$(document).ready(function() {
		
		prt_nm = $("input#PRT_CD_NM").val();					// 매장검색란의 value값을 받아온다
		se_prt_cd = $("input#SE_PRT_CD").val();					// 로그인유저의 매장코드를 받아온다
		se_prt_nm = $("input#SE_PRT_NM").val();					// 로그인유저의 매장명을 받아온다
		se_user_dt_cd = $("input#SE_USER_DT_CD").val();			// 로그인유저의 거래처구분코드를 받아온다
		
		defaultSearch();
		
		
	}); // end of $(document).ready(function() {})--------------------------
	
	// 함수 정의
	
	// 새로고침 아이콘 클릭시 실행되는 함수
	function refresh() {
		defaultSearch();
	}
	
	// 기본 조건을 불러오는 함수
	function defaultSearch() {
		$("input#JN_PRT_CD").val("");							// disabled 처리된 고객번호 input 태그의 값을 비운다
		$("input#PRT_CD_NM").val("");							// 고객번호 input 태그의 값을 비운다
		
		if( prt_nm === "" && se_user_dt_cd == 2 ) {				// 매장검색란에 아무 값이 없고 거래처구분코드가 2(매장)라면
			$("input#JN_PRT_CD").val(se_prt_cd);				// 매장코드의 value값을 로그인유저의 매장코드로 적용한다
			$("input#PRT_CD_NM").val(se_prt_nm);				// 매장검색란의 value값을 로그인유저의 매장명으로 적용한다
		} 
		
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
	
	function searchStorePerformance() {
		
	}
	
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
							<input type="text" class="dark medium" name="JN_PRT_CD" id="JN_PRT_CD" disabled />&nbsp;
							<button type="button" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" id="btnSearch_prt" class="btn btn-secondary" onclick="search_popup('search_prt')">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
							</button>
							<input type="text"  id="PRT_CD_NM" name="PRT_CD_NM" class="large enter_prt" value="" autofocus />
						</td>
						<td style="float:right; padding-right: 20px;">
							<button type="button" style="margin: 5px 0; width: 50px; height: 50px; padding: 0 0 0 7px;" id="btnSearch" class="btn btn-secondary" onclick="">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
							</button>
						</td>
					</tr>
				</thead>
			</table>	
			
			<input type="hidden" name="SE_PRT_CD" id="SE_PRT_CD" value="${sessionScope.loginuser.PRT_CD}" />
			<input type="hidden" name="SE_USER_DT_CD" id="SE_USER_DT_CD" value="${sessionScope.loginuser.USER_DT_CD}" />
			<input type="hidden" name="SE_PRT_NM" id="SE_PRT_NM" value="${sessionScope.loginuser.PRT_NM}" />
			<input type="hidden" name="HIS_CUST_NO" id="HIS_CUST_NO" value="" />
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
		
		</div>
	</div>

</div>