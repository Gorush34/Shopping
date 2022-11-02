
$(document).ready(function() {										// 페이지가 로딩되었을 때 시작하는 부분
	
	// input box가 공백인지 체크
	$(document).on("keyup",".blank_key",function(){					// 매장조건 입력란에서 키보드를 입력할 때
		if(event.keyCode == 8 || event.keyCode == 46) { 			// 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
			if( $("input#PRT_CD_NM").val() == "" ) {				// 매장검색란의 내용이 아무것도 없다면
				$("input#JN_PRT_CD").val("");						// 매장코드를 비운다
			} 
			// 과제3 고객판매수금등록 전용 시작 ====================================
			if(typeof regSal !== 'undefined' && $("input#IN_CUST_NO").val() == "" && $("input#CUST_NO").val() != "") {	// 과제3 2페이지에서 왔다면
				confirmClear();										// 입력정보 초기화여부를 물어보는 함수 실행
			}
			// 과제3 고객판매수금등록 전용 끝 ====================================
			if($("input#IN_CUST_NO").val() == "") {					// 고객검색란의 내용이 아무것도 없다면
				$("input#CUST_NO").val("");							// 고객번호를 지운다
				$("input#AVB_PNT").val("");							// 가용포인트를 지운다
			}
			
			if($(this).val() == "" && this.id == "PRD_CD") {		// 아이디가 상품코드이고 그 값이 비었다면
				var blk_tr = $(this).closest('tr');					// 해당 row의 위치를 담는다
				var blk_td = blk_tr.children();						// 해당 row의 td 위치를 담는다
				blk_td.eq(3).text("");								// 상품정보들을 지운다
				blk_td.eq(4).text("");
				blk_td.eq(5).find("#CUST_SAL_QTY").val("");
				blk_td.eq(5).find("#CUST_SAL_QTY").attr("readonly", true);
				blk_td.eq(6).text("");
				blk_td.eq(7).text("");
				getTotalPrd();
			}
 		}
	}); // end of $("input.blank_key").keyup(function(event){})------------- 
	
	// 매장검색칸에서 엔터 입력시
	$("input.enter_prt").keydown(function(event){					// 매장조건 입력란에서 키를 입력 후 
		
		if(event.keyCode == 13) { 									// 엔터를 했을 경우
			if(checkWord($("input#PRT_CD_NM").val()) === true ) {	// 정규표현식(checkWord)에 위배되지 않는다면
				getPrtCodeName();									// 검색조건의 결과가 몇 개인지 알아오는 함수 실행	
			} 
		}
		
	}); // end of $("input#PRT_CD_NM").keydown(function(event){})-------------------------------
	
	// 고객검색칸에서 엔터 입력시
	$("input.enter_cust").keydown(function(event){					// 고객번호 입력란에서 키를 입력 후 
		
		if(event.keyCode == 13) { 									// 엔터를 했을 경우
			if(checkWord($("input#IN_CUST_NO").val()) === true ) {	// 정규표현식(checkWord)에 위배되지 않는다면
				
				// 과제3 고객판매수금등록 전용 시작 ====================================
				if(typeof regSal !== 'undefined' && $("input#IN_CUST_NO").val() != org_cust_nm && $("input#CUST_NO").val() != "") {
					temp = $("input#IN_CUST_NO").val();				// 임시저장변수에 검색어를 담는다
					if(confirmClear()){									// 입력정보 초기화여부를 물어보는 함수 실행
						$("input#IN_CUST_NO").val(temp);				// 검색어입력란에 임시값에 저장한 값을 담는다
						getCustCodeName();								// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
						temp = "";
					}
				} // 과제3 고객판매수금등록 전용 끝 ====================================
				else{
					getCustCodeName();								// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
				}
			}
		}
	}); // end of $("input#IN_CUST_NO").keydown(function(event){})------------------------------

	// 제품검색칸에서 엔터 입력시
	// $("input.enter_prd").keydown(function(event){				// 제품번호 입력란에서 키를 입력 후 (수정필히해야함!)
	$(document).on("keydown",".enter_prd",function(){
		if(event.keyCode == 13) { 									// 엔터를 했을 경우
			if(checkWord($("input#PRD_CD").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
				rowIdx = getRowLocation();							// 해당 행의 판매번호를 가져온다
				$("#SEARCH_PRD_CD_NM").val($(this).val());			// 검색어를 hidden에 저장
				getPrdCodeName();
			}
		}
	}); // end of $("input.enter_prd").keydown(function(event){	

	// 매장찾기버튼 클릭시
	$("button#btn_search_prt").on("click", function () { 			// 매장 찾기 버튼을 클릭했을 때
		
		if(checkWord($("input#PRT_CD_NM").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
				getPrtCodeName();									// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
		}
	
	}); // end of $("button#btnSearch_prt").on("click", function (event) {})---------------------
	
	// 고객찾기버튼 클릭시
	$("button#btn_search_cust").on("click", function () { 			// 고객번호 찾기 버튼을 클릭했을 때\
		if(checkWord($("input#IN_CUST_NO").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
			// 과제3 고객판매수금등록 전용 시작 ====================================
			if(typeof regSal !== 'undefined' && $("input#IN_CUST_NO").val() != org_cust_nm && $("input#CUST_NO").val() != "") {
				temp = $("input#IN_CUST_NO").val();				// 임시저장변수에 검색어를 담는다
				if(confirmClear()){									// 입력정보 초기화여부를 물어보는 함수 실행
					$("input#IN_CUST_NO").val(temp);				// 검색어입력란에 임시값에 저장한 값을 담는다
					getCustCodeName();								// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
					temp = "";
				}
			} // 과제3 고객판매수금등록 전용 끝 ====================================
			else{
				getCustCodeName();								// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
			}
		}
	
	}); // end of $("button#btnSearch_cust").on("click", function (event) {})---------------------

	// 제품찾기버튼 클릭시
	//$("button#btn_search_prd").click(function(){					// 상품코드 버튼을 눌렀을 때
	$(document).on("click","#btn_search_prd",function(){
		if(checkWord($("input#PRD_CD").val()) === true ) {			// 정규표현식(checkWord)에 위배되지 않는다면
				rowIdx = getRowLocation();							// 해당 행의 판매번호를 가져온다
				$("#SEARCH_PRD_CD_NM").val($(this).prev().val());	// 검색어를 hidden에 저장
				getPrdCodeName();
		}
		
    }); // end of $("button#test").click(function(){})------------
	
	// ##1-4. 고객판매관리 버튼 클릭시
	$("button#btnCustSalMag").click(function(){						// 과제3 고객판매관리 큰 돋보기 버튼 클릭시
		from_csm = true;											// 고객판매관리에서 왔음을 구분하는 변수 true로 설정
		reqCheck();													// 필수입력항목 검사
		if(flag_req) {												// 필수입력항목에서 이상이 없으면
			sMethodName = "SEARCHSALLIST";							// 메소드이름을 제품검색으로 저장
			sArgument = func_createArgument(sMethodName);			// 메소드이름으로 인자를 생성
			$.ajax(sArgument);										// ajax 통신 실행	
		}
	}); // end of $("button#btn_search_sal_list").click(function(){})------------	
	
}); // end of $(document).ready(function() {}------------------------

// Function Declaration

// 매장정보를 검색하여 정보를 받거나 팝업을 띄우는 함수
function getPrtCodeName() {
	var searchWord = $("input#PRT_CD_NM").val();						// 매장검색어를 변수에 담는다
	
	getList(searchWord, "/shopping/getPrtList.dowell", "prt");			// 검색어와 실행할 URL을 지정하여 리스트 검색함수 실행
} // end of function getPrtCodeName() {}-----------

// 고객정보를 검색하여 정보를 받거나 팝업을 띄우는 함수
function getCustCodeName() {
	var searchWord = $("input#IN_CUST_NO").val();						// 매장검색어를 변수에 담는다
	
	getList(searchWord, "/shopping/getPopUpCustList.dowell", "cust");	// 검색어와 실행할 URL을 지정하여 리스트 검색함수 실행
} // end of function getPrtCodeName() {}-----------

// 제품정보를 검색하여 정보를 받거나 팝업을 띄우는 함수
function getPrdCodeName() {
	target = $(event.target).closest('tr').find("#PRD_CD");				// 클릭한 곳의 상품코드의 위치를 담는다
	sMethodName = "SEARCHPRODUCT";										// 메소드이름을 제품검색으로 저장
	sArgument = func_createArgument(sMethodName, target.val());			// 메소드이름으로 인자를 생성
	$.ajax(sArgument);													// ajax통신 실행 디버깅
} // end of function getPrdCodeName() {}-----------


// 매장 및 고객에서 검색어를 통해 리스트를 불러오는 함수(##결과하나검색)
function getList(searchWord, url, from) {
	
	if(searchWord == undefined) {										// 아무것도 입력하지 않았다면
		searchWord = "";												// 빈칸처리
	} 
	
	$.ajax({
		url: url,
		dataType:"JSON", 												// 데이터 타입을 JSON 형태로 전송
		data: {"SEARCHWORD":searchWord,
			   "SEARCHWORD_NM":"",
			   "SEARCHWORD_MBL":""}, 
		type:"POST",													// POST 방식을 적용
		success:function(json){ 										// return된 값이 존재한다면
		
			if(json.length == 1 && from === "prt") { 					// 매장검색의 결과가 하나라면
				$("input#JN_PRT_CD").val(json[0].PRT_CD); 				// 매장코드를 입력한다
				$("input#PRT_CD_NM").val(json[0].PRT_NM); 				// 매장명을 입력한다
			}
			else if(json.length == 1 && from === "cust") { 				// 고객검색의 결과가 하나라면
				if( typeof regSal !== 'undefined' && json[0].CUST_SS_CD != "정상") {		// 과제3 2페이지 전용(고객상태가 정상이 아니라면)
					alert("고객상태가 정상인 고객을 대상으로 판매가 가능합니다.");
					$("input#CUST_NO").val("");
					$("input#IN_CUST_NO").val("");
					$("input#AVB_PNT").val("");
					$("input#IN_CUST_NO").focus();
				}
				else {
					$("input#CUST_NO").val(json[0].CUST_NO); 				// 고객번호를 입력한다
					$("input#IN_CUST_NO").val(json[0].CUST_NM); 			// 고객명을 입력한다
					$("input#AVB_PNT").val( addComma(json[0].AVB_PNT) );	// 가용포인트를 입력한다
					
					if(typeof regSal !== 'undefined') {
						org_cust_no = json[0].CUST_NO;
						org_cust_nm = json[0].CUST_NM; 
						org_avb_pnt = json[0].AVB_PNT; 
					}
				}
			}
			else{														// json으로 받아온 status의 값이 1이 아니라면(결과가 1이 아니라면)
				if(from === "prt") { 									// 매장코드 검색했을 때
					search_popup('search_prt', from, '900', '600');		// 매장검색 팝업을 실행
				}
				else if(from === "cust") {								// 고객정보 검색했을 때 
					search_popup('search_cust', from, '900', '600');	// 고객정보 팝업을 실행
				}
			}
			
		},
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
			
	}); // end of $.ajax({})-------------------
	
	from_cust = false;													// 어디에서 왔는지 구분하는 flag 초기화(고객)
	from_prt = false; 													// 어디에서 왔는지 구분하는 flag 초기화(매장)
		
} // end of function getList(searchWord, url)----------------------

// ##2-2. 버튼을 누르거나 검색어 입력시 값을 출력하거나 팝업창을 띄워주는 함수
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
			checkCustStatus();																// 고객상태에 따른 설정함수 실행
		},
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	}); // end of $.ajax()-----------------------
	
} // end of function selectItem(SEARCHWORD, url)----------

