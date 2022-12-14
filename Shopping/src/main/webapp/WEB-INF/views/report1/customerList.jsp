<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	String ctxPath = request.getContextPath();
%>    
	
<script type="text/javascript">

	let from_cust = false;										// 고객번호를 검색하는지 알아오는 변수
	let from_prt = false;										// 매장을 검색하는지 알아오는 변수

	var prt_nm = "";											// 매장명을 받을 변수 선언
	var se_prt_cd = "";											// 세션에 저장된 매장코드를 받을 변수 선언
	var se_prt_nm = "";											// 세션에 저장된 매장명을 받을 변수 선언
	var se_user_dt_cd = "";										// 세션에 저장된 거래처구분코드를 받아올 변수 선언
	var input_check = "";										// 검색창의 유효성을 검사하기 위한 변수 선언
	
	$(document).ready(function() {								// 페이지가 로딩되었을 때 시작하는 부분
		
		prt_nm = $("input#PRT_CD_NM").val();					// 매장검색란의 value값을 받아온다
		se_prt_cd = $("input#SE_PRT_CD").val();					// 로그인유저의 매장코드를 받아온다
		se_prt_nm = $("input#SE_PRT_NM").val();					// 로그인유저의 매장명을 받아온다
		se_user_dt_cd = $("input#SE_USER_DT_CD").val();			// 로그인유저의 거래처구분코드를 받아온다

		defaultSearch();										// 기본정보를 불러오는 함수 실행
		
		if(se_user_dt_cd != 2 ) {								// 세션에 저장된 사용자구분코드가 2(특약점)가 아니라면
			$("div#adminContainer").hide();						// 신규등록이 포함된 div를 숨긴다
		}
		
		// ====================================== 가입일자 관련 기능 시작 ======================================
		
		// 가입일자를 입력하기 위한 datepicker 부분 시작 ================================
			
	    $.datepicker.regional['ko'] = {
	        closeText: '닫기',
	        prevText: '이전달',
	        nextText: '다음달',
	        currentText: '오늘',
	        monthNames: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)',
	        '7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
	        monthNamesShort: ['1월','2월','3월','4월','5월','6월',
	        '7월','8월','9월','10월','11월','12월'],
	        dayNames: ['일','월','화','수','목','금','토'],
	        dayNamesShort: ['일','월','화','수','목','금','토'],
	        dayNamesMin: ['일','월','화','수','목','금','토'],
	        weekHeader: 'Wk',
	        dateFormat: 'yy-mm-dd',
	        firstDay: 0,
	        isRTL: false,
	        showMonthAfterYear: true,
	        yearSuffix: '',
	        showOn: 'button',
	        buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif", //버튼 이미지 경로
            buttonImageOnly: true, //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
	        changeMonth: true,
	        changeYear: true,
	        showButtonPanel: true,
	        yearRange: 'c-99:c+99',
	        maxDate: 0
	        
	    };
	
	    $.datepicker.setDefaults($.datepicker.regional['ko']);
	
	    $('#SDATE').datepicker();													// 시작일자 datepicker 활성화
	    $('#SDATE').datepicker('setDate', '-7D'); 									// (-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
        $('#SDATE').datepicker("option", "maxDate", 'today');						// 시작일자의 최댓값을 오늘로 설정
	    $('#SDATE').datepicker("option", "onClose", function ( selectedDate ) { 	// onClose 옵션을 주어야, 종료일이 시작일보다 뒤로 갈수 없고, 시작일이 종료일보다 앞으로 갈 수 없음
	        $("#EDATE").datepicker( "option", "minDate", selectedDate );
	    });
	
	    $('#EDATE').datepicker();													// 종료일자 datepicker 활성화
	    $('#EDATE').datepicker('setDate', 'today'); 								//(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
	    $('#EDATE').datepicker("option", "minDate", $("#SDATE").val());				// 종료일자의 최소값을 시작일자로 설정
	    $('#EDATE').datepicker("option", "maxDate", 'today');						// 종료일자의 최댓값을 오늘로 설정
	    $('#EDATE').datepicker("option", "onClose", function ( selectedDate ) { 	// onClose 옵션을 주어야, 종료일이 시작일보다 뒤로 갈수 없고, 시작일이 종료일보다 앞으로 갈 수 없음
	        $("#SDATE").datepicker( "option", "maxDate", selectedDate );
	    });
		
	    // $('img.ui-datepicker-trigger').css({'cursor':'pointer', 'padding-left':'5px', 'padding-right':'10px'});  //아이콘(icon) 위치
			
		// 가입일자를 입력하기 위한 datepicker 부분 끝 ================================
		
		// 시작일자에서 커서가 벗어나는 순간 실행	
		$("input#SDATE").on('blur',function(){
			
			var startDate = $('#SDATE').val();											// 시작일자를 변수에 담는다.
			var endDate = $('#EDATE').val(); 											// 종료일자를 변수에 담는다.
			var regex = RegExp(/^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/); 	// 날짜 정규표현식
			
			var str02 = startDate.substr(5,2) + startDate.substr(8,2);					// 월일을 받아온다
			
			if( str02.substr(0,2) == "02" && parseInt(str02.substr(3,2)) >= 30 ) {		// 2월이면서 30일 이상의 일을 입력했다면
				alert("날짜 형식에 맞지 않습니다. 다시 입력해주세요!");	
				$('#SDATE').datepicker('setDate', '-7D');								// 시작일자를 현재보다 1주 전 또는 종료일자로 초기화한다
				return false;  															// 종료
			}
			
			if(!regex.test(startDate)){													// 시작일자가 정규표현식에 맞지 않다면
				alert("날짜 형식에 맞지 않습니다. 다시 입력해주세요!");	
				$('#SDATE').datepicker('setDate', '-7D');								// 시작일자를 현재보다 1주 전 또는 종료일자로 초기화한다.
				return false;  															// 종료
			}
			
			var startArray = startDate.split('-');         								// 배열에 담겨있는 연,월,일을 사용해서 Date 객체 생성   
			var endArray = endDate.split('-');            								// 배열에 담겨있는 연,월,일을 사용해서 Date 객체 생성         
			var start_date = new Date(startArray[0], startArray[1], startArray[2]);     // 날짜를 숫자형태의 날짜 정보로 변환하여 비교한다	   
			var end_date = new Date(endArray[0], endArray[1], endArray[2]);             // 날짜를 숫자형태의 날짜 정보로 변환하여 비교한다
			
			if(start_date.getTime() > end_date.getTime()) {             				// 시작일자가 종료일자보다 크다면
				alert("종료날짜보다 시작날짜가 작아야합니다.");  
				$('#SDATE').datepicker('setDate', '-7D');								// 시작일자를 현재보다 1주 전 또는 종료일자로 초기화한다
				return false;  															// 종료         
			}
			
		});
		
		// 종료일자에서 커서가 벗어나는 순간 실행
		$("input#EDATE").on('blur',function(){
			
			var startDate = $('#SDATE').val();											// 시작일자를 변수에 담는다.        
			var endDate = $('#EDATE').val(); 											// 종료일자를 변수에 담는다.
			
			var end02 = endDate.substr(5,2) + endDate.substr(8,2);						// 월일을 받아온다
			if( end02.substr(0,2) == "02" && parseInt(end02.substr(2,2)) >= 30 ) {		// 2월이면서 30일 이상의 일을 입력했다면
				alert("날짜 형식에 맞지 않습니다. 다시 입력해주세요!");	
				$('#EDATE').datepicker('setDate', 'today');								// 종료일자를 현재일자로 초기화한다
				return false;  															// 종료
			}
			
			var regex = RegExp(/^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/); 	// 날짜 정규표현식
			
			if(!regex.test(endDate)){													// 종료일자가 정규표현식에 맞지 않다면
				alert("날짜 형식에 맞지 않습니다. 다시 입력해주세요!");
				$('#EDATE').datepicker('setDate', 'today');								// 종료일자를 현재일자로 초기화한다
				return false;  															// 종료  
			}
			
			var startArray = startDate.split('-');         								// 배열에 담겨있는 연,월,일을 사용해서 Date 객체 생성         
			var endArray = endDate.split('-');            								// 배열에 담겨있는 연,월,일을 사용해서 Date 객체 생성         
			var start_date = new Date(startArray[0], startArray[1], startArray[2]);     // 날짜를 숫자형태의 날짜 정보로 변환하여 비교한다        
			var end_date = new Date(endArray[0], endArray[1], endArray[2]);             // 날짜를 숫자형태의 날짜 정보로 변환하여 비교한다
			
			if(start_date.getTime() > end_date.getTime()) {             				// 시작일자가 종료일자보다 크다면             
				alert("종료날짜보다 시작날짜가 작아야합니다.");  
				$('#EDATE').datepicker('setDate', 'today');								// 종료일자를 오늘로 초기화한다
				return false;  															// 종료          
			}
			
		});
		
		// ====================================== 가입일자 관련 기능 끝 ======================================
		
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
					from_prt = true;									// 매장 입력에서 왔음을 표시
					getTotalCount();									// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
				} 
			}
			
		}); // end of $("input#PRT_CD_NM").keydown(function(event){})-------------------------------
		
		$("input.enter_cust").keydown(function(event){					// 고객번호 입력란에서 키를 입력 후 
			if(event.keyCode == 13) { 									// 엔터를 했을 경우
				if(checkWord($("input#IN_CUST_NO").val()) === true ) {	// 정규표현식(checkWord)에 위배되지 않는다면
					from_cust = true;									// 고객번호 입력에서 왔음을 표시
					getTotalCount();									// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
				}
			}
		}); // end of $("input#IN_CUST_NO").keydown(function(event){})------------------------------

		$("button#btn_search_prt").on("click", function (event) { 		// 매장 찾기 버튼을 클릭했을 때
			
			if(checkWord($("input#PRT_CD_NM").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
				from_prt = true;										// 매장 입력에서 왔음을 표시
				getTotalCount();										// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
			}
		
		}); // end of $("button#btnSearch_prt").on("click", function (event) {})---------------------
		
		$("button#btn_search_cust").on("click", function (event) { 		// 고객번호 찾기 버튼을 클릭했을 때\
			
			if(checkWord($("input#IN_CUST_NO").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
				from_cust = true;										// 고객번호 입력에서 왔음을 표시
				getTotalCount();										// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
			}
		
		}); // end of $("button#btnSearch_cust").on("click", function (event) {})---------------------
		
	}); // end of $(document).ready(function() {})--------------------------
	
	// 함수 정의
	
	// 새로고침 아이콘 클릭시 실행되는 함수
	function refresh() {
		defaultSearch();										// 기본조건으로 세팅
		$("tbody#CUST_DISPLAY").hide(); 						// tbody의 id가 CUST_DISPLAY인 부분을 숨겨준다
		$("input#PRT_CD_NM").focus();							// 커서의 위치를 매장검색란으로 위치시킨다
	}
	
	// 기본 조건을 불러오는 함수
	function defaultSearch() {
		
		$("input#CUST_NO").val("");								// disabled 처리된 고객번호 input 태그의 값을 비운다
		$("input#IN_CUST_NO").val("");							// 고객번호 input 태그의 값을 비운다
		
		$('#SDATE').datepicker('setDate', '-7D');				// 시작일자를 현재보다 1주 전 또는 종료일자로 초기화한다.
		$('#EDATE').datepicker('setDate', 'today');				// 종료일자를 오늘로 초기화한다
		
		$('input:radio[id=default]').prop("checked", true);
		
		if( prt_nm === "" && se_user_dt_cd == 2 ) {				// 매장검색란에 아무 값이 없고 거래처구분코드가 2(매장)라면
			$("input#JN_PRT_CD").val(se_prt_cd);				// 매장코드의 value값을 로그인유저의 매장코드로 적용한다
			$("input#PRT_CD_NM").val(se_prt_nm);				// 매장검색란의 value값을 로그인유저의 매장명으로 적용한다
		} 
		else if( se_user_dt_cd == 1 ) {							// 거래처구분코드가 1(본사)라면
			$("input#JN_PRT_CD").val("");						// 매장코드의 value값을 비운다
			$("input#PRT_CD_NM").val("");						// 매장검색란의 value값을 비운다
		}
		
		if(se_user_dt_cd != 2 ) {								// 세션에 저장된 사용자구분코드가 2(특약점)가 아니라면
			$("div#adminContainer").hide();						// 신규등록이 포함된 div를 숨긴다
		}
		
	} // end of function defaultSearch() {}-------------------
	
	// 버튼을 누르거나 검색어 입력시 값을 출력하거나 팝업창을 띄워주는 함수
	function search_popup(location, width, height) {

		// 버튼마다의 주소값을 받는다.
		var loc = location;
		// 팝업창을 띄울 주소를 설정한다.
		const url = "<%= ctxPath%>/"+loc+".dowell"; 
		
		const pop_width = width;
		const pop_height = height;
		const pop_left = Math.ceil( ((window.screen.width)-pop_width)/2 ) ; 		// 값을 정수로 만든다
		const pop_top = Math.ceil( ((window.screen.height)-pop_height)/2 ) ;
		
		window.open( url
					 , "팝업설정"
					 , "left="+pop_left+
					 ", top="+pop_top+
					 ", width="+pop_width+
					 ", height="+pop_height+
					 ", location = no" );
		
	} // end of function search_popup(location) {})---------------------------------------

	// 결과가 하나인지 알아오는 함수 
	function getTotalCount() {
		
		$.trim("input#PRT_CD_NM");										// 매장검색란의 공백을 제거
		var searchWord_prt = $("input#PRT_CD_NM").val();				// 매장검색란의 값을 가져옴
		
		$.trim("input#IN_CUST_NO");										// 고객검색란의 공백을 제거
		var searchWord_cust = $("input#IN_CUST_NO").val();				// 고객검색란의 값을 가져옴
		
		if(from_prt) { 													// 매장검색란에서 함수를 실행했다면
			searchWord_cust = "";										// 고객검색란의 값을 비운다
		}
		else if(from_cust) {											// 고객검색란에서 함수를 실행했다면
			searchWord_prt = ""; 										// 매장검색란의 값을 비운다
		}
		
		$.ajax({
			url:"<%= request.getContextPath()%>/getTotalCount.dowell",
			data: { "searchWord_prt" : searchWord_prt,					// 검색어를 Map 형태로 넣어준다.
				    "searchWord_cust" : searchWord_cust,				// 검색조건 : 매장코드 / 고객번호 / 어떤 버튼을 눌렀는지(매장 or 고객)
				    "from_prt" : from_prt,
				    "from_cust" : from_cust},
			dataType:"JSON", 											// 데이터 타입을 JSON 형태로 전송
			type:"POST",												// POST 방식을 적용
			async:false,												// 동기로 처리(이게 끝나야 다른것을 진행하게끔)
			success:function(json){ 									// return된 값이 존재한다면
				
				if(json.status != "1"){									// json으로 받아온 status의 값이 1이 아니라면(결과가 1이 아니라면)
					if(from_prt) { 										// 매장코드 검색했을 때
						search_popup("search_prt", "900", "600");		// 매장검색 팝업을 실행
					}
					else if(from_cust) {								// 고객정보 검색했을 때 
						search_popup("search_cust", "900", "600");		// 고객정보 팝업을 실행
					}
				}
				else if(from_prt) { 									// 결과가 1이고 매장검색란에서 함수를 실행했다면(결과가 하나일 때)
					$("input#JN_PRT_CD").val(json.PRT_CD);				// 매장코드를 넣는다
					$("input#PRT_CD_NM").val(json.PRT_NM);				// 매장명을 넣는다
				}
				else if(from_cust) {									// 결과가 1이고 고객검색란에서 함수를 실행했다면(결과가 하나일 때)
					$("input#CUST_NO").val(json.CUST_NO);				// 고객번호를 넣는다
					$("input#IN_CUST_NO").val(json.CUST_NM);			// 고객명을 넣는다
				} 
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		}); // end of $.ajax()-----------------------------
		
		from_cust = false;												// 어디에서 왔는지 구분하는 flag 초기화
		from_prt = false; 												// 어디에서 왔는지 구분하는 flag 초기화
		
	} // end of function getTotalCount() {}--------------------------------------
	
	// 고객조회 목록을 불러오는 함수
	function read_cust() {
		
		// 필수입력사항 검사 시작
		let b_FlagRequiredInfo = false;
		
		$("input.requiredInfo").each(function(index, item) {			// 태그의 class가 필수입력항목인 것에 대해서 각각 실행
			const data = $(item).val().trim();							// 공백을 제거한 값이
			if(data == ""){												// 비었다면
				console.log("item : " + data);
				alert("*표시된 필수입력사항은 모두 입력하셔야 합니다.");
				b_FlagRequiredInfo = true;								// flag에 true를 담는다
				return false; 											// 종료
			}
		});
		
		if(b_FlagRequiredInfo) {										// flag가 true라면
			console.log("b_FlagRequiredInfo : " + b_FlagRequiredInfo);
			return;														// read_cust 함수 종료
		}
		
		// 필수입력사항 검사 끝
		
		$.trim("input#PRT_CD_NM");										// 검색란의 공백을 제거한다.
		$.trim("input#IN_CUST_NO");										// 검색란의 공백을 제거한다.
		var formData = $("form[name=searchFrm]").serialize(); 			// form 이름이 searchFrm 인 곳의 input name과 value들을 직렬화
		
		$.ajax({
			url:"<%= request.getContextPath()%>/readCust.dowell",
			data: formData, 
			dataType:"JSON", 											// 데이터 타입을 JSON 형태로 전송
			type:"POST",												// POST 방식을 적용
			success:function(json){ 									// return된 값이 존재한다면
				
				let html = "";											// html 태그를 담기위한 변수 생성
				
				if(json.length > 0) { 
					
					$.each(json, function(index, item){					// return된 json 배열의 각각의 값에 대해서 반복을 실시한다.
						
						// 결과값 한 행의 값들을 담는다
						html += "<tr style='width: 100%;'>";  
						html += "<td class='left' style='width:200px;'>"+item.CUST_NO+"&nbsp;&nbsp;<button type='button' class='btn btn-secondary btn_td' id='change_history' onclick='change_history("+item.CUST_NO+")' style='float:right;'>변경이력</button></td>";
						html += "<td class='left' style='width:170px;'>"+item.CUST_NM+"&nbsp;&nbsp;<button type='button' class='btn btn-secondary btn_td' id='user_detail'  onclick='user_detail("+item.CUST_NO+")' style='float:right;'>상세</button></td>";
						html += "<td class='center'>"+item.MBL_NO+"</td>";
						html += "<td class='center'>"+item.CUST_SS_CD+"</td>";
						html += "<td class='center'>"+item.JS_DT+"</td>";
						html += "<td class='left'>"+item.PRT_NM+"</td>";
						html += "<td class='left'>"+item.USER_NM+"</td>";
						html += "<td class='center'>"+item.LST_UPD_DT+"</td>";
						html += "</tr>";
					
					});
				}
				else {													// 검색조건에 맞는 결과가 없다면
					html += "<tr>";
					html += "<td colspan='8' id='no' class='center'>검색조건에 맞는 고객이 존재하지 않습니다.</td>";
					html += "</tr>";
					alert("조건을 만족하는 검색결과가 없습니다!");
				}
				
				$("tbody#CUST_DISPLAY").html(html); 					// tbody의 id가 CUST_DISPLAY인 부분에 html 변수에 담긴 html 태그를 놓는다.
				$("tbody#CUST_DISPLAY").show(); 						// tbody의 id가 CUST_DISPLAY인 부분을 보여준다
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of $.ajax()-----------------------
		  
	}// end of function goReadComment(){}--------------------------		
	
	// 변경이력 버튼 클릭시 팝업을 불러오는 함수
	function change_history(CUST_NO) {
		
		var his_cust_no = CUST_NO;										// 버튼으로부터 고객번호를 받아온다
		$("input#HIS_CUST_NO").val(his_cust_no);						// input 태그(hidden)에 값을 저장(예비용)
		
		search_popup("change_history", "900", "600"); 					// 이력변경사항 팝업을 실행
		
	} // end of function change_history(CUST_NO)--------------------
	
	
	// 상세 버튼 클릭시 고객상세정보 팝업을 불러오는 함수
	function user_detail(CUST_NO) {
		
		$("input#viewCust").val(CUST_NO);								// input 태그에 클릭한 행의 고객번호를 담는다
		
		const frm = document.viewCustFrm;								// 클릭한 버튼에서 전달한 정보가 담긴 form 변수 선언
	    frm.method = "POST";											// 전송방식 POST 설정
	    frm.action = "<%= ctxPath%>/viewCustomer.dowell";				// 경로 지정
	    frm.submit();													// 제출
		
	} // end of function userDetail(CUST_NO)--------------------
	
	// 날짜를 yyyy-mm-dd 형식으로 만들어 줌.
	function date_mask(objValue) {
	 	var v = objValue.replace("--", "-");										// -- 가 이어지면 -로 교체
	
	    if (v.match(/^\d{4}$/) !== null) {											// 앞의 년도가 yyyy형식으로 채워지면
	        v = v + '-';															// yyyy-로 바꿔준다
	    } else if (v.match(/^\d{4}\-\d{2}$/) !== null) {							// yyyy-mm형식으로 채워지면
	        v = v + '-';															// yyyy-mm-로 바꿔준다
	    }
	 
	    return v;																	// 종료
	} // end of function date_mask(objValue) {})------------------
	
	// 검색시 유효성 검사를 실행하는 함수
	function checkWord(obj) {
		
		let search_length = obj.length;												// 고객이름의 길이를 알아온다
		
		var regex = RegExp(/[가-힣a-zA-Z0-9]{2,20}$/);								// 2-20글자 사이에 완전한 음절과 영어가 들어갔는지 체크하는 정규표현식
		var regex2 = RegExp(/[ㄱ-ㅎㅏ-ㅣ]+/);											// 자음, 모음이 한글자라도 있는지 체크하는 정규표현식
		var pattern = /\s/g;														// " "공백(스페이스)이 있는지 체크하는 정규표현식
		
		if( (!regex.test(obj) && search_length != 0) || regex2.test(obj) ) { 		// 공란이 아니거나 고객이름 정규표현식에 맞지 않다면
			alert("검색은 특수문자 및 공백을 제외한 최소 두글자 이상 한글 혹은 숫자로 입력하셔야 합니다.");
			return false;															// false를 반환
		}
		else if( obj.match(pattern) ){
			alert("검색시 공백은 허용하지 않습니다.");
			return false;															// false를 반환
		}
		else if(search_length == 0) {												// 아무것도 적지 않았다면
			return true;															// true를 반환
		}
		else {
			return true;															// true를 반환
		}
		
	} // end of function checkWord() {})---------------------
	
</script>

<div>
	
	<div id="contentContainer">
		
		<!-- 고객조회 제목 / 새로고침 아이튼 버튼 시작 -->
		<div style="margin: auto 0; padding: 0px 10px 5px 10px;">
			<i class="far fa-star fa-2x"></i>
			<span style="font-size: 30px; padding-left: 10px;">고객조회</span>&nbsp;&nbsp;
			<button type="button" style="margin-bottom: 5px; width: 40px; height: 40px; padding: 0 0 0 7px;" id="btnSearch" class="btn btn-secondary" onclick="refresh()">
				<span style="padding-right: 10px;"><i class="fa fa-redo-alt" aria-hidden="true" style="font-size:25px;"></i></span>
			</button>
		</div>
		<!-- 고객조회 제목 / 새로고침 아이튼 버튼 끝 -->
		
		<!-- 검색조건 시작 -->
		<form name="searchFrm">
			<table id="tbl_searchCustmor">
				<thead>
					<tr>
						<td class="pd_td pd_left" style="float:right; padding-right: 28px; padding-bottom: 20px;">매장</td>
						<td>
							<input type="text" class="dark medium" name="JN_PRT_CD" id="JN_PRT_CD" readonly />&nbsp;
							<button type="button" id="btn_search_prt" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
							</button>
							<!-- 
								<i class="fas fa-search fa-border"></i>&nbsp;
							 -->
							&nbsp;<input type="text"  id="PRT_CD_NM" name="PRT_CD_NM" class="large enter_prt blank_key" value="" placeholder="매장코드 / 매장명" spellcheck="false" autofocus />
						</td>
						
						<td class="pd_td" style="float:right;">고객번호</td>
						<td>
							<input type="text" class="dark medium" name="CUST_NO" id="CUST_NO" value="" readonly />
							<button type="button" id="btn_search_cust" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
							</button>
							<input type="text" class="large enter_cust blank_key" name="IN_CUST_NO" id="IN_CUST_NO" value="" placeholder="고객번호 / 고객명" spellcheck="false" />
						</td>
						<td style="float:right; padding-right: 20px;">
							<button type="button" style="margin: 5px 0; width: 50px; height: 50px; padding: 0 0 0 7px;" id="btnSearch" class="btn btn-secondary" onclick="read_cust()">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
							</button>
						</td>
					</tr>
					<tr>
						<td class="pd_td pd_left" style="float:right;">
							<strong style="color:red;">*&nbsp;</strong>
							고객상태
						</td>
						<td>
							<input type="radio" name="CUST_SS_CD" value="" id="default" checked="checked"/>&nbsp;&nbsp;전체&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<!-- 
							<input type="radio" name="CUST_SS_CD" value="10" />&nbsp;&nbsp;정상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="CUST_SS_CD" value="80" />&nbsp;&nbsp;중지&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="CUST_SS_CD" value="90" />&nbsp;&nbsp;해지&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 -->
							<c:forEach var="ssList" items="${requestScope.prtCustList}">
								<input type="radio" name="CUST_SS_CD" value="${ssList.DTL_CD}" />&nbsp;&nbsp;${ssList.DTL_CD_NM}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</c:forEach>
						</td>
						
						<td class="pd_td" style="float:right;">
							<strong style="color:red;">*&nbsp;</strong>
							가입일자
						</td>
						<td>
							<input type="text" class="medium datepicker requiredInfo" name="SDATE" id="SDATE" onkeyup="this.value = date_mask(this.value)" maxlength="10" />&nbsp;&nbsp;&nbsp;
							<input type="text" class="medium datepicker requiredInfo" name="EDATE" id="EDATE" onkeyup="this.value = date_mask(this.value)" maxlength="10" />
						</td>
					</tr>
				</thead>
			</table>	
			
			<input type="hidden" name="SE_PRT_CD" id="SE_PRT_CD" value="${sessionScope.loginuser.PRT_CD}" />
			<input type="hidden" name="SE_USER_DT_CD" id="SE_USER_DT_CD" value="${sessionScope.loginuser.USER_DT_CD}" />
			<input type="hidden" name="SE_PRT_NM" id="SE_PRT_NM" value="${sessionScope.loginuser.PRT_NM}" />
			<input type="hidden" name="HIS_CUST_NO" id="HIS_CUST_NO" value="" />
			
		</form>
		<!-- 검색조건 끝 -->
		
		<!--  신규등록 버튼 부분 시작 -->
		<div id="adminContainer">
			<button type="button" class="btn-secondary" id="register" onclick="search_popup('register_cust', '1100', '700')">신규등록</button>
		</div>
		<!--  신규등록 버튼 부분 끝 -->
		
		<!--  조건에 부합하는 결과물을 보여주는 부분 시작 -->
		<table id="tbl_css"  class="scrolltable">
			<thead id="tbl_css_header" style="width: 100%;">
				<tr>
					<th class="center pd_td title" style="width: 200px;">고객번호</th>
					<th class="center title" style="width: 170px;">고객이름</th>
					<th class="center title">휴대폰번호</th>
					<th class="center title">고객상태</th>
					<th class="center title">가입일자</th>
					<th class="center title">가입매장</th>
					<th class="center title">등록자</th>
					<th class="center title">수정일자</th>
				</tr>
			</thead>
		
			<tbody id="CUST_DISPLAY" />
		
		</table>
		<!--  조건에 부합하는 결과물을 보여주는 부분 끝 -->
		
		<!-- 상세정보 클릭시 고객번호를 담아주는 form 시작 -->
		<form name="viewCustFrm">
			<input type="hidden" id="viewCust" name="viewCust" value=""/>
		</form>
		<!-- 상세정보 클릭시 고객번호를 담아주는 form 끝 -->
	</div>

</div>