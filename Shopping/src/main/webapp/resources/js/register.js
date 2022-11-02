$(document).ready(function() {								// 페이지가 로딩되었을 때 시작하는 부분
		
		// ====================================== 일자 관련 기능 시작 ======================================
		
		// ================================ datepicker 부분 시작 ================================
			
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
	        yearRange: 'c-99:c+99'
	        
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
	    //$('#EDATE').datepicker("option", "maxDate", 'today');						// 종료일자의 최댓값을 오늘로 설정
	    $('#EDATE').datepicker("option", "onClose", function ( selectedDate ) { 	// onClose 옵션을 주어야, 종료일이 시작일보다 뒤로 갈수 없고, 시작일이 종료일보다 앞으로 갈 수 없음
	        $("#SDATE").datepicker( "option", "maxDate", selectedDate );
	    });

	    $('#BRDY_DT').datepicker();													// 생년월일 datepicker 활성화
	    $('#BRDY_DT').datepicker('setDate', 'today'); 								// (-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
        $('#BRDY_DT').datepicker("option", "maxDate", 'today');						// 시작일자의 최댓값을 오늘로 설정
	
	    $('#MRRG_DT').datepicker();													// 결혼기념일 datepicker 활성화	
		// ================================ datepicker 부분 끝 ================================
		
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
		
		// 생년월일에서 커서가 벗어나는 순간 실행	
		$("input#BRDY_DT").on('blur',function(){
			
			var birthday = $('#BRDY_DT').val();											// 시작일자를 변수에 담는다.
			var regex = RegExp(/^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/); 	// 날짜 정규표현식
			
			var brdy02 = birthday.substr(5,2) + birthday.substr(8,2);					// 월일을 받아온다
			
			if( brdy02.substr(0,2) == "02" && parseInt(brdy02.substr(3,2)) >= 30 ) {		// 2월이면서 30일 이상의 일을 입력했다면
				alert("날짜 형식에 맞지 않습니다. 다시 입력해주세요!");	
				$('#BRDY_DT').datepicker('setDate', 'today');							// 시작일자를 현재보다 1주 전 또는 종료일자로 초기화한다
				return false;  															// 종료
			}
			
			if(!regex.test(birthday)){													// 시작일자가 정규표현식에 맞지 않다면
				alert("날짜 형식에 맞지 않습니다. 다시 입력해주세요!");	
				$('#BRDY_DT').datepicker('setDate', 'today');							// 시작일자를 현재보다 1주 전 또는 종료일자로 초기화한다.
				return false;  															// 종료
			}
			
			// var startArray = birthday.split('-');         								// 배열에 담겨있는 연,월,일을 사용해서 Date 객체 생성        
			var start_date = new Date(birthday);     									// 날짜를 숫자형태의 날짜 정보로 변환하여 비교한다	   
			var today = new Date();             										// 날짜를 숫자형태의 날짜 정보로 변환하여 비교한다
			
			if(start_date.getTime() > today.getTime()) {             					// 시작일자가 종료일자보다 크다면
				alert("생년월일은 미래를 선택할 수 없습니다.");  
				$('#BRDY_DT').datepicker('setDate', 'today');								// 시작일자를 현재보다 1주 전 또는 종료일자로 초기화한다
				return false;  															// 종료         
			}
			
		});
		
		// 결혼기념일에서 커서가 벗어나는 순간 실행
		$("input#MRRG_DT").on('blur',function(){
			
			var mrrgDate = $('#MRRG_DT').val(); 											// 종료일자를 변수에 담는다.
			if(mrrgDate == ""){
				return;
			}
			
			var mrrg02 = mrrgDate.substr(5,2) + mrrgDate.substr(8,2);						// 월일을 받아온다
			if( mrrg02.substr(0,2) == "02" && parseInt(mrrg02.substr(2,2)) >= 30) {		// 2월이면서 30일 이상의 일을 입력했다면
				alert("날짜 형식에 맞지 않습니다. 다시 입력해주세요!");	
				return false;  															// 종료
			}
			
			var regex = RegExp(/^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/); 	// 날짜 정규표현식
			
			if(!regex.test(mrrgDate) ){									// 종료일자가 정규표현식에 맞지 않다면
				alert("날짜 형식에 맞지 않습니다. 다시 입력해주세요!(정규식)");
				return false;  															// 종료  
			}
		});
		
		// ====================================== 일자 관련 기능 끝 ======================================
		
});



