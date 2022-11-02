$(document).ready(function() {								// 페이지가 로딩되었을 때 시작하는 부분




}); // end of $(document).ready(function() {}------------------------

// ## 피드백 이후 고객판매관리 쿼리에서 가져온 합계 입력하는 함수
function getTotal(item, sKind) {
	
	if(sKind == "SEARCHSALLIST") {														// 종류가 고객판매관리목록이라면
		$("#TFOOT_SUM").find("#TOTAL_QTY").text(addComma(item.TOT_SAL_QTY));			// TFOOT에 총합계수량을 입력한다
		$("#TFOOT_SUM").find("#TOTAL_AMT").text(addComma(item.TOT_SAL_AMT));			// TFOOT에 총합계금액을 입력한다
		$("#TFOOT_SUM").find("#TOTAL_CSH_AMT").text(addComma(item.CSH_STLM_AMT));		// TFOOT에 총현금액을 입력한다
		$("#TFOOT_SUM").find("#TOTAL_CRD_AMT").text(addComma(item.CRD_STLM_AMT));		// TFOOT에 총카드금액을 입력한다
		$("#TFOOT_SUM").find("#TOTAL_PNT_AMT").text(addComma(item.PNT_STLM_AMT));		// TFOOT에 총포인트액을 입력한다
	}
	
	is_exist = false;																	// flag 초기화
	$("tfoot#TFOOT_SUM").show();														// TFOOT을 보여준다
} // end of function getTotal(item, sKind) {}---------------

// ##2-6 판매수량에 따라 판매금액을 알아오는 함수
function getRowAmt(loc) {
	var qty = parseInt( loc.find("#CUST_SAL_QTY").val().split(',').join("") );	// 해당 row의 판매수량을 읽어온 뒤 숫자로 변환한다
	var upr = parseInt( loc.find("#PRD_CSMR_UPR").text().split(',').join("") ); // 해당 row에 소비자가를 읽어온 뒤 숫자로 변환한다
	if(isNaN(qty)){			// 수량이 존재하지 않는다면
		qty = parseInt(0);	// 수량을 0으로 한다
	}
	
	if(isNaN(upr)){			// 소비자가가 존재하지 않는다면
		upr = parseInt(0);	// 소비자가를 0으로 한다
	}
	
	loc.find("#SAL_AMT").text( addComma(qty*upr) );								// 판매수량과 소비자가를 곱하여 해당 row의 판매금액에 입력한다
	getTotalPrd(loc);	// 총판매수량과 총판매금액을 구하는 함수 실행
	
} // end of function getRowAmt() {}-------------



// ##2-7 총판매수량과 총판매금액을 구하는 함수
function getTotalPrd() {
	
	var len = $("#TBODY tr").length;			// 상품입력 row 개수를 구한다
	var TOT_QTY = parseInt(0);					// 총 판매수량을 담을 변수 선언
	var TOT_AMT = parseInt(0);					// 총 판매금액을 담을 변수 선언

    for( let i = 0; i < len; i++ ) { 			// row의 개수만큼 반복
		
		var qty = $("#TBODY").find("tr:eq("+i+")").find("#CUST_SAL_QTY").val();		// i+1 번째 row의 수량을 얻는다
		var amt = $("#TBODY").find("tr:eq("+i+")").find("#PRD_CSMR_UPR").text();	// i+1 번째 row의 판매금액을 얻는다
		qty = qty.split(',').join("");			// 콤마제거
		qty = parseInt(qty);					// 숫자처리하여 담는다
		if( (!isNaN(qty)) && qty != ""){		// 수량이 비어있지 않거나 숫자라면
			
			TOT_QTY += qty;						// 총합계수량에 해당 i번째 row의 수량을 더한다
			
			amt = amt.split(',').join("");		// 콤마제거
			TOT_AMT += parseInt(amt) * qty;		// 총합계금액에 i번째 row의 소비자가* 수량을 더한다
		}
		
    }

	$("#TOT_SAL_QTY").text(addComma(TOT_QTY));	// 콤마처리하여 합계수량을 표시
	$("#TOT_SAL_AMT").text(addComma(TOT_AMT));	// 콤마처리하여 합계금액을 표시
	
	loc = "";									// 위치를 담는 변수값을 초기화한다
    
} // end of function getTotalPrd() {}----------------------