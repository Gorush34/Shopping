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
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/cud.js"></script> 
	<script type="text/javascript">
		/* ##3-1. 판매상세조회 초기조건 설정(19까지있음) */
		var parentStr;														// 부모창에서 받아온 데이터를 담는 변수 선언					
		var se_user_dt_cd = "";												// 세션에 저장된 거래처구분코드를 받아올 변수 선언
		var paramArr = [];													// 파라미터를 담아줄 배열 선언
		var cnclPnt;														// 반품시 포인트가 0보다 낮지 않게 방지하는 변수 선언
		
		$(document).ready(function(){
			
			$(".ui-datepicker-trigger").addClass("hide");					// 달력아이콘 비활성화
			
			parentStr = opener.$("#VIEW_MAP").val();						// 부모창에서 해당 row의 정보를 받아온다
			se_user_dt_cd = opener.$("#USER_DT_CD").val();					// 부모창의 판매구분코드를 input에 담는다
			$("#PT_MAP").val(parentStr);									// 그 값을 input hidden에 뿌린다
			var map = JSON.parse(parentStr);								// 받아온 정보를 key/value형태로 변환한다
			
			showSalDetailInfo(map);											// 해당 판매정보를 출력하는 함수를 실행(3-2)
			setRetunInfo(map);												// 반품정보를 설정하는 함수 실행(3-3)		
			
			cnclPnt = parseInt($("#CSH_STLM_AMT").val() ) + parseInt( $("#CRD_STLM_AMT").val() );	// 구매시 사용한 현금금액과 카드금액을 더한다
			cnclPnt = cnclPnt*0.1;																	// 그것을 10%로 나눈다
			
			if(se_user_dt_cd != 2 ) {								// 세션에 저장된 사용자구분코드가 2(특약점)가 아니라면
				$("button#return").hide();							// 신규등록이 포함된 div를 숨긴다
			} 
			
			sMethodName = "GETSALDETAIL";										// 메소드이름을 판매상세조회로 저장
			sArgument = func_createArgument(sMethodName, $("#PT_MAP").val());	// 메소드이름으로 인자를 생성(3-4)
			$.ajax(sArgument);													// ajax 통신 실행
			
			if( $("input#SAL_TP_CD").val() == "RTN" ) {				// 판매구분코드가 RTN 이라면
				$("#return").prop('disabled', true);				// 반품버튼을 선택불가로 만든다
			}
			
			$("button#return").click(function(){									// 반품버튼을 눌렀을 때
				if( $("#SE_PRT_CD").val() != $("#PRT_CD").text() ){			// 세션에 있는 매장과 데이터에 있는 매장이 다를 때
					alert("반품은 같은 매장에 있는 사용자여야 가능합니다.");
					return;															// 함수 종료
				}
				else{
					if(confirm("반품하시겠습니까?")){
						sMethodName = "INSERTRTN";								// 메소드이름을 반품상세등록으로 저장
						sArgument = func_createArgument(sMethodName);					// 메소드이름으로 인자를 생성(3-9)
						$.ajax(sArgument);												// ajax 통신 실행 
					}
				}
				
				/*
				else if( $("#AVB_PNT").val() < cnclPnt ){							// 가용포인트가 적립했던 포인트보다 작다면
					alert("가용포인트가 포인트를 제외한 구매금액의 10% 이상이어야 반품이 가능합니다(현재 가용포인트 : "+$("#AVB_PNT").val()+", 총금액의 10% : "+cnclPnt+")");
					return;															// 함수 종료
				}
				*/
		    }); // end of $("button#test").click(function(){})------------
			
			$("button#close").click(function(){									// 닫기버튼을 눌렀을 때
				closeTabClick();												// 팝업을 닫는다
		    }); // end of $("button#test").click(function(){})------------
	    	
			$(opener).one('beforeunload', function() {							// 부모창의 새로고침/닫기/앞으로/뒤로
				closeTabClick();												// 팝업을 닫는다
            });	// end of $(opener).one('beforeunload', function() {}--------------------
		    
		});	// end of $(document).ready(function(){})----------
	
		// Function Declaration
		
		// ##3-2. 판매상세조회 윗부분(매장) 보여주기
		function showSalDetailInfo(map) {
			$.each(map, function(key, value){							// map에 있는 key/value 한 쌍 각각에 대해 반복
				console.log("key : " + key + " value : " + value);
				$("#"+key).text(value);									// id가 key값인 곳에 value를 넣는다
				$("#COMMA_"+key).text(addComma(value));					// 콤마처리가 필요한 id가 key값인 곳에 콤마처리를 하여 value를 넣는다
			});

			$("#SAL_TP_CD").val(map.SAL_TP_CD);							// 버튼활성화 및 숨김유무를 표시하기 위한 값들을 담아둔다
			$("#ORG_SHOP_CD").val(map.ORG_SHOP_CD);						
			// $("#RTN_CNT").val(map.RTN_CNT);
			$("#FST_USER_ID").val(map.FST_USER_ID);
			
		} // end of function showSalDetailInfo(map) {}-----------
		
		// ##3-3. 반품시 마스터테이블 반품정보 반환을 위한 값을 담는 함수
		function setRetunInfo(map) {
			$.each(map, function(key, value){							// map에 있는 key/value 한 쌍 각각에 대해 반복
				$("#rtnInfoFrm").find("#HID_"+key).val(value);			// form안의 hidden태그에 value를 넣는다
				$("input#"+key).val(value);								// id가 key값인 곳에 value를 넣는다
			});
			
			var cash = parseInt($("#CSH_STLM_AMT").val());		// 숫자타입으로 변환
			var card = parseInt($("#CRD_STLM_AMT").val());		// 숫자타입으로 변환
			var point = parseInt($("#PNT_STLM_AMT").val());		// 숫자타입으로 변환
			var sum = cash + card + point;
			$("#RSVG_PNT").val( (cash + card) * 0.1 * -1 );		// 적립포인트를 음수처리						
			$("#US_PNT").val(point * -1);						// 사용포인트를 음수처리
			$("#IN_TOT_SAL_QTY").val($("#TOT_SAL_QTY").text());									// data 전송용 input 태그에 값을 넘긴다		
			$("#IN_TOT_SAL_AMT").val(sum);
			$("#IN_TOT_VOS_AMT").val( sum - (sum*0.1) );
			$("#IN_TOT_VAT_AMT").val( (sum*0.1) );
			
		} // end of function setRetunInfo(map) {}-----------
		
        // 닫기 버튼을 클릭했을 때 실행하는 함수
		function closeTabClick() {
			window.close();														// 팝업을 닫는다
        } // end of function closeTabClick()------------
        
	</script>

