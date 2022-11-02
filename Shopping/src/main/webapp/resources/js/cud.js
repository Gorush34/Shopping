$(document).ready(function() {								// 페이지가 로딩되었을 때 시작하는 부분




}); // end of $(document).ready(function() {}------------------------

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