//===================================모듈화 ver.2=====================

// 종류에 따라 인자를 생성하는 함수
function func_createArgument(sKind, searchWord) {
	
	if(searchWord == undefined) {								// 아무것도 입력하지 않았다면
		searchWord = "";										// 빈칸처리
	}
	
	var sReturnObj;												// 인자를 담을 변수 생성
	if(sKind == "SEARCHPRODUCT") {								// ##4-2. 검색종류 : 고객판매수금등록에서 상품코드를 검색시 페이지 요청
 
		sReturnObj = {
						url : "/shopping/getProductList.dowell",
						data : {
									"SEARCHWORD_PRD" : searchWord,
									"SEARCHWORD_PRT" : $("#SE_PRT_CD").val(),
									"FROM" : "PRD"
						},	
						datatype : "JSON",
						type : "POST",
						success : function(data){
							fn_postProcess(JSON.parse(data), "SEARCHPRODUCT");	// ##4-4. 통신성공시 함수 실행
						},
						error : function(request, status, error){
									alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								}
			
					  };
	} // end of if(sKind == "SEARCHPRODUCT") {}---------
	else if(sKind == "GETPRODUCTLIST") {						// 검색종류 : 제품조회팝업창에서 상품코드를 검색시(윗부분 판매정보)
 
		sReturnObj = {
						url : "/shopping/getProductList.dowell",
						data : {
									"SEARCHWORD_PRD" : $("#PRD_CD_NM").val(),
									"SEARCHWORD_PRT" : $("#PRT_CD_NM").val()
						},	
						datatype : "JSON",
						type : "POST",
						success : function(data){
							fn_postProcess(JSON.parse(data), "GETPRODUCTLIST");
						},
						error : function(request, status, error){
									alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								}
			
					  };
	} // end of if(sKind == "GETPRODUCTLIST") {}---------
	else if(sKind == "SEARCHSALLIST"){							// ##1-5. 검색종류 : 과제3 1페이지 고객판매관리에서 목록 조회시 페이지 요청(아래부분 상품정보)
		sReturnObj = {	
						url : "/shopping/getSalList.dowell",
						data : $("#searchFrm").serialize(),	
						datatype : "JSON",
						type : "POST",
						success : function(data){
							fn_postProcess(JSON.parse(data), "SEARCHSALLIST");	// 성공시 메소드 이름에 따른 함수 실행
						},
						error : function(request, status, error){
									alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								}
			
					  };
	} // end of if(sKind == "SEARCHSALLIST"){}------------
	else if(sKind == "GETSALDETAIL"){											//  ##3-4. 검색종류 : 고객판매관리에서 목록 조회시 페이지 요청(상세부분)											
		sReturnObj = {
						url : "/shopping/getSalDetailList.dowell",
						data : JSON.parse($("#PT_MAP").val()),	
						datatype : "JSON",
						type : "POST",
						success : function(data){
							fn_postProcess(JSON.parse(data), "GETSALDETAIL");	// 성공시 함수 실행(3-6)
						},
						error : function(request, status, error){
									alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								}
			
					  };
	} // end of if(sKind == "GETSALDETAIL"){}------------
	else if(sKind == "INSERTSAL" || sKind == "INSERTRTN"){	// ##피드백2. 고객판매수금등록 / 반품등록시 제품판매상세테이블 insert 및 매장현재고 update 페이지 요청								
		sReturnObj = {
						url : "/shopping/insertSal.dowell",
						data : JSON.stringify(convertData(sKind)),	 	// 2-9 데이터 가공함수 실행
						datatype : "JSON",
						contentType : "application/json",
						type : "POST",
						success : function(data){
							if(data.status == "SAL") {
								alert("판매등록이 완료되었습니다.");	
							}
							else {
								alert("반품처리가 완료되었습니다.");
							}
							
							paramArr = [];							// 배열 초기화
							closeTabClick();						// 팝업창을 닫는 함수 실행
						},
						error : function(request, status, error){
									alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								}
			
					  };
	} // end of if(sKind == "INSERTSAL"){}------------
	else if(sKind == "REALTIMECHECKPRODUCT"){											//  ################# 실시간체크 테스트 ####################									
		sReturnObj = {
						url : "/shopping/realTimeCheckProduct.dowell",
						data : JSON.stringify(convertData(sKind)),	
						datatype : "JSON",
						contentType : "application/json",
						type : "POST",
						success : function(data){
							realTimeFlag = displayStatus(data);		// 상태에 따른 데이터 표시
							paramArr = [];							// 배열 초기화
							
							if(realTimeFlag){									// 실시간 유효성검사가 통과되었다면
								sMethodName = "INSERTSAL";						// 메소드이름을 판매등록으로 저장(피드백2)
								sArgument = func_createArgument(sMethodName);	// 메소드이름으로 인자를 생성(피드백2)
								$.ajax(sArgument);								// ajax 통신 실행(피드백2)
							}
						},
						error : function(request, status, error){
									alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								}
			
					  };
	} // end of if(sKind == "REALTIMECHECKPRODUCT"){}------------
	
	return sReturnObj;			

}// end of func_createArgument(sKind) {}---------------------