<meta charset="UTF-8">
<title>판매상세조회</title>
</head>
<body>

	<div id="contentContainer">
		
		<div style="margin: auto 0; padding: 20px 10px 5px 10px;">
			<span style="font-size: 20px; padding-left: 10px;">판매상세조회</span>&nbsp;&nbsp;
		</div>
		
		<!-- 해당판매번호의 상세정보 출력부분 시작 -->
		<div id="searchContainer">
			<div id="rowContainer">
				<div class="inline">
					<span class="title_text_2">매장&nbsp;:</span>
					<span id="PRT_CD">&nbsp;&nbsp;</span>
					<span id="PRT_NM"></span>
				</div>
				<div class="inline">
					<span class="title_text_2">고객번호&nbsp;:</span>
					<span id="CUST_NO">&nbsp;&nbsp;</span>
					<span id="CUST_NM"></span>
				</div>
			</div>
			<div id="rowContainer">
				<div class="inline">
					<span class="title_text_2">판매수량&nbsp;:</span>
					<span id="COMMA_TOT_SAL_QTY">0</span>
					<input type="hidden" name ="TOT_SAL_QTY" id="TOT_SAL_QTY" />
				</div>
				<div class="inline">
					<span class="title_text_2">판매금액&nbsp;:</span>
					<span id="COMMA_TOT_SAL_AMT">0</span>
					<input type="hidden" name ="TOT_SAL_AMT" id="TOT_SAL_AMT" />
				</div>
				<div class="inline">
					<span class="title_text_2">현금&nbsp;:</span>
					<span id="COMMA_CSH_STLM_AMT">0</span>
					<input type="hidden" name ="CSH_STLM_AMT" id="CSH_STLM_AMT" />
				</div>
				<div class="inline">
					<span class="title_text_2">카드&nbsp;:</span>
					<span id="COMMA_CRD_STLM_AMT">0</span>
					<input type="hidden" name ="CRD_STLM_AMT" id="CRD_STLM_AMT" />
				</div>
				<div class="inline">
					<span class="title_text_2">포인트&nbsp;:</span>
					<span id="COMMA_PNT_STLM_AMT">0</span>
					<input type="hidden" name ="CRD_STLM_AMT" id="PNT_STLM_AMT" />
				</div>
			</div>
		</div>
		<!-- 해당판매번호의 상세정보 출력부분 끝 -->
		
		<!-- 조회한 결과들을 보여주는 부분 시작 -->
		<div id="popup_table_container">
			<form id="salDetailFrm">
				<table id="tbl_detail" style="margin: 15px auto;">
					<thead id="" style="width: 100%;">
						<tr>
							<th class="border center" style="width:50px; min-width:50px; max-width: 50px;">번호</th>
							<th class="border center" style="width:150px; min-width:150px; max-width:150px;">상품코드</th>
							<th class="border center" style="width:150px; min-width:150px; max-width:150px;">상품명</th>
							<th class="border center" style="width:100px; min-width:100px; max-width:100px;">판매수량</th>
							<th class="border center" style="width:180px; min-width:180px; max-width:180px;">공급가</th>
							<th class="border center" style="width:150px; min-width:150px; max-width:150px;">부가세</th>
							<th class="border center" style="width:200px; min-width:200px; max-width:200px;">판매금액</th>
						</tr>
					</thead>
				
					<tbody id="PERFORM_DISPLAY">
					</tbody>
					<tfoot id="TFOOT_SUM">
						<tr>
							<td colspan="3" class="border right" style="width:50px; min-width:50px; max-width: 50px;">합계</td>
							<td class="border right" style="width:100px; min-width:100px; max-width:100px;">1</td>
							<td class="border right" style="width:180px; min-width:180px; max-width:180px;">2</td>
							<td class="border right" style="width:150px; min-width:150px; max-width:150px;">3</td>
							<td class="border right" style="width:200px; min-width:200px; max-width:200px;">4</td>
						</tr>
					</tfoot>
				</table>
				
				<input type="hidden" name="ORG_SHOP_CD" id="ORG_SHOP_CD" value="" />
				<input type="hidden" name="SAL_TP_CD" id="SAL_TP_CD" value="" />
				<input type="hidden" name="PT_MAP" id="PT_MAP" value="" />
				<input type="hidden" name="FST_USER_ID" id="FST_USER_ID" value="" />
				<input type="hidden" name="SE_USER_ID" id="SE_USER_ID" value="${sessionScope.loginuser.USER_ID}" />
				<input type="hidden" name="SE_PRT_CD" id="SE_PRT_CD" value="${sessionScope.loginuser.PRT_CD}" />
			</form>
		</div>
		<!-- 조회한 결과들을 보여주는 부분 끝 -->
		
		<!-- 반품시 반품정보를 보내주는 form 시작 -->
		<form id="rtnInfoFrm">
			<input type="hidden" name="CUST_NO" id="HID_CUST_NO" value="" />
			<input type="hidden" name="CSH_STLM_AMT" id="HID_CSH_STLM_AMT" value="" /><!-- 받아올땐 id로 받은 뒤 반품시에는 serializeArray로 name이 키가 되게 설정 -->
			<input type="hidden" name="CRD_STLM_AMT" id="HID_CRD_STLM_AMT" value="" /><!-- 받아올땐 id로 받은 뒤 반품시에는 serializeArray로 name이 키가 되게 설정 -->
			<input type="hidden" name="PNT_STLM_AMT" id="HID_PNT_STLM_AMT" value="" /><!-- 받아올땐 id로 받은 뒤 반품시에는 serializeArray로 name이 키가 되게 설정 -->
			<input type="hidden" name="SE_USER_ID" id="HID_SE_USER_ID" value="${sessionScope.loginuser.USER_ID}" /><!-- 받아올땐 id로 받은 뒤 반품시에는 serializeArray로 name이 키가 되게 설정 -->
			<input type="hidden" name="MT_PRT_CD" id="HID_PRT_CD" value="" />
			<input type="hidden" name="SAL_TP_CD" id="HID_SAL_TP" value="RTN" />
			<input type="hidden" name="EDATE" id="EDATE" value="" />
			<input type="hidden" name="ORG_SHOP_CD" id="PRT_CD" value="" /><!-- 받아올땐 id로 받은 뒤 반품시에는 serializeArray로 name이 키가 되게 설정 -->
			<input type="hidden" name="ORG_SAL_DT" id="SAL_DT" value="" /><!-- 받아올땐 id로 받은 뒤 반품시에는 serializeArray로 name이 키가 되게 설정 -->
			<input type="hidden" name="ORG_SAL_NO" id="SAL_NO" value="" /><!-- 받아올땐 id로 받은 뒤 반품시에는 serializeArray로 name이 키가 되게 설정 -->
			<input type="hidden" name="RSVG_PNT" id="RSVG_PNT" value="" />
			<input type="hidden" name="US_PNT" id="US_PNT" value="" />
			<input type="hidden" name="IN_TOT_SAL_QTY" id="IN_TOT_SAL_QTY" value="" />
			<input type="hidden" name="IN_TOT_SAL_AMT" id="IN_TOT_SAL_AMT" value="" />
			<input type="hidden" name="IN_TOT_VOS_AMT" id="IN_TOT_VOS_AMT" value="" />
			<input type="hidden" name="IN_TOT_VAT_AMT" id="IN_TOT_VAT_AMT" value="" />
			<input type="hidden" name="CRD_NO" id="HID_CRD_NO" value="" />
			<input type="hidden" name="VLD_YM" id="HID_VLD_YM" value="" />
			<input type="hidden" name="CRD_CO_CD" id="HID_CRD_CO_CD" value="" />
		
		</form>
		<!-- 반품시 반품정보를 보내주는 form 끝 -->
		
	</div>

	<!-- 닫기 버튼이 포함된 부분 시작 -->
	<div id="container_btn" style="padding: 0 auto; text-align: center;">
		<button type="button" id="close" class="btn btn-secondary" >닫기</button>
		<span style="padding: 10px 20px 10px 0;"></span>
		<button type="button" id="return" class="btn btn-secondary" >반품</button>
	</div>
	<!-- 닫기 버튼이 포함된 부분 끝 -->
	
</body>
</html>