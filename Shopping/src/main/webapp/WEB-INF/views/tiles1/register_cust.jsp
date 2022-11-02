<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
	String ctxPath = request.getContextPath();
%>
    

    
<!DOCTYPE html>
<html>



<head>
	<!-- Required meta tags -->
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> 
	
	
	<!-- Optional JavaScript -->
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.6.0.min.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> 
	
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 
	
	<!-- Font Awesome 5 Icons -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	
	<!-- 직접 만든 CSS 1 -->
	<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/style1.css" />
	
	<%--  ===== 스피너 및 datepicker 를 사용하기 위해  jquery-ui 사용하기 ===== --%>
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.css" />
	<script type="text/javascript" src="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.js"></script>
	
 	<%-- *** ajax로 파일을 업로드할때 가장 널리 사용하는 방법 ==> ajaxForm *** --%>
 	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery.form.min.js"></script>
     
    <!-- 구글 폰트를 쓰기 위한 링크 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Noto+Sans+KR&display=swap" rel="stylesheet">
  
 	<!-- Optional JavaScript-->
	<script type="text/javascript" src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  		 
	<!-- 모듈화 연습 -->
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/common.js"></script>  
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/register.js"></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/common_search.js"></script> 
	
	<!-- 직접 만든 CSS -->
  	<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/registerPopUp.css" />

	
	<style type="text/css">
		img { margin-left: 5px !important; }
	</style>
	
	<script type="text/javascript">

		let flag_req = false;												// 필수입력항목이 충족되었는지 구별할 flag 변수 선언
		let flag_mblDuplicated = false;										// 등록 버튼 클릭시 핸드폰중복확인 검사유무를 구별할 flag 변수 선언
		let flag_emailDuplicated = false;									// 등록 버튼 클릭시 이메일중복확인 검사유무를 구별할 flag 변수 선언
		
		$(document).ready(function(){
			
			var SE_PRT_CD = opener.$("input#SE_PRT_CD").val(); 				// 부모창에서 id가 SE_PRT_CD인 태그의 val()
			var SE_PRT_NM = opener.$("input#SE_PRT_NM").val(); 				// 부모창에서 id가 SE_PRT_NM인 태그의 val()
			$("input#JN_PRT_CD").val(SE_PRT_CD); 							// 자식창에서 id가 JN_PRT_CD인 val에 id를 넣기
			$("input#PRT_CD_NM").val(SE_PRT_NM); 							// 자식창에서 id가 PRT_CD_NM인 val에 id를 넣기
			$("input#MRRG_DT").val(""); 									// 결혼기념일 기본값 공란 지정
			
			$("input[name='SEX_CD'][value='F']").prop("checked", true);			// 초기값 설정(성별)
			$("input[name='PSMT_GRC_CD'][value='H']").prop("checked", true);	// 초기값 설정(우편물수령)
			
			
			$("button#btn_close").click(function(){							// 닫기 버튼 클릭시		
				closeTabClick(); 
		    }); // end of $("button#btn_close").click(function(){})------------
				
			$("button#register").click(function(){										// 등록 버튼 클릭시
				if(confirm("신규고객으로 등록하시겠습니까?")){									// 확인창에서 확인버튼을 누른다면
					reqCheck();															// 필수입력항목 검사
					if(flag_req) {														// 필수입력항목에 값이 모두 입력되었다면
						if(checkInfo()) {													// 각 항목에 대한 유효성 검사 함수 실행
							insertItemWithForm("custInfoFrm", "/shopping/registerCustSubmit.dowell");	// insert 함수 실행
						}										
					}
				}
			}); // end of $("button#register").click(function(){})---------------
		    		   	
		});	// end of $(document).ready(function(){})----------
	    
		// Function Declaration
		
		// 팝업창 닫기를 클릭했을때 실행되는 함수
		function closeTabClick() {
			window.close();																// 팝업을 닫는다
		} // end of function closeTabClick()---------------------------

	</script>

