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
	
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 
	
	<!-- Font Awesome 5 Icons -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	
	<!-- 직접 만든 CSS 1 -->
	<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/style1.css" />
	<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/popupPage.css" />
	
	<!-- Optional JavaScript -->
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.6.0.min.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> 
	
	<%--  ===== 스피너 및 datepicker 를 사용하기 위해  jquery-ui 사용하기 ===== --%>
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.css" />
	<script type="text/javascript" src="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.js"></script>
	
 	<%-- *** ajax로 파일을 업로드할때 가장 널리 사용하는 방법 ==> ajaxForm *** --%>
 	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery.form.min.js"></script>
     
    <!-- 구글 폰트를 쓰기 위한 링크 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Noto+Sans+KR&display=swap" rel="stylesheet">
	 
	<style type="text/css">
		
	</style> 
	
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/register.js"></script>  
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/common.js"></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/check.js"></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/search.js"></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/sum.js"></script>  
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/cud.js"></script> 
	<script type="text/javascript">
		/* ##2-4. 고객판매수금등록 초기조건 설정(20까지있음) */
    	var sMethodName;			// 메소드 이름을 담아주는 변수 선언
    	var sArgument;				// 메소드 이름으로 인자를 생성하는 변수 선언
		var searchWord = "";		// 메소드 이름으로 인자 생성시 검색어 담는 변수 선언
    	var rowIdx;					// 해당 row가 몇번째인지 알아오는 변수 선언
    	var target;					// 이벤트가 발생된 위치를 담는 변수 선언
    	var org_value;				// 완성된 상품코드 값을 담는 변수 선언 
    	var loc;					// 금액계산용 위치를 담는 변수 선언
    	var paramArr = [];			// 파라미터를 담아줄 배열 선언
    	var isEmpty = false;		// 등록할 제품을 담을 배열이 비었는지 확인할 변수 선언
    	var regSal = true;			// 고객판매수금등록에서 왔음을 표시하는 변수 선언
    	var org_cust_no;			// 초기화 전 고객번호를 담는 변수 선언
    	var org_cust_nm;			// 초기화 전 고객명을 담는 변수 선언
    	var org_avb_pnt;			// 초기화 전 포인트를 담는 변수 선언
    	var temp;					// 임시값을 담을 변수 선언
    	var realTimeFlag = false;	// 실시간 비교 구분변수 선언
    	
		$(document).ready(function(){
			
			$(".ui-datepicker-trigger").addClass("hide");								// 달력아이콘 비활성화
			
			$("button#close").click(function(){											// 닫기버튼을 눌렀을 때
				closeTabClick();														// 팝업을 닫는다
		    }); // end of $("button#test").click(function(){})------------
		    
		    $(document).on("keyup", ".ONLYNM", function(){								// 숫자입력전용 클래스에 키 입력시
		    	if(this.value == 0){													// 처음 입력값이 0이면
		    		this.value = this.value.replace(/[0]/g,'');							// 그 값을 ''로 대체한다
		    	}
		    	else if( this.value.substring(0,1) == 0 ) {								// 숫자의 맨앞자리숫자가 0이라면
		    		this.value = this.value.substring(1, this.value.length);			// 앞자리를 자른다
		    	}
		    	else{																	// 그 외에는
		    		this.value=this.value.replace(/[^0-9,]/g,'');						// 숫자가 아닌 문자는 ''로 대체한다
		    	}
		    }); // end of $(document).on("keyup", ".ONLYNM", function(){}--------
		    
	    	$(document).on("click", "input#PRD_CD", function(){							// 상품코드 input tag 클릭시
		    	org_value = $(event.target).val();										// 변수에 클릭한 행의 상품코드입련란의 값을 담는다
		    }); // end of $("button#test").click(function(){})------------
		    
			$(document).on("change", "input#PRD_CD", function(){						// 상품코드 input tag 값 변동시
				if( $(event.target).val().length != 9 && org_value.length == 9 ||		// 기존값이 있고 상품코드가 변경되었다면
		    	    ( $(event.target).val() != org_value && org_value.length == 9 ) ){	// 길이는 같지만 값이 다르다면		
		    		compareOrg(org_value);												// 기존값과 비교 함수 실행(2-5)
				}
			}); // end of $(document).on("change", "input#PRD_CD", function(){}----------
		    
			$(document).on("change", "input#CUST_SAL_QTY", function(){					// 판매수량 input tag 값 변동시
				loc = $(this).closest('tr');											// 현재 row의 위치를 담는다
				checkPrdQty(loc);														// 판매수량을 체크하는 함수 실행(2-6)
			}); // end of $(document).on("change", "input#CUST_SAL_QTY", function(){}------------
		    
			$("button#btn_insert").click(function(){									// 저장버튼을 눌렀을 때
				if(checkCardInfo()){												// 카드관련 유효성검사 실시 후 통과한다면(2-7)
					if(checkPaymentRegister()){									// 전체 유효성검사 실시 후 통과한다면(2-8-1)
						if(confirm("등록하시겠습니까?")){
							sMethodName = "REALTIMECHECKPRODUCT";			// 메소드이름을 실시간상품체크로 저장(##피드백)
							sArgument = func_createArgument(sMethodName);	// 메소드이름으로 인자를 생성(##피드백)
							$.ajax(sArgument);								// ajax 통신 실행(##피드백)
						}
					}
				}
				
			}); // end of $("button#btn_insert").click(function(){}--------------------
			
			$(opener).one('beforeunload', function() {							// 부모창의 새로고침/닫기/앞으로/뒤로
				closeTabClick();												// 팝업을 닫는다
            });	// end of $(opener).one('beforeunload', function() {}--------------------	

			$("#btn_check").click(function(){
				sMethodName = "REALTIMECHECKPRODUCT";					// 메소드이름을 실시간제품체크로 저장
				sArgument = func_createArgument(sMethodName);	// 메소드이름으로 인자를 생성(피드백2)
				$.ajax(sArgument);						// ajax 통신 실행(피드백2)
			}); // end of $("#btn_check").click(function(){}--------------
			
		});	// end of $(document).ready(function(){})----------
	
		// Function Declaration
		
		// 초기화여부를 물어보는 함수 
		function confirmClear() {
			if ( confirm("고객정보를 수정하면 화면에 있는 기존 정보는 초기화됩니다. 진행하시겠습니까?") ) {
				clearInfo();
    			org_cust_no = "";							// 기존 고객정보를 담고 있던 변수 초기화
    			org_cust_nm = "";
    			org_avb_pnt = "";
    			return true;
    		}
    		else {
    			$("#CUST_NO").val(org_cust_no);				// 기존 고객정보를 다시 담아준다
    			$("#IN_CUST_NO").val(org_cust_nm);
    			$("#AVB_PNT").val(addComma(org_avb_pnt));
    			return false;
    		}
		}
		
		// 판매정보들을 초기화하는 함수 실행
		function clearInfo() {
			$(".clear").find("input").val("");				// 상단 검색조건에 있는 모든 input, select, radio의 값을 비운다
			$("#CRD_CO_CD").val("");
			resetRow();										// 상품정보 입력부분 초기화
			alert("입력하신 값들이 초기화되었습니다.");
		}
		
        // 닫기 버튼을 클릭했을 때 실행하는 함수
		function closeTabClick() {
			window.close();																// 팝업을 닫는다
        } // end of function closeTabClick()
        
        
	</script>

