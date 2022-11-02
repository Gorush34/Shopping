$(document).ready(function() {								// 페이지가 로딩되었을 때 시작하는 부분

	$(".chkBox").click(function() {
		$("input.chkBox").not(this).prop('checked', false); 		// 클릭하지 않은 다른 체크박스의 체크를 해제한다. 
	});		

}); // end of $(document).ready(function() {}------------------------

// Function Declaration

// 검색시 유효성 검사를 실행하는 함수
function checkWord(obj) {
	
	let search_length = obj.length;												// 고객이름의 길이를 알아온다
	
	var regex = RegExp(/[가-힣a-zA-Z0-9\s]{2,20}$/);								// 2-20글자 사이에 완전한 음절과 영어가 들어갔는지 체크하는 정규표현식
	var regex2 = RegExp(/[ㄱ-ㅎㅏ-ㅣ]+/);											// 자음, 모음이 한글자라도 있는지 체크하는 정규표현식
	var pattern = /\s/g;														// " "공백(스페이스)이 있는지 체크하는 정규표현식
	
	if( (!regex.test(obj) && search_length != 0) || regex2.test(obj) ) { 		// 공란이 아니거나 고객이름 정규표현식에 맞지 않다면
		alert("검색어는 특수문자 및 공백을 제외한 최소 두글자 이상 한글 혹은 숫자로 입력하셔야 합니다.");
		return false;															// false를 반환
	}
	/*else if( obj.match(pattern) ){											// 공백이 체크되었다면(공백검사시 주석제거)
		alert("검색시 공백은 허용하지 않습니다.");
		return false;															// false를 반환
	}*/
	else if(search_length == 0) {												// 아무것도 적지 않았다면
		return true;															// true를 반환
	}
	else {																		// 위의 경우들을 제외한 나머지
		return true;															// true를 반환
	}
	
} // end of function checkWord() {})---------------------

// 중복검사 버튼 클릭시 실행 함수
function checkDuplicated(obj) {
	
	if(obj == "email") {		// 체크할 대상이 이메일이라면
		var email = $("#EMAIL1").val() + "@" + $("#EMAIL2").val();	// 이메일 입력값을 하나로 완성하여 저장
		$("#EMAIL").val(email);										// input(hidden)태그에 email값을 저장
		if( checkText(email, "EMAIL") ){							// 정규표현식에 맞는다면
			compareItem(email, "EMAIL");							// 이메일 중복검사 실행
		}
	}
	else if(obj == "mbl") {		// 체크할 대상이 핸드폰번호라면
		var mbl = $("#MBL1").val() + $("#MBL2").val() + $("#MBL3").val();	// 핸드폰 입력값을 하나로 완성하여 저장
		var reg = RegExp(/^01([0|1|6|7|8|9]?)$/);
		if( $("#MBL2").val().length == 4 && $("#MBL3").val().length == 3 || $("#MBL1").val().length != 3 ) {	// 휴대폰입력자릿수가 자리에 맞지 않을 경우
			alert("휴대전화번호가 10자리인 경우 첫번호가 3자리, 중간번호가 4자리여야 합니다.");
			return;
		}
		/*else if( !reg.test($("#MBL1").val()) ) {
			alert("휴대전화 앞자리를 형식에 맞춰 입력해주세요.");
			$("#MBL1").focus();
			return;
		}*/
		$("#MBL_NO").val(mbl);										// input(hidden)태그에 mbl값을 저장
		if( checkText(mbl, "MBL") ){								// 정규표현식에 맞는다면
			compareItem(mbl, "MBL");								// 휴대폰 중복검사 실행
		}
	}
	
} // end of function checkDuplicated(obj) {}--------------------

// 항목에 대한 유효성검사를 실시하는 함수(시험용)
function checkText(obj, type) {
	
	let text_length = obj.length;													// 고객이름의 길이를 알아온다
	
	if(type == "NM") {		// 유효성 검사할 대상이 이름이라면
		var regex = RegExp(/[가-힣a-zA-Z0-9]{2,10}$/);								// 2-20글자 사이에 완전한 음절과 영어가 들어갔는지 체크하는 정규표현식
		var regex2 = RegExp(/[ㄱ-ㅎㅏ-ㅣ]+/);											// 자음, 모음이 한글자라도 있는지 체크하는 정규표현식
		var pattern = /\s/g;														// " "공백(스페이스)이 있는지 체크하는 정규표현식
		
		if( (!regex.test(obj) && text_length != 0) || regex2.test(obj) ) { 			// 공란이 아니거나 고객이름 정규표현식에 맞지 않다면
			alert("이름은 특수문자 및 공백을 제외한 최소 두글자 이상 한글 혹은 숫자로 입력하셔야 합니다.");
			return false;															// false를 반환
		}
		else if( obj.match(pattern) ){												// 공백이 체크되었다면
			alert("검색시 공백은 허용하지 않습니다.");
			return false;															// false를 반환
		}
		else {																		// 위의 경우들을 제외한 나머지
			return true;															// true를 반환
		}
	}
	else if(type == "EMAIL") { 	// 유효성 검사할 대상이 이메일이라면
		const regExp = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i); // 이메일 정규표현식
		if( !regExp.test(obj) ){													// 이메일주소가 정규표현식에 맞지 않다면
			alert("이메일주소를 정확하게 입력해주세요.");
			return false;															// false를 반환
		}
		else{																		// 공란이거나 핸드폰번호 정규표현식에 맞다면
			return true;															// true를 반환
		}
	}
	else if(type == "MBL") { 	// 유효성 검사할 대상이 핸드폰이라면
		var mofmt = RegExp(/[0-9]{10,11}$/);										// 핸드폰번호는 10-11자리 숫자만 들어가게끔 정규표현식을 선언한다
		if( !mofmt.test(obj) || text_length > 11 ){									// 핸드폰번호가 11자리 초과거나 정규표현식에 맞지 않다면
			alert("핸드폰번호는 공백없이 숫자로만 10~11자리 입력하셔야 합니다!");
			return false;															// false를 반환
		}
		else{																		// 공란이거나 핸드폰번호 정규표현식에 맞다면
			return true;															// true를 반환
		}
	}

} // end of function checkText(obj, type) {}-----------------