<meta charset="UTF-8">
<title>고객조회</title>
</head>
<body>

	<div id="contentContainer">
		
		<div class="title" style="margin: auto 0; padding: 10px 10px 0 10px;">
			<span style="font-weight:bold; font-size: 20px; padding-left: 10px;">신규고객등록</span>&nbsp;&nbsp;
		</div>
		
		<!-- 고객정보를 등록하기 위한 form 시작 -->
		<form name="custInfoFrm">
			<!-- 고객기본정보를 입력하기 위한 div 시작 -->
			<div class="title" id = "BaseInfo">
				<span style="font-size: 18px; padding-left: 10px;">고객기본정보(<strong style="color:red;">*&nbsp;</strong>가 표시된 항목은 필수 입력사항입니다)</span>&nbsp;&nbsp;
				<!-- 기본정보를 담는 테이블 시작 -->
				<table id="tbl_baseInfo">
					<tbody>
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>고객명</td>
							<td class="item_value"><input type="text" class="req med" name="CUST_NM" id="CUST_NM" value="" placeholder="2글자이상 입력" maxlength="20" spellcheck="false" autofocus maxlength='50'/></td>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>직업코드</td>
							<td>
								<select class="req_sel" name="POC_CD" id="POC_CD" required>
									<option value="">선택하세요</option>
									<c:forEach var="POC_CD" items="${requestScope.POC_CD}">
										<option value="${POC_CD.DTL_CD}">${POC_CD.DTL_CD_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						
						<tr>
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
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>휴대폰번호</td>
							<td class="item_value">
								<input type="text" class="req sm" name="MBL1" id="MBL1" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="3"/>&nbsp;
								<input type="text" class="req sm" name="MBL2" id="MBL2" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4"/>&nbsp;
								<input type="text" class="req sm" name="MBL3" id="MBL3" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4"/>
								<button type='button' class='btn btn-secondary btn_td btn_check' id='checkMblDuplicated'  onclick="checkDuplicated('mbl')" style='margin-bottom:5px;'>중복확인</button>
							</td>
							<td class="f_right item_name">생일</td>
							<td class="item_value">
								<input type="radio" id="SCAL_YN" name="SCAL_YN" value="0" checked/>&nbsp;양력&nbsp;&nbsp;
								<input type="radio" id="SCAL_YN" name="SCAL_YN" value="1" />&nbsp;음력
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>우편물수령</td>
							<td class="item_value">
								<c:forEach var="PSMT_GRC_CD" items="${requestScope.PSMT_GRC_CD}">
									<input type="radio" class="req_rad" id="PSMT_GRC_CD" name="PSMT_GRC_CD" value="${PSMT_GRC_CD.DTL_CD}"/>&nbsp;${PSMT_GRC_CD.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>이메일</td>
							<td class="item_value">
								<input type="text" class="req med" name="EMAIL1" id="EMAIL1" value="" maxlength='50'/>&nbsp;@
								<input type="text" class="req med" name="EMAIL2" id="EMAIL2" value="" style="max-width: 160px !important;" maxlength='50'/>
								<button type='button' class='btn btn-secondary btn_td btn_check' id='checkEmailDuplicated'  onclick='checkDuplicated("email")' style='margin-bottom:5px;'>중복확인</button>
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name" >주소</td>
							<td colspan="3">
								<input type="text" class="ADD" name="ZIP_CD" id="ZIP_CD" value="" placeholder="우편번호" style="width: 100px;" readonly maxlength='10'/>
								<button type="button" id="btn_tmp" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" disabled>
									<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
								</button>
								&nbsp;<input type="text" class="ADD" name="ADDR" id="ADDR" value="" placeholder="주소" style="width: 450px;" maxlength="100"/>
								<input type="text" class="ADD" name="ADDR_DTL" id="ADDR_DTL" value="" placeholder="상세주소" style="width: 250px;" maxlength="100"/>
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name">결혼기념일</td>
							<td class="item_value"><input type="text" class="datepicker med" name="MRRG_DT" id="MRRG_DT" onkeyup="this.value = date_masking(this.value)" maxlength="10" /></td>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>매장</td>
							<td class="item_value">
								<input type="text" class="dk med" name="JN_PRT_CD" id="JN_PRT_CD" style="background-color: #b3b3b3;" readonly />&nbsp;
								<button type="button" id="btn_search_prt" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" disabled>
									<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
								</button>
								&nbsp;<input type="text"  id="PRT_CD_NM" name="PRT_CD_NM" class="lg enter_prt blank_key" value="" placeholder="매장코드 / 매장명" spellcheck="false" readonly autofocus />
							</td>
						</tr>
						
					</tbody>
				</table>
				<!-- 기본정보를 담는 테이블 시작 -->
			</div>
			<!-- 고객기본정보를 입력하기 위한 div 끝 -->
			
			<!-- 수신동의(통합)를 입력하기 위한 div 시작 -->
			<div class="title" id = "receiveYN">
				<span style="font-size: 18px; padding-left: 10px;">수신동의(통합)</span>&nbsp;&nbsp;
				<!-- 기본정보를 담는 테이블 시작 -->
				<table id="tbl_receiveYN">
					<tbody>
						<tr>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>이메일수신동의</td>
							<td class="item_value">
								<input type="radio" class="req_rad" id="EMAIL_RCV_YN" name="EMAIL_RCV_YN" value="Y" />&nbsp;예&nbsp;&nbsp;
								<input type="radio" class="req_rad" id="EMAIL_RCV_YN" name="EMAIL_RCV_YN" value="N" checked/>&nbsp;아니오
							</td>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>SMS수신동의</td>
							<td class="item_value" style="max-width:20%;">
								<input type="radio" class="req_rad" id="SMS_RCV_YN" name="SMS_RCV_YN" value="Y" />&nbsp;예&nbsp;&nbsp;
								<input type="radio" class="req_rad" id="SMS_RCV_YN" name="SMS_RCV_YN" value="N" checked/>&nbsp;아니오
							</td>
						</tr>
						
						<tr>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>DM수신동의</td>
							<td class="item_value">
								<input type="radio" class="req_rad" id="DM_RCV_YN" name="DM_RCV_YN" value="Y" />&nbsp;예&nbsp;&nbsp;
								<input type="radio" class="req_rad" id="DM_RCV_YN" name="DM_RCV_YN" value="N" checked/>&nbsp;아니오
							</td>
							<td class="item_value"></td>
							<td class="item_value"></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 수신동의(통합)를 입력하기 위한 div 끝 -->
			
			
			<input type="hidden" name="MBL_NO" id="MBL_NO" value="" />
			<input type="hidden" name="EMAIL" id="EMAIL" value="" />
			<input type="hidden" name="SE_USER_ID" id="SE_USER_ID" value="${sessionScope.loginuser.USER_ID}" />
		</form>
		<!-- 고객정보를 등록하기 위한 form 끝 -->
		
	</div>
	
	<!-- 닫기 / 등록 버튼이 포함되어 있는 하단 부분 시작 -->
	<div id="container_btn" style="padding: 0 auto; margin-top:30px; text-align: center;">
		<button type="button" id="btn_close" class="btn btn-secondary" >닫기</button>
		<span style="padding: 10px 20px 10px 0;"></span>
		<button type="button" id="register" class="btn btn-secondary">등록</button>
	</div>
	<!-- 닫기 / 등록 버튼이 포함되어 있는 하단 부분 끝 -->
</body>
</html>