<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix ="fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>

<%
	String ctxPath = request.getContextPath();
%>

<!-- 직접 만든 CSS 1 -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/viewCust.css" />

<style type="text/css">
	[disabled="true"] { border: 1px solid #f00; }
	.hide { display:none; }
</style>

<!-- 모듈화 연습 -->
<script type="text/javascript" src="<%= ctxPath%>/resources/js/register.js"></script> 
<script type="text/javascript" src="<%= ctxPath%>/resources/js/common_search.js"></script> 

<script type="text/javascript">
	
	let flag_req = false;				// 필수입력항목이 충족되었는지 구별할 flag 변수 선언
	let flag_mblDuplicated = false;		// 등록 버튼 클릭시 핸드폰중복확인 검사유무를 구별할 flag 변수 선언
	let flag_emailDuplicated = false;	// 등록 버튼 클릭시 이메일중복확인 검사유무를 구별할 flag 변수 선언
	var blank ="";
	
	let flag_existOrg = false;			// 기존정보가 존재하는지 구별할 flag 선언
	let flag_changed = false;			// 고객정보조회시 변동사항 유무 구별 flag 선언
	var changeArr = [];					// 변동된 사항을 담아주는 배열 선언
	
	$(document).ready(function(){
		$("input#MRRG_DT").val(""); 									// 결혼기념일 기본값 공란 지정
		
		var custNum = $("#CUST_NO").val();
		if(custNum != "") {													// 고객번호가 비어있지 않으면
			selectItem(custNum, "/shopping/readCustInfo.dowell");			// 고객정보를 통해 고객정보를 가져오는 함수 실행
			flag_existOrg = true;											// 기존정보 존재여부 flag true 변환
		}
		
 		$("input[name='CUST_SS_CD']").change(function(){					// 고객상태를 변경할 때 실행되는 부분
			// checkCustStatus();												// 고객상태에 따른 설정함수 실행
			changeCustStatus();
 		}); 
		
		if( $("#CUST_NO").val() != "" ) {								// 고객조회-상세버튼을 통해 왔다면
			flag_mblDuplicated = true;									// 중복검사 true
			$("#checkMblDuplicated").css("background-color","green");	// 버튼 색변경
			flag_emailDuplicated = true;								// 중복검사 true
			$("#checkEmailDuplicated").css("background-color","green");	// 버튼 색변경
		}
		
		if( $("#SE_USER_DT_CD").val() != 2 ) {								// 세션에 저장된 사용자구분코드가 2(특약점)가 아니라면
			$(".btn_check, #btn_update").hide();							// 중복체크 및 저장버튼 숨김
			$(".req").prop('readonly', true);								// 필수입력항목 읽기전용으로 설정
			$('input:radio, #POC_CD').prop('disabled', true);				// 라디오버튼, 직업코드 비활성화
			$("#ZIP_CD, #ADDR, #ADDR_DTL").prop('readonly',true); 			// 주소 읽기전용으로 설정
			$("#BRDY_DT ,#MRRG_DT").datepicker('option', 'disabled', true); // 일자 비활성화
			
			$("#BaseInfo").find("input, select, button").prop("disabled", true);	// BaseInfo에 있는 모든 input, select, radio를 비활성화한다
		}

	}); // end of $(document).ready(function(){}------------------
			
</script>

<div>
	
	<div id="contentContainer">
	
	<!-- 고객조회 제목 / 새로고침 아이튼 버튼 시작 -->
	<div style="margin: auto 0; padding: 0px 10px 5px 10px;">
		<i class="far fa-star fa-2x"></i>
		<span style="font-size: 30px; padding-left: 10px;">고객정보조회</span>&nbsp;&nbsp;
		<button type="button" style="margin-bottom: 5px; width: 40px; height: 40px; padding: 0 0 0 7px;" id="btnSearch" class="btn btn-secondary" onclick="location.replace(location.href);">
			<span style="padding-right: 10px;"><i class="fa fa-redo-alt" aria-hidden="true" style="font-size:25px;"></i></span>
		</button>
	</div>
	<!-- 고객조회 제목 / 새로고침 아이튼 버튼 끝 -->
	<c:set var="DT" value="${requestScope.custInfo.get(0)}" />
		<form name="custTotalInfoFrm" id="custTotalInfoFrm" >
			<table id="tbl_searchCustmor">
				<thead>
					<tr>
						<td class="pd_td pd_left" style="float:right; padding-top: 35px; width: 75px;">고객번호</td>
						<td>
							<input type="text" class="dark medium" name="CUST_NO" id="CUST_NO" value="${DT.CUST_NO}"readonly />&nbsp;
							<button type="button" id="btn_search_cust" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
							</button>
							&nbsp;<input type="text"  id="IN_CUST_NO" name="IN_CUST_NO" class="large enter_cust blank_key" value="${DT.CUST_NM}" placeholder="고객번호 / 고객명" spellcheck="false" autofocus />
						</td>
						<td style="float:right; padding-right: 20px;">
							<button type="button" style="margin: 5px 0; width: 50px; height: 50px; padding: 0 0 0 7px;" id="readCustInfo" class="btn btn-secondary">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
							</button>
						</td>
					</tr>
				</thead>
			</table>	
		</form>
		
		<!-- 고객정보를 등록하기 위한 form 시작 -->
		<form name="custInfoFrm" id="custInfoFrm">
			<!-- 고객기본정보를 입력하기 위한 div 시작 -->
			<div class="title" id = "BaseInfo" style="padding-right: 0;">
				<span style="font-size: 18px;">고객기본정보(<strong style="color:red;">*&nbsp;</strong>가 표시된 항목은 필수 입력사항입니다)</span>&nbsp;&nbsp;
				<!-- 기본정보를 담는 테이블 시작 -->
				<table id="tbl_baseInfo">
					<tbody>
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>고객명</td>
							<td class="item_value"><input type="text" class="req med not" name="CUST_NM" id="CUST_NM" value="${DT.CUST_NM}" placeholder="" spellcheck="false" autofocus readonly maxlength='50'/></td>
							
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>생년월일</td>
							<td class="item_value"><input type="text" class="datepicker req med not" name="BRDY_DT" id="BRDY_DT" value="${DT.BRDY_DT}" onkeyup="this.value = date_masking(this.value)" maxlength="10" style="text-align:center; width:120px;" /></td>
							
							<td class="f_right item_name">성별</td>
							<td>
								
								<c:forEach var="SEX_CD" items="${requestScope.SEX_CD}">
									<input type="radio" id="SEX_CD" name="SEX_CD" value="${SEX_CD.DTL_CD}" <c:if test="${SEX_CD.DTL_CD eq DT.SEX_CD}">checked</c:if> />&nbsp;${SEX_CD.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							
						</tr>
						
						<tr>
							<td class="f_right item_name">생일</td>
							<td class="item_value">
								<c:forEach var="SCAL_YN" items="${requestScope.SCAL_YN}">
									<input type="radio" id="SCAL_YN" name="SCAL_YN" value="${SCAL_YN.DTL_CD}" <c:if test="${SCAL_YN.DTL_CD eq DT.SCAL_YN}">checked</c:if> />&nbsp;${SCAL_YN.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							
							<td class="f_right item_name">결혼기념일</td>
							<td class="item_value"><input type="text" class="datepicker med not" name="MRRG_DT" id="MRRG_DT" value="${DT.MRRG_DT}" onkeyup="this.value = date_masking(this.value)" maxlength="10" style="text-align:center; width:120px;"/></td>
							
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>직업코드</td>
							<td>
								<select class="req" name="POC_CD" id="POC_CD">
									<option value="">선택하세요</option>
									<c:forEach var="POC_CD" items="${requestScope.POC_CD}">
										<option value="${POC_CD.DTL_CD}" <c:if test="${POC_CD.DTL_CD eq DT.POC_CD}">selected</c:if>>${POC_CD.DTL_CD_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>휴대폰번호</td>
							<td class="item_value">
								<c:if test ="${fn:length(DT.MBL_NO) eq 10 }">
									<c:set var = "MBL1" value = "${fn:substring(DT.MBL_NO, 0, 3)}"/>
	    							<c:set var = "MBL2" value = "${fn:substring(DT.MBL_NO, 3, 6)}" />
	    							<c:set var = "MBL3" value = "${fn:substring(DT.MBL_NO, 6, 10)}" />
								</c:if>
								<c:if test ="${fn:length(DT.MBL_NO) eq 11 }">
									<c:set var = "MBL1" value = "${fn:substring(DT.MBL_NO, 0, 3)}"/>
	    							<c:set var = "MBL2" value = "${fn:substring(DT.MBL_NO, 3, 7)}" />
	    							<c:set var = "MBL3" value = "${fn:substring(DT.MBL_NO, 7, 11)}" />
								</c:if>
								<input type="text" class="req sm not" name="MBL1" id="MBL1" value="${MBL1}" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="3" />&nbsp;
								<input type="text" class="req sm not" name="MBL2" id="MBL2" value="${MBL2}" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4"/>&nbsp;
								<input type="text" class="req sm not" name="MBL3" id="MBL3" value="${MBL3}" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4"/>&nbsp;
								<button type='button' class='btn btn-secondary btn_td btn_check' id='checkMblDuplicated'  onclick="checkDuplicated('mbl')" style='margin-bottom:5px;'>중복확인</button>
							</td>
							
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>가입매장</td>
							<td class="item_value" style="width:600px;">
								<input type="text" class="dark med not" name="JN_PRT_CD" id="JN_PRT_CD" value="${DT.JN_PRT_CD}" readonly />&nbsp;
								<button type="button" id="btn_search_prt" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
									<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
								</button>
								&nbsp;<input type="text"  id="PRT_CD_NM" name="PRT_CD_NM" class="lg enter_prt blank_key not" value="${DT.PRT_CD_NM}" placeholder="매장코드 / 매장명" spellcheck="false" autofocus />
								<input type="hidden" id="PRT_NM" name="PRT_NM" value="${DT.PRT_CD_NM}" />
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>우편물수령</td>
							<td class="item_value">
								<c:forEach var="PSMT_GRC_CD" items="${requestScope.PSMT_GRC_CD}">
									<input type="radio" class="req" id="PSMT_GRC_CD" name="PSMT_GRC_CD" value="${PSMT_GRC_CD.DTL_CD}" <c:if test="${PSMT_GRC_CD.DTL_CD eq DT.PSMT_GRC_CD}">checked</c:if> />&nbsp;${PSMT_GRC_CD.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>이메일</td>
							<td class="item_value" style="width:600px;">
								<input type="text" class="req med not" name="EMAIL1" id="EMAIL1" value="${fn:split(DT.EMAIL, '@')[0]}" maxlength="50"/>&nbsp;@
								<input type="text" class="req med not" name="EMAIL2" id="EMAIL2" value="${fn:split(DT.EMAIL, '@')[1]}"  style="max-width: 165px !important;" maxlength='50'/>
								<button type='button' class='btn btn-secondary btn_td btn_check' id='checkEmailDuplicated'  onclick='checkDuplicated("email")' style='margin-bottom:5px;'>중복확인</button>
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name">주소</td>
							<td colspan="5" style="width:700px;">
								<input type="text" class="sm ADD not" name="ZIP_CD" id="ZIP_CD" value="" placeholder="" maxlength='10'/>
								<button type="button" id="btn_tmp" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" disabled>
									<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
								</button>
								&nbsp;<input type="text" class="ADD not" name="ADDR" id="ADDR" value="${DT.ADDR}" style="width: 500px !important;" placeholder="주소(직접입력)" maxlength="100"/>
								<input type="text" class="ADD not" name="ADDR_DTL" id="ADDR_DTL" value="${DT.ADDR_DTL}" style="width: 300px !important;" placeholder="상세주소(직접입력)" maxlength="100"/>
							</td>
						</tr>
							
							
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>고객상태</td>
							<td class="item_value">
								<c:forEach var="CUST_SS_CD" items="${requestScope.CUST_SS_CD}">
									<input type="radio" class="req" id="CUST_SS_CD" name="CUST_SS_CD" value="${CUST_SS_CD.DTL_CD}" <c:if test="${CUST_SS_CD.DTL_CD eq DT.CUST_SS_CD}">checked</c:if> />&nbsp;<label for="${CUST_SS_CD.DTL_CD}">${CUST_SS_CD.DTL_CD_NM}</label>&nbsp;&nbsp;
								</c:forEach>
							</td>
							<td class="f_right item_name">최초가입일자</td>
							<td>
							<fmt:parseDate value="${DT.FST_JS_DT}" var="FMT_FST_JS_DT" pattern="yyyyMMdd"/>
							<input type="text" class="" name="FST_JS_DT" id="FST_JS_DT" value="<fmt:formatDate value="${FMT_FST_JS_DT}" pattern="yyyy-MM-dd"/>" style="text-align:center; width:120px;" readonly /></td>
							
							<td class="f_right item_name">가입일자</td>
							<td>
							<fmt:parseDate value="${DT.JS_DT}" var="FMT_JS_DT" pattern="yyyyMMdd"/>
							<input type="text" class="" name="JS_DT" id="JS_DT" value="<fmt:formatDate value="${FMT_JS_DT}" pattern="yyyy-MM-dd"/>" style="text-align:center; width:120px;" readonly /></td>
						</tr>
						
						<tr>
							<td class="f_right item_name">해지사유</td>
							<td><input type="text" class="" name="CNCL_CNTS" id="CNCL_CNTS" value="${DT.CNCL_CNTS}" readonly maxlength="100"/></td>
							<td class="f_right item_name">중지일자</td>
							<td>
							<fmt:parseDate value="${DT.STP_DT}" var="FMT_STP_DT" pattern="yyyyMMdd"/>
							<input type="text" class="" name="STP_DT" id="STP_DT" value="<fmt:formatDate value="${FMT_STP_DT}" pattern="yyyy-MM-dd"/>" style="text-align:center; width:120px;" readonly /></td>
							<td class="f_right item_name">해지일자</td>
							<td>
							<fmt:parseDate value="${DT.CNCL_DT}" var="FMT_CNCL_DT" pattern="yyyyMMdd"/>
							<input type="text" class="" name="CNCL_DT" id="CNCL_DT" value="<fmt:formatDate value="${FMT_CNCL_DT}" pattern="yyyy-MM-dd"/>" style="text-align:center; width:120px;" readonly /></td>
						</tr>
					</tbody>
				</table>
				<!-- 기본정보를 담는 테이블 시작 -->
			</div>
			<!-- 고객기본정보를 입력하기 위한 div 끝 -->
			
			<!-- 구매를 입력하기 위한 div 시작 -->
			<div class="title" id = "receiveYN" style="padding-right: 0;">
				<span style="font-size: 18px;">구매</span>&nbsp;&nbsp;
				<!-- 기본정보를 담는 테이블 시작 -->
				<table id="tbl_purchase">
					<tbody>
						<tr>
							<td class="f_right item_name_only">총구매금액</td>
							<td class="item_val_only"><input type="text" class="" name="TOT_SAL_AMT" id="TOT_SAL_AMT" value="<fmt:formatNumber value="${DT.TOT_SAL_AMT}" pattern="#,###"/>"  style="text-align:right;" readonly/></td>
							<td class="f_right item_name_only">당월구매금액</td>
							<td class="item_val_only"><input type="text" class="" name="MON_SAL_AMT" id="MON_SAL_AMT" value="<fmt:formatNumber value="${DT.MON_SAL_AMT}" pattern="#,###"/>"  style="text-align:right;" readonly/></td>
							<td class="f_right item_name_only">최종구매일</td>
							<td class="item_val_only" style="max-width:256px;"><input type="text" class="" name="LAST_SAL" id="LAST_SAL" value="${DT.LAST_SAL}"  style="text-align:center;" readonly/></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 구매를 입력하기 위한 div 끝 -->
			
			<!-- 포인트를 입력하기 위한 div 시작 -->
			<div class="title" id = "receiveYN" style="padding-right: 0;">
				<span style="font-size: 18px;">포인트</span>&nbsp;&nbsp;
				<!-- 기본정보를 담는 테이블 시작 -->
				<table id="tbl_point">
					<tbody>
						<tr>
							<td class="f_right item_name_only">총포인트</td>
							<td class="item_val_only"><input type="text" class="" name="TOT_PNT" id="TOT_PNT" value="<fmt:formatNumber value="${DT.TOT_PNT}" pattern="#,###"/>"  style="text-align:right;" readonly/></td>
							<td class="f_right item_name_only">당월적립포인트</td>
							<td class="item_val_only"><input type="text" class="" name="MON_RSVG_PNT" id="MON_RSVG_PNT" value="<fmt:formatNumber value="${DT.MON_RSVG_PNT}" pattern="#,###"/>"  style="text-align:right;" readonly/></td>
							<td class="f_right item_name_only">당월사용포인트</td>
							<td class="item_val_only" style="max-width:256px;"><input type="text" class="" name="MON_US_PNT" id="MON_US_PNT" value="<fmt:formatNumber value="${DT.MON_US_PNT}" pattern="#,###"/>"  style="text-align:right;" readonly /></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 포인트를 입력하기 위한 div 끝 -->
			
			<!-- 수신동의(통합)를 입력하기 위한 div 시작 -->
			<div class="title" id = "receiveYN" style="padding-right: 0;">
				<span style="font-size: 18px;">수신동의(통합)</span>&nbsp;&nbsp;
				<!-- 기본정보를 담는 테이블 시작 -->
				<table id="tbl_receiveYN">
					<tbody>
						<tr>
							<td style="width:130px;"></td>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>이메일수신동의</td>
							<td class="item_value">
								<c:forEach var="EMAIL_RCV_YN" items="${requestScope.EMAIL_RCV_YN}">
									<input type="radio" class="req" id="EMAIL_RCV_YN" name="EMAIL_RCV_YN" value="${EMAIL_RCV_YN.DTL_CD}" <c:if test="${EMAIL_RCV_YN.DTL_CD eq DT.EMAIL_RCV_YN}">checked</c:if> />&nbsp;${EMAIL_RCV_YN.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>SMS수신동의</td>
							<td class="item_value" style="max-width:20%;">
								<c:forEach var="SMS_RCV_YN" items="${requestScope.SMS_RCV_YN}">
									<input type="radio" class="req" id="SMS_RCV_YN" name="SMS_RCV_YN" value="${SMS_RCV_YN.DTL_CD}" <c:if test="${SMS_RCV_YN.DTL_CD eq DT.SMS_RCV_YN}">checked</c:if> />&nbsp;${SMS_RCV_YN.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>DM수신동의</td>
							<td class="item_value">
								<c:forEach var="DM_RCV_YN" items="${requestScope.DM_RCV_YN}">
									<input type="radio" class="req" id="DM_RCV_YN" name="DM_RCV_YN" value="${DM_RCV_YN.DTL_CD}" <c:if test="${DM_RCV_YN.DTL_CD eq DT.DM_RCV_YN}">checked</c:if> />&nbsp;${DM_RCV_YN.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 수신동의(통합)를 입력하기 위한 div 끝 -->
			
			<input type="hidden" name="MBL_NO" id="MBL_NO" value="" />
			<input type="hidden" name="EMAIL" id="EMAIL" value="" />
			<input type="hidden" name="BF_SS_CD" id="BF_SS_CD" value="" />
			<input type="hidden" name="OR_SS_CD" id="OR_SS_CD" value="${DT.CUST_SS_CD}" />
			<input type="hidden" name="HD_CUST_NO" id="HD_CUST_NO" value="${DT.CUST_NO}" />
			<input type="hidden" name="SE_USER_ID" id="SE_USER_ID" value="${sessionScope.loginuser.USER_ID}" />
			<input type="hidden" name="SE_USER_DT_CD" id="SE_USER_DT_CD" value="${sessionScope.loginuser.USER_DT_CD}" />
			
		</form>
		<!-- 고객정보를 등록하기 위한 form 끝 -->
		
		<div id="div_compareInfo">
			<form name="compareFrm" id="compareFrm" >
				<c:if test="${not empty DT}">
					<c:forEach var="ORG" items="${DT}">
						<input type="hidden" name="ORG_${ORG.key}" id="ORG_${ORG.key}" value="${ORG.value}" />
					</c:forEach>
				</c:if>
				<input type="hidden" name="ORG_STP_DT" id="ORG_STP_DT" value="" />
				<input type="hidden" name="ORG_CNCL_DT" id="ORG_CNCL_DT" value="" /> 
			</form>
		</div>
		
		<div style="float:right;">
			<button type="button" id="btn_close" class="btn-secondary" onclick="location.href='<%= ctxPath %>/customerList.dowell'" >닫기</button>
			<button type="button" id="btn_update" class="btn-secondary">수정</button>
		</div>
	</div>

</div>