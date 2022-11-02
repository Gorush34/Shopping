<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	String ctxPath = request.getContextPath();
%>    
<!-- 모듈화 연습 -->
<script type="text/javascript" src="<%= ctxPath%>/resources/js/register.js"></script> 
<script type="text/javascript" src="<%= ctxPath%>/resources/js/common.js"></script> 
<script type="text/javascript" src="<%= ctxPath%>/resources/js/check.js"></script> 
<script type="text/javascript" src="<%= ctxPath%>/resources/js/search.js"></script> 
<script type="text/javascript" src="<%= ctxPath%>/resources/js/cud.js"></script> 
<script type="text/javascript" src="<%= ctxPath%>/resources/js/sum.js"></script> 

<script type="text/javascript">
	/* ##1-1. 고객판매관리 초기조건 설정(14까지있음) */
	var prt_nm = "";													// 매장명을 받을 변수 선언
	var se_prt_cd = "";													// 세션에 저장된 매장코드를 받을 변수 선언
	var se_prt_nm = "";													// 세션에 저장된 매장명을 받을 변수 선언
	var se_user_dt_cd = "";												// 세션에 저장된 거래처구분코드를 받아올 변수 선언
	let flag_req = false;												// 필수항목 검사통과유무를 받아올 변수 선언
	let from_csm = false;												// 매장을 검색하는지 알아오는 변수
	let is_exist = false;												// 일자별 총 합계를 구하기 위해 결과가 있는지 알아오는 변수
	
	var info = [];														// 판매상세조회 클릭시 전달할 데이터를 담을 배열 선언		
	
	$(document).ready(function() {										// 페이지가 로딩될 때 시작하는 부분
		prt_nm = $("input#PRT_CD_NM").val();							// 매장검색란의 value값을 받아온다
		se_prt_cd = $("input#SE_PRT_CD").val();							// 로그인유저의 매장코드를 받아온다
		se_prt_nm = $("input#SE_PRT_NM").val();							// 로그인유저의 매장명을 받아온다
		se_user_dt_cd = $("input#SE_USER_DT_CD").val();					// 로그인유저의 거래처구분코드를 받아온다
		
		refresh();														// 초기조건 세팅 함수 실행
		
		if(se_user_dt_cd != 2 ) {										// 세션에 저장된 사용자구분코드가 2(특약점)가 아니라면
			$("div#adminContainer").hide();								// 판매등록이 포함된 div를 숨긴다
		}

	}); // end of $(document).ready(function() {})--------------------------
	
	// 함수 정의
	
	// ##1-2. 새로고침 아이콘 클릭시 실행되는 함수
	function refresh() {
		defaultSearch();												// 기본 조건을 불러오는 함수 실행
		$("tbody#PERFORM_DISPLAY").hide(); 								// tbody의 id가 CUST_DISPLAY인 부분을 숨겨준다
		$("tfoot#TFOOT_SUM").hide();									// tfoot의 id가 TFOOT_SUM인 부분을 숨겨준다 
		
		if( se_user_dt_cd == 1 ) {										// 로그인유저가 본사라면
			$("input#PRT_CD_NM").focus();								// 커서의 위치를 매장검색란으로 위치시킨다
		}
		else {															// 매장사용자라면
			$("input#IN_CUST_NO").focus();								// 커서의 위치를 고객검색란으로 위치시킨다
		}
	}
	
	// ##1-3. 기본 조건을 불러오는 함수
	function defaultSearch() {
		
		$("#search").find("input").val("");								// 상단 검색조건에 있는 모든 input, select, radio의 값을 비운다
		
		$('#SDATE').datepicker('setDate', '-7D');						// 시작일자를 현재보다 1주 전으로 초기화한다
		$('#EDATE').datepicker('setDate', 'today');						// 종료일자를 오늘로 초기화한다
		
		if( se_user_dt_cd == 2 ) {										// 거래처구분코드가 2(매장)라면
			$("input#JN_PRT_CD").val(se_prt_cd);						// 매장코드의 value값을 로그인유저의 매장코드로 적용한다
			$("input#PRT_CD_NM").val(se_prt_nm);						// 매장검색란의 value값을 로그인유저의 매장명으로 적용한다
			$(".not").attr("readonly", true);							// 매장입력란을 읽기전용으로 설정
			$(".btn_not").attr("disabled", true);						// 버튼 disabled;
		} 
		else if( se_user_dt_cd == 1 ) {									// 거래처구분코드가 1(본사)라면
			$("input#JN_PRT_CD").val("");								// 매장코드의 value값을 비운다
			$("input#PRT_CD_NM").val("");								// 매장검색란의 value값을 비운다
		}	
		
	} // end of function defaultSearch() {}-------------------

 	// 상세버튼 클릭시 팝업창 실행
	function sal_detail(index){

		$("#VIEW_MAP").val(info[index]);								// 해당 행의 정보를 input태그에 담는다
		search_popup('viewSalDetail', 'viewSalDetail', '1050', '600');	// 판매상세페이지 팝업을 실행한다
		
	} // end of function sal_detail(index)-------------------- 
	
	// ##2-1. 판매등록 버튼 클릭시 팝업창 실행
	function register_sal(){
		search_popup('registerSal', 'registerSal', '1130', '900');		// 판매등록페이지 팝업을 실행한다
	} // end of function register_sal()--------------------