// ajax통신 성공시 실행하는 함수
function fn_postProcess(data, sKind) {
	
	if(sKind == "SEARCHPRODUCT") { 												// ##4-4. 종류가 상품검색일 때
		if( data.length >= 0 ) {												// 데이터가가 하나 이상일 때
			if(data.length == 1) { 												// 상품검색의 결과가 하나라면
				if( checkProduct(data[0])) {									// 상품상태가 적합하다면
					var tr = target.closest('tr');								// 해당 행의 위치를 가져온다
					tr.find("#PRD_CD").val(data[0].PRD_CD);							// 상품코드를 담는다
					if(checkUnique(data[0].PRD_CD)){							// 해당 상품이 고유하다면
						
						// tr.find("#PRD_CD").val(data[0].PRD_CD);						// 상품코드를 담는다
						tr.find("#HD_PRD_CD").val(data[0].HD_PRD_CD);					// 상품코드를 담는다(hidden)
						tr.find("#PRD_NM").text(data[0].PRD_NM);						// 상품명을 담는다
						tr.find("#IVCO_QTY").text(addComma(data[0].IVCO_QTY));			// 재고수량을 담는다
						tr.find("#PRD_CSMR_UPR").text(addComma(data[0].PRD_CSMR_UPR));	// 소비자가를 담는다
						tr.find("#CUST_SAL_QTY").val("");								// 판매수량을 초기화한다
						tr.find("#CUST_SAL_QTY").attr("readonly", false);				// 판매수량을 입력가능하게 한다
						tr.find("#CUST_SAL_QTY").focus();								// 커서를 판매수량에 위치시킨다
					}
					else{														// 해당 상품이 고유하지 않다면
						tr.find("#PRD_CD").val("");								// 상품코드를 비운다
						tr.find("#PRD_CD").focus();								// 커서를 상품코드에 위치시킨다 
					}
				}
				else{
					target.val("");												// 값을 비워준다
				}
				
			}
			else{																// json으로 받아온 status의 값이 1이 아니라면(결과가 1이 아니라면)
				
				// 견본품 제거 시작(미사용)
				/*if(data.length != 0) {											// 값이 비어있지 않다면
					data = getOnePrdInfo(data);									// 견본품을 제거하는 함수 실행
				}
				
				if(data.length == 1) { 											// 견본품을 제거한 상품의 결과가 하나라면
					setOnePrdInfo(data[0]);										// 그 상품정보를 해당 행에 담는 함수 실행
				}
				else {
					search_popup('searchPrd', 'searchPrd', '700', '600');			// 제품검색 팝업을 띄운다
				}*/
				// 견본품 제거 끝(미사용)
				
				search_popup('searchPrd', 'searchPrd', '700', '600');			// 제품검색 팝업을 띄운다
			}			
		}
	} // end of if(sKind == "SEARCHPRODUCT") {}-----------------
	else if(sKind == "GETPRODUCTLIST") { 										// 종류가 상품검색목록 조회일 때
		createTableRow(data, sKind);									// 테이블 row 생성
	}
	else if(sKind == "SEARCHSALLIST") { 										// ##1-12. 종류가 판매목록 조회일 때
		createTableRow(data, sKind);									// 테이블 row 생성
	}
	else if(sKind == "GETSALDETAIL") { 											// ##3-6. 종류가 판매상세목록 조회일 때
		createTableRow(data, sKind);									// 테이블 row 생성
	}
	
} // end of function fn_postProcess(data) {}----------------

