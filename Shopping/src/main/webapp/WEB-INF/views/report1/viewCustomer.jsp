<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	String ctxPath = request.getContextPath();
%>

<!-- 직접 만든 CSS 1 -->
 <link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/viewCust.css" />


<script type="text/javascript">

</script>

<div>
	
	<div id="contentContainer">
	
	<!-- 고객조회 제목 / 새로고침 아이튼 버튼 시작 -->
	<div style="margin: auto 0; padding: 0px 10px 5px 10px;">
		<i class="far fa-star fa-2x"></i>
		<span style="font-size: 30px; padding-left: 10px;">고객정보조회</span>&nbsp;&nbsp;
		<button type="button" style="margin-bottom: 5px; width: 40px; height: 40px; padding: 0 0 0 7px;" id="btnSearch" class="btn btn-secondary" onclick="refresh()">
			<span style="padding-right: 10px;"><i class="fa fa-redo-alt" aria-hidden="true" style="font-size:25px;"></i></span>
		</button>
	</div>
	<!-- 고객조회 제목 / 새로고침 아이튼 버튼 끝 -->
	
		<form>
			<table id="tbl_searchCustmor">
				<thead>
					<tr>
						<td class="pd_td pd_left" style="float:right; padding-top: 35px; width: 75px;">고객번호</td>
						<td>
							<input type="text" class="dark medium" name="JN_PRT_CD" id="JN_PRT_CD" readonly />&nbsp;
							<button type="button" id="btn_search_prt" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
							</button>
							<!-- 
								<i class="fas fa-search fa-border"></i>&nbsp;
							 -->
							&nbsp;<input type="text"  id="CUST_SEARCH" name="CUST_SEARCH" class="large enter_prt blank_key" value="" placeholder="고객번호 / 고객명" spellcheck="false" autofocus />
						</td>
						<td style="float:right; padding-right: 20px;">
							<button type="button" style="margin: 5px 0; width: 50px; height: 50px; padding: 0 0 0 7px;" id="btnSearch" class="btn btn-secondary" onclick="read_cust()">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
							</button>
						</td>
					</tr>
				</thead>
			</table>	
		</form>
		
		<!-- 고객정보를 등록하기 위한 form 시작 -->
		<form name="custInfoFrm">
			<!-- 고객기본정보를 입력하기 위한 div 시작 -->
			<div class="title" id = "BaseInfo" style="padding-right: 0;">
				<span style="font-size: 18px;">고객기본정보(<strong style="color:red;">*&nbsp;</strong>가 표시된 항목은 필수 입력사항입니다)</span>&nbsp;&nbsp;
				<!-- 기본정보를 담는 테이블 시작 -->
				<table id="tbl_baseInfo">
					<tbody>
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>고객명</td>
							<td class="item_value"><input type="text" class="req med" name="CUST_NM" id="CUST_NM" value="" placeholder="" autofocus /></td>
							
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>생년월일</td>
							<td class="item_value"><input type="text" class="datepicker req med" name="BRDY_DT" id="BRDY_DT" onkeyup="this.value = date_masking(this.value)" maxlength="10" /></td>
							
							<td class="f_right item_name">성별</td>
							<td>
								<c:forEach var="SEX_CD" items="${requestScope.SEX_CD}">
									<input type="radio" id="SEX_CD" name="SEX_CD" value="${SEX_CD.DTL_CD}"/>&nbsp;${SEX_CD.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							
						</tr>
						
						<tr>
							<td class="f_right item_name">생일</td>
							<td class="item_value">
								<input type="radio" id="SCAL_YN" name="SCAL_YN" value="Y" checked/>&nbsp;양력&nbsp;&nbsp;
								<input type="radio" id="SCAL_YN" name="SCAL_YN" value="N" />&nbsp;음력
							</td>
							
							<td class="f_right item_name">결혼기념일</td>
							<td class="item_value"><input type="text" class="datepicker med" name="MRRG_DT" id="MRRG_DT" onkeyup="this.value = date_masking(this.value)" maxlength="10" /></td>
							
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>직업코드</td>
							<td>
								<select class="req" name="POC_CD" id="POC_CD">
									<option value="">선택하세요</option>
									<c:forEach var="POC_CD" items="${requestScope.POC_CD}">
										<option value="${POC_CD.DTL_CD}">${POC_CD.DTL_CD_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>휴대폰번호</td>
							<td class="item_value">
								<input type="text" class="req sm" name="MBL1" id="MBL1" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />&nbsp;
								<input type="text" class="req sm" name="MBL2" id="MBL2" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />&nbsp;
								<input type="text" class="req sm" name="MBL3" id="MBL3" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />&nbsp;
								<button type='button' class='btn btn-secondary btn_td btn_check' id='checkMblDuplicated'  onclick='' style='margin-bottom:5px;'>중복확인</button>
							</td>
							
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>가입매장</td>
							<td class="item_value" style="width:600px;">
								<input type="text" class="dark med" name="JN_PRT_CD" id="JN_PRT_CD" readonly />&nbsp;
								<button type="button" id="btn_search_prt" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
									<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
								</button>
								&nbsp;<input type="text"  id="PRT_NM" name="PRT_NM" class="lg enter_prt blank_key" value="" placeholder="매장코드 / 매장명" spellcheck="false" autofocus />
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>우편물수령</td>
							<td class="item_value">
								<c:forEach var="PSMT_GRC_CD" items="${requestScope.PSMT_GRC_CD}">
									<input type="radio" class="req" id="PSMT_GRC_CD" name="PSMT_GRC_CD" value="${PSMT_GRC_CD.DTL_CD}"/>&nbsp;${PSMT_GRC_CD.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>이메일</td>
							<td class="item_value" style="width:600px;">
								<input type="text" class="req med" name="EMAIL1" id="EMAIL1" value="" />&nbsp;@
								<input type="text" class="req med" name="EMAIL2" id="EMAIL2" value="" />
								<button type='button' class='btn btn-secondary btn_td btn_check' id='checkEmailDuplicated'  onclick='' style='margin-bottom:5px;'>중복확인</button>
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name">주소</td>
							<td style="width:700px;">
								<input type="text" class="sm ADD" name="ZIP_CD" id="ZIP_CD" value="" placeholder="우편번호" />
								<input type="text" class="lg ADD" name="ADDR" id="ADDR" value="" placeholder="주소(직접입력)" />
								<input type="text" class="lg ADD" name="ADDR_DTL" id="ADDR_DTL" value="" placeholder="상세주소(직접입력)" />
							</td>
						</tr>
							
							
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>고객상태</td>
							<td class="item_value">
								<c:forEach var="CUST_SS_CD" items="${requestScope.CUST_SS_CD}">
									<input type="radio" class="req" id="CUST_SS_CD" name="CUST_SS_CD" value="${CUST_SS_CD.DTL_CD}"/>&nbsp;${CUST_SS_CD.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							<td class="f_right item_name">최초가입일자</td>
							<td><input type="text" class="" name="FST_JS_DT" id="FST_JS_DT" /></td>
							<td class="f_right item_name">가입일자</td>
							<td><input type="text" class="" name="JS_DT" id="JS_DT" /></td>
						</tr>
						
						<tr>
							<td class="f_right item_name">해지사유</td>
							<td><input type="text" class="" name="CNCL_CNTS" id="CNCL_CNTS" /></td>
							<td class="f_right item_name">중지일자</td>
							<td><input type="text" class="" name="STP_DT" id="STP_DT" /></td>
							<td class="f_right item_name">해지일자</td>
							<td><input type="text" class="" name="CNCL_DT" id="CNCL_DT" /></td>
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
							<td class="item_val_only"><input type="text" class="" name="TOT_PHC_AMT" id="TOT_PHC_AMT" readonly/></td>
							<td class="f_right item_name_only">당월구매금액</td>
							<td class="item_val_only"><input type="text" class="" name="MON_PHC_AMT" id="MON_PHC_AMT" readonly/></td>
							<td class="f_right item_name_only">최종구매일</td>
							<td class="item_val_only" style="max-width:256px;"><input type="text" class="" name="LST_PHC_DT" id="LST_PHC_DT" readonly/></td>
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
							<td class="item_val_only"><input type="text" class="" name="TOT_PNT_AMT" id="TOT_PNT_AMT" readonly/></td>
							<td class="f_right item_name_only">당월적립포인트</td>
							<td class="item_val_only"><input type="text" class="" name="MON_PNT_AMT" id="MON_PNT_AMT" readonly/></td>
							<td class="f_right item_name_only">당월사용포인트</td>
							<td class="item_val_only" style="max-width:256px;"><input type="text" class="" name="MON_USE_PNT" id="MON_USE_PNT" readonly/></td>
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
								<input type="radio" class="req" id="EMAIL_RCV_YN" name="EMAIL_RCV_YN" value="Y" />&nbsp;예&nbsp;&nbsp;
								<input type="radio" class="req" id="EMAIL_RCV_YN" name="EMAIL_RCV_YN" value="N" />&nbsp;아니오
							</td>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>SMS수신동의</td>
							<td class="item_value" style="max-width:20%;">
								<input type="radio" class="req" id="SMS_RCV_YN" name="SMS_RCV_YN" value="Y" />&nbsp;예&nbsp;&nbsp;
								<input type="radio" class="req" id="SMS_RCV_YN" name="SMS_RCV_YN" value="N" />&nbsp;아니오
							</td>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>DM수신동의</td>
							<td class="item_value">
								<input type="radio" class="req" id="DM_RCV_YN" name="DM_RCV_YN" value="Y" />&nbsp;예&nbsp;&nbsp;
								<input type="radio" class="req" id="DM_RCV_YN" name="DM_RCV_YN" value="N" />&nbsp;아니오
							</td>
							<!-- 
							<td class="item_value"></td>
							<td class="item_value"></td>
							 -->
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 수신동의(통합)를 입력하기 위한 div 끝 -->
		</form>
		<!-- 고객정보를 등록하기 위한 form 끝 -->
		
		<div style="float:right;">
			<button type="button" class="btn-secondary">닫기</button>
			<button type="button" class="btn-secondary">저장</button>
		</div>
	</div>

</div>