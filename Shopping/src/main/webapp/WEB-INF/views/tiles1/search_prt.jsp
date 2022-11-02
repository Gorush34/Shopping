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
	
	<!-- Optional JavaScript -->
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.6.0.min.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 
	
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 
	
	<!-- Font Awesome 5 Icons -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	
	<!-- 직접 만든 CSS 1 -->
	<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/style1.css" />
	
 	<%-- *** ajax로 파일을 업로드할때 가장 널리 사용하는 방법 ==> ajaxForm *** --%>
 	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery.form.min.js"></script>
     
    <!-- 구글 폰트를 쓰기 위한 링크 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Noto+Sans+KR&display=swap" rel="stylesheet">
 
	<style type="text/css">
		
		table#tbl_searchCustmor {
			background-color: #b3d9ff;
			border: solid 1px gray;
			width: 100%;
			min-height: 100px;
		}
		
		body {
			font-family: 'Noto Sans KR', sans-serif;
		}
		
		div#popup_table_container {
			margin: 0 auto;
			width: 90%;
		}
		
		.scrolltable {
		  	table-layout: fixed;
		  	width:70%;
		}
		
		thead#custList_header > tr > th {
		background-color: #b3b3b3;
		}
		
		.scrolltable thead {
		    min-width:90%;
		    display:block;
		}
		
		.scrolltable tbody{
			min-width:90%;
		    display:block;
		    overflow:auto;
		    height:300px;
		}
		
		#custList_header > tr > td {
			font-size: 15px; 
		}
		
		.scrolltable th, .scrolltable td {
		  padding: 10px;
		  width: 50px;
		  font-size: 0.875em;
		  border: solid 1px gray;
		}
		
		.left{ text-align: left; }
		.center{ text-align: center; }	
		.right{ text-align: right; }
		
		td#no{
			width: 470px;
		    text-align: center;
		    font-weight: bold;
		    font-size: 15pt;
		}
		
	</style> 
	 
	 
	<script type="text/javascript">
	
		var tr = "";														// 값을 부모창에게 전달하기 위해 위치 파악하는 변수 생성
		var td = "";														// 값을 부모창에게 전달하기 위해 위치 파악하는 변수 생성
	
		$(document).ready(function(){
			var PRT_CD_NM = opener.$("input#PRT_CD_NM").val(); 				// 부모창에서 id가 PRT_CD_NM인 태그의 val()
			$("input#PRT_CD_NM").val(PRT_CD_NM); 							// 자식창에서 id가 PRT_CD_NM인 val에 id를 넣기
			
			getPrtList(PRT_CD_NM); 											// 검색어로 거래처목록을 가져오는 함수 실행 

			
			// 닫기 버튼을 눌렀을 때
			$("button#test").click(function(){			
				
		        closeTabClick(); 											// 팝업창 닫는 함수 실행
		        
		    }); // end of $("button#test").click(function(){})------------
	    		    
		    // 검색버튼 클릭시
		    $("button#btn_prtSearch").click(function() {
		    	if(checkWord($("input#PRT_CD_NM").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
		    		getPrtList(PRT_CD_NM);									// PRT_CD_NM 를 검색조건으로 하는 매장목록 검색 함수 실행
		    	}
		    }); // end of $("button#btn_prtSearch").click(function() {}-----------------

		    
			// 체크박스를 클릭시
			$("input.chkBox").click(function() {
			    $("input.chkBox").not(this).prop('checked', false); 		// 클릭하지 않은 다른 체크박스의 체크를 해제한다.
			});

		    // 적용버튼 클릭시
		    $("button#apply").click(function(){	
		    	
		    	let is_checked = $("input:checkbox[name='chBox']").is(":checked");							// name이 chBox인 체크박스가 체크되었는지 확인
		    	if(!is_checked) {																			// 체크된 것이 하나도 없다면
		    		alert("항목을 선택한 후 적용버튼을 눌러주세요!");
		    		return false;																			// 종료
		    	}
		    	
				var PRT_CD_NM = $("input[name='chBox']:checked").attr('id');								// name 이 chBox인 체크박스의 id(매장명)를 가져온다
		    	var PRT_CD = $("input[name='chBox']:checked").parent().parent().children().eq(1).text();	// 체크한 위치를 기반으로 매장코드를 가져온다
		    	
		    	$("#PRT_CD_NM", opener.document).val(PRT_CD_NM); 	 										// 자식창에서 부모창으로 온전한 매장명 전달하기
		    	$("#JN_PRT_CD", opener.document).val(PRT_CD); 		 										// 자식창에서 부모창으로 온전한 매장번호 전달하기
		    	closeTabClick(); 																			// 팝업창 닫는 함수 실행
		    	
		    }); // end of $("button#apply").click(function(){}---------------
		    		
		    $(opener).one('beforeunload', function() {							// 부모창의 새로고침/닫기/앞으로/뒤로
				closeTabClick();												// 팝업을 닫는다
            });	// end of $(opener).one('beforeunload', function() {}--------------------
            		
		});	// end of $(document).ready(function(){})----------
	
		
		
		// Function Declaration
		
		// 검색어로 거래처목록을 가져오는 함수
		function getPrtList(PRT_CD_NM) {
			
			PRT_CD_NM = $("input#PRT_CD_NM").val();								// 검색창의 값을 넣는다
			
			if(PRT_CD_NM == undefined) {										// 아무것도 입력하지 않았다면
				PRT_CD_NM = "";													// 빈칸처리
			} 
			
			$.ajax({
				url:"<%= request.getContextPath()%>/getPrtList.dowell",
				data: {"SEARCHWORD":PRT_CD_NM}, 
				dataType:"JSON", 												// 데이터 타입을 JSON 형태로 전송
				type:"POST",													// POST 방식을 적용
				async: false,
				success:function(json){ 										// return된 값이 존재한다면
					
					let html = "";												// html 태그를 담기위한 변수 생성
					if(json.length > 0) { 
						
						$.each(json, function(index, item){						// return된 json 배열의 각각의 값에 대해서 반복을 실시한다.
							
							html += "<tr style='width: 100%;'>";  
							html += "<td class='center'><input type='checkbox' name='chBox' class='chkBox' id='"+item.PRT_NM+"'/></td>";
							html += "<td class='' ondblclick='sendPopupToOpener_prt()' style='width:160px; text-align:center;' id='PRT_CD'>"+item.PRT_CD+"</td>";
							html += "<td class='' ondblclick='sendPopupToOpener_prt()' style='width:160px; text-align:center;' id='PRT_NM'>"+item.PRT_NM+"</td>";
							html += "<td class='' ondblclick='sendPopupToOpener_prt()' style='width:160px; text-align:center;' id='PRT_SS_CD'>"+item.PRT_SS_CD+"</td>";
							html += "</tr>";
							
						});
					}
					else {
						html += "<tr>";
						html += "<td colspan='4' id='no' style='width:530px;'>검색조건에 맞는 매장이 존재하지 않습니다.</td>";
						html += "</tr>";
						alert("조건을 만족하는 검색결과가 없습니다!");
					}
					
					$("tbody#PRT_DISPLAY").html(html); 							// tbody의 id가 PRT_DISPLAY인 부분에 html 변수에 담긴 html 태그를 놓는다.
	
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
					
			});
			
		} // end of function getPrtList(PRT_CD_NM)-------------------------
		
		// 팝업창의 값을 부모 페이지로 전달하는 함수
		function sendPopupToOpener_prt() {
			
			const $target = $(event.target);											// 더블클릭이 된 해당 위치를 담는다
			var tr = $target.parent();													// 해당 위치의 부모(tr)의 위치를 담는다
			var td = tr.children();														// tr의 자식(td)의 위치를 담는다.
			
 
			var prt_cd = td.eq(1).text();												// tr안에 있는 td에서 index가 1인 td의 text(매장명)를 담는다
    		var prt_cd_nm = td.eq(2).text();											// tr안에 있는 td에서 index가 2인 td의 text(매장번호)를 담는다  	
		    
		    $("#PRT_CD_NM", opener.document).val(prt_cd_nm); 	 						// 자식창에서 부모창으로 온전한 매장명 전달하기
	    	$("#JN_PRT_CD", opener.document).val(prt_cd); 		 						// 자식창에서 부모창으로 온전한 매장번호 전달하기
	    	closeTabClick(); 															// 팝업창 닫는 함수 실행
	    	
		} // end of function sendPopupToOpener() {})-------------------------
		
		// 팝업창 닫기를 클릭했을때 실행되는 함수
		function closeTabClick() {
			window.close();																// 팝업을 닫는다
        } // end of function closeTabClick()---------------------------
		
     	// 특수문자 입력 방지(현재 미사용)
    	function characterCheck(obj){
    	var regExp = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi; 
    	// 허용할 특수문자는 여기서 삭제하면 됨
    	// 지금은 띄어쓰기도 특수문자 처리됨
    	if( regExp.test(obj.value) ){									
    		alert("특수문자는 입력하실수 없습니다.");
    		obj.value = obj.value.substring( 0 , obj.value.length - 1 ); 				// 입력한 특수문자 한자리 지움
    		}
    	} // end of function characterCheck(obj){}--------------------
        
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
    	
	</script>

<meta charset="UTF-8">
<title>매장조회</title>
</head>
<body>

	<div id="contentContainer">
		
		<div style="margin: auto 0; padding: 20px 10px 5px 10px;">
			<span style="font-size: 20px; padding-left: 10px;">매장조회</span>&nbsp;&nbsp;
		</div>
		
		<!-- 검색조건이 들어있는 form 시작 -->
		<form onsubmit="return false;"><!-- form 태그안 input 태그 1개 존재시 엔터로 submit됨 방지 -->
			<table id="tbl_searchCustmor">
				<thead>
					<tr>
						<td class="pd_td pd_left" style="float:right;">매장&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<input type="text" id="PRT_CD_NM" placeholder="매장코드 또는 매장명 검색" autofocus />&nbsp;
						</td>
						<td style="float:right; padding-right: 20px;">
							<button type="button" style="margin: 5px 0; width: 50px; height: 50px; padding: 0 0 0 7px;" id="btn_prtSearch" class="btn btn-secondary">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
							</button>
						</td>
					</tr>
				</thead>
			</table>	
		</form>
		<!-- 검색조건이 들어있는 form 끝 -->
		
		<!-- 검색결과를 보여주는 테이블 시작 -->
		<div id="popup_table_container">
			<form>
				<table id="custList"  class="scrolltable" style="margin: 15px auto;">
					<thead id="custList_header" style="width: 100%;">
						<tr>
							<th class="center pd_td">선택</th>
							<th class="center" style="width:160px;">매장코드</th>
							<th class="center" style="width:160px;">매장명</th>
							<th class="center" style="width:160px;">매장상태</th>
						</tr>
					</thead>
				
					<tbody id="PRT_DISPLAY" />
				
				</table>
			</form>
		</div>
		<!-- 검색결과를 보여주는 테이블 끝 -->
	</div>

	<!-- 닫기 / 적용 버튼이 포함되어 있는 하단 부분 시작 -->
	<div id="container_btn" style="padding: 0 auto; text-align: center;">
		<button type="button" id="test" class="btn btn-secondary" >닫기</button>
		<span style="padding: 10px 20px 10px 0;"></span>
		<button type="button" id="apply" class="btn btn-secondary" >적용</button>
	</div>
	<!-- 닫기 / 적용 버튼이 포함되어 있는 하단 부분 끝 -->
</body>
</html>