// 데이터의 개수만큼 테이블 안의 row를 추가해주는 함수
function createTableRow(data, sKind) {
	
	if(sKind == "SEARCHSALLIST") {								// ##1-13. 만드려는 행의 종류가 과제3 고객판매관리의 판매목록이라면
		let html = "";											// html 태그를 담기위한 변수 생성
			
		if(data.length > 0) { 									// 데이터가 하나라도 존재한다면
			
			$.each(data, function(index, item){					// return된 json 배열의 각각의 값에 대해서 반복을 실시한다.
				
				info[index] = JSON.stringify(item);				// 해당 행에 대한 정보들을 배열에 담는다(상세버튼 클릭시 넘겨주기 위함)
				
				if( data.length == (index+1) && is_exist){
					getTotal(item, sKind);
				}
				else{
					html += "<tr>";  
					html += "<td class='border center tbl_sm' id=''>"+convertDateFormat(item.SAL_DT)+"</td>";
					html += "<td class='border center tbl_sm' id=''>"+item.CUST_NO+"</td>";
					html += "<td class='border left tbl_md' id=''>"+item.CUST_NM+"</td>";
					html += "<td class='border left tbl_sm' id=''>"+item.SAL_NO+"<button type='button' class='btn btn-secondary btn_td' id='sal_detail'  onclick='sal_detail("+index+")' style='float:right; width:40px;'>상세</button></td>";
					if(item.SAL_TP_CD == "SAL"){
						html += "<td class='border right tbl_md' id=''>"+addComma(item.TOT_SAL_QTY)+"</td>";
						html += "<td class='border right tbl_md' id=''>"+addComma(item.TOT_SAL_AMT)+"</td>";
					} else if(item.SAL_TP_CD == "RTN"){
						html += "<td class='border right tbl_md' id='' style='color:red;'>"+addComma(item.TOT_SAL_QTY)+"</td>";
						html += "<td class='border right tbl_md' id='' style='color:red;'>"+addComma(item.TOT_SAL_AMT)+"</td>";
					}
					html += "<td class='border right tbl_md' id=''>"+addComma(item.CSH_STLM_AMT)+"</td>";
					html += "<td class='border right tbl_md' id=''>"+addComma(item.CRD_STLM_AMT)+"</td>";
					html += "<td class='border right tbl_md' id=''>"+addComma(item.PNT_STLM_AMT)+"</td>";
					html += "<td class='border left tbl_sm' id=''>"+item.REG_USER_NM+"</td>";
					html += "<td class='border center tbl_sm' id=''>"+item.FST_REG_DT+"</td>";
					html += "<td class='border center' id='' style='display:none;'>"+item.SAL_TP_CD+"</td>";
					// html += "<td class='border center' id='' style='display:none;'>"+item.RTN_CNT+"</td>";
					html += "<td class='border center' id='' style='display:none;'>"+item.PRT_NM+"</td>";
					html += "<td class='border center' id='' style='display:none;'>"+item.FST_USER_ID+"</td>";
					html += "<td class='border center' id='' style='display:none;'>"+item.CRD_NO+"</td>";
					html += "<td class='border center' id='' style='display:none;'>"+item.VLD_YM+"</td>";
					html += "<td class='border center' id='' style='display:none;'>"+item.CRD_CO_CD+"</td>";
					// html += "<td class='border center' id='' style='display:none;'>"+item.AVB_PNT+"</td>";
					html += "</tr>";
					
					is_exist = true;									// 값을 출력해주기 위한 flag true
				}		
			});
			
		}
		else {														// 검색조건에 맞는 결과가 없다면
			html += "<tr>";
			html += "<td colspan='11' id='no' class='border center'>검색조건에 맞는 결과가 존재하지 않습니다.</td>";
			html += "</tr>";
			alert("조건을 만족하는 검색결과가 없습니다!");
			
			$("tfoot#TFOOT_SUM").hide();							// 총합계가 출력되는 행을 숨긴다
		}
		
		$("tbody#PERFORM_DISPLAY").html(html); 						// tbody의 id가 PERFORM_DISPLAY인 부분에 html 변수에 담긴 html 태그를 놓는다.
		$("tbody#PERFORM_DISPLAY").show(); 							// tbody의 id가 PERFORM_DISPLAY인 부분을 보여준다
		
		if(is_exist){
			// getTotalQty(4, 9, sKind);								// 행들의 총합을 구하는 함수 실행
		}
		
	} // end of if(sKind == "SEARCHSALLIST"){}---------------------
	else if(sKind == "GETSALDETAIL") {								// ##3-7. 만드려는 행의 종류가 과제3 판매상세조회 아랫부분 판매상세목록이라면
		let html = "";												// html 태그를 담기위한 변수 생성
		if(data.length > 0) { 										// 데이터가 하나라도 존재한다면
			
			$.each(data, function(index, item){						// return된 json 배열의 각각의 값에 대해서 반복을 실시한다.
				
				if(data.length == index +1 ){						// 배열의 마지막(반품여부) 인덱스라면
					// $("#RTN_YN").val(item);						// 반품여부를 input tag에 담는다
					if(item == "Y"){								// 반품여부가 Y(반품된 상세정보)라면
						$("#return").prop('disabled', true);		// 반품버튼을 선택불가로 만든다
					}
					is_exist = true;								// 값을 출력해주기 위한 flag true	
					return true;									// 반복문 continue로 탈출
				}
				
				html += "<tr>";
				html += "<td class='border center' id='' style='width:50px; min-width:50px; max-width:50px;'>"+item.SAL_SEQ+"</td>";
				html += "<td class='border center' id='' style='width:150px; min-width:150px; max-width:150px;'>"+item.PRD_CD+"</td>";
				html += "<td class='border left' id='' style='width:150px; min-width:150px; max-width:150px;'>"+item.PRD_NM+"</td>";
				html += "<td class='border right' id='' style='width:100px; min-width:100px; max-width:100px;'>"+addComma(item.SAL_QTY)+"</td>";		
				html += "<td class='border right' id='' style='width:180px; min-width:180px; max-width:180px;'>"+addComma(item.SAL_VOS_AMT)+"</td>";
				html += "<td class='border right' id='' style='width:150px; min-width:150px; max-width:150px;'>"+addComma(item.SAL_VAT_AMT)+"</td>";
				html += "<td class='border right' id='' style='width:200px; min-width:200px; max-width:200px;'>"+addComma(item.SAL_AMT)+"</td>";
				html += "</tr>";

				is_exist = true;								// 값을 출력해주기 위한 flag true
				
			});
		
		}
	else {														// 검색조건에 맞는 결과가 없다면
			html += "<tr>";
			html += "<td colspan='7' id='no' class='border center'>검색조건에 맞는 결과가 존재하지 않습니다.</td>";
			html += "</tr>";
			alert("조건을 만족하는 검색결과가 없습니다!");
		}
		
		$("tbody#PERFORM_DISPLAY").html(html); 					// tbody의 id가 DISPLAY인 부분에 html 변수에 담긴 html 태그를 놓는다.
		$("tbody#PERFORM_DISPLAY").show(); 						// tbody의 id가 DISPLAY인 부분을 보여준다
		
		if(is_exist){											// 출력할 값이 존재한다면
			getTotalQty(3, 7, sKind);							// 합계를 구하는 함수를 실행
		}
		
	} // end of if(sKind == "GETSALDETAIL"){}---------------------
	else if(sKind == "GETPRODUCTLIST") {						// 만드려는 행의 종류가 과제3 매장재고조회(팝업) 제품목록이라면
		let html = "";											// html 태그를 담기위한 변수 생성
		if(data.length > 0) { 									// 데이터가 하나라도 존재한다면
			
			$.each(data, function(index, item){					// return된 json 배열의 각각의 값에 대해서 반복을 실시한다.
				
				if(item.PRD_TP_NM != "견본품") {					// 상품유형명이 견본품이 아닐 때
					html += "<tr id='row_"+index+"'>";  
					html += "<td class='center' style='width:50px; min-width:50px; max-width: 50px;'><input type='checkbox' id='chBox"+index+"' class='checkBox' name='chBox'/></td>";
					html += "<td class='center' id='PRD_CD' style='width:150px; min-width:150px; max-width:150px;' ondblclick='sendPopupToOpener_prd()'>"+item.PRD_CD+"</td>";
					html += "<td class='left' id='PRD_NM' style='width:150px; min-width:150px; max-width:150px;' ondblclick='sendPopupToOpener_prd()'>"+item.PRD_NM+"</td>";
					html += "<td class='right' id='IVCO_QTY' style='width:100px; min-width:100px; max-width:100px;' ondblclick='sendPopupToOpener_prd()'>"+addComma(item.IVCO_QTY)+"</td>";
					html += "<td class='right' id='PRD_CSMR_UPR' style='width:180px; min-width:180px; max-width:180px;' ondblclick='sendPopupToOpener_prd()'>"+addComma(item.PRD_CSMR_UPR)+"</td>";
					html += "<td class='border center' id='PRD_TP_CD' style='display:none;'>"+item.PRD_TP_CD+"</td>";
					html += "<td class='border center' id='PRD_TP_NM' style='display:none;'>"+item.PRD_TP_NM+"</td>";
					html += "<td class='border center' id='PRD_SS_CD' style='display:none;'>"+item.PRD_SS_CD+"</td>";
					html += "<td class='border center' id='PRD_SS_NM' style='display:none;'>"+item.PRD_SS_NM+"</td>";
					html += "</tr>";
				}
			});
			
			if(html == ""){								// 견본품을 제외한 검색결과가 없다면
				html += "<tr>";
				html += "<td colspan='5' id='no' class='border center' style='width:630px;'>검색조건에 맞는 결과가 존재하지 않습니다.</td>";
				html += "</tr>";
				alert("조건을 만족하는 검색결과가 없습니다!");
			}
		}
		else {											// 검색조건에 맞는 결과가 없다면
			html += "<tr>";
			html += "<td colspan='5' id='no' class='border center' style='width:630px;'>검색조건에 맞는 결과가 존재하지 않습니다.</td>";
			html += "</tr>";
			alert("조건을 만족하는 검색결과가 없습니다!");
		}
		
		$("tbody#TBODY").html(html); 					// tbody의 id가 DISPLAY인 부분에 html 변수에 담긴 html 태그를 놓는다.
		$("tbody#TBODY").show(); 						// tbody의 id가 DISPLAY인 부분을 보여준다
		
		$.each(data, function(index, item){											// data 각 인덱스에 대해 반복문 실행
			if(item.PRD_SS_NM == "해지"){											// 상품상태명이 해지라면
				$("tr#row_"+index).addClass('yellow');								// 해당 row에 yellow 클래스를 더해 배경을 노란색으로 한다
				$("input#chBox"+index).prop('disabled', true);						// 체크박스 선택 불가	
			}
			else if(item.IVCO_QTY == "0" || item.PRD_CSMR_UPR == "0"){				// 재고수량 또는 소비자단가가 0이라면
				$("input#chBox"+index).prop('disabled', true);						// 체크박스 선택 불가	
			}
		});
			
	} // end of if(sKind == "GETPRODUCTLIST"){}---------------------
	
} // end of function createTableRow(data) {}---------------