// DB를 통해 비교하여 중복검사를 실행하는 함수
function compareItem(obj, type) {
	
	var tp = "";							// 검사대상 텍스트 출력 변수 선언
	if(type == "MBL") { tp = "핸드폰"; }		// type이 MBL 이면 핸드폰
	else { tp ="이메일"; }					// 외엔 이메일
	
	$.ajax({
		url:"/shopping/compareItem.dowell",
		data:{"item": obj,
			  "type": type}, 
		type: "post" , 
		dataType: "json",
		success: function(json){	
           if(json.result == "0" && type == "MBL" && obj != "0000000000" && obj != "00000000000" ) {  // 중복값이 없고 type이 MBL 이면
           		alert(tp +" "+ obj +" 은(는) 가입이 가능합니다!" );
           		flag_mblDuplicated = true;						// 핸드폰 중복검사 flag를 true로 변경
           		$("#checkMblDuplicated").css("background-color","green");
           } 
		   else if(obj == "0000000000" && type == "MBL") {		// 휴대폰번호가 0으로 10개 구성되어 있다면
        	   alert("000-000-0000 은 사용할 수 없는 핸드폰 번호입니다!");
           }
		   else if(obj == "00000000000" && type == "MBL") {		// 휴대폰번호가 0으로 11개 구성되어 있다면
        	   alert("000-0000-0000 은 사용할 수 없는 핸드폰 번호입니다!");
           } 
           else if(json.result == "0" && type == "EMAIL") {		// 중복값이 없고 type이 EMAIL 이면
        	   alert(tp +" "+ obj +" 은(는) 가입이 가능합니다!" );
        	   flag_emailDuplicated = true;						// 이메일 중복검사 flag를 true로 변경
        	   $("#checkEmailDuplicated").css("background-color","green");
           }
           else {												// 중복값이 존재하면
        	   alert(tp +" "+ obj +" 은(는) 이미 사용중입니다. 다른 "+tp+"을(를) 입력해주세요." );
           }
		}, 
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
		
	}); // end of $.ajax({})
	
} // end of function compareItem(obj, type) {}--------------------

// 필수입력항목을 검사하는 함수
function reqCheck() {
	
	let b_FlagRequiredInfo = false;									// 필수입력유무를 판별하는 flag 선언(기본값 false)
	
	$("input.req").each(function(index, item) {						// 태그의 class가 필수입력항목인 것에 대해서 각각 실행
		const data = $(item).val().trim();							// 공백을 제거한 값이
		if(data == ""){												// 비었다면
			console.log("item : " + data);
			// alert("*표시된 필수입력사항은 모두 입력하셔야 합니다.");
			if(this.id == "CUST_NM"){								// 비어있는 값이 고객명
				alert("이름은 필수입력사항입니다!");
				$("#"+this.id).focus();
			} else if(this.id == "CUST_NO"){	// 비어있는 값이 고객명(수금등록전용)
				alert("고객번호는 필수입력사항입니다!");
				$("#IN_CUST_NO").focus();
			} else if(this.id == "BRDY_DT"){						// 비어있는 값이 생년월일
				alert("생년월일은 필수입력사항입니다!");
				$("#"+this.id).focus();
			} else if(this.id == "MBL1" || this.id == "MBL2" || this.id == "MBL3"){ // 비어있는 값이 핸드폰번호
				alert("휴대폰번호는 필수입력사항입니다!");
				$("#"+this.id).focus();
			} else if(this.id == "POC_CD" && data == ""){			// 비어있는 값이 직업코드
				alert("직업코드는 필수입력사항입니다!");
				$("#"+this.id).focus();
			} else if(this.id == "EMAIL1" || this.id == "EMAIL2"){ // 비어있는 값이 이메일
				alert("이메일은 필수입력사항입니다!");
				$("#"+this.id).focus();
			} else if(this.id == "JN_PRT_CD" && from_csm != true){ 				// 비어있는 값이 가입매장
				alert("가입매장은 필수입력사항입니다!");
				$("#"+this.id).focus();
			} else if(this.id == "JN_PRT_CD" && from_csm == true){ 				
				return false;
			} 
			
			b_FlagRequiredInfo = true;								// flag에 true를 담는다
			return false; 											// 종료
		}
	});
	
	
	if(b_FlagRequiredInfo) {										// flag가 true라면(필수입력항목이 충족이 안되었다면)
		console.log("b_FlagRequiredInfo : " + b_FlagRequiredInfo);
		return;														// 함수 종료
	} else if( $("[name='POC_CD'").val() == "") {					// select가 선택되어지지 않았다면
		  	alert("*표시된 필수입력사항은 모두 선택 혹은 입력하셔야 합니다.");
			b_FlagRequiredInfo = true;								// flag에 true를 담는다
			return false;
	} else {														// 모든 조건이 충족되었다면
		flag_req = true;											// 필수입력항목 flag에 true를 담는다
		from_csm = false;
		return true;	
	}
	
} // end of function reqCheck() {}---------------------

// 각 항목에 대한 유효성 검사를 실시하는 부분
function checkInfo() {	
	if( !checkWord($("#CUST_NM").val()) ){														// 이름이 정규표현식에 위배된다면
		return false;																			// 함수 종료
	} else if( !(flag_mblDuplicated && flag_emailDuplicated) ){ 								// 두개의 중복검사를 모두 완료하지 않았다면 
		alert("휴대폰 / 이메일 중복검사를 실시해주세요.");												
		return false;																			// 함수 종료
	} else if(     ( $.trim($('#ADDR').val()) != '' && $.trim($('#ADDR_DTL').val()) == '' ) 	// 주소 및 상세주소 중 하나만 입력되었다면
			    || ( $.trim($('#ADDR').val()) == '' && $.trim($('#ADDR_DTL').val()) != '' ) ) {
		alert("주소와 상세주소는 둘 다 비워두거나 채워주셔야 합니다.");
		return false;																			// 함수 종료
	} else if( !checkWord($("#PRD_CD").val()) ) {
		return false;
	} else {																					// 모든 유효성 검사에서 통과되었다면
		if( $("#MRRG_DT").val() == "" ) { $("#MRRG_DT").val(""); }								// 결혼기념일을 설정안하였으면 값 없앰
		return true;
	}
	
	
	
} // end of end of function checkInfo()---------------------------