</script>

<div>
	
	<div id="contentContainer">
		
		<!-- 고객판매관리 문구 시작 -->
		<div style="margin: auto 0; padding: 0px 10px 5px 10px;">
			<i class="far fa-star fa-2x"></i>
			<span style="font-size: 30px; padding-left: 10px;">고객판매관리</span>&nbsp;&nbsp;
			<button type="button" style="margin-bottom: 5px; width: 40px; height: 40px; padding: 0 0 0 7px;" id="refresh" class="btn btn-secondary" onclick="refresh()">
				<span style="padding-right: 10px;"><i class="fa fa-redo-alt" aria-hidden="true" style="font-size:25px;"></i></span>
			</button>
		</div>
		<!-- 고객판매관리 문구 끝 -->
		
		<div id ="search">
		<!-- 검색조건 시작 -->
		<form name="searchFrm" id="searchFrm">
			<div id="searchContainer">
				<div id="rowContainer">
					<div id="inline">
						<span id="title_text"><strong style="color:red;">*&nbsp;</strong>판매일자</span>
						<span id="input_text"><input type="text" class="date req" id="SDATE" name="SDATE" value="시작일자" /></span>&nbsp;&nbsp;
						<span id="input_text"><input type="text" class="date req" id="EDATE" name="EDATE" value="종료일자" /></span>
					</div>
					<div id="inline" class="mg_left">
						<span id="title_text"><strong style="color:red;">*&nbsp;</strong>매&nbsp;&nbsp;&nbsp;&nbsp;장</span>
						<span id="input_text">
							<input type="text" class="dark med not req" name="JN_PRT_CD" id="JN_PRT_CD" value="" readonly />&nbsp;
						</span>
						<button type="button" id="btn_search_prt" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
							<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
						</button>
						<span id="input_text">
						&nbsp;<input type="text"  id="PRT_CD_NM" name="PRT_CD_NM" class="lg enter_prt blank_key not" value="" placeholder="매장코드 / 매장명" spellcheck="false" autofocus />
						</span>
					</div>
					<button type="button" id="btnCustSalMag"  style="margin: 5px 20px 5px 0; width: 50px; height: 50px; padding: 0 20px 0 7px; float:right;" class="btn btn-secondary">
						<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
					</button>
				</div>
				
				<div id="rowContainer">
					<span id="title_text">&nbsp;&nbsp;고객번호</span>
					<span id="input_text">
						<input type="text" class="dark medium" name="CUST_NO" id="CUST_NO" value=""readonly />&nbsp;
					</span>
					<button type="button" id="btn_search_cust" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
						<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
					</button>
					<span id="input_text">
						&nbsp;<input type="text" id="IN_CUST_NO" name="IN_CUST_NO" class="large enter_cust blank_key" value="" placeholder="고객번호 / 고객명" spellcheck="false" autofocus />
					</span>
				</div>
			</div>
			<input type="hidden" name="SE_PRT_CD" id="SE_PRT_CD" value="${sessionScope.loginuser.PRT_CD}" />
			<input type="hidden" name="SE_USER_DT_CD" id="SE_USER_DT_CD" value="${sessionScope.loginuser.USER_DT_CD}" /><%-- 
			<input type="text" name="SE_PRT_NM" id="SE_PRT_NM" value="${sessionScope.loginuser.PRT_NM}" /> --%>
		</form>
		<!-- 검색조건 끝 -->
		</div>
				
		<!--  판매등록 버튼 부분 시작 -->
		<div id="adminContainer">
			<button type="button" class="btn-secondary" id="register" onclick='register_sal()'>판매등록</button>
		</div>
		<!--  판매등록 버튼 부분 끝 -->

		
		<!-- 데이터를 보여주는 부분 시작 -->
		<div class="view">
		  <div class="wrapper">
		    <table id="tbl_cust_sal_mag" class="scrolltable2">
		      <thead >
		        <tr>
			          <th rowspan="2" class="border center tbl_sm">판매일자</th>
			          <th rowspan="2" class="border center tbl_sm">고객번호</th>
			          <th rowspan="2" class="border center tbl_md">고객명</th>
			          <th rowspan="2" class="border center tbl_sm">판매번호</th>
			          <th colspan="2" class="border center" style="width:280px;">판매</th>
			          <th colspan="3" class="border center" style="width:420px;">수금</th>
			          <th rowspan="2" class="border center tbl_sm">등록자</th>
			          <th rowspan="2" class="border center tbl_sm">등록시간</th>
		        </tr>
		        <tr>
			          <th class="border center tbl_md">수량</th>
			          <th class="border center tbl_md">금액</th>
			          <th class="border center tbl_md">현금</th>
			          <th class="border center tbl_md">카드</th>
			          <th class="border center tbl_md">포인트</th>
		        </tr>
		      </thead>
		      <tbody id="PERFORM_DISPLAY"></tbody>
		      <tfoot id="TFOOT_SUM">
    		       	<tr>
		       		  <td colspan="4" class="border center" id="" style="width:515px;">합계</td>
		       		  <td class="border right tbl_md" id="TOTAL_QTY">합계</td>
		       		  <td class="border right tbl_md" id="TOTAL_AMT">합계</td>
		       		  <td class="border right tbl_md" id="TOTAL_CSH_AMT">합계</td>
		       		  <td class="border right tbl_md" id="TOTAL_CRD_AMT">합계</td>
		       		  <td class="border right tbl_md" id="TOTAL_PNT_AMT">합계</td>
		       		  <td colspan="2" class="border" id="" style="text-align: center; width:250px;"></td>
		       		</tr>
		      </tfoot>
		    </table>
		  </div>
		</div>
		<!-- 데이터를 보여주는 부분 끝 -->
		
		<!-- 상세정보 클릭시 판매상세를 조회하는 data를 담아주는 form 시작 -->
		<form name="viewSalFrm">
			<!-- <input type="hidden" id="VIEW_PRT_CD" name="VIEW_PRT_CD" value=""/>
			<input type="hidden" id="VIEW_SAL_DT" name="VIEW_SAL_DT" value=""/>
			<input type="hidden" id="VIEW_SAL_NO" name="VIEW_SAL_NO" value=""/> -->
			<input type="hidden" id="VIEW_SAL_TP_CD" name="VIEW_SAL_TP_CD" value=""/>
			<input type="hidden" id="VIEW_MAP" style="width:500px;" name="VIEW_MAP" value=""/>
			<input type="hidden" id="SE_USER_ID" name="SE_USER_ID" value="${sessionScope.loginuser.USER_ID}"/>
			<input type="hidden" name="USER_DT_CD" id="USER_DT_CD" value="${sessionScope.loginuser.USER_DT_CD}" />
			<input type="hidden" name="SE_PRT_NM" id="SE_PRT_NM" value="${sessionScope.loginuser.PRT_NM}" />
		</form>
		<!-- 상세정보 클릭시 판매상세를 조회하는 data를 담아주는 form 끝 -->
		
		</div>
	</div>

</div>