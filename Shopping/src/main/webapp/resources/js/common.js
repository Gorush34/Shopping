$(document).ready(function() {								// 페이지가 로딩되었을 때 시작하는 부분




}); // end of $(document).ready(function() {}------------------------

// yyyymmdd 형을 yyyy-mm-dd형식으로 바꿔줌
function convertDateFormat(date) {
    var year = date.substr(0,4);												// 연도를 추출한다
    var month = date.substr(4,2);												// 월을 추출한다
    var day = date.substr(6,8);													// 일을 추출한다
    return [year, month, day].join('-');										// 사이를 '-'로 이어준 뒤 반환
} // end of function convertDateFormat(date) {}------------------


// 날짜를 yyyy-mm-dd 형식으로 만들어 줌.
function date_masking(objValue) {
 	var v = objValue.replace("--", "-");										// -- 가 이어지면 -로 교체

    if (v.match(/^\d{4}$/) !== null) {											// 앞의 년도가 yyyy형식으로 채워지면
        v = v + '-';															// yyyy-로 바꿔준다
    } else if (v.match(/^\d{4}\-\d{2}$/) !== null) {							// yyyy-mm형식으로 채워지면
        v = v + '-';															// yyyy-mm-로 바꿔준다
    }
 
    return v;																	// 종료
} // end of function date_masking(objValue) {})------------------

// 자동으로 콤마 넣기(시작부분)
function inputNumberFormat(obj) {
     obj.value = addComma(removeComma(obj.value));								// 콤마를 제거한 값에 콤마처리를 한다
}

//천단위 콤마 펑션
function addComma(value){
     value = value.toString();													// 값을 문자열형태로 받아온다
	 value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");						// 3자리마다 ,를 추가해준다
     return value; 																// 변환한 값을 return

	 //return value.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
} // end of function addComma(value){}-------------

//콤마 제거
function removeComma(value){
     value = value.split(',').join("");											// 콤마를 제거
     return value; 																// 변환한 값을 return
} // end of function removeComma(value){}-------------

// 오늘날짜 가져오기
function getToday(){
    var date = new Date();														// Date 객체 생성
    var year = date.getFullYear();												// 현재년도를 받아옴
    var month = ("0" + (1 + date.getMonth())).slice(-2);						// 현재월을 받아옴
    var day = ("0" + date.getDate()).slice(-2);									// 현재일자를 받아옴

    return year + "-" + month + "-" + day;										// 사이를 '-'로 이은 뒤 반환
} // end of function getToday(){}---------------------

// 하이픈(-) 제거
function removeHyphen(obj) {
	
	var value = obj.replace(/[-]/gi, '');		// 문자 '-' 를 제거한다
	return value;								// 제거한 값을 반환
	
} // end of function removeHyphen(obj)----------------

// 날짜 형식의 값들 하이픈 제거
function dateOnlyNumber() {
	
	$("#BRDY_DT").val( removeHyphen($("#BRDY_DT").val()) );
	$("#MRRG_DT").val( removeHyphen($("#MRRG_DT").val()) );
	$("#JS_DT").val( removeHyphen($("#JS_DT").val()) );
	$("#STP_DT").val( removeHyphen($("#STP_DT").val()) );
	$("#CNCL_DT").val( removeHyphen($("#CNCL_DT").val()) );
	
} // end of function dateOnlyNumber() {}-------------------

// 팝업창 닫기를 클릭했을때 실행되는 함수
function closePopUp() {
	window.close();																// 팝업을 닫는다
} // end of function closePopUp()---------------------------

// 과제3 판매등록에서 + 버튼 클릭시 테이블 행 추가 함수
function addRow() {
	
	$("#tbl_detail").append(	// 상세테이블에 더한다
		 "<tr><td class='center' style='width:50px; min-width:50px; max-width: 50px;'><input type='checkbox' name='chBox' class='chkBox'/></td>"
		+"<td class='center' id='NM' style='width:50px; min-width:50px; max-width: 50px;'></td>"
		+"<td class='center' style='width:150px; min-width:150px; max-width:150px;'>"
		+"<input type='text' class='small enter_prd blank_key' id='PRD_CD' name='PRD_CD' value='' maxlength='9'/>"
		+"<button type='button' id='btn_search_prd' class='btn btn-secondary' style='margin-bottom: 5px; margin-left: 5px; width: 25px; height: 25px; padding: 0 0 0 5px;' >"
		+"<span style='padding-right: 10px;'><i class='fa fa-search' aria-hidden='true' style='font-size:15px;'></i></span></button></td>"
		+"<td class='right' id='PRD_NM' style='width:230px; min-width:230px; max-width:230px;'></td>"
		+"<td class='right' id='IVCO_QTY' style='width:100px; min-width:100px; max-width:100px;'></td>"
		+"<td class='right' id='' style='width:180px; min-width:100px; max-width:100px;'><input type='text' class='ONLYNM' id='CUST_SAL_QTY' name='CUST_SAL_QTY' style='width:80px; font-size:80%; text-align:right;' value='' readonly/></td>"
		+"<td class='right' id='PRD_CSMR_UPR' style='width:150px; min-width:150px; max-width:150px;'></td>"
		+"<td class='right' id='SAL_AMT' style='width:200px; min-width:200px; max-width:200px;'></td>"
		+"</tr>"
	);
	
	insertSeq();	// 새로 판매번호를 넣어준다
	
} // end of addRow() {}----------------------