// 정보의 변경이 일어난다면 변경사항을 담아두는 함수
function checkChanged(orgFrm, chgFrm) {

	var orgArr = $("#"+orgFrm).serializeArray();	// 처음 조회했을 때의 고객정보가 담겨있는 form 의 내용들을 serialize
	var chgArr = $("#"+chgFrm).serializeArray();	// 화면에 표시된 고객정보가 담겨있는 form 의 내용들을 serialize

	var CUST_NO = $("#ORG_CUST_NO").val();			// 데이터 비교대상인 고객번호를 가져온다(객체에 넣을 목적)
	var status = $("#BF_SS_CD").val();				// 현재 고객상태를 확인(checkCustStatus() 참조)
	
	for(var i =0; i< orgArr.length; i++){			// 기존정보의 배열길이만큼 반복
		var org_key = orgArr[i].name;				// 기존정보의 key를 담는다
			org_key = org_key.substr(4, org_key.length); // 기존정보의 key를 비교대상의 key의 이름과 일치시킨다
		var org_value = orgArr[i].value;			// 기존정보의 value를 담는다
		
		for(var j=0; j< chgArr.length; j++) {				// 화면에 표시된 배열길이만큼 반복
			var chg_key = chgArr[j].name;					// 표시된 정보의 key를 담는다
			var chg_value = chgArr[j].value;				// 표시된 정보의 value를 담는다
			org_value = org_value.replace(/[-]/gi, '');		// 기존 내용의 문자 '-' 를 제거한다
			chg_value = chg_value.replace(/[-]/gi, '');		// 변경된 내용의 문자 '-' 를 제거한다
			
			if( org_key == chg_key && $.trim(org_value) != $.trim(chg_value) && ( org_key != "PRT_CD_NM" || chg_key != "PRT_CD_NM" ) ) {	// key값이 일치하지만 value가 다를 때
				
				flag_changed = true;								// 변경사항 유무 flag를 true로 설정(변경됨)
				
				var chg = {											// 변경사항을 담을 객체 chg 선언
					"CUST_NO" : CUST_NO,							// 고객번호
					"CHG_CD" : chg_key,								// 변경항목코드
					"CHG_BF_CNT" : org_value,						// 변경전내용
					"CHG_AFT_CNT" : chg_value,						// 변경후내용
					"UPD_ID" : $("#SE_USER_ID").val()				// 수정자아이디
				}
				
				changeArr.push(chg);								// 객체를 List에 담는다	
				
				
				// alert("변경사항 : " + chg_key + " 변경 전 내용 : " + org_value + " 변경 후 내용 : " + chg_value );
			}
			else if( status == "90" && chg_key == "MBL_NO" && org_key == chg_key && org_key != "00000000000" ) { // 변경한 고객상태가 해지라면(휴대전화)
				
				var chg = {											// 변경사항을 담을 객체 chg 선언
					"CUST_NO" : CUST_NO,							// 고객번호
					"CHG_CD" : chg_key,								// 변경항목코드
					"CHG_BF_CNT" : org_value,						// 변경전내용
					"CHG_AFT_CNT" : "00000000000",					// 휴대전화번호를 0으로 설정
					"UPD_ID" : $("#SE_USER_ID").val()				// 수정자아이디
				}
				changeArr.push(chg);								// 객체를 List에 담는다	
			}
			else if( status == "90" && chg_key == "CUST_NM" && org_key == chg_key ) {		// 변경한 고객상태가 해지라면(고객명)
				
				var chg = {											// 변경사항을 담을 객체 chg 선언
					"CUST_NO" : CUST_NO,							// 고객번호
					"CHG_CD" : chg_key,								// 변경항목코드
					"CHG_BF_CNT" : org_value,						// 변경전내용
					"CHG_AFT_CNT" : "해지고객",						// 고객이름을 해지고객으로 설정
					"UPD_ID" : $("#SE_USER_ID").val()				// 수정자아이디
				}
				changeArr.push(chg);								// 객체를 List에 담는다	
			}
		} // end of for(var j=0; j< chgArr.length; j++) {}---------------------------
		
	} // end of for(var i =0; i< orgArr.length; i++){}--------------------------------
	
	var result = changeArr.filter(function(item1, idx1){	// 이중 반복으로 같은 것이 있다면 덮어쓰기로 중복 제거
		//filter() 메서드는 콜백함수에서 정의한 조건이 true인 항목만 리턴한다.(필터링)
	    return changeArr.findIndex(function(item2, idx){
	    	//findIndex() 메서드는 콜백함수에 정의한 조건이 true인 항목의 index를 리턴한다.
	        return item1.CHG_CD == item2.CHG_CD
    	}) == idx1;
	});
	changeArr = result; // 중복제거한 배열을 다시 담는다
	
} // end of function checkChanged(orgFrm, chgFrm)----------------