// ##1-14, ##3-8. 각 열의 합계를 구하는 함수
function getTotalQty(strIndex, endIndex, sKind) {										// (시작인덱스, 종료인덱스, 종류)
	
	var sum_array = new Array();														// 행의 값들을 담을 배열 생성
	var sum = "";																		// 각 일자별 합계를 담을 변수 생성
	var rows = document.getElementById("PERFORM_DISPLAY").getElementsByTagName("tr");	// tbody 안의 tr의 개수(조회된 매장의 수)를 구한다

    for( let i = strIndex; i < endIndex; i++ ) { 										// 1일부터 31일 + 총 합계만큼 반복
    	
    	sum = 0;																		// 일자별로 합을 넣은 후 다음 작업을 위한 초기화
    	
    	for(let j=0; j< rows.length; j++) {												// tr의 개수만큼 반복(조회된 매장의 수만큼)
    		
    		var cells = rows[j].getElementsByTagName("td");								// row의 j번째 인덱스에 있는 td의 위치를 담는다
    		
    		var cell_val = cells[i].firstChild.data;									// j번째 row에 위치한 i+시작인덱스에 td의 값을 담는 변수 생성 
			cell_val = cell_val.split(',').join("");									// 콤마를 제거
			    		
			if(sKind =="SEARCHSALLIST"){												// 고객판매관리 조회라면
				var SAL_TP_CD = cells[11].lastChild.data;								// 판매구분코드를 담는다
			}
			
			if(SAL_TP_CD == "RTN"){														// 판매구분코드가 반품이라면
    			sum += (parseInt(cell_val)*-1);											// 숫자로 변환 후 그 값을 sum에 빼준다
    		} 
			else {																		// 그 외에는
				sum += parseInt(cell_val);												// 숫자로 변환 후 그 값을 sum에 더해준다
			}	
		}
    	
    	sum = addComma(sum);															// 합쳐진 sum을 다시 콤마처리
    	sum_array.push(sum);															// 배열의 i번째 인덱스에 sum값을 넣는다(일별 총계)
    	
    	// tfoot(모든 매장의 일별 합계를 보여주는 곳)의 첫번째 row(tr)의 i+1번째 td값을 변경한다
		document.getElementById("TFOOT_SUM").getElementsByTagName("tr")[0].getElementsByTagName("td")[(i+1-strIndex)].innerHTML = sum_array[i-strIndex];
    } // end of for-------------

	is_exist = false;																	// flag 초기화
	$("tfoot#TFOOT_SUM").show();														// tfoot을 보여준다
	
} // end of function getTotalQty() {}------------------