// 과제3 판매등록에서 체크박스로 선택한 뒤 -버튼 클릭시 테이블 행 삭제
function deleteRow() {
	
	if( $("#TBODY tr").length == 1 ) {										// 하나의 행만 남은 경우
		alert("하나의 상품은 반드시 존재해야 합니다!");
		return;	
	}
	else if($("input:checkbox[name='chBox']:checked").length === 0 ) {		// 삭제할 행을 선택하지 않은 경우
		alert("삭제할 행을 선택해주시기 바랍니다.");
		return;
	}
	else if( $("#TBODY tr").length != 1 && $("#TBODY tr").length == ( $("input:checkbox[name='chBox']:checked").length ) ) {
		alert("적어도 하나의 상품입력란은 존재해야 합니다!");							// 전체 행을 선택한 뒤 삭제할 경우
		return;
	}
	
	$("input:checkbox[name='chBox']:checked").each(function(key, value){	// 체크한 행 각각에 대해서 실행
		let selectedRow = value.parentElement.parentElement;				// 체크박스 위치를 기준으로 해당 row의 위치를 저장
		$(selectedRow).remove();											// 삭제한다
	});
	
	insertSeq();	// 새로 판매번호를 넣어준다
	getTotalPrd();	// 총계를 구하는 함수 실행
	
} // end of deleteRow() {}----------------------

// 고객판매수금등록에서 행을 한 행만 남기고 모두 지우는 함수
function resetRow() {
	
	var len = $("#TBODY tr").length;		// TBODY의 행 개수를 얻어온다
	for(let i=0; i<len; i++){				// 행 개수만큼 반복한다
	  $('#TBODY tr:last').remove();			// 가장 마지막 행을 삭제한다
	}
	
	addRow();								// 한 행을 더한다
	getTotalPrd();							// 총합계를 초기화한다(금액계산함수 실행)
} // end of function resetRow() {}-----------

// 행의 번호를 순서대로 넣어주는 함수
function insertSeq() {
	for(var i = 0; i<$("#TBODY tr").length; i++)				// 테이블 전체 행만큼 반복
	{
		tbl_detail.rows[i+1].cells[1].innerHTML = i+1;			// 순서대로 번호를 넣는다
	}
} // end of function insertSeq(){}-----------------

// 1자리 문자열의 경우 앞자리에 숫자 0을 자동으로 채워 00형태로 출력하기위한 함수
function autoLeftPad(num, digit) {
    if(String(num).length < digit) {
        num = new Array(digit - String(num).length + 1).join('0') + num;
    }
    return num;
} // end of function autoLeftPad(num, digit) {}------------ 