// 조회한 고객의 고객상태에 따라 설정을 바꾸는 함수
function checkCustStatus() {
	
	var CUST_SS_CD = $('input[name="CUST_SS_CD"]:checked').val();		// 고객상태코드를 가져온다
	var CUST_SS = $("label[for='"+CUST_SS_CD+"']").text();				// 고객상태명을 가져온다
	
	var BF_SS_CD = $("#BF_SS_CD").val();								// DB에 저장된 고객상태코드를 가져온다
	var BF_SS_NM = $("label[for='"+BF_SS_CD+"']").text();				// DB에 저장된 고객상태명을 가져온다
	
	if( CUST_SS == "정상" ) {											// 고객상태가 정상이라면
		// $("input:radio").prop('disabled', false);						// 라디오버튼 선택불가
		$(".not").prop('readonly', false);								// 텍스트상자 선택가능
		$(".ui-datepicker-trigger").removeClass("hide");				// 달력아이콘 비활성화
		$("input:radio[value='80']").prop('disabled', false);			// 중지버튼을 선택가능으로 만든다
		$("input:radio[value='90']").prop('disabled', true);			// 해지버튼을 선택불가로 만든다
		$("#CNCL_CNTS").prop('readonly', true);							// 해지사유를 적을수 없게 한다
		
		if( BF_SS_NM == "해지" ) {										// 해지 -> 정상으로 변경시
			$("#STP_DT").val("");										// 중지일자 값 지움
			$("#CNCL_DT").val("");										// 해지일자 값 지움
			$("#CNCL_CNTS").val("");									// 해지사유 값 지움
			$("#CNCL_CNTS").prop('readonly', true);						// 해지사유를 적을수 없게 한다
			$("#JS_DT").val(getToday());								// 가입일자를 오늘로 변경한다
			$("#CUST_NM, #MBL1, #MBL2, #MBL3").prop('readonly', false);	// 고객명, 핸드폰번호를 수정가능으로 만든다
			
			flag_mblDuplicated = false;									// 핸드폰 중복검사 flag를 false로 변경
			$("#checkMblDuplicated").css("background-color","red");		// 휴대폰중복확인버튼 빨간색 표시
		}
		else if( BF_SS_NM == "중지" ) {
			$("#STP_DT").val("");								// 중지일자를 현재로 설정
			
		}
	}
	else if( CUST_SS == "중지" ) {										// 고객상태가 중지라면
		$('input[name="CUST_SS_CD"]').prop('disabled', false);			// 라디오버튼, 직업코드 비활성화
		$("#CNCL_CNTS").prop('readonly', true);							// 해지사유를 적을수 없게 한다
		$("#STP_DT").val(getToday());									// 중지일자를 현재로 설정	
		$("#CNCL_DT").val("");											// 해지일자 값 지움
		$(".not").prop('readonly', false);								// 텍스트상자 선택가능
		$(".ui-datepicker-trigger").removeClass("hide");					// 달력아이콘 비활성화
		
	}
	else if( CUST_SS == "해지" ) {										// 고객상태가 해지라면
		// $("input:radio").prop('disabled', true);						// 라디오버튼 선택불가
		$(".not").prop('readonly', true);								// 텍스트상자 선택불가
		$(".ui-datepicker-trigger").addClass("hide");					// 달력아이콘 비활성화
		$("input:radio[value='10']").prop('disabled', false);			// 정상버튼을 선택가능으로 만든다
		$("input:radio[value='80']").prop('disabled', true);			// 중지버튼을 선택불가로 만든다
		$("#CNCL_DT").val(getToday());									// 해지일자를 현재로 설정	
		// $("#CNCL_CNTS").val("");										// 해지사유를 공백으로 설정	
		$("#CNCL_CNTS").prop('readonly', false);						// 해지사유를 적을수 있게 한다
		$("#CUST_NM, #MBL1, #MBL2, #MBL3").prop('readonly', true);		// 고객명, 핸드폰번호를 수정불가로 만든다
		
	}
	
	$("#BF_SS_CD").val(CUST_SS_CD);										// 기능을 모두 수행한 뒤 변경 전 코드를 최신화한다
	
} // end of function checkCustStatus()------------

// 고객상태 변경시 실행되는 함수
function changeCustStatus() {
	var CUST_SS_CD = $('input[name="CUST_SS_CD"]:checked').val();		// 고객상태코드를 가져온다
	var CUST_SS = $("label[for='"+CUST_SS_CD+"']").text();				// 고객상태명을 가져온다
	
	var BF_SS_CD = $("#BF_SS_CD").val();								// DB에 저장된 고객상태코드를 가져온다
	var BF_SS_NM = $("label[for='"+BF_SS_CD+"']").text();				// DB에 저장된 고객상태명을 가져온다
	
	if( CUST_SS == "정상" ) {											// 고객상태가 정상이라면
		$(".not").prop('readonly', false);								// 텍스트상자 검색 가능
		$(".ui-datepicker-trigger").removeClass("hide");				// 달력아이콘 비활성화
		$("#CNCL_CNTS").prop('readonly', true);							// 해지사유를 적을수 없게 한다
		
		if( BF_SS_NM == "해지" ) {										// 해지 -> 정상으로 변경시
			$("#STP_DT").val("");										// 중지일자 값 지움
			$("#CNCL_DT").val("");										// 해지일자 값 지움
			$("#CNCL_CNTS").val("");									// 해지사유 값 지움
			$("#CNCL_CNTS").prop('readonly', true);						// 해지사유를 적을수 없게 한다
			$("#JS_DT").val(getToday());								// 가입일자를 오늘로 변경한다
			$("#CUST_NM, #MBL1, #MBL2, #MBL3").prop('readonly', false);	// 고객명, 핸드폰번호를 수정가능으로 만든다
			
			flag_mblDuplicated = false;									// 핸드폰 중복검사 flag를 false로 변경
			$("#checkMblDuplicated").css("background-color","red");		// 휴대폰중복확인버튼 빨간색 표시
		}
		else if( BF_SS_NM == "중지" ) {
			$("#STP_DT").val("");								// 중지일자를 현재로 설정
			
		}
	}
	else if( CUST_SS == "중지" ) {										// 고객상태가 중지라면
		$("#CNCL_CNTS").prop('readonly', true);							// 해지사유를 적을수 없게 한다
		$("#STP_DT").val(getToday());									// 중지일자를 현재로 설정	
		$("#CNCL_DT").val("");											// 해지일자 값 지움
		$(".not").prop('readonly', false);								// 텍스트상자 선택가능
		$(".ui-datepicker-trigger").removeClass("hide");					// 달력아이콘 비활성화
		
	}
	else if( CUST_SS == "해지" ) {										// 고객상태가 해지라면
		// $("input:radio").prop('disabled', true);						// 라디오버튼 선택불가
		$(".not").prop('readonly', true);								// 택스트상자 선택불가
		$(".ui-datepicker-trigger").addClass("hide");					// 달력아이콘 비활성화
		$("#CNCL_DT").val(getToday());									// 해지일자를 현재로 설정	
		$("#CNCL_CNTS").val( $("#ORG_CNCL_CNTS").val() );				// 기존 해지사유를 가져옴 
		$("#STP_DT").val( $("#ORG_STP_DT").val() );						// 기존 중지일자를 가져옴
		$("#CNCL_CNTS").prop('readonly', false);						// 해지사유를 적을수 있게 한다
		$("#CUST_NM, #MBL1, #MBL2, #MBL3").prop('readonly', true);		// 고객명, 핸드폰번호를 수정불가로 만든다
	}
	
	$("#BF_SS_CD").val(CUST_SS_CD);										// 기능을 모두 수행한 뒤 변경 전 코드를 최신화한다
	
} // end of function changeCustStatus() {}-------------------