<meta charset="UTF-8">
<title>고객판매수금등록</title>
</head>
<body>

	<div id="contentContainer">
		
		<div style="margin: auto 0; padding: 20px 10px 5px 10px;">
			<span style="font-size: 20px; padding-left: 10px;">고객판매수금등록</span>&nbsp;&nbsp;
		</div>
		
		<form id="registrSalFrm">
		<!-- 고객판매수금등록의 판매구분 항목 시작 -->
		<div id="searchContainer">
			<div id="rowContainer">
				<div class="inline">
					<span class="title_text"><strong style="color:red;">*&nbsp;</strong>판매일자</span>
					<span id="input_text"><input type="text" class="date req" id="EDATE" name="EDATE" value="종료일자" readonly/></span>
				</div>
				<div class="inline">
					<span class="title_text"><strong style="color:red;">*&nbsp;</strong>판매구분</span>
					<select class="req" id="SAL_TP_CD">
						<option id="SAL" VALUE="SAL" selected>판매</option>
						<option id="RTN" VALUE="RTN" disabled>반품</option>
					</select>
				</div>
			</div>
			<div id="rowContainer" class="clear">
				<div class="inline">
					<span class="title_text"><strong style="color:red;">*&nbsp;</strong>고객번호</span>
					<span id="input_text">
						<input type="text" class="req dark medium REG_CUST" name="CUST_NO" id="CUST_NO" value=""readonly />&nbsp;
					</span>
					<button type="button" id="btn_search_cust" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
						<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
					</button>
					<span id="input_text">
						&nbsp;<input type="text" id="IN_CUST_NO" name="IN_CUST_NO" class="large enter_cust blank_key" value="" placeholder="고객번호 / 고객명" spellcheck="false" autofocus />
					</span>
				</div>
			</div>
		</div>
		<!-- 고객판매수금등록의 판매구분 항목 끝 -->
		
		<!-- 고객판매수금등록의 결제금액 부분 시작 -->
		<div style="margin: auto 0; padding: 5px 10px 5px 10px;">
			<span style="font-size: 20px; padding-left: 10px;">결제금액</span>&nbsp;&nbsp;
		</div>
		<div id="popup_container" class="clear">
			<div id="rowContainer_2">
				<div class="inline">
					<span class="title_text">&nbsp;&nbsp;현금</span>
					<span id="input_text">
						<input type="text" class="large ONLYNM" name="CSH_STLM_AMT" id="CSH_STLM_AMT" onkeyup="inputNumberFormat(this)" value="" />&nbsp;
					</span>
					<span class="title_text">&nbsp;&nbsp;카드금액</span>
					<span id="input_text">
						<input type="text" class="large CRD ONLYNM blank_key" name="CRD_STLM_AMT" id="CRD_STLM_AMT" onkeyup="inputNumberFormat(this)" value="" />&nbsp;
					</span>
					<span class="title_text">&nbsp;&nbsp;포인트사용액</span>
					<span id="input_text">
						<input type="text" class="large ONLYNM" name="PNT_STLM_AMT" id="PNT_STLM_AMT" onkeyup="inputNumberFormat(this)" value="" />&nbsp;
					</span>
				</div>
			</div>
			
			<div id="rowContainer_2">
				<div class="inline">
					<span class="title_text">&nbsp;&nbsp;유효일자</span>
					<span id="input_text">
						<input type="text" class="large CRD CRD_DT" name="DIS_VLD_YM" id="DIS_VLD_YM"  onKeyup="inputValidThru(this);" placeholder="MM/YY" maxlength="5" value="" />&nbsp;
						<input type="hidden" class="" name="VLD_YM" id="VLD_YM" value="" />
					</span>
					<span class="title_text">&nbsp;&nbsp;카드회사</span>
					<span id="input_text" style="margin-right: 45px;">
						<select class="CRD CRD_DT" name="CRD_CO_CD" id="CRD_CO_CD">
							<option value="">선택하세요</option>
							<c:forEach var="CRD_CO_CD" items="${requestScope.CRD_CO_CD}">
								<option value="${CRD_CO_CD.DTL_CD}" >${CRD_CO_CD.DTL_CD_NM}</option>
							</c:forEach>
						</select>
					</span>
					
					<span class="title_text">&nbsp;&nbsp;포인트가능액</span>
					<span id="input_text">
						<input type="text" class="dark large" name="AVB_PNT" id="AVB_PNT" value="" readonly />&nbsp;
					</span>
				</div>
			</div>
			
			<div id="rowContainer_2">
				<div class="inline">
					<span class="title_text">&nbsp;&nbsp;카드번호</span>
					<span id="input_text">
						<input type="text" class="small CRD CRD_NM CRD_DT" name="CARD1" id="CARD1" value="" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" maxlength="4" />&nbsp;
					</span>
					<span id="input_text">
						<input type="text" class="small CRD CRD_NM CRD_DT" name="CARD2" id="CARD2" value="" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" maxlength="4" />&nbsp;
					</span>
					<span id="input_text">
						<input type="text" class="small CRD CRD_NM CRD_DT" name="CARD3" id="CARD3" value="" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" maxlength="4" />&nbsp;
					</span>
					<span id="input_text">
						<input type="text" class="small CRD CRD_NM CRD_DT" name="CARD4" id="CARD4" value="" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" maxlength="4" />&nbsp;
					</span>
				</div>
			</div>
		</div>
		<input type="hidden" name="MT_PRT_CD" id="MT_PRT_CD" value="${sessionScope.loginuser.PRT_CD}" />
		<input type="hidden" name="IN_TOT_SAL_QTY" id="IN_TOT_SAL_QTY" value="" />
		<input type="hidden" name="IN_TOT_SAL_AMT" id="IN_TOT_SAL_AMT" value="" />
		<input type="hidden" name="IN_TOT_VOS_AMT" id="IN_TOT_VOS_AMT" value="" />
		<input type="hidden" name="IN_TOT_VAT_AMT" id="IN_TOT_VAT_AMT" value="" />
		<input type="hidden" name="CRD_NO" id="CRD_NO" value="" />
		<input type="hidden" name="SE_USER_ID" id="SE_USER_ID" value="${sessionScope.loginuser.USER_ID}" />
		<input type="hidden" name="SAL_TP_CD" id="SAL_TP_CD" value="SAL" />
		<input type="hidden" name="RSVG_PNT" id="RSVG_PNT" value="" />
		<input type="hidden" name="US_PNT" id="US_PNT" value="" />
		<input type="hidden" name="PNT_DS_CD" id="PNT_DS_CD" value="" />
		<input type="hidden" name="PNT_DS_DT_CD" id="PNT_DS_DT_CD" value="" />
		</form>
		<!-- 고객판매수금등록의 결제금액 부분 끝 -->
		
		<!--  제품추가/제거 버튼 부분 시작 -->
		<div id="adminContainer">
			<button type="button" class="btn-secondary" id="add" onclick='addRow()'><i class="fas fa-plus"></i></button>
			<button type="button" class="btn-secondary" id="delete" onclick='deleteRow()'><i class="fas fa-minus"></i></button>
		</div>
		<!--  제품추가/제거 버튼 부분 끝 -->
		
		<!-- 조회한 결과들을 보여주는 부분 시작 -->
		<div id="popup_table_container">
			<form id="prdFrm">
				<table id="tbl_detail"  class="scrolltable" style="margin: 15px auto;">
					<thead id="tbl_header" style="width: 100%;">
						<tr>
							<th class="center" style="width:50px; min-width:50px; max-width: 50px;">선택</th>
							<th class="center" style="width:50px; min-width:50px; max-width: 50px;">번호</th>
							<th class="center" style="width:150px; min-width:150px; max-width:150px;">상품코드</th>
							<th class="center" style="width:150px; min-width:230px; max-width:230px;">상품명</th>
							<th class="center" style="width:100px; min-width:100px; max-width:100px;">매장재고</th>
							<th class="center" style="width:180px; min-width:100px; max-width:100px;">판매수량</th>
							<th class="center" style="width:150px; min-width:150px; max-width:150px;">소비자가</th>
							<th class="center" style="width:200px; min-width:200px; max-width:200px;">판매금액</th>
						</tr>
					</thead>
				
					<tbody id="TBODY">
						<tr>
							<td class="center" style="width:50px; min-width:50px; max-width: 50px;"><input type="checkbox" name='chBox' class='chBox'/></td>
							<td class="center" id="SAL_SEQ" style="width:50px; min-width:50px; max-width: 50px;">1</td>
							<td class="center" style="width:150px; min-width:150px; max-width:150px;">
							<input type="text" class="small enter_prd blank_key" id="PRD_CD" name="PRD_CD" value="" maxlength="9"/>
							<button type="button" id="btn_search_prd" class="btn btn-secondary" style="margin-bottom: 5px; width: 25px; height: 25px; padding: 0 0 0 5px;" >
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:15px;"></i></span>
							</button>
							</td>
							<td class="right" id="PRD_NM" style="width:230px; min-width:230px; max-width:230px;"></td>
							<td class="right" id="IVCO_QTY" style="width:100px; min-width:100px; max-width:100px;"></td>
							<td class="right" id="" style="width:180px; min-width:100px; max-width:100px;">
								<input type="text" class="ONLYNM" id="CUST_SAL_QTY" name="CUST_SAL_QTY" style="width:80px; font-size:80%; text-align:right;" value="" readonly/>
							</td>
							<td class="right" id="PRD_CSMR_UPR" style="width:150px; min-width:150px; max-width:150px;"></td>
							<td class="right" id="SAL_AMT" style="width:200px; min-width:200px; max-width:200px;"></td>
						</tr>
					</tbody>
					 
					<tfoot id="TFOOT" style="height: 50px !important;">
	    		    	<tr>
			       		  <td colspan="4" class="right" id="" style="width: 480px;">합계</td>
			       		  <td class="center" id="" style="width: 100px;">수량</td>
			       		  <td class="right" id="TOT_SAL_QTY" style="width: 100px;"></td>
			       		  <td class="center" id="" style="width: 150px;">금액</td>
			       		  <td class="right" id="TOT_SAL_AMT" style="width: 200px;"></td>
			       		</tr> 	
		     		</tfoot>
		     		
				</table>
				<input type="hidden" name="SE_PRT_CD" id="SE_PRT_CD" value="${sessionScope.loginuser.PRT_CD}" />
				<input type="hidden" name="SE_PRT_NM" id="SE_PRT_NM" value="${sessionScope.loginuser.PRT_NM}" />
				<input type="hidden" name="SE_USER_ID" id="SE_USER_ID" value="${sessionScope.loginuser.USER_ID}" />
				<input type="hidden" name="CARD" id="CARD" value="" />
				<input type="hidden" name="SEARCH_PRD_CD_NM" id="SEARCH_PRD_CD_NM" value="" />
				<input type="hidden" name="RCV_PRD_CD" id="RCV_PRD_CD" value="" />
				<input type="hidden" name="RCV_PRD_NM" id="RCV_PRD_NM" value="" />
				<input type="hidden" name="RCV_IVCO_QTY" id="RCV_IVCO_QTY" value="" />
				<input type="hidden" name="RCV_PRD_CSMR_UPR" id="RCV_PRD_CSMR_UPR" value="" />
				<input type="hidden" name="RCV_PRD_SS_CD" id="RCV_PRD_SS_CD" value="" />
				<input type="hidden" name="HD_PRD_CD" id="HD_PRD_CD" value="" />
			</form>
		</div>
		<!-- 조회한 결과들을 보여주는 부분 끝 -->
		
	</div>

	<!-- 닫기 버튼이 포함된 부분 시작 -->
	<div id="container_btn" style="padding: 0 auto; text-align: center;">
		<button type="button" id="close" class="btn btn-secondary" >닫기</button>
		<span style="padding: 10px 20px 10px 0;"></span>
		<button type="button" id="btn_insert" class="btn btn-secondary" >저장</button>
	</div>
	<!-- 닫기 버튼이 포함된 부분 끝 -->
	
</body>
</html>