// 메소드이름에 따라 필요한 파라미터를 모아서 리턴해주는 함수
function convertData(sMethodName) {
	
	var param;																			// parameter를 담을 변수 선언
	if( sMethodName == "INSERTSAL" ){													// ##피드백2#############. 메소드이름이 판매등록이라면
		var len = $("#TBODY tr").length;												// 상품입력 row 개수를 구한다(TBODY의 길이)
		var cnt = 0;																	// 판매일련번호를 넣기 위한 변수 선언
		var obj = {};
		for( let i = 0; i < len; i++ ) { 												// row의 개수만큼 반복
			var amt = $("#TBODY").find("tr:eq("+i+")").find("#SAL_AMT").text();			// TBODY i번째 판매금액의 값을 담는다
			var ch_prd_cd = $("#TBODY").find("tr:eq("+i+")").find("#PRD_CD").val();		// TBODY i번째 상품코드의 값을 담는다
			var ch_qty = $("#TBODY").find("tr:eq("+i+")").find("#CUST_SAL_QTY").val();	// TBODY i번째 판매수량의 값을 담는다
			if( amt != "" && ch_prd_cd != "" && ch_qty != "") {							// 상품코드, 수량, 판매금액이 존재한다면
				cnt = cnt + 1;															// cnt를 1 더한다
				var tr = $("#TBODY").find("tr:eq("+i+")");								// TBODY의 i번째 tr의 위치를 담는다
				var qty = parseInt( tr.find("#CUST_SAL_QTY").val() );					// 판매수량을 변수에 담는다
				var amt = removeComma( tr.find("#SAL_AMT").text() );					// 판매금액을 변수에 담는다
				var vat = amt * 0.1;													// 부가세액을 변수에 담는다( 부가세액 = 소비자판매가 * 10%)
				var vos = amt - ( amt * 0.1 );											// 공급가액을 변수에 담는다( 공급가액 = 소비자판매가 - (소비자판매가 - 10%) )
				var prd = {																// 상품정보를 담을 객체 prd 선언
					"PRT_CD" : $("#SE_PRT_CD").val(),									// 매장코드를 담는다
					"SAL_DT" : removeHyphen($("#EDATE").val()),							// 판매일자를 담는다							
					"SAL_NO" : "판매번호",												// 판매번호를 담는다
					"SAL_SEQ" : cnt,													// 판매일련번호를 담는다
					"PRD_CD" : tr.find("#PRD_CD").val(),								// 상품코드를 담는다
					"PRD_CSMR_UPR" : removeComma( tr.find("#PRD_CSMR_UPR").text() ),	// 소비자단가를 담는다				
					"SAL_QTY" : qty,													// 판매수량를 담는다				
					"SAL_AMT" : amt,													// 판매금액을 담는다
					"SAL_VOS_AMT" : vos,												// 공급가를 담는다
					"SAL_VAT_AMT" : vat,												// 부가세를 담는다
					"FST_USER_ID" : $("#SE_USER_ID").val(),								// 최초등록자(로그인유저)를 담는다
					"SAL_TP" : "SAL"													// 판매구분을 판매로 설정
				}
				console.log(prd);
				paramArr.push(prd);														// 객체를 배열에 넣는다
			}
		} // end of for--------------
		
		if(paramArr.length == 0){														// 입력할 data를 담는 배열의 크기가 0이라면
			isEmpty = true;																// 배열이 비었는지 확인하는 변수 true 설정
		}
		else {
			var masterMap = $("#registrSalFrm").serializeArray();						// 판매마스터테이블에 담을 정보들을 name/value를 한쌍으로 배열에 담는다
			masterMap = convertKeyValue(masterMap);										// name/value로 이루어진 것을 key/value 형태로 객체에 담는다
			obj = {	"masterMap" : masterMap,											// 마스터테이블 / 상세테이블에 담을 정보를 객체 obj에 담는다
					"detailList" : paramArr  };
		}

		console.log(paramArr);
		param = obj;
		
		console.log(obj);																// 배열을 param에 넣는다
	} // end of if( sMethodName == "INSERTSAL" ){}------------------------
	else if ( sMethodName == "INSERTRTN" ) {											// ##피드백2#############. 메소드이름이 반품등록이라면
		var obj = {};																	// 파라미터들을 담을 객체 선언
		var len = $("#PERFORM_DISPLAY tr").length;										// 상품상세 row 개수를 구한다
		for( let i = 0; i < len; i++ ) { 												// row의 개수만큼 반복
			var tr = $("#PERFORM_DISPLAY").find("tr:eq("+i+")");						// TBODY의 i번째 tr의 위치를 담는다
			var td = tr.children();														// 해당 row의 td 위치를 담는다
			var upr = removeComma(td.eq(6).text()) / removeComma(td.eq(3).text()) ;		// 제품 1개의 소비자단가를 얻어온다
			
			var prd = {																	// 상품정보를 담을 객체 prd 선언
				"PRT_CD" : $("#PRT_CD").text(),											// 매장코드를 담는다
				"SAL_DT" : removeHyphen($("#EDATE").val()),								// 판매일자를 담는다							
				"SAL_NO" : "판매번호",													// 판매번호를 담는다
				"SAL_SEQ" : td.eq(0).text(),											// 판매일련번호를 담는다
				"PRD_CD" : td.eq(1).text(),												// 상품코드를 담는다
				"PRD_CSMR_UPR" : upr,													// 소비자단가를 담는다					
				"SAL_QTY" : removeComma(td.eq(3).text()),								// 판매수량를 담는다				
				"SAL_AMT" : removeComma(td.eq(6).text()),								// 판매금액을 담는다
				"SAL_VOS_AMT" : removeComma(td.eq(4).text()),							// 공급가를 담는다
				"SAL_VAT_AMT" : removeComma(td.eq(5).text()),							// 부가세를 담는다
				"FST_USER_ID" : $("#SE_USER_ID").val(),									// 최초등록자(로그인유저)를 담는다
				"SAL_TP" : "RTN"														// 판매구분을 반품으로 설정
			}
			paramArr.push(prd);															// 객체를 배열에 넣는다
			console.log(prd);
		} // end of for--------------
		
		var masterMap = $("#rtnInfoFrm").serializeArray(); 
		masterMap = convertKeyValue(masterMap);										// name/value로 이루어진 것을 key/value 형태로 객체에 담는다
		obj = {	"masterMap" : masterMap,											// 마스터테이블 / 상세테이블에 담을 정보를 객체 obj에 담는다
				"detailList" : paramArr  };
		
		console.log(paramArr);
		param = obj;	
		
		console.log(obj);
	} // end of else if ( sMethodName == "INSERTRTN" ) {}-----------------------
	else if( sMethodName == "REALTIMECHECKPRODUCT" ) {
		
		debugger;
		var obj = {};																// 파라미터들을 담을 객체 선언
		var USE_POINT = removeComma( $("#PNT_STLM_AMT").val() );					// 사용포인트를 콤마를 제거한 뒤 넣는다
		if(USE_POINT == ""){														// 사용포인트가 없다면
			USE_POINT = 0;															// 0을 넣는다
		}
		
		var custStatus = {															// 고객상태를 담는 객체 선언
			"CUST_NO" : $("#CUST_NO").val(),										// 고객번호를 담는다
			"AVB_PNT" : removeComma( $("#AVB_PNT").val() ),							// 가용포인트를 담는다
			"USE_POINT" : USE_POINT,												// 사용포인트를 담는다
			"TOT_SAL_AMT" : removeComma( $("#TOT_SAL_AMT").text() )					// 총합계금액을 담는다
		};
		
		var len = $("#TBODY tr").length;											// 상품입력 row 개수를 구한다(TBODY의 길이)
		var row = 0;																// 몇번째 행의 상품인지 확인하기 위한 변수 선언
		for( let i = 0; i < len; i++ ) { 											// row의 개수만큼 반복
			var tr = $("#TBODY").find("tr:eq("+i+")");								// TBODY의 i번째 tr의 위치를 담는다
			var prd_cd = tr.find("#PRD_CD").val();
			var qty = parseInt( tr.find("#CUST_SAL_QTY").val() );					// 판매수량을 변수에 담는다
			var amt = removeComma( tr.find("#SAL_AMT").text() );					// 판매금액을 변수에 담는다
			row = row + 1;															// row에 1을 더한다
			if( prd_cd != "" && qty != "" && amt != "") {							// 상품코드 수량 판매금액이 존재한다면
				var prd = {																// 상품정보를 담을 객체 prd 선언
					"ROW" : row,
					"PRT_CD" : $("#SE_PRT_CD").val(),									// 매장코드를 담는다
					"PRD_CD" : prd_cd,								// 상품코드를 담는다
					"PRD_CSMR_UPR" : removeComma( tr.find("#PRD_CSMR_UPR").text() ),	// 소비자단가를 담는다				
					"SAL_QTY" : qty,													// 판매수량를 담는다				
					"SAL_AMT" : amt,													// 판매금액을 담는다
					"SAL_TP" : "SAL"													// 판매구분을 판매로 설정
				}
				paramArr.push(prd);														// 객체를 배열에 넣는다
			}
		} // end of for--------------
		
		obj = {	"custStatus" : custStatus,											// 고객정보와 판매할 제품정보를 담는다
				"prdList" : paramArr  };
				
		param = obj;																// 파라미터에 객체 obj를 담는다
		// console.log(obj);
		
	} // end of else if( sMethodName == "REALTIMECHECKPRODUCT" ) {}---------------
	
	
	return param;																		// 그 값을 return
} // end of function convertData(sMethodName) {}------------

// name/value를 key/value로 변환하는 함수
function convertKeyValue(data) {
	var map = {};
	
	$.each(data, function(){						
		map[this.name] = this.value;
	});
	
	return map;
} // end of function convertKeyValue(data) {}-----------