// 부모창으로 데이터를 넘기는 함수
function dataToOpener(sMethodName) {
	if(sMethodName == "GETPRODUCTLIST") {	// ##4-5. 메소드 이름이 제품목록얻기라면
		let is_checked = $("input:checkbox[name='chBox']").is(":checked");
		if(!is_checked) {
			alert("항목을 선택한 후 적용버튼을 눌러주세요!");
			return false;
		}
		
		var TO_PRD_CD = $("input[name='chBox']:checked").parent().parent().children().eq(1).text();			// 체크한 위치를 기반으로 제품번호를 가져온다
		var TO_PRD_NM = $("input[name='chBox']:checked").parent().parent().children().eq(2).text();			// 체크한 위치를 기반으로 제품명을 가져온다
		var TO_IVCO_QTY = $("input[name='chBox']:checked").parent().parent().children().eq(3).text();		// 체크한 위치를 기반으로 매장재고를 가져온다
		var TO_PRD_CSMR_UPR = $("input[name='chBox']:checked").parent().parent().children().eq(4).text();	// 체크한 위치를 기반으로 소비자단가를 가져온다
		// var TO_PRD_SS_CD = $("input[name='chBox']:checked").parent().parent().children().eq(7).text();	// 체크한 위치를 기반으로 상품상태코드를 가져온다
		
		$("#RCV_PRD_CD", opener.document).val(TO_PRD_CD); 	 			// 자식창에서 부모창으로 온전한 상품번호 전달하기(hidden태그)
		$("#HD_PRD_CD", opener.document).val(TO_PRD_CD); 	 			// 자식창에서 부모창으로 온전한 상품번호 전달하기(hidden태그)
	    $("#RCV_PRD_NM", opener.document).val(TO_PRD_NM); 	 			// 자식창에서 부모창으로 온전한 상품명 전달하기
	    $("#RCV_IVCO_QTY", opener.document).val(TO_IVCO_QTY); 	 		// 자식창에서 부모창으로 온전한 재고수량 전달하기
	    $("#RCV_PRD_CSMR_UPR", opener.document).val(TO_PRD_CSMR_UPR); 	// 자식창에서 부모창으로 온전한 소비자단가 전달하기
		
	} // end of if(sMethodName == "GETPRODUCTLIST") {}---------------------
} // end of function dataToOpener(sMethodName) {}----------

// 제품의 상태를 확인하는 함수
function checkProduct(data){
	var flag = true;								// 통과유무를 판별하는 변수 선언
	
	if( data.PRD_TP_NM == "견본품" ) {				// 상품타입이 견본품이라면
		alert("해당 상품은 판매할 수 없는 상품입니다.");
		flag = false;								// 판별변수 false
	}
	
	if( data.PRD_SS_CD != "R" ) {					// 상품상태코드가 정상이 아니라면
		alert("해당 상품의 상품상태가 정상이 아닙니다.");
		flag = false;								// 판별변수 false
	}

	if( data.IVCO_QTY == "0" ) {					// 상품의 현재재고가 0이라면
		alert("해당 상품의 재고가 존재하지 않습니다.");
		flag = false;								// 판별변수 false
	}

	if( data.PRD_CSMR_UPR <= 0 ) {					// 소비자단가가 0이하라면
		alert("해당 상품의 소비자단가가 없습니다.");
		flag = false;								// 판별변수 false
	}
	
	return flag;									// flag를 반환
	
} // end of function checkProduct(data){}----------

//////////////////////////////견본품제거 시작(미사용)

// 견본품을 포함하지 않는 결과가 1개인 것을 알아오는 함수
function getOnePrdInfo(data) {
	var sliceData = [];
	for(var i=0; i<data.length; i++){				// 데이터의 길이만큼 반복
		if(data[i].PRD_TP_NM != "견본품") {			// 상품유형명이 견본품이 아닐 때
			sliceData.push(data[i]);
		}
	}
	
	return sliceData;
} // end of function getOnePrdInfo(data) {}--------------

// 하나의 정보를 담아주는 함수
function setOnePrdInfo(data) {
	if( checkProduct(data)) {											// 상품상태가 적합하다면
		var tr = target.closest('tr');									// 해당 행의 위치를 가져온다
		tr.find("#PRD_CD").val(data.PRD_CD);							// 상품코드를 담는다
		if(checkUnique(data.PRD_CD)){									// 해당 상품이 고유하다면
			
			tr.find("#HD_PRD_CD").val(data.HD_PRD_CD);					// 상품코드를 담는다(hidden)
			tr.find("#PRD_NM").text(data.PRD_NM);						// 상품명을 담는다
			tr.find("#IVCO_QTY").text(addComma(data.IVCO_QTY));			// 재고수량을 담는다
			tr.find("#PRD_CSMR_UPR").text(addComma(data.PRD_CSMR_UPR));	// 소비자가를 담는다
			tr.find("#CUST_SAL_QTY").val("");							// 판매수량을 초기화한다
			tr.find("#CUST_SAL_QTY").attr("readonly", false);			// 판매수량을 입력가능하게 한다
			tr.find("#CUST_SAL_QTY").focus();							// 커서를 판매수량에 위치시킨다
		}
		else{															// 해당 상품이 고유하지 않다면
			tr.find("#PRD_CD").val("");									// 상품코드를 비운다
			tr.find("#PRD_CD").focus();									// 커서를 상품코드에 위치시킨다 
		}
	}
	else{
		target.val("");													// 값을 비워준다
	}
} // end of function setOnePrdInfo(data) {}----------
////////////////////////////////////견본품제거 끝(미사용)


// 해당 row가 몇번째 row인지 알아오는 함수
function getRowLocation() {
	const $target = $(event.target);				// 이벤트가 발생된 위치를 담는다
	var tr = $target.closest('tr');					// 해당 이벤트의 tr 위치를 담는다
	var trNum = tr.find("#SAL_SEQ").text();			// 해당 row의 일련번호값을 얻어온다

	return trNum;									// 일련번호를 반환한다
} // end of function getRowLocation() {}-----------

