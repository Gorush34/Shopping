<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	String ctxPath = request.getContextPath();
%>    

<script type="text/javascript">

	var prt_nm = "";													// 매장명을 받을 변수 선언
	var se_prt_cd = "";													// 세션에 저장된 매장코드를 받을 변수 선언
	var se_prt_nm = "";													// 세션에 저장된 매장명을 받을 변수 선언
	var se_user_dt_cd = "";												// 세션에 저장된 거래처구분코드를 받아올 변수 선언
	let from_prt = false;												// 매장을 검색하는지 알아오는 변수
	let is_exist = false;												// 일자별 총 합계를 구하기 위해 결과가 있는지 알아오는 변수
	
	$(document).ready(function() {
		
		prt_nm = $("input#PRT_CD_NM").val();							// 매장검색란의 value값을 받아온다
		se_prt_cd = $("input#SE_PRT_CD").val();							// 로그인유저의 매장코드를 받아온다
		se_prt_nm = $("input#SE_PRT_NM").val();							// 로그인유저의 매장명을 받아온다
		se_user_dt_cd = $("input#SE_USER_DT_CD").val();					// 로그인유저의 거래처구분코드를 받아온다
		
		defaultSearch();
		
		$("tfoot#TFOOT_SUM").hide();
		
		$("input.blank_key").keyup(function(event){						// 매장조건 입력란에서 키보드를 입력할 때
			if(event.keyCode == 8) { 									// 백스페이스를 입력했을 경우
				if( $("input#PRT_CD_NM").val() == "" ) {				// 매장검색란의 내용이 아무것도 없다면
					$("input#JN_PRT_CD").val("");						// 매장코드를 비운다
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
		
		$("button#btn_search_prt").on("click", function (event) { 		// 매장 찾기 버튼을 클릭했을 때
			
			if(checkWord($("input#PRT_CD_NM").val()) === true ) {		// 정규표현식(checkWord)에 위배되지 않는다면
				from_prt = true;										// 매장 입력에서 왔음을 표시
				getTotalCount();										// 검색조건의 결과가 몇 개인지 알아오는 함수 실행
			}
		
		}); // end of $("button#btnSearch_prt").on("click", function (event) {})---------------------
		
		
	}); // end of $(document).ready(function() {})--------------------------
	
	// 함수 정의
	
	// 새로고침 아이콘 클릭시 실행되는 함수
	function refresh() {
		defaultSearch();																// 기본 조건을 불러오는 함수 실행
		$("tbody#PERFORM_DISPLAY").hide(); 												// tbody의 id가 CUST_DISPLAY인 부분을 숨겨준다
		$("tfoot#TFOOT_SUM").hide();													// tfoot의 id가 TFOOT_SUM인 부분을 숨겨준다 
	}
	
	// 기본 조건을 불러오는 함수
	function defaultSearch() {
		$("input#JN_PRT_CD").val("");													// disabled 처리된 고객번호 input 태그의 값을 비운다
		$("input#PRT_CD_NM").val("");													// 고객번호 input 태그의 값을 비운다
		var today = new Date().toISOString().slice(0, 7);								// 현재연도와 월을 알아온다
		document.getElementById('SAL_DT').value= today;									// SAL_DT에 기본값을 담는다		
		$("#SAL_DT").attr("max", today);												// 선택할 수 있는 최대값을 현재달로 설정한다ㅅ
		
		if( se_user_dt_cd == 2 ) {														// 거래처구분코드가 2(매장)라면
			$("input#JN_PRT_CD").val(se_prt_cd);										// 매장코드의 value값을 로그인유저의 매장코드로 적용한다
			$("input#PRT_CD_NM").val(se_prt_nm);										// 매장검색란의 value값을 로그인유저의 매장명으로 적용한다
		} 
		else if( se_user_dt_cd == 1 ) {													// 거래처구분코드가 1(본사)라면
			$("input#JN_PRT_CD").val("");												// 매장코드의 value값을 비운다
			$("input#PRT_CD_NM").val("");												// 매장검색란의 value값을 비운다
		}
		
		if(se_user_dt_cd == 2) { 														// 거래처구분코드가 2(매장)라면
			$(".not").attr("readonly", true);											// 매장검색버튼을 비활성화한다.
																						// disabled시 form 안넘어감!
			$(".btn_not").attr("disabled", true);										// 버튼 disabled;
		}		
		
	}
	
	// 버튼을 누르거나 검색어 입력시 값을 출력하거나 팝업창을 띄워주는 함수
	function search_popup(location) {

		// 버튼마다의 주소값을 받는다.
		var loc = location; 

		// 팝업창을 띄울 주소를 설정한다.
		const url = "<%= ctxPath%>/"+loc+".dowell"; 
		
		// 너비 800, 높이 600 인 팝업창을 화면 가운데 위치시키기
		const pop_width = 800;
		const pop_height = 600;
		const pop_left = Math.ceil( ((window.screen.width)-pop_width)/2 ) ; <%-- 정수로 만든다 --%>
		const pop_top = Math.ceil( ((window.screen.height)-pop_height)/2 ) ;
		
		window.open( url, 
					 "memberEdit"
					 , "left="+pop_left+
					 ", top="+pop_top+
					 ", width="+pop_width+
					 ", height="+pop_height+
					 ", location = no" );
		
	} // end of function search_popup(location) {})---------------------------------------
	
	// 결과가 하나인지 알아오는 함수 
	function getTotalCount() {
		
		$.trim("input#PRT_CD_NM");											// 매장검색란의 공백을 제거
		var searchWord_prt = $("input#PRT_CD_NM").val();					// 매장검색란의 값을 가져옴
		
		$.ajax({
			url:"<%= request.getContextPath()%>/getTotalCount.dowell",
			data: { "searchWord_prt" : searchWord_prt,
						  "from_prt" : from_prt			},					// 검색어를 Map 형태로 넣어준다.
			dataType:"JSON", 												// 데이터 타입을 JSON 형태로 전송
			type:"POST",													// POST 방식을 적용
			async:false,													// 동기로 처리(이게 끝나야 다른것을 진행하게끔)
			success:function(json){ 										// return된 값이 존재한다면
				
				if(json.status != "1"){										// json으로 받아온 status의 값이 1이 아니라면(결과가 1이 아니라면)
					search_popup("search_prt");								// 매장정보 팝업을 실행
				}
				else { 														// 결과가 1이라면
					$("input#JN_PRT_CD").val(json.PRT_CD);					// 매장명을 넣는다	
					$("input#PRT_CD_NM").val(json.PRT_NM);					// 매장코드를 넣는다
				}
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		}); // end of $.ajax()-----------------------------
		
	} // end of function getTotalCount() {}--------------------------------------
	
	// 매장별 월 실적조회를 불러오는 함수
	function searchPerfomance() {
		
		// 필수입력사항 검사 시작
		let b_FlagRequiredInfo = false;														// 필수입력사항을 구분하기 위한 flag 선언
		
		$("input.requiredInfo").each(function(index, item) {								// 필수입력사항들 각각에 대해 실행
			const data = $(item).val().trim();												// 데이터의 값을 받아오고 공백 제거
			if(data == ""){																	// 값이 공백이라면
				console.log("item : " + data);										
				alert("*표시된 필수입력사항은 모두 입력하셔야 합니다.");								// 경고 표시
				b_FlagRequiredInfo = true;													// flag 를 true로 변경
				return false; 																// each 종료
			}
		});
		
		if(b_FlagRequiredInfo) {															// 필수입력사항이 모두 입력되지 않았다면
			console.log("b_FlagRequiredInfo : " + b_FlagRequiredInfo);
			return;																			// 함수 종료
		}
		// 필수입력사항 검사 끝
		
		var jn = $("input#JN_PRT_CD").val();
		if(jn == undefined) {								// 비어있다면
			$("input#JN_PRT_CD").val("");					// 공백처리
		}
		
		/*
		if(checkWord($("input#PRT_CD_NM").val()) === false ) {
			// 매장검색란과 고객검색란의 검색어가 정규표현식에 맞지 않으면
			return false;											// 함수 종료
		}
		*/
		$.trim("input#PRT_CD_NM");															// 매장 검색창의 공백 제거
		var formData = $("form[name=searchFrm]").serialize();								// form 이름이 searchFrm 인 곳의 input name과 value들을 직렬화
		
		
		$.ajax({
			url:"<%= request.getContextPath()%>/searchPerformance.dowell",
			data: formData, 
			dataType:"JSON", 																// 데이터 타입을 JSON 형태로 전송
			type:"POST",															// POST 방식을 적용
			async: false,
			success:function(json){ 														// return된 값이 존재한다면
				
				$("tfoot#TFOOT_SUM").show();
				let html = "";																// html 태그를 담기위한 변수 생성
				
				if(json.length > 0) { 
					
					$.each(json, function(index, item){										// return된 json 배열의 각각의 값에 대해서 반복을 실시한다.
						
						html += "<tr style='width: 100%; max-height:30px; min-height:30px;'>";  
						html += "<td class='sticky-col first-col'>"+item.PRT_CD+"</td>";
						html += "<td class='sticky-col second-col'>"+item.PRT_NM+"</td>";
						html += "<td class='right border_td'>"+item.D01+"</td>";
						html += "<td class='right border_td'>"+item.D02+"</td>";
						html += "<td class='right border_td'>"+item.D03+"</td>";
						html += "<td class='right border_td'>"+item.D04+"</td>";
						html += "<td class='right border_td'>"+item.D05+"</td>";
						html += "<td class='right border_td'>"+item.D06+"</td>";
						html += "<td class='right border_td'>"+item.D07+"</td>";
						html += "<td class='right border_td'>"+item.D08+"</td>";
						html += "<td class='right border_td'>"+item.D09+"</td>";
						html += "<td class='right border_td'>"+item.D10+"</td>";
						html += "<td class='right border_td'>"+item.D11+"</td>";
						html += "<td class='right border_td'>"+item.D12+"</td>";
						html += "<td class='right border_td'>"+item.D13+"</td>";
						html += "<td class='right border_td'>"+item.D14+"</td>";
						html += "<td class='right border_td'>"+item.D15+"</td>";
						html += "<td class='right border_td'>"+item.D16+"</td>";
						html += "<td class='right border_td'>"+item.D17+"</td>";
						html += "<td class='right border_td'>"+item.D18+"</td>";
						html += "<td class='right border_td'>"+item.D19+"</td>";
						html += "<td class='right border_td'>"+item.D20+"</td>";
						html += "<td class='right border_td'>"+item.D21+"</td>";
						html += "<td class='right border_td'>"+item.D22+"</td>";
						html += "<td class='right border_td'>"+item.D23+"</td>";
						html += "<td class='right border_td'>"+item.D24+"</td>";
						html += "<td class='right border_td'>"+item.D25+"</td>";
						html += "<td class='right border_td'>"+item.D26+"</td>";
						html += "<td class='right border_td'>"+item.D27+"</td>";
						html += "<td class='right border_td'>"+item.D28+"</td>";
						html += "<td class='right border_td'>"+item.D29+"</td>";
						html += "<td class='right border_td'>"+item.D30+"</td>";
						html += "<td class='right border_td'>"+item.D31+"</td>";
						html += "<td class='sticky-col last-col border_td' style='text-align: right;'>"+item.SUM+"</td>";
						html += "</tr>";
					}); // end of $.each----------------
					
					is_exist = true;									// 값을 출력해주기 위한 flag true
				}
				else {
					html += "<tr>";
					html += "<td colspan='25' style='width: 800px;' id='no' class='center'>검색조건에 맞는 매장판매실적이 존재하지 않습니다.</td>";
					html += "</tr>";
					$("tfoot#TFOOT_SUM").hide();
					alert("조건을 만족하는 검색결과가 없습니다!");
				}
				
				$("tbody#PERFORM_DISPLAY").html(html); 					// tbody의 id가 PERFORM_DISPLAY인 부분에 html 변수에 담긴 html 태그를 놓는다.
				$("tbody#PERFORM_DISPLAY").show(); 						// tbody의 id가 CUST_DISPLAY인 부분을 숨겨준다
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of $.ajax()-----------------------

		
		if(is_exist) {
			getTotalQty();											// 각 열의 합계를 구하는 함수 실행
		}
		
	}// end of function searchPerfomance(){}--------------------------	
	
	// 각 열의 합계를 구하는 함수
	function getTotalQty() {
		
		var sum_array = new Array();														// 행의 값들을 담을 배열 생성
    	var sum = "";																		// 각 일자별 합계를 담을 변수 생성
		var rows = document.getElementById("PERFORM_DISPLAY").getElementsByTagName("tr");	// tbody 안의 tr의 개수(조회된 매장의 수)를 구한다
        
        for( let i = 0; i < 32; i++ ) { 													// 1일부터 31일 + 총 합계만큼 반복
        	
        	sum = 0;																		// 일자별로 합을 넣은 후 다음 작업을 위한 초기화
        	
        	for(let j=0; j< rows.length; j++) {												// tr의 개수만큼 반복(조회된 매장의 수만큼)
        		
        		var cells = rows[j].getElementsByTagName("td");								// row의 j번째 인덱스에 있는 td의 위치를 담는다
        		
        		var cell_val = cells[(i+2)].firstChild.data;								// j번째 row에 위치한 i+2번째 td의 값을 담는 변수 생성 
        		cell_val = cell_val.split(',').join("");									// 콤마를 제거
        		
        		sum += parseInt(cell_val);													// 숫자로 변환 후 그 값을 sum에 더해준다
        	}
        	
        	sum = addComma(sum);															// 합쳐진 sum을 다시 콤마처리
        	sum_array.push(sum);															// 배열의 i번째 인덱스에 sum값을 넣는다(일별 총계)
        	
        	// tfoot(모든 매장의 일별 합계를 보여주는 곳)의 첫번째 row(tr)의 i+1번째 td값을 변경한다
			document.getElementById("TFOOT_SUM").getElementsByTagName("tr")[0].getElementsByTagName("td")[(i+1)].innerHTML = sum_array[i];
        }

		is_exist = false;																	// flag 초기화
		$("tfoot#TFOOT_SUM").show();
		
	} // end of function getTotalQty() {}------------------
	
	// 검색시 유효성 검사를 실행하는 함수
	function checkWord(obj) {
		
		let search_length = obj.length;												// 고객이름의 길이를 알아온다
		
		var regex = RegExp(/[가-힣a-zA-Z0-9]{2,20}$/);								// 2-20글자 사이에 완전한 음절과 영어가 들어갔는지 체크하는 정규표현식
		var regex2 = RegExp(/[ㄱ-ㅎㅏ-ㅣ]+/);											// 자음, 모음이 한글자라도 있는지 체크하는 정규표현식
		var pattern = /\s/g;														// " "공백(스페이스)이 있는지 체크하는 정규표현식
		
		if( (!regex.test(obj) && search_length != 0) || regex2.test(obj) ) { 		// 공란이 아니거나 고객이름 정규표현식에 맞지 않다면
			alert("검색은 특수문자 및 공백을 제외한 최소 두글자 이상 한글 혹은 숫자로 입력하셔야 합니다.");
			return false;															// 함수 종료
		}
		else if( obj.match(pattern) ){												// 공백이 있다면
			alert("검색시 공백은 허용하지 않습니다.");
			return false;															// 함수 종료
		}
		else if(search_length == 0) {												// 아무것도 적지 않았다면
			return true;
		}
		else {
			return true;
		}
		
	} // end of function checkWord() {})---------------------
	
	//천단위 콤마 펑션
   function addComma(value){
        value = value.toString();
		value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        return value; 
    }
	
</script>

<div>
	
	<div id="contentContainer">
		
		<!-- 매장별월실적조회 문구 시작 -->
		<div style="margin: auto 0; padding: 0px 10px 5px 10px;">
			<i class="far fa-star fa-2x"></i>
			<span style="font-size: 30px; padding-left: 10px;">매장월별실적조회</span>&nbsp;&nbsp;
			<button type="button" style="margin-bottom: 5px; width: 40px; height: 40px; padding: 0 0 0 7px;" id="refresh" class="btn btn-secondary" onclick="refresh()">
				<span style="padding-right: 10px;"><i class="fa fa-redo-alt" aria-hidden="true" style="font-size:25px;"></i></span>
			</button>
		</div>
		<!-- 매장별월실적조회 문구 끝 -->
		
		<!-- 검색조건 시작 -->
		<form name="searchFrm">
			<table id="tbl_searchCustmor">
				<thead>
					<tr>
						<td class="pd_left" style="float:right; padding-bottom: 20px;">
							<strong style="color:red;">*&nbsp;</strong>
							매출월
							<input type="month" id="SAL_DT" class="requiredInfo" name="SAL_DT" value="" />
						</td>
						<td>
							<span style="padding: 0 60px;" />
						</td>
						<td class="pd_td" style="float: left; padding-top: 20px; ">
							매장
							<input type="text" class="dark medium" name="JN_PRT_CD" id="JN_PRT_CD" value="" readonly />&nbsp;
							<button type="button" style="margin-bottom: 5px; width: 35px; height: 35px; padding: 0 0 0 7px;" id="btn_search_prt" class="btn btn-secondary btn_not" onclick="search_popup('search_prt')">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:20px;"></i></span>
							</button>
							<input type="text"  id="PRT_CD_NM" name="PRT_CD_NM" class="large enter_prt blank_key btn_not" value="" placeholder="매장코드 / 매장명" spellcheck="false" autofocus />
						</td>
						<td style="float:right; padding-right: 20px;">
							<button type="button" style="margin: 5px 0; width: 50px; height: 50px; padding: 0 0 0 7px;" id="btnSearch" class="btn btn-secondary" onclick="searchPerfomance()">
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
							</button>
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
		
		<!-- 데이터를 보여주는 부분 시작 -->
		<div class="view">
		  <div class="wrapper">
		    <table id="tbl_css_header" class="table">
		      <thead>
		        <tr>
			          <th class="sticky-col first-col border" style="text-align: center;">매장코드</th>
			          <th class="sticky-col second-col border" style="text-align: center;">매장명</th>
			          <th class="border" id="sum_1">1일</th>
			          <th class="border" id="sum_2">2일</th>
			          <th class="border" id="sum_3">3일</th>
			          <th class="border" id="sum_4">4일</th>
			          <th class="border" id="sum_5">5일</th>
			          <th class="border" id="sum_6">6일</th>
			          <th class="border" id="sum_7">7일</th>
			          <th class="border" id="sum_8">8일</th>
			          <th class="border" id="sum_9">9일</th>
			          <th class="border" id="sum_10">10일</th>
			          <th class="border" id="sum_11">11일</th>
			          <th class="border" id="sum_12">12일</th>
			          <th class="border" id="sum_13">13일</th>
			          <th class="border" id="sum_14">14일</th>
			          <th class="border" id="sum_15">15일</th>
			          <th class="border" id="sum_16">16일</th>
			          <th class="border" id="sum_17">17일</th>
			          <th class="border" id="sum_18">18일</th>
			          <th class="border" id="sum_19">19일</th>
			          <th class="border" id="sum_20">20일</th>
			          <th class="border" id="sum_21">21일</th>
			          <th class="border" id="sum_22">22일</th>
			          <th class="border" id="sum_23">23일</th>
			          <th class="border" id="sum_24">24일</th>
			          <th class="border" id="sum_25">25일</th>
			          <th class="border" id="sum_26">26일</th>
			          <th class="border" id="sum_27">27일</th>
			          <th class="border" id="sum_28">28일</th>
			          <th class="border" id="sum_29">29일</th>
			          <th class="border" id="sum_30">30일</th>
			          <th class="border" id="sum_31">31일</th>
			          <th class="sticky-col last-col border" id="sum_32" style='text-align: right;'>합계</th>
		        </tr>
		      </thead>
		      <tbody id="PERFORM_DISPLAY"></tbody>
		      <tfoot id="TFOOT_SUM">
    		       	<tr>
		       		  <td class="sticky-col first-col" colspan="2" style="text-align: center;">합계</td>
		       		  <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="border_td" style="text-align: right;"></td>
			          <td class="sticky-col last-col border_td"  style='text-align: right;'></td>
		       		</tr>
		      </tfoot>
		    </table>
		  </div>
		</div>
		<!-- 데이터를 보여주는 부분 끝 -->
		
		</div>
	</div>

</div>