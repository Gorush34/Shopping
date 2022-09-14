function welcome(){
		alert("Hello world");
}

// 버튼을 누르거나 검색어 입력시 값을 출력하거나 팝업창을 띄워주는 함수
function createPopup(location, width, height) {

	// 버튼마다의 주소값을 받는다.
	var loc = location; 
	var nm = name;
	// 팝업창을 띄울 주소를 설정한다.
	const url = loc+".dowell"; 
	
	const pop_width = width;
	const pop_height = height;
	const pop_left = Math.ceil( ((window.screen.width)-pop_width)/2 ) ; 		// 값을 정수로 만든다
	const pop_top = Math.ceil( ((window.screen.height)-pop_height)/2 ) ;
	
	window.open( url
				 , nm 
				 , "left="+pop_left+
				 ", top="+pop_top+
				 ", width="+pop_width+
				 ", height="+pop_height+
				 ", location = no" );
	
} // end of function createPopup(location, width, height) {})---------------------------------------

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

// 팝업창 닫기를 클릭했을때 실행되는 함수
function closePopUp() {
	window.close();																// 팝업을 닫는다
} // end of function closePopUp()---------------------------

// 필수입력사항을 검사하는 함수
function reqCheck1() {
	
	// 필수입력사항 검사 시작
	let b_FlagRequiredInfo = false;
	
	$("input.req").each(function(index, item) {			// 태그의 class가 필수입력항목인 것에 대해서 각각 실행
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
	
} // end of function reqCheck() {}---------------------