// 제품번호가 고유한지 찾아오는 함수
function checkUnique(data) {
	var cnt = 0;														// 중복되는 값을 세기 위한 변수 선언
	for(var i = 0; i<tbl_detail.rows.length-2; i++)						// 테이블 tbody 행수만큼 반복
	{
		var cd = tbl_detail.rows[i+1].querySelector("#PRD_CD").value;	// 상품코드 입력칸의 값을 받아온다
		if(cd == null){													// 값이 null이라면
			cd == "";													// 공백처리
		}
		
		if(data == cd && cd != "") {									// 받아온 값이 공백이 아니면서 상품코드랑 일치한다면
			cnt = cnt + 1;
		}
		
		if(cnt >= 2) {													// 받아온 값이 공백이 아니면서 상품코드랑 일치한다면
			cnt = cnt + 1;
			alert("동일한 상품은 하나의 행에서만 등록할 수 있습니다.");			// 경고창 띄움
			return false;												// false를 반환
		}
	}
		
	org_value = "";														// 값 초기화
	return true;														// true를 반환
} // end of function insertSeq(){}-----------------

// ##2-5. 완전한 상품코드와 input tag 값을 비교하는 함수
function compareOrg(org) {																
	target = $(event.target);						// 이벤트 발생위치를 담는다
	var tr = target.closest('tr');					// 해당 이벤트 tr의 위치를 담는다
	if( org != $("#PRD_CD").val() ) {				// 기존상품코드와 검색창의 값이 다르면
		if( confirm("상품코드를 수정하면 행에 있는 기존 정보는 초기화됩니다. 진행하시겠습니까?") ) {	// 확인을 선택했다면
			
			tr.find("#PRD_CD").val("");				// 상품코드 초기화
			tr.find("#HD_PRD_CD").val("");			// 상품코드 초기화(hidden)
			tr.find("#PRD_NM").text("");			// 상품명 초기화
			tr.find("#IVCO_QTY").text("");			// 매장재고 초기화
			tr.find("#PRD_CSMR_UPR").text("");		// 소비자가 초기화
			tr.find("#CUST_SAL_QTY").val("");		// 판매수량 초기화
			tr.find("#CUST_SAL_QTY").attr("readonly", true);		// 판매수량을 입력불가하게 한다
			tr.find("#PRD_CD").focus();				// 상품코드 focus
			org_value = "";							// 원본코드 초기화
			alert("해당 상품정보가 초기화되었습니다.");
			
			getRowAmt(tr);							// 해당 행의 합을 구함
			tr.find("#SAL_AMT").text("");			// 판매금액 초기화
		}
		else {										// 취소를 선택했다면
			tr.find("#PRD_CD").val(org);			// 수정 전 값을 넣는다
		}
	}
	
	org_value = "";									// 값 초기화
} // end of function compareOrg(org) {}-------------

// ##4-6. 상품코드를 검색한 row에 제품정보를 입력하는 함수(자식창에서 실행하는 함수)
window.setPrdInfo = function() {
	var tr = target.closest('tr');									// 해당 행의 위치를 가져온다
	tr.find("#PRD_CD").val($("#RCV_PRD_CD").val());				// 상품코드를 담는다
	if( checkUnique($("#RCV_PRD_CD").val()) ){						// 해당 상품이 고유하다면
		tr.find("#PRD_CD").val($("#RCV_PRD_CD").val());				// 상품코드를 담는다
		tr.find("#HD_PRD_CD").val($("#HD_PRD_CD").val());			// 상품코드를 담는다(hidden)
		tr.find("#PRD_NM").text($("#RCV_PRD_NM").val());			// 상품명을 담는다
		tr.find("#IVCO_QTY").text($("#RCV_IVCO_QTY").val());		// 재고수량을 담는다
		tr.find("#PRD_CSMR_UPR").text($("#RCV_PRD_CSMR_UPR").val()); // 소비자가를 담는다
		tr.find("#CUST_SAL_QTY").val("");								// 판매수량을 초기화한다
		tr.find("#CUST_SAL_QTY").attr("readonly", false);			// 판매수량을 입력가능하게 한다
		tr.find("#CUST_SAL_QTY").focus();							// 커서를 판매수량에 위치시킨다
	}
	else {															// 해당 상품이 고유하지 않다면
		$("#RCV_PRD_CD").val("");									// 팝업에서 받아온 값들을 초기화
		$("#HD_PRD_CD").val("");
		$("#RCV_PRD_NM").val("");
		$("#RCV_IVCO_QTY").val("");
		$("#RCV_PRD_CSMR_UPR").val("");
		tr.find("#PRD_CD").val("");									// 상품코드를 비운다
		tr.find("#PRD_CD").focus();									// 커서를 상품코드에 위치시킨다
	}
	
	$("#RCV_PRD_CD").val("");									// 팝업에서 받아온 값들을 초기화
	$("#HD_PRD_CD").val("");
	$("#RCV_PRD_NM").val("");
	$("#RCV_IVCO_QTY").val("");
	$("#RCV_PRD_CSMR_UPR").val("");
} // end of window.setPrdInfo = function() {}-----------

// ##2-6. 판매수량을 체크하는 함수
function checkPrdQty(loc) {
	if( parseInt(loc.find("#CUST_SAL_QTY").val().split(',').join("")) > parseInt(loc.find("#IVCO_QTY").text().split(',').join("")) ){ 
		// 판매수량이 매장재고보다 많을 경우
		alert("판매수량은 매장재고보다 적어야 합니다. 다시 입력해주세요.");
		loc.find("#CUST_SAL_QTY").val("");							// 판매수량 초기화
		loc.find("#SAL_AMT").text("");								// 판매금액 초기화
		loc.find("#CUST_SAL_QTY").focus();							// 판매수량으로 커서 위치
		getTotalPrd();												// 총판매수량과 총판매금액을 구하는 함수 실행
	}
	else if( loc.find("#CUST_SAL_QTY").val().split(',').join("") <= 0 || loc.find("#CUST_SAL_QTY").val() == "" ) {
		// 판매수량이 0개 이하일 경우
		alert("판매수량은 적어도 1개 이상 입력해야 합니다. 다시 입력해주세요.");
		loc.find("#CUST_SAL_QTY").val("");							// 판매수량 초기화
		loc.find("#SAL_AMT").text("");								// 판매금액 초기화
		loc.find("#CUST_SAL_QTY").focus();							// 판매수량으로 커서 위치
		getTotalPrd();												// 총판매수량과 총판매금액을 구하는 함수 실행											
	}
	else{
		getRowAmt(loc);												// 해당 행의 판매금액을 구하는 함수 실행 
	}
} // end of function checkPrdQty(loc) {}---------------

