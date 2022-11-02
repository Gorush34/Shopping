$(document).ready(function() {								// 페이지가 로딩되었을 때 시작하는 부분
		
	$("input.blank_key").keyup(function(event){						// 매장조건 입력란에서 키보드를 입력할 때
		if(event.keyCode == 8 || event.keyCode == 46) { 			// 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
			if( $("input#PRT_CD_NM").val() == "" ) {				// 매장검색란의 내용이 아무것도 없다면
				$("input#JN_PRT_CD").val("");						// 매장코드를 비운다
			} 
		
			if($("input#IN_CUST_NO").val() == "") {					// 고객검색란의 내용이 아무것도 없다면
				$("input#CUST_NO").val("");							// 고객번호를 지운다
			}
		}
	}); // end of $("input.blank_key").keyup(function(event){})------------- 
	
	$("input.enter_prt").keydown(function(event){					// 매장조건 입력란에서 키를 입력 후 
		
		if(event.keyCode == 13) { 									// 엔터를 했을 경우
			if(checkWord($("input#PRT_CD_NM").val()) === true ) {	// 정규표현식(checkWord)에 위배되지 않는다면
				getPrtCodeName();									// 검색조건의 결과가 몇 개인지 알아오는 함수 실행	
			} 
		}
		
	}); // end of $("input#PRT_CD_NM").keydown(function(event){})-------------------------------
	
	$("input.enter_cust").keydown(function(event){					// 고객번호 입력란에서 키를 입력 후 
		
		if(event.keyCode == 13) { 									// 엔터를 했을 경우
			if(checkWord($("input#IN_CUST_NO").val()) === true ) {	// 정규표현식(checkWord)에 위배되지 않는다면
				getCustCodeName();									// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
			}
		}
	}); // end of $("input#IN_CUST_NO").keydown(function(event){})------------------------------

	$("button#btn_search_prt").on("click", function () { 		// 매장 찾기 버튼을 클릭했을 때
		
		if(checkWord($("input#PRT_CD_NM").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
				getPrtCodeName();									// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
		}
	
	}); // end of $("button#btnSearch_prt").on("click", function (event) {})---------------------
	
	$("button#btn_search_cust").on("click", function () { 		// 고객번호 찾기 버튼을 클릭했을 때\
		
		if(checkWord($("input#IN_CUST_NO").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
				getCustCodeName();										// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
		}
	
	}); // end of $("button#btnSearch_cust").on("click", function (event) {})---------------------

	$(".req, .req_rad, .req_sel").bind("change",()=>{  				// 필수입력사항 값이 변경되면 등록 버튼 클릭시 확인 flag 초기화 시키기
 		flag_req = false;
 	});
   	
 	$("#MBL1, #MBL2, #MBL3").bind("change",()=>{  					// 핸드폰값이 변경되면 등록 버튼 클릭시 중복확인 flag 초기화 시키기
 		flag_mblDuplicated = false;
 		$("#checkMblDuplicated").css("background-color","red");
		
		if( $("#MBL1").val() + $("#MBL2").val() + $("#MBL3").val() == $("#ORG_MBL_NO").val() ){	// 변경한 휴대폰값이 기존값이라면
			flag_mblDuplicated = true;															// 중복체크 true
 			$("#checkMblDuplicated").css("background-color","green");							// 버튼 초록색
		}
	
 	});
	
 	$("#EMAIL1, #EMAIL2").bind("change",()=>{  						// 이메일값이 변경되면 등록 버튼 클릭시 중복확인 flag 초기화 시키기
		flag_emailDuplicated = false;
		$("#checkEmailDuplicated").css("background-color","red");
		
		if( $("#EMAIL1").val() +"@"+ $("#EMAIL2").val() == $("#ORG_EMAIL").val() ){	// 변경한 이메일값이 기존값이라면
			flag_emailDuplicated = true;										// 중복체크 true
			$("#checkEmailDuplicated").css("background-color","green");			// 버튼 초록색
		}
 	});

	$("button#readCustInfo").click(function(){								// 큰 돋보기(고객상세정보 조회) 버튼 클릭시
		
		var custNum = $("#CUST_NO").val();									// 고객번호를 담는다
		if(custNum != "") {													// 고객번호가 비어있지 않으면
			
			if(flag_existOrg){												// 고객정보가 조회된 상태에서 고객조회버튼을 클릭했다면
				$("#MBL_NO").val($("#MBL1").val() + $("#MBL2").val() + $("#MBL3").val()); // 비교할 hidden 태그에 값을 넣는다
				$("#EMAIL").val($("#EMAIL1").val()+"@"+$("#EMAIL2").val());				  // 비교할 hidden 태그에 값을 넣는다	
				checkChanged("compareFrm", "custInfoFrm");					// 변경사항이 있는지 확인하는 함수 실행
				
				if(flag_changed){														// 변경사항이 존재한다면
					if(confirm("기존에 조회하신 고객의 정보 중 수정된 사항이 있습니다. 그래도 계속하시겠습니까?")){	// 계속하시겠습니까? 에서 확인시
						changeArr = [];													// 변경사항을 담는 배열 초기화(변경이력정보 비움)
						flag_changed = false;											// 변경유무를 확인하는 flag 초기화(변경유무 없음)
						selectItem(custNum, "/shopping/readCustInfo.dowell");			// 고객정보를 통해 고객정보를 가져오는 함수 실행
						checkCustStatus();
					}
				}
				else{														// 변경사항이 존재하지 않는다면
					changeArr = [];											// 변경사항을 담는 배열 초기화
					selectItem(custNum, "/shopping/readCustInfo.dowell");	// 고객정보를 통해 고객정보를 가져오는 함수 실행
				}
			}
			else {															// 고객정보가 비어있다면
				selectItem(custNum, "/shopping/readCustInfo.dowell");		// 고객정보를 통해 고객정보를 가져오는 함수 실행
			}
			flag_existOrg = true;											// 기존정보 존재여부 flag true 설정(존재함)
		}
		else{																// 고객번호가 비어있다면
			alert("조회를 원하시는 고객번호를 입력하세요!");
			return;
		}	
		
	}); // $("button#readCustInfo").click(function(){})---------------


	$("button#btn_update").click(function(){							// 수정버튼 클릭시
		if(confirm("고객정보를 수정하시겠습니까?")){							// 수정버튼 후 알림창에서 확인을 클릭했다면
			if(!flag_existOrg) {										// 기존정보가 존재하지 않는다면
				alert("조회 또는 수정할 고객의 정보가 없습니다!");
			}
			else {														// 기존정보가 존재한다면
				reqCheck();												// 필수입력항목 검사
				if(flag_req) {											// 필수입력항목에 값이 모두 입력되었다면
					if(checkInfo()){									// 각 항목에 대한 유효성 검사 함수 실행

						$("#MBL_NO").val($("#MBL1").val() + $("#MBL2").val() + $("#MBL3").val()); 	// 비교할 hidden 태그에 값을 넣는다
						$("#EMAIL").val($("#EMAIL1").val()+"@"+$("#EMAIL2").val());				  	// 비교할 hidden 태그에 값을 넣는다	
						checkChanged("compareFrm", "custInfoFrm");									// 변경사항이 있는지 확인하는 함수 실행
						
						if(!flag_changed){								// 변경사항이 없다면
							alert("조회하신 고객의 수정된 정보가 없습니다!");	
						}
						else if( $("#CUST_NM").val() == "해지고객" && $("#CUST_SS_CD").val() == "10" && $("#BF_SS_CD").val() != "90" ){	// 고객상태가 현재 정상이고 이름이 해지고객이라면
							alert("해지고객의 경우 반드시 고객명을 변경해주셔야 합니다!");
						}
						else if( $.trim($("#CNCL_CNTS").val()) == "" && $("#BF_SS_CD").val() == "90" && $("#CUST_NM").val() != "해지고객" ) {
							alert("해지사유를 입력해주세요!!");
						}
						else {																			// 모든 조건을 만족했다면
							if($("#BF_SS_CD").val() == "90" ){				// 최종 고객상태가 해지일 때
								$("#MBL_NO").val("00000000000"); 			// hidden 태그에 해지고객 핸드폰값을 넣는다
								$("#CUST_NM").val("해지고객"); 				// 고객명을 해지고객으로 변경한다.
							} 
							dateOnlyNumber();															// 날짜형식을 숫자로 변환
							updateItem("custInfoFrm", "/shopping/updateCustInfo.dowell", "serialize");	// 변경된 고객정보를 update
							
						}
					}										
				}
			}
		}
		
		
	}); // $("button#btn_update").click(function(){})----------------------

}); // end of ready----------------------------------------------


// Function Declaration

// 검색시 유효성 검사를 실행하는 함수
function checkWord(obj) {
	
	let search_length = obj.length;												// 고객이름의 길이를 알아온다
	
	var regex = RegExp(/[가-힣a-zA-Z0-9]{2,20}$/);								// 2-20글자 사이에 완전한 음절과 영어가 들어갔는지 체크하는 정규표현식
	var regex2 = RegExp(/[ㄱ-ㅎㅏ-ㅣ]+/);											// 자음, 모음이 한글자라도 있는지 체크하는 정규표현식
	var pattern = /\s/g;														// " "공백(스페이스)이 있는지 체크하는 정규표현식
	
	if( (!regex.test(obj) && search_length != 0) || regex2.test(obj) ) { 		// 공란이 아니거나 고객이름 정규표현식에 맞지 않다면
		alert("특수문자 및 공백을 제외한 최소 두글자 이상 한글 혹은 숫자로 입력하셔야 합니다.");
		return false;															// false를 반환
	}
	else if( obj.match(pattern) ){												// 공백이 체크되었다면
		alert("검색시 공백은 허용하지 않습니다.");
		return false;															// false를 반환
	}
	else if(search_length == 0) {												// 아무것도 적지 않았다면
		return true;															// true를 반환
	}
	else {																		// 위의 경우들을 제외한 나머지
		return true;															// true를 반환
	}
	
} // end of function checkWord() {})---------------------

// 매장정보를 검색하여 정보를 받거나 팝업을 띄우는 함수
function getPrtCodeName() {
	var searchWord = $("input#PRT_CD_NM").val();								// 매장검색어를 변수에 담는다
	
	getList(searchWord, "/shopping/getPrtList.dowell", "prt");					// 검색어와 실행할 URL을 지정하여 리스트 검색함수 실행
} // end of function getPrtCodeName() {}-----------

// 고객정보를 검색하여 정보를 받거나 팝업을 띄우는 함수
function getCustCodeName() {
	var searchWord = $("input#IN_CUST_NO").val();								// 매장검색어를 변수에 담는다
	
	getList(searchWord, "/shopping/getPopUpCustList.dowell", "cust");			// 검색어와 실행할 URL을 지정하여 리스트 검색함수 실행
} // end of function getPrtCodeName() {}-----------

// 매장 및 고객에서 검색어를 통해 리스트를 불러오는 함수
function getList(searchWord, url, from) {
	
	if(searchWord == undefined) {												// 아무것도 입력하지 않았다면
		searchWord = "";														// 빈칸처리
	} 
	
	$.ajax({
		url: url,
		dataType:"JSON", 														// 데이터 타입을 JSON 형태로 전송
		data: {"SEARCHWORD":searchWord,
			   "SEARCHWORD_NM":"",
			   "SEARCHWORD_MBL":""}, 
		type:"POST",															// POST 방식을 적용
		success:function(json){ 												// return된 값이 존재한다면
		
			if(json.length == 1 && from === "prt") { 							// 매장검색의 결과가 하나라면
				$("input#JN_PRT_CD").val(json[0].PRT_CD); 						// 자식창에서 id가 JN_PRT_CD인 val에 id를 넣기
				$("input#PRT_CD_NM").val(json[0].PRT_NM); 						// 자식창에서 id가 PRT_CD_NM인 val에 id를 넣기
			}
			else if(json.length == 1 && from === "cust") { 						// 고객검색의 결과가 하나라면
				$("input#CUST_NO").val(json[0].CUST_NO); 						// 자식창에서 id가 JN_PRT_CD인 val에 id를 넣기
				$("input#IN_CUST_NO").val(json[0].CUST_NM); 						// 자식창에서 id가 PRT_CD_NM인 val에 id를 넣기
			}
			else{																// json으로 받아온 status의 값이 1이 아니라면(결과가 1이 아니라면)
				if(from === "prt") { 											// 매장코드 검색했을 때
					search_popup('search_prt', 'search_prt', '900', '600');					// 매장검색 팝업을 실행
				}
				else if(from === "cust") {										// 고객정보 검색했을 때 
					search_popup('search_cust', 'search_cust', '900', '600');					// 고객정보 팝업을 실행
				}
			}
			
		},
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
			
	}); // end of $.ajax({})-------------------
	
	from_cust = false;															// 어디에서 왔는지 구분하는 flag 초기화
	from_prt = false; 															// 어디에서 왔는지 구분하는 flag 초기화
		
} // end of function getList(searchWord, url)----------------------

// 버튼을 누르거나 검색어 입력시 값을 출력하거나 팝업창을 띄워주는 함수
function search_popup(location, title, width, height) {

	// 버튼마다의 주소값을 받는다.
	var loc = location;
	// 팝업창을 띄울 주소를 설정한다.
	const url = "/shopping/"+loc+".dowell"; 
	
	const pop_width = width;
	const pop_height = height;
	const pop_left = Math.ceil( ((window.screen.width)-pop_width)/2 ) ; 		// 값을 정수로 만든다
	const pop_top = Math.ceil( ((window.screen.height)-pop_height)/2 ) ;
	
	window.open( url
				 , title
				 , "left="+pop_left+
				 ", top="+pop_top+
				 ", width="+pop_width+
				 ", height="+pop_height+
				 ", location = no" );
	
} // end of function search_popup(location) {})---------------------------------------

// 중복검사 버튼 클릭시 실행 함수
function checkDuplicated(obj) {
	
	if(obj == "email") {		// 체크할 대상이 이메일이라면
		var email = $("#EMAIL1").val() + "@" + $("#EMAIL2").val();
		$("#EMAIL").val(email);										// input(hidden)태그에 email값을 저장
		if( checkText(email, "EMAIL") ){							// 정규표현식에 맞는다면
			compareItem(email, "EMAIL");							// 이메일 중복검사 실행
		}
	}
	else if(obj == "mbl") {		// 체크할 대상이 핸드폰번호라면
		var mbl = $("#MBL1").val() + $("#MBL2").val() + $("#MBL3").val();
		var reg = RegExp(/^01([0|1|6|7|8|9]?)$/);
		if( $("#MBL2").val().length == 4 && $("#MBL3").val().length == 3 || $("#MBL1").val().length != 3 ) {
			alert("휴대전화번호가 10자리인 경우 첫번호가 3자리, 중간번호가 4자리여야 합니다.");
			return;
		}
		/*else if( !reg.test($("#MBL1").val()) ) {
			alert("휴대전화 앞자리를 형식에 맞춰 입력해주세요.");
			$("#MBL1").focus();
			return;
		}*/
		$("#MBL_NO").val(mbl);											// input(hidden)태그에 mbl값을 저장
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
		   	   	$("#MBL1").val("");
				$("#MBL2").val("");
				$("#MBL3").val("");
				$("#MBL1").focus();								// 입력한 핸드폰번호를 지워주고 커서를 휴대전화 앞자리에 위치시킨다
           }
		   else if(obj == "00000000000" && type == "MBL") {		// 휴대폰번호가 0으로 11개 구성되어 있다면
        	   	alert("000-0000-0000 은 사용할 수 없는 핸드폰 번호입니다!");
				$("#MBL1").val("");	
				$("#MBL2").val("");
				$("#MBL3").val("");
				$("#MBL1").focus();								// 입력한 핸드폰번호를 지워주고 커서를 휴대전화 앞자리에 위치시킨다
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

//천단위 콤마 펑션
function addComma(value){
     value = value.toString();															// 값을 문자열형태로 받아온다
	 value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");								// 3자리마다 ,를 추가해준다
     return value; 																		// 변환한 값을 return
 }

// 필수입력항목을 검사하는 함수
function reqCheck() {

	let b_FlagRequiredInfo = false;			
	
	$("input.req").each(function(index, item) {						// 태그의 class가 필수입력항목인 것에 대해서 각각 실행
		const data = $(item).val().trim();							// 공백을 제거한 값이
		
		if(data == ""){												// 비었다면
			console.log("item : " + data);
			// alert("*표시된 필수입력사항은 모두 입력하셔야 합니다.");
			if(this.id == "CUST_NM"){								// 비어있는 값이 고객명
				alert("이름은 필수입력사항입니다!");
				$("#"+this.id).focus();
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
			} else if(this.id == "JN_PRT_CD" ){ 				// 비어있는 값이 가입매장
				alert("가입매장은 필수입력사항입니다!");
				$("#"+this.id).focus();
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
	} else {																					// 모든 유효성 검사에서 통과되었다면
		if( $("#MRRG_DT").val() == "" ) { $("#MRRG_DT").val(""); }								// 결혼기념일을 설정안하였으면 값 없앰
		return true;
	}
	
} // end of end of function checkInfo()---------------------------

// 검색어 하나로 select를 실행하는 함수(여기서는 고객상세조회 큰돋보기 클릭 후 조건 만족시 실행)
function selectItem(SEARCHWORD, url) {
	
	$.ajax({
		url:url,
		data: {"viewCust" : SEARCHWORD}, 
		dataType:"JSON", 											// 데이터 타입을 JSON 형태로 전송
		type:"POST",												// POST 방식을 적용
		success:function(json){ 									// return된 값이 존재한다면
		
			var keys = Object.keys(json); 							// json 안의 key의 이름이 담긴 Object 변수 선언
			
			for (var i=0; i<keys.length; i++) {						// 가져온 회원정보의 원본값을 저장하기 위한 input태그 생성 반복문
				var key = keys[i];									// i번째 인덱스의 key 이름을 담는다
				if($("#ORG_"+key).length == 0) {					// 만일 input태그가 생성되지 않았다면
					var org_input = document.createElement('input');// 원본을 담을 input 태그를 생성한다
					org_input.setAttribute("type", "hidden");		// type을 hidden으로 지정한다
					org_input.setAttribute("id", "ORG_"+key);		// id의 접두어를 ORG_로 표기한다 
					org_input.setAttribute("name", "ORG_"+key);		// name의 접두어를 ORG_로 표기한다
					
					var compareFrm = document.forms['compareFrm'];	// 비교를 위한 form 지정
					compareFrm.appendChild(org_input);				// 생성한 input을 form 안에 담는다
				}
				else{												// 이미 생성되었다면
					break;											// 반복문 탈출
				}
			}
			
		    for (var i=0; i<keys.length; i++) {						// 가져온 key의 길이만큼 반복문을 실행
			    	var key = keys[i];								// i번째 인덱스의 key 이름을 담는다
			 
					if(key.includes("_DT") && key != "ADDR_DTL" || key == "LAST_SAL" ) {	// value 값이 일자라면
						var dt = json[key].substr(0,4) + "-" + json[key].substr(4,2) + "-" + json[key].substr(6); // value값을 yyyy-mm-dd로 표시
						if(dt.trim() != "--" ){								// 빈 값이 아니라면
							$("input#"+key).val(dt);				// 각 key값 태그에 value를 담는다
							$("input#ORG_"+key).val(dt);		// 비교를 위한 input 안에 해당 key의 value를 담는다 
		    			} else { 
							$("input#"+key).val(""); 				// 각 key값 태그에 value를 담는다
							$("input#ORG_"+key).val("");		// 비교를 위한 input 안에 해당 key의 value를 담는다 
						}
					}
					else if( key.includes("POC_CD") ) {				// key 이름이 직업코드라면
						$("select#"+key).val(json[key]).prop("selected", true);	// 해당 value를 select 한다
						$("input#ORG_"+key).val(json[key]);		// 비교를 위한 input 안에 해당 key의 value를 담는다 
					}
					else if(key.includes("_YN") || key.includes("SEX_CD") || key.includes("CUST_SS_CD") || key.includes("PSMT_GRC_CD") ) { // 라디오버튼
						$("input:radio[name='"+key+"']:radio[value='"+json[key]+"']").prop('checked', true);	// 해당 value를 check 한다
						$("input#ORG_"+key).val(json[key]);		// 비교를 위한 input 안에 해당 key의 value를 담는다 
					}
					else if(key.includes("MBL_NO")) {										// 핸드폰번호라면
						var mbl1 = json[key].substr(0, 3);									// 휴대번호 앞자리 선언
						var mbl2 = json[key].substr(3, json[key].length-7);					// 휴대번호 중간자리 선언
						var mbl3 = json[key].substr(json[key].length-4, json[key].length);	// 휴대번호 끝자리 선언
						$("input#MBL1").val(mbl1);											// 앞자리 값을 넣는다
						$("input#MBL2").val(mbl2);											// 중간자리 값을 넣는다
						$("input#MBL3").val(mbl3);											// 끝자리 값을 넣는다
						$("input#"+key).val(json[key]);										// 비교할 hidden 태그에 값을 넣는다
						$("input#ORG_"+key).val(json[key]);		// 비교를 위한 input 안에 해당 key의 value를 담는다 
					}
					else if(key.includes("EMAIL")) {										// 이메일
						var email = json[key].split('@');									// @를 기준으로 배열로 저장한다
						$("input#EMAIL1").val(email[0]);									// 이메일 앞쪽의 값을 넣는다
						$("input#EMAIL2").val(email[1]);									// 이메일 뒤쪽의 값을 넣는다
						$("input#"+key).val(json[key]);										// 비교할 hidden 태그에 값을 넣는다
						$("input#ORG_"+key).val(json[key]);		// 비교를 위한 input 안에 해당 key의 value를 담는다 
					}
					else if(key.includes("_PNT") || key.includes("_AMT")) {					// 숫자(판매, 포인트)
						$("input#"+key).val(addComma(json[key]));							// 콤마처리를 한 뒤 값에 넣는다
						$("input#ORG_"+key).val(addComma(json[key]));		// 비교를 위한 input 안에 해당 key의 value를 담는다 
					}
					else{																	// 위의 조건을 제외한 나머지
						$("input#"+key).val(json[key]);										// 해당 key의 value를 담는다
						$("input#ORG_"+key).val(json[key]);		// 비교를 위한 input 안에 해당 key의 value를 담는다 
					}
					
			} // end of for-----------------------------
			
			flag_mblDuplicated = true;														// 핸드폰 중복검사 flag를 true로 변경
			flag_emailDuplicated = true;													// 이메일 중복검사 flag를 true로 변경
			
           	$("#checkMblDuplicated").css("background-color","green");						// 휴대폰중복확인버튼 초록색 표시
        	$("#checkEmailDuplicated").css("background-color","green");						// 메일중복확인버튼 초록색 표시

			$("#BF_SS_CD").val($("#ORG_CUST_SS_CD").val());									// 초기 고객상태를 담는다
			$("#HD_CUST_NO").val($("#CUST_NO").val());										// 고객번호를 담는다
			$("#OR_SS_CD").val($("#ORG_CUST_SS_CD").val());									// 초기 고객상태를 담는다
			checkCustStatus();																// 고객상태에 따른 설정함수 실행
		},
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	}); // end of $.ajax()-----------------------
	
} // end of function selectItem(SEARCHWORD, url)----------


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
			
			
			if($("#OR_SS_CD").val() != "80"){							// 최초고객상태가 정지가 아니라면
				flag_mblDuplicated = false;									// 핸드폰 중복검사 flag를 false로 변경
				$("#checkMblDuplicated").css("background-color","red");		// 휴대폰중복확인버튼 빨간색 표시
			}
		}
		else if( BF_SS_NM == "중지" ) {
			$("#STP_DT").val("");								// 중지일자를 현재로 설정
		}
		
				
		if($("#OR_SS_CD").val() == "80") {								// 처음코드가 중지였다면
			if(confirm("고객상태를 정상으로 변경하시겠습니까?")){
				$("input:radio[value='80']").prop('disabled', true);	// 중지버튼을 선택불가로 만든다
				$("input:radio[value='90']").prop('disabled', true);	// 해지버튼을 선택불가로 만든다
			}
			else{
				$("input:radio[value='80']").prop('checked', true);		// 중지버튼을 선택한다
				$("#STP_DT").val(getToday());							// 중지일자를 현재로 설정
			}
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
		
		if($("#OR_SS_CD").val() == "80") {								// 처음코드가 중지였다면
			if(confirm("고객상태를 해지로 변경하시겠습니까?")){
				$("input:radio[value='10']").prop('disabled', true);	// 중지버튼을 선택불가로 만든다
				$("input:radio[value='80']").prop('disabled', true);	// 해지버튼을 선택불가로 만든다
			}
			else{
				$("input:radio[value='80']").prop('checked', true);		// 중지버튼을 선택한다
				$("#CNCL_DT").val("");									// 해지일자를 비운다
				$(".not").prop('readonly', false);								// 택스트상자 선택가능
				$(".ui-datepicker-trigger").removeClass("hide");					// 달력아이콘 활성화
				$("#CNCL_CNTS").prop('readonly', true);						// 해지사유를 적을수 있게 한다
				$("#CUST_NM, #MBL1, #MBL2, #MBL3").prop('readonly', false);		// 고객명, 핸드폰번호를 수정불가로 만든다
			}
		}
	}
	
	$("#BF_SS_CD").val(CUST_SS_CD);										// 기능을 모두 수행한 뒤 변경 전 코드를 최신화한다
	
} // end of function changeCustStatus() {}-------------------

// 오늘날짜 가져오기
function getToday(){
    var date = new Date();
    var year = date.getFullYear();
    var month = ("0" + (1 + date.getMonth())).slice(-2);
    var day = ("0" + date.getDate()).slice(-2);

    return year + "-" + month + "-" + day;
} // end of function getToday(){}---------------------
		
// 회원정보를 update
function updateItem(data, url, dataTp) {
	
	if( dataTp == "serialize" ){
		var formData = $("form[name="+data+"]").serialize(); 			// form 이름을 받아와 그 form의 input name과 value들을 직렬화
	}
	
	$.ajax({
		url: url,
		data: formData, 
		dataType:"JSON", 											// 데이터 타입을 JSON 형태로 전송
		type:"POST",												// POST 방식을 적용
		success:function(json){ 									// return된 값이 존재한다면
			if(json.result == "1"){
				alert("고객정보 수정 성공!");
				console.log(changeArr + "길이 : " + changeArr.length);
				insertHistory(changeArr, "/shopping/insertHistory.dowell");		// 변경항목을 변경이력에 insert
			}
		},
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	}); // end of $.ajax()-----------------------
	
} // end of function updateItem(data, url, dataTp) {}-------------------------

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

// 변경이력을 insert(고객이력등록)
function insertHistory(data, url){
	
	$.ajax({
		url: url,
		data: {"data" : JSON.stringify(data)},						// data를 JSON 문자열로 변환
		dataType: "JSON", 											// 데이터 타입을 JSON 형태로 전송
		type: "POST",												// POST 방식을 적용
		traditional: true,											// 데이터에 배열을 전송할 때 데이터 직렬화를 하는 옵션(true / false)
		success:function(json){ 									// return된 값이 존재한다면
		
			if(json.result == "1"){
				// alert("변경이력 insert 성공!");
			}
		},
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	}); // end of $.ajax()-----------------------
	
	flag_req = false;			// 필수입력항목이 충족되었는지 구별할 flag 초기화
	flag_existOrg = false;		// 기존정보가 존재하는지 구별할 flag 초기화
	flag_changed = false;		// 고객정보조회시 변동사항 유무 구별 flag 초기화
	changeArr = [];				// 변동된 사항을 담아주는 배열 초기화

	// location.reload(); 			// 새로고침
	location.href = "/shopping/customerList.dowell";
	
} // end of function insertHistory(target, data, url){}--------------------

// form에 있는 정보로 insert를 실행하는 함수(신규등록 등록버튼 클릭시 실행)
function insertItemWithForm(form, url) {
	
	var formData = $("form[name="+form+"]").serialize(); 			// form 이름을 받아와 그 form의 input name과 value들을 직렬화
	// alert(formData);
	
	$.ajax({
		url: url,
		data: formData, 
		dataType:"JSON", 											// 데이터 타입을 JSON 형태로 전송
		type:"POST",												// POST 방식을 적용
		success:function(json){ 									// return된 값이 존재한다면
			if(json.result == "1"){
				alert("고객등록 성공!");
				closeTabClick();
			}
		},
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	}); // end of $.ajax()-----------------------
	
} // end of function insertItemWithForm(form, url) {}---------------
		
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////모듈화 시험 ////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		

// ajax 통신 성공시 한 row의 정보를 보여주는 함수		
function getOneDetail(data) {
	
	alert(data);
	/*$.each(data, function(key, value){
		$("#"+data.key).val(data.value);
	});*/
}	

// ajax안의 환경설정 함수
function ajaxForm(data, url, dataType, type, successFunc) {
	var form = {	
					"url": url,
					"data": data, 
					"dataType": dataType, 											// 데이터 타입을 JSON 형태로 전송
					"type": type,												// POST 방식을 적용
					"success": function(result){ 									// return된 값이 존재한다면
						successFunc(result);
					},
					error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				}
				
	return form;
}

// (모듈화 심화과정) 하나의 정보 가져오기
function getOneData(data, url) {
	$.ajax(ajaxForm(data, url, "JSON" ,"POST", "getOneDetail()"));
} // end of function getOneData(data, url) {}--------------------		
		
// (모듈화 심화과정) 리스트 가져오기
function getItemList() {
	
} // end of function getItemList() {}------------------- 