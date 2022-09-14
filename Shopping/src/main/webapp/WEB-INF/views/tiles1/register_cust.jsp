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
	<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> 
	
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 
	
	<!-- Font Awesome 5 Icons -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	
	<!-- 직접 만든 CSS 1 -->
	<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/style1.css" />
	
	<%--  ===== 스피너 및 datepicker 를 사용하기 위해  jquery-ui 사용하기 ===== --%>
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.css" />
	<script type="text/javascript" src="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.js"></script>
	
 	<%-- *** ajax로 파일을 업로드할때 가장 널리 사용하는 방법 ==> ajaxForm *** --%>
 	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery.form.min.js"></script>
     
    <!-- 구글 폰트를 쓰기 위한 링크 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Noto+Sans+KR&display=swap" rel="stylesheet">
  
 	<!-- Optional JavaScript-->
	<script type="text/javascript" src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

	<!-- 직접 만든 CSS -->
  	<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/registerPopUp.css" />
  		 
	<!-- 모듈화 연습 -->
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/common.js"></script>  
	
	<script type="text/javascript">

		let flag_req = false;												// 필수입력항목이 충족되었는지 구별할 flag 변수 선언
		let flag_mblDuplicated = false;										// 등록 버튼 클릭시 핸드폰중복확인 검사유무를 구별할 flag 변수 선언
		let flag_emailDuplicated = false;									// 등록 버튼 클릭시 이메일중복확인 검사유무를 구별할 flag 변수 선언
		
		$(document).ready(function(){
			
			var SE_PRT_CD = opener.$("input#SE_PRT_CD").val(); 				// 부모창에서 id가 SE_PRT_CD인 태그의 val()
			var SE_PRT_NM = opener.$("input#SE_PRT_NM").val(); 				// 부모창에서 id가 SE_PRT_NM인 태그의 val()
			$("input#JN_PRT_CD").val(SE_PRT_CD); 							// 자식창에서 id가 JN_PRT_CD인 val에 id를 넣기
			$("input#PRT_CD_NM").val(SE_PRT_NM); 							// 자식창에서 id가 PRT_CD_NM인 val에 id를 넣기
			
			$("input[name='SEX_CD'][value='F']").prop("checked", true);			// 초기값 설정(성별)
			$("input[name='PSMT_GRC_CD'][value='H']").prop("checked", true);	// 초기값 설정(우편물수령)
			
			$("button#btn_search_prt").on("click", function (event) { 		// 매장 찾기 버튼을 클릭했을 때
				if(checkWord($("input#PRT_CD_NM").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
					getPrtCodeName();										// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
				}
			}); // end of $("button#btnSearch_prt").on("click", function (event) {})---------------------
			
			$("input.blank_key").keyup(function(event){						// 매장조건 입력란에서 키보드를 입력할 때
				if(event.keyCode == 8 || event.keyCode == 46) { 			// 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
					if( $("input#PRT_CD_NM").val() == "" ) {				// 매장검색란의 내용이 아무것도 없다면
						$("input#JN_PRT_CD").val("");						// 매장코드를 비운다
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
			
			$("button#btn_close").click(function(){							// 닫기 버튼 클릭시		
				closeTabClick(); 
		    }); // end of $("button#btn_close").click(function(){})------------
				
			$("button#register").click(function(){							// 등록 버튼 클릭시
				if(confirm("신규고객으로 등록하시겠습니까?")){						// 확인창에서 확인버튼을 누른다면
					reqCheck();												// 필수입력항목 검사
					if(flag_req) {											// 필수입력항목에 값이 모두 입력되었다면
						checkInfo();										// 각 항목에 대한 유효성 검사 함수 실행
					}
				}
			}); // end of $("button#register").click(function(){})---------------
		    
		 	$(".req, .req_rad, .req_sel").bind("change",()=>{  				// 필수입력사항 값이 변경되면 등록 버튼 클릭시 확인 flag 초기화 시키기
		 		flag_req = false;
		 	});
		   	
		 	$("#MBL1, #MBL2, #MBL3").bind("change",()=>{  					// 핸드폰값이 변경되면 등록 버튼 클릭시 중복확인 flag 초기화 시키기
		 		flag_mblDuplicated = false;
		 		$("#checkMblDuplicated").css("background-color","red");
		 	});
			
		 	$("#EMAIL1, #EMAIL2").bind("change",()=>{  						// 이메일값이 변경되면 등록 버튼 클릭시 중복확인 flag 초기화 시키기
				flag_emailDuplicated = false;
				$("#checkEmailDuplicated").css("background-color","red");
		 	});
		   	
		});	// end of $(document).ready(function(){})----------
	    
		// Function Declaration
		
		// 팝업창 닫기를 클릭했을때 실행되는 함수
		function closeTabClick() {
			window.close();																// 팝업을 닫는다
		} // end of function closeTabClick()---------------------------
		
		// 신규고객을 등록하는 함수
		function regCust() {
			alert("여기 옵니까? onclick");	
			
		} // end of end of function regCust()---------------------------
		
		// 각 항목에 대한 유효성 검사를 실시하는 부분
		function checkInfo() {
			alert($("#CUST_NM").val());	
			if( !checkWord($("#CUST_NM").val()) ){
				return;
			} else {
				alert("어저라고");	
			}
			
		} // end of end of function checkInfo()---------------------------
		
		// 모듈화 해야할 부분 ================================================================================
		
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
		
		// 매장정보를 검색하여 정보를 받거나 팝업을 띄우는 함수
		function getPrtCodeName() {
			var searchWord = $("input#PRT_CD_NM").val();
			
			getList(searchWord, "getPrtList");
		} // end of function getPrtCodeName() {}-----------
		
		// 리스트를 불러오는 함수
		function getList(searchWord, url) {
			
			if(searchWord == undefined) {												// 아무것도 입력하지 않았다면
				searchWord = "";														// 빈칸처리
			} 
			
			$.ajax({
				url:"<%= request.getContextPath()%>/"+url+".dowell",
				dataType:"JSON", 														// 데이터 타입을 JSON 형태로 전송
				data: {"searchWord":searchWord}, 
				type:"POST",															// POST 방식을 적용
				success:function(json){ 												// return된 값이 존재한다면
					
					if(json.length == 1) { 												// 결과가 하나라면
						$("input#JN_PRT_CD").val(json[0].PRT_CD); 						// 자식창에서 id가 JN_PRT_CD인 val에 id를 넣기
						$("input#PRT_CD_NM").val(json[0].PRT_NM); 						// 자식창에서 id가 PRT_CD_NM인 val에 id를 넣기
					}
					else {																// 결과가 하나가 아니라면
						createPopup('search_prt','900','600');							// 매장검색 팝업을 띄운다
					}
					
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
					
			});
		} // end of function getList(searchWord, url)----------------------
		
		// 필수입력항목을 검사하는 함수
		function reqCheck() {

			let b_FlagRequiredInfo = false;			
			
			$("input.req").each(function(index, item) {						// 태그의 class가 필수입력항목인 것에 대해서 각각 실행
				const data = $(item).val().trim();							// 공백을 제거한 값이
				if(data == ""){												// 비었다면
					console.log("item : " + data);
					alert("*표시된 필수입력사항은 모두 입력하셔야 합니다.");
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
				alert("다 넣었다!");
			}
			
		} // end of function reqCheck() {}---------------------
		
		// 중복검사 버튼 클릭시 실행 함수
		function checkDuplicated(obj) {
			
			if(obj == "email") {		// 체크할 대상이 이메일이라면
				alert("난 이메일검사다!");
				var email = $("#EMAIL1").val() + "@" + $("#EMAIL2").val();
				if( checkText(email, "EMAIL") ){							// 정규표현식에 맞는다면
					compareItem(email, "EMAIL");							// 이메일 중복검사 실행
					
					// flag_emailDuplicated = true;							// 이메일중복검사 flag를 true로 변경
				}
			}
			else if(obj == "mbl") {		// 체크할 대상이 핸드폰번호라면
				alert("난 핸드폰번호다!");
				var mbl = $("#MBL1").val() + $("#MBL2").val() + $("#MBL3").val();
				if( checkText(mbl, "MBL") ){								// 정규표현식에 맞는다면
					compareItem(mbl, "MBL");								// 휴대폰 중복검사 실행
							
					// flag_mblDuplicated = true;							// 휴대폰중복검사 flag를 true로 변경
				}
			}
			
		} // end of function checkDuplicated(obj) {}--------------------
		
		// 항목에 대한 유효성검사를 실시하는 함수(시험용)
		function checkText(obj, type) {
			
			let text_length = obj.length;												// 고객이름의 길이를 알아온다
			
			if(type == "NM") {		// 유효성 검사할 대상이 이름이라면
				var regex = RegExp(/[가-힣a-zA-Z0-9]{2,20}$/);								// 2-20글자 사이에 완전한 음절과 영어가 들어갔는지 체크하는 정규표현식
				var regex2 = RegExp(/[ㄱ-ㅎㅏ-ㅣ]+/);											// 자음, 모음이 한글자라도 있는지 체크하는 정규표현식
				var pattern = /\s/g;														// " "공백(스페이스)이 있는지 체크하는 정규표현식
				
				if( (!regex.test(obj) && text_length != 0) || regex2.test(obj) ) { 		// 공란이 아니거나 고객이름 정규표현식에 맞지 않다면
					alert("검색은 특수문자 및 공백을 제외한 최소 두글자 이상 한글 혹은 숫자로 입력하셔야 합니다.");
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
	 			url:"<%= ctxPath%>/compareItem.dowell",
	 			data:{"item": obj,
	 				  "type": type}, 
	 			type: "post" , 
	 			dataType: "json",
				success: function(json){	
	
                   if(json.result == "0" && type == "MBL") {			// 중복값이 없고 type이 MBL 이면
                   		alert(tp +" "+ obj +" 은(는) 가입이 가능합니다!" );
                   		flag_mblDuplicated = true;						// 핸드폰 중복검사 flag를 true로 변경
                   		$("#checkMblDuplicated").css("background-color","green");
                   }
                   else if(json.result == "0" && type == "EMAIL") {		// 중복값이 없고 type이 EMAIL 이면
                	   alert(tp +" "+ obj +" 은(는) 가입이 가능합니다!" );
                	   flag_emailDuplicated = true;						// 이메일 중복검사 flag를 true로 변경
                	   $("#checkEmailDuplicated").css("background-color","green");
                   }
                   else {												// 중복값이 존재하면
                	   alert(tp +" "+ obj +" 은(는) 이미 사용중입니다. 다른 "+tp+"를 입력해주세요." );
                   }
	 			}, 
	 			error: function(request, status, error){
	 				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	 			}
	 			
	 		}); // end of $.ajax({})
			
			
		} // end of function compareItem(obj, type) {}--------------------
		
		
	</script>

<meta charset="UTF-8">
<title>고객조회</title>
</head>
<body>

	<div id="contentContainer">
		
		<div class="title" style="margin: auto 0; padding: 10px 10px 0 10px;">
			<span style="font-weight:bold; font-size: 20px; padding-left: 10px;">신규고객등록</span>&nbsp;&nbsp;
		</div>
		
		<!-- 고객정보를 등록하기 위한 form 시작 -->
		<form name="custInfoFrm">
			<!-- 고객기본정보를 입력하기 위한 div 시작 -->
			<div class="title" id = "BaseInfo">
				<span style="font-size: 18px; padding-left: 10px;">고객기본정보(<strong style="color:red;">*&nbsp;</strong>가 표시된 항목은 필수 입력사항입니다)</span>&nbsp;&nbsp;
				<!-- 기본정보를 담는 테이블 시작 -->
				<table id="tbl_baseInfo">
					<tbody>
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>고객명</td>
							<td class="item_value"><input type="text" class="req med" name="CUST_NM" id="CUST_NM" value="" placeholder="2글자이상 입력" autofocus /></td>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>직업코드</td>
							<td>
								<select class="req_sel" name="POC_CD" id="POC_CD" required>
									<option value="">선택하세요</option>
									<c:forEach var="POC_CD" items="${requestScope.POC_CD}">
										<option value="${POC_CD.DTL_CD}">${POC_CD.DTL_CD_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>생년월일</td>
							<td class="item_value"><input type="text" class="datepicker req med" name="BRDY_DT" id="BRDY_DT" onkeyup="this.value = date_masking(this.value)" maxlength="10" /></td>
							<td class="f_right item_name">성별</td>
							<td>
								<c:forEach var="SEX_CD" items="${requestScope.SEX_CD}">
									<input type="radio" id="SEX_CD" name="SEX_CD" value="${SEX_CD.DTL_CD}"/>&nbsp;${SEX_CD.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>휴대폰번호</td>
							<td class="item_value">
								<input type="text" class="req sm" name="MBL1" id="MBL1" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />&nbsp;
								<input type="text" class="req sm" name="MBL2" id="MBL2" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />&nbsp;
								<input type="text" class="req sm" name="MBL3" id="MBL3" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
								<button type='button' class='btn btn-secondary btn_td btn_check' id='checkMblDuplicated'  onclick="checkDuplicated('mbl')" style='margin-bottom:5px;'>중복확인</button>
							</td>
							<td class="f_right item_name">생일</td>
							<td class="item_value">
								<input type="radio" id="SCAL_YN" name="SCAL_YN" value="Y" checked/>&nbsp;양력&nbsp;&nbsp;
								<input type="radio" id="SCAL_YN" name="SCAL_YN" value="N" />&nbsp;음력
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>우편물수령</td>
							<td class="item_value">
								<c:forEach var="PSMT_GRC_CD" items="${requestScope.PSMT_GRC_CD}">
									<input type="radio" class="req_rad" id="PSMT_GRC_CD" name="PSMT_GRC_CD" value="${PSMT_GRC_CD.DTL_CD}"/>&nbsp;${PSMT_GRC_CD.DTL_CD_NM}&nbsp;&nbsp;
								</c:forEach>
							</td>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>이메일</td>
							<td class="item_value">
								<input type="text" class="req med" name="EMAIL1" id="EMAIL1" value="" />&nbsp;@
								<input type="text" class="req med" name="EMAIL2" id="EMAIL2" value="" />
								<button type='button' class='btn btn-secondary btn_td btn_check' id='checkEmailDuplicated'  onclick='checkDuplicated("email")' style='margin-bottom:5px;'>중복확인</button>
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name" >주소</td>
							<td>
								<input type="text" class="ADD" name="ZIP_CD" id="ZIP_CD" value="" style="width: 50px;" />
								<input type="text" class="ADD" name="ADDR" id="ADDR" value="" placeholder="주소" style="width: 300px;" />
								<input type="text" class="ADD" name="ADDR_DTL" id="ADDR_DTL" value="" placeholder="상세주소" style="width: 100px;" />
							</td>
						</tr>
						
						<tr>
							<td class="f_right item_name">결혼기념일</td>
							<td class="item_value"><input type="text" class="datepicker med" name="MRRG_DT" id="MRRG_DT" onkeyup="this.value = date_masking(this.value)" maxlength="10" /></td>
							<td class="f_right item_name"><strong style="color:red;">*&nbsp;</strong>매장</td>
							<td class="item_value">
								<input type="text" class="dk med" name="JN_PRT_CD" id="JN_PRT_CD" style="background-color: #b3b3b3;" readonly />&nbsp;
								<button type="button" id="btn_search_prt" class="btn btn-secondary" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" >
									<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
								</button>
								&nbsp;<input type="text"  id="PRT_CD_NM" name="PRT_CD_NM" class="lg enter_prt blank_key" value="" placeholder="매장코드 / 매장명" spellcheck="false" autofocus />
							</td>
						</tr>
						
					</tbody>
				</table>
				<!-- 기본정보를 담는 테이블 시작 -->
			</div>
			<!-- 고객기본정보를 입력하기 위한 div 끝 -->
			
			<!-- 수신동의(통합)를 입력하기 위한 div 시작 -->
			<div class="title" id = "receiveYN">
				<span style="font-size: 18px; padding-left: 10px;">수신동의(통합)</span>&nbsp;&nbsp;
				<!-- 기본정보를 담는 테이블 시작 -->
				<table id="tbl_receiveYN">
					<tbody>
						<tr>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>이메일수신동의</td>
							<td class="item_value">
								<input type="radio" class="req_rad" id="EMAIL_RCV_YN" name="EMAIL_RCV_YN" value="Y" />&nbsp;예&nbsp;&nbsp;
								<input type="radio" class="req_rad" id="EMAIL_RCV_YN" name="EMAIL_RCV_YN" value="N" checked/>&nbsp;아니오
							</td>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>SMS수신동의</td>
							<td class="item_value" style="max-width:20%;">
								<input type="radio" class="req_rad" id="SMS_RCV_YN" name="SMS_RCV_YN" value="Y" />&nbsp;예&nbsp;&nbsp;
								<input type="radio" class="req_rad" id="SMS_RCV_YN" name="SMS_RCV_YN" value="N" checked/>&nbsp;아니오
							</td>
						</tr>
						
						<tr>
							<td class="yn_name"><strong style="color:red;">*&nbsp;</strong>DM수신동의</td>
							<td class="item_value">
								<input type="radio" class="req_rad" id="DM_RCV_YN" name="DM_RCV_YN" value="Y" />&nbsp;예&nbsp;&nbsp;
								<input type="radio" class="req_rad" id="DM_RCV_YN" name="DM_RCV_YN" value="N" checked/>&nbsp;아니오
							</td>
							<td class="item_value"></td>
							<td class="item_value"></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 수신동의(통합)를 입력하기 위한 div 끝 -->
			
			
			<input type="hidden" name="MBL_NO" id="MBL_NO" value="" />
			<input type="hidden" name="EMAIL" id="EMAIL" value="" />
		</form>
		<!-- 고객정보를 등록하기 위한 form 끝 -->
		
		
		
	</div>
	
	<!-- 닫기 / 등록 버튼이 포함되어 있는 하단 부분 시작 -->
	<div id="container_btn" style="padding: 0 auto; text-align: center;">
		<button type="button" id="btn_close" class="btn btn-secondary" >닫기</button>
		<span style="padding: 10px 20px 10px 0;"></span>
		<button type="button" id="register" class="btn btn-secondary">등록</button>
	</div>
	<!-- 닫기 / 등록 버튼이 포함되어 있는 하단 부분 끝 -->
</body>
</html>