// 유효년월을 형식에 맞게 입력하고 유효성 검사를 실시하는 함수
function inputValidThru(period) {

	var replaceCard = period.value.replace(/\//g, "");					// replace 함수를 사용하여 슬래시( / )을 공백으로 치환한다
	
	if(replaceCard.length >= 4 && replaceCard.length < 5) {				// 텍스트박스의 입력값이 4~5글자 사이가 되는 경우에만 실행한다

	    var inputMonth = replaceCard.substring(0, 2);    				// 선언한 변수 month에 월의 정보값을 담는다
	    var inputYear = replaceCard.substring(2, 4);       				// 선언한 변수 year에 년의 정보값을 담는다
	
		var nowDate = new Date();														// 현재 날짜 값을 구한다
		var nowMonth = autoLeftPad(nowDate.getMonth() + 1, 2);							// 현재월을 구한다
		var nowYear = autoLeftPad(nowDate.getFullYear().toString().substr(2, 2), 2);	// 현재년도를 구한다
	

	    // isFinite() => 유한한 숫자인지 판별 (무한대 및 문자 false)
	    if(isFinite(inputMonth + inputYear) == false) {									// 유효기간 입력형식에 맞지 않다면
	        alert("문자는 입력하실 수 없습니다.");
	        period.value = "";
	        return false;
	    }
	    
	    if(inputMonth > 12) {											// 입력한 월이 12월 보다 큰 경우
	        alert("12월보다 큰 월수는 입력하실 수 없습니다. ");
	        period.value = "";
			return false;
	    }

		
	    if( (inputYear + inputMonth) < (nowYear + nowMonth)) {			// 유효기간이 만료되었다면
	        alert("유효기간이 만료된 카드는 사용하실 수 없습니다.");
	        period.value = "";
			return false;
	    }
		
		$("#VLD_YM").val(inputMonth +"20"+inputYear);
        period.value = inputMonth + "/" + inputYear;					// 값을 월 / 년도 로 바꾼다
    }
} // end of function inputValidThru(period) {}-----------

// ##2-7. 카드항목이 있다면 카드항목에 대해 체크하는 함수
function checkCardInfo() {
	var cnt = 0;													// 입력한 곳의 개수를 담는 변수 선언
	var flag = true;												// 통과여부를 판별하는 변수 선언
	$(".CRD").each(function(index, item) {							// 카드관련 입력data 각각에 대한 반복문 실행
		const data = $(item).val().trim();							// 공백을 제거한 값이
		if(data != ""){												// 비었다면
			cnt = cnt + 1;											// cnt에 1 추가
		} 
	});
	
	if(cnt !=7 && cnt != 0){										// 입력한 것이 있지만 모두 입력하지 않았다면
		alert("카드에 관한 항목들은 비워두거나 모두 입력하셔야 합니다.");
		return false;												// false 반환
	}
	
	if( $("#DIS_VLD_YM").val().length != 5 && $("#DIS_VLD_YM").val() != "" ) {
		alert("유효기간을 완전히 입력해주세요.");
		$("#DIS_VLD_YM").focus();
		return false;
	}
	
	// 카드번호 모두 4자리인지 확인
	$(".CRD_NM").each(function(index, item) {						// 카드번호 입력data 각각에 대한 반복문 실행
		const data = $(item).val().trim();							// 공백을 제거한 값이
		if(data.length != 4 && data != ""){							// 4자리가 아니라면
			alert("카드번호는 4자리로 이루어져야 합니다. \n "+(index+1)+"번째 카드번호를 정확히 입력해주세요.");
			$("#"+this.id).focus();									// 4자리가 아닌곳에 커서를 위치시킨다
			flag = false;
			return false;
		} 
	});
	
	if(flag){														// 판별변수가 true라면
		return true;												// true를 반환
	}
} // end of function checkCardInfo() {}--------------------

// ##2-8-1. 결제금액 form을 체크하는 함수
function checkPaymentRegister() {
	var cash = 0;										// 현금액을 받는 변수 선언
	var card = 0;										// 카드결제액을 받는 변수 선언
	var point = 0;										// 포인트사용액을 받는 변수 선언
	if( $("#CSH_STLM_AMT").val() != "" ){				// 현금이 비어있지 않다면
		cash += parseInt( removeComma($("#CSH_STLM_AMT").val()) );		// 숫자타입으로 변환
	}
	if( $("#CRD_STLM_AMT").val() != "" ){				// 카드금액이 비어있지 않다면
		card += parseInt( removeComma($("#CRD_STLM_AMT").val()) );		// 숫자타입으로 변환
	}
	if( $("#PNT_STLM_AMT").val() != "" ){				// 포인트사용액이 비어있지 않다면
		point += parseInt( removeComma($("#PNT_STLM_AMT").val()) );	// 숫자타입으로 변환
	}
	
	var sum = cash + card + point;						// 각 결제금액의 합을 구한다
	
	if(!reqCheck()){									// 필수입력사항이 입력되지 않았다면
		return false;
	}																
	else if( $("#TOT_SAL_AMT").text() == "" || $("#TOT_SAL_AMT").text() == "0" ) {	// 총판매금액이 0이거나 비었다면
		alert("등록할 제품이 없습니다. 적어도 하나의 제품정보와 판매수량을 입력해주세요.");
		return false;
	}
	else if( point != "" && point < 100){													// 사용포인트가 100 미만이라면
		alert("포인트는 100점 이상 사용가능합니다. \n 입력하신 포인트 : "+$("#PNT_STLM_AMT").val()+"원\n 가용포인트 : "+$("#AVB_PNT").val()+"원");
		$("#PNT_STLM_AMT").val("");
		$("#PNT_STLM_AMT").focus();
		return false;
	}
	else if( point > parseInt(removeComma($("#AVB_PNT").val())) && point != 0 ){			// 사용할 포인트가 부족하다면
		// alert(point);
		alert("사용할 수 있는 포인트가 부족합니다. \n 입력하신 포인트 : "+$("#PNT_STLM_AMT").val()+"원\n 가용포인트 : "+$("#AVB_PNT").val()+"원");
		$("#PNT_STLM_AMT").val("");
		$("#PNT_STLM_AMT").focus();
		return false;
	}
	else if( ( sum != removeComma($("#TOT_SAL_AMT").text()) && sum != "" ) || sum == "" ){	// 결제금액과 총판매금액이 일치하지 않는다면
		alert( "결제금액과 총판매금액이 일치하지 않습니다. \n 결제하실 금액 : "+$("#TOT_SAL_AMT").text()+"원\n 입력하신 총 금액 : "+ addComma(sum)+"원" );
		if(cash > 0){					// 결제수단이 현금이었다면
			$("#CSH_STLM_AMT").focus();
		}
		else if(card > 0){				// 결제수단이 카드였다면
			$("#CRD_STLM_AMT").focus();
		}
		else if(point > 0){				// 결제수단이 포인트였다면
			$("#PNT_STLM_AMT").focus();
		}
		return false;
	}
	else{																					// 모든 조건을 만족한다면
		$("#RSVG_PNT").val( (cash + card) * 0.1 );									
		$("#US_PNT").val(point);									
		$("#IN_TOT_SAL_QTY").val($("#TOT_SAL_QTY").text());									// data 전송용 input 태그에 값을 넘긴다		
		$("#IN_TOT_SAL_AMT").val(sum);
		$("#IN_TOT_VOS_AMT").val( sum - (sum*0.1) );
		$("#IN_TOT_VAT_AMT").val( (sum*0.1) );
		$("#CRD_NO").val( $("#CARD1").val() + $("#CARD2").val() + $("#CARD3").val() + $("#CARD4").val() );
		return true;
	}
	
} // end of function checkPaymentRegister() {}--------------------

// 상태에 따른 데이터 표시함수
function displayStatus(data) {
	
	var flag = false;							// 통과여부 판단하는 변수 선언(초기값 false)
	var loc;									// 상품정보의 행 위치를 담는 변수 선언
	
	if(data.status == "CUST_SS_CD") {			// return된 값 : 고객상태가 정상이 아님 - 통과
		var cust_ss = data.CUST_SS_CD == 80 ? "중지" : "해지";	// 고객상태코드가 80이면 중지, 아니면 해지(정상은 애초에 여기 도착안함)
		alert("현재 "+data.CUST_NM+" 님의 고객상태가 정상이 아닙니다.\n현재 고객상태 : "+cust_ss +"\n(고객번호 : " + data.CUST_NO + ")");
	}
	else if(data.status == "AVB_PNT") {			// return된 값 : 가용포인트 불일치(필요없을듯함)
		alert(data.CUST_NM+" 님의 가용포인트가 일치하지 않습니다.\n화면의 가용포인트 : "+$("#AVB_PNT").val()+"\n실제 가용포인트 : "+addComma(data.AVB_PNT));
		$("#AVB_PNT").val(addComma(data.AVB_PNT));							// 가용포인트를 최신화한다
	}
	else if(data.status == "USE_POINT") {		// return된 값 : 사용포인트 > 가용포인트(포인트부족) - 통과
		alert(data.CUST_NM+" 님의 가용포인트가 일치하지 않습니다.\n화면의 가용포인트 : "+$("#AVB_PNT").val()+"\n실제 가용포인트 : "+addComma(data.AVB_PNT));
		$("#AVB_PNT").val(addComma(data.AVB_PNT));							// 가용포인트를 최신화한다
		$("#PNT_STLM_AMT").val("");											// 사용포인트 초기화
		$("#PNT_STLM_AMT").focus();											// 사용포인트에 커서 위치
	}
	else if(data.status == "PRD_EMPTY") {		// return된 값 : 일치하는 상품이 없음 - 통과
		alert(data.ROW+"번째 줄의 상품코드 "+data.PRD_CD+" 는 존재하지 않습니다.");
	}
	else if(data.status == "PRD_TP_CD") {		// return된 값 : 상품이 본품이 아님 - 통과
		alert(data.ROW+"번째 줄의 상품 "+data.ORG_PRD_NM+" 은 견본품입니다(상품코드 : "+data.ORG_PRD_CD+")");
	}
	else if(data.status == "PRD_SS_CD") {		// return된 값 : 상품상태가 R이 아님 - 통과
		alert(data.ROW+"번째 줄의 상품 "+data.ORG_PRD_NM+" 은 판매할 수 없는 상품입니다(상품코드 : "+data.ORG_PRD_CD+")");
	}
	else if(data.status == "PRD_CSMR_UPR") {	// return된 값 : 소비자단가 불일치 - 통과
		alert(data.ROW+"번째 줄의 상품 "+data.ORG_PRD_NM+" 의 소비자가가 일치하지 않습니다(상품코드 : "+data.ORG_PRD_CD+")\n실제 소비자가 : "+addComma(data.PRD_CSMR_UPR)+"원");
		loc = $("TBODY tr").eq( (data.ROW-1) );								// 해당 행의 위치를 담는다
		loc.find("#PRD_CSMR_UPR").text(addComma(data.PRD_CSMR_UPR));		// 그 행의 소비자가를 최신화한다
		getRowAmt(loc);														// 행의 합계를 구한다
	}
	else if(data.status == "IVCO_QTY") {		// return된 값 : 재고부족 - 통과
		alert(data.ROW+"번째 줄의 상품 "+data.ORG_PRD_NM+" 의 재고수량이 판매수량보다 부족합니다.(상품코드 : "+data.ORG_PRD_CD+")\n현재 재고수량  : "+addComma(data.IVCO_QTY));
		$("TBODY tr").eq( (data.ROW-1) ).find("#IVCO_QTY").text(addComma(data.IVCO_QTY));		// 해당 상품의 재고수량을 최신화한다
	}
	else if(data.status == "SUM") {				// return된 값 : 총합계금액 불일치 - 통과
		alert("현재 결제금액과 실제 판매금액이 일치하지 않습니다.\n입력하신 결제금액 : "+addComma(data.SUM)+"원\n결제해야할 금액 : "+addComma(data.ORG_SUM) +"원");
		$("#TOT_SAL_AMT").text(addComma(data.ORG_SUM));						// 총합계금액을 최신화한다
	}
	else{										// 모든 조건 통과시
		flag = true;							// flag에 true를 담는다
	}
	
	return flag;
	
} // end of function displayStatus(data) {}--------------
