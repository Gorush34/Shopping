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
	
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 
	
	<!-- Font Awesome 5 Icons -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	
	<!-- 직접 만든 CSS 1 -->
	<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/style1.css" />
	
	<!-- Optional JavaScript -->
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.6.0.min.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> 
	
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
			width: 95%;
		}
		
		.scrolltable {
		  	table-layout: fixed;
		  	width:100%;
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
			width: 690px;
		    text-align: center;
		    font-weight: bold;
		    font-size: 15pt;
		}
		
	</style> 
	 
	 
	<script type="text/javascript">
	
	let from_name = false;														// 고객이름을 검색하는지 알아오는 변수 선언
	let from_mobile = false;													// 핸드폰번호를 검색하는지 알아오는 변수 선언
	var CUST_NO = "";															// 고객번호를 담는 변수 선언
	var searchWord_nm = "";														// 고객이름 검색어를 담는 변수 선언
	var searchWord_mobile = "";													// 핸드폰번호 검색어를 담는 변수 선언
	var regexHan = RegExp(/[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z]+/);
	
	let flag = false;															// 올바른 형식에 맞게 검색어를 입력하였는지 구분하기 위한 flag 변수 선언
	
		$(document).ready(function(){
			
			var CUST_NO = opener.$("input#IN_CUST_NO").val(); 					// 부모창에서 id가 IN_CUST_NO인 input태그의 val()
			$("input#CUST_NO").val(CUST_NO); 									// 자식창에서 id가 CUST_NO인 val에 값을 넣기
			
			if(regexHan.test(CUST_NO)){											// 부모창에서 받아온 값이 한글로만 있다면
				$("input#CUST_NM").val(CUST_NO);								// 고객명 검색칸에 값을 넣는다
				searchWord_nm = $("input#CUST_NO").val();						// 고객명 파라미터를 넣는다
				$("input#CUST_NO").val("");										// 고객번호 파라미터를 공백으로 만든다
			}
			
			getPopUpCustList(); 												// 검색어로 고객목록을 가져오는 함수 실행 
			
			
			// 닫기 버튼을 눌렀을 때
			$("button#test").click(function(){			
				
		        closeTabClick(); 												// 팝업창 닫는 함수 실행
		        
		    }); // end of $("button#test").click(function(){})------------
	    	
		 	// 검색버튼 클릭시
		    $("button#btn_custSearch").click(function() {
		    	checkWord(); 													// 검색어에 대한 유효성 검사 실행
		    }); // end of $("button#btn_custSearch").click(function() {})-----------
		    
		    // 체크박스를 클릭시
			$("input.chkBox").click(function() {
			    $("input.chkBox").not(this).prop('checked', false); 			// 클릭하지 않은 다른 체크박스의 체크를 해제한다.
			}); // end of $("input.chkBox").click(function() {})---------------------
			
		    // 적용버튼 클릭시
		    $("button#apply").click(function(){	
		    	
		    	let is_checked = $('.chkBox').prop('checked');
		    	
		    	if(!is_checked) {
		    		alert("항목을 선택한 후 적용버튼을 눌러주세요!");
		    		return false;
		    	}
		    	
				var TO_CUST_NO = $("input[name='chBox']:checked").attr('id');	// name 이 chBox인 체크박스의 id(매장명)를 가져온다
		    	
		    	$("#CUST_NO", opener.document).val(TO_CUST_NO); 	 			// 자식창에서 부모창으로 온전한 매장명 전달하기
		    	$("#IN_CUST_NO", opener.document).val(TO_CUST_NO); 		 		// 자식창에서 부모창으로 온전한 매장번호 전달하기
		    	closeTabClick(); 												// 팝업창 닫는 함수 실행
		    	
		    });
		   
		});	// end of $(document).ready(function(){})----------
	
		// Function Declaration
		
		// 검색어로 고객목록을 가져오는 함수 실행 
		function getPopUpCustList() {
			
			CUST_NO = $("input#CUST_NO").val();									// 매장명 값을 담는다
			
			if(CUST_NO == undefined) {											// 비어있다면
				CUST_NO = "";													// 공백처리
			} 
			
			if(flag) {															// 정규표현식에 위배되지 않았다면
				searchWord_nm = $("input#CUST_NM").val();						// 고객이름 검색칸의 값을 담는다
				if(searchWord_nm == undefined) {								// 비어있다면
					searchWord_nm = "";											// 공백처리
				}
				searchWord_mobile = $("input#MBL_NO").val();					// 핸드폰번호 검색칸의 값을 담는다
				if(searchWord_mobile == undefined) {							// 비어있다면
					searchWord_mobile = "";										// 공백처리
				}
			} // end of if(flag) {}--------------------------------
			
			$.ajax({
				url:"<%= request.getContextPath()%>/getPopUpCustList.dowell",
				data: {"CUST_NO":CUST_NO,
					   "SEARCHWORD_NM":searchWord_nm,
					   "SEARCHWORD_MBL":searchWord_mobile}, 
				dataType:"JSON", 												// 데이터 타입을 JSON 형태로 전송
				success:function(json){ 										// return된 값이 존재한다면
					
					let html = "";												// html 태그를 담기위한 변수 생성
					if(json.length > 0) { 
						
						$.each(json, function(index, item){						// return된 json 배열의 각각의 값에 대해서 반복을 실시한다.
							
							html += "<tr style='width: 100%;'>";  
							html += "<td class='center'><input type='checkbox' name='chBox' class='chkBox' id='"+item.CUST_NO+"'/></td>";
							html += "<td class='center' ondblclick='sendPopupToOpener_cust()' style='width:190px;' id='CUST_NO'>"+item.CUST_NO+"</td>";
							html += "<td class='center' ondblclick='sendPopupToOpener_cust()' style='width:190px;' id='CUST_NM'>"+item.CUST_NM+"</td>";
							html += "<td class='center' ondblclick='sendPopupToOpener_cust()' style='width:190px;' id='MBL_NO'>"+item.MBL_NO+"</td>";
							html += "<td class='center' ondblclick='sendPopupToOpener_cust()' style='width:190px;' id='CUST_SS_CD'>"+item.CUST_SS_CD+"</td>";
							html += "</tr>";
							
						});
					}
					else {
						html += "<tr>";
						html += "<td colspan='5' id='no' style='width:810px;'>결과와 일치하는 고객이 없습니다.</td>";
						html += "</tr>";
						alert("조건을 만족하는 검색결과가 없습니다!");
					}
					
					$("tbody#CUST_DISPLAY").html(html); 						// tbody의 id가 PRT_DISPLAY인 부분에 html 변수에 담긴 html 태그를 놓는다.
	
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
					
			});
			
			$("input#CUST_NO").val("");													// 값을 초기화
			flag = false;																// 정규표현식 구분 flag를 초기화
			
		} // end of function getPrtList(PRT_CD_NM)-------------------------
		
 		// 고객이름 및 핸드폰번호 검색시 유효성 검사를 실행하는 함수
		function checkWord() {
			
			CUST_NM = $("input#CUST_NM").val();											// 검색란의 고객이름 값을 받아온다 
			let search_length = CUST_NM.length;											// 고객이름의 길이를 알아온다
			
			var regex = RegExp(/[가-힣a-zA-Z]{2,20}$/);									// 2-20글자 사이에 완전한 음절과 영어가 들어갔는지 체크하는 정규표현식
			var regex2 = RegExp(/[ㄱ-ㅎㅏ-ㅣ]+/);											// 자음, 모음이 한글자라도 있는지 체크하는 정규표현식
			
			var mobile = $("input#MBL_NO").val();										// 검색란의 핸드폰번호 값을 받아온다 
			let mobile_length = mobile.length;											// 핸드폰번호의 길이를 알아온다
			
			var mofmt = RegExp(/[0-9]{10,11}$/);										// 핸드폰번호는 10-11자리 숫자만 들어가게끔 정규표현식을 선언한다
			
			if( (!regex.test(CUST_NM) && search_length != 0) || regex2.test(CUST_NM)) { // 공란이 아니거나 고객이름 정규표현식에 맞지 않다면
				alert("고객이름은 최소 두글자 이상 한글 혹은 영어로 입력하셔야 합니다.");
				return false;															// 함수 종료
			}
			else {																		// 공란이거나 고객이름 정규표현식에 맞다면
				
				if(!mofmt.test(mobile) && mobile_length != 0){							// 핸드폰번호가 공란이 아니거나 정규표현식에 맞지 않다면
					alert("핸드폰번호는 정확히 입력하셔야 합니다!");
					return false;														// 함수 종료
				}
				else{																	// 공란이거나 핸드폰번호 정규표현식에 맞다면
					flag = true;
					getPopUpCustList();
				}
			
			}
			
		} // end of function checkWord() {})---------------------
		
		// 팝업창의 값을 부모 페이지로 전달하는 함수
		function sendPopupToOpener_cust() {
			const $target = $(event.target);											// 더블클릭이 된 해당 위치를 담는다
			var tr = $target.parent();													// 해당 위치의 부모(tr)의 위치를 담는다
			var td = tr.children();														// tr의 자식(td)의 위치를 담는다.
			
 
			var cst_no = td.eq(1).text();												// tr안에 있는 td에서 index가 1인 td의 text(매장명)를 담는다
    		
		    $("#IN_CUST_NO", opener.document).val(cst_no); 	 							// 자식창에서 부모창으로 온전한 매장명 전달하기
	    	$("#CUST_NO", opener.document).val(cst_no); 								// 자식창에서 부모창으로 온전한 매장번호 전달하기
	    	closeTabClick(); // 팝업창 닫는 함수 실행
		} // end of function sendPopupToOpener_cust()---------------
		
		// 팝업창 닫기를 클릭했을때 실행되는 함수
		function closeTabClick() {
			window.close();																// 팝업을 닫는다
        } // end of function closeTabClick()---------------------------

	</script>

<meta charset="UTF-8">
<title>고객조회</title>
</head>
<body>

	<div id="contentContainer">
		
		<div style="margin: auto 0; padding: 20px 10px 5px 10px;">
			<span style="font-size: 20px; padding-left: 10px;">고객조회</span>&nbsp;&nbsp;
		</div>
		
		<!-- 고객정보를 검색하기 위한 form 시작 -->
		<form>
			<table id="tbl_searchCustmor">
				<thead>
					<tr>
						<td class="pd_td pd_left" style="float:right;">고객이름&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<input type="text" id="CUST_NM"autofocus />&nbsp;
							<input type="hidden" id="CUST_NO" autofocus />&nbsp;
						</td>
						
						<td class="pd_td pd_left" style="float:right;">핸드폰번호&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<input type="text" id="MBL_NO" />&nbsp;
						</td>
						<td style="float:right; padding-right: 20px;">
							<button type="button" style="margin: 5px 0; width: 50px; height: 50px; padding: 0 0 0 7px;" id="btn_custSearch" class="btn btn-secondary" >
								<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
							</button>
						</td>
					</tr>
				</thead>
			</table>	
		</form>
		<!-- 고객정보를 검색하기 위한 form 끝 -->
		
		<!-- 검색결과를 보여주는 부분 시작 -->
		<div id="popup_table_container">
			<form>
				<table id="custList"  class="scrolltable" style="margin: 15px auto;">
					<thead id="custList_header" style="width: 100%;">
						<tr>
							<th class="center pd_td">선택</th>
							<th class="center" style="width:190px;">고객번호</th>
							<th class="center" style="width:190px;">고객명</th>
							<th class="center" style="width:190px;">핸드폰번호</th>
							<th class="center" style="width:190px;">고객상태</th>
						</tr>
					</thead>
				
					<tbody id="CUST_DISPLAY">
						<!-- 
						<tr style="width: 100%;">
							<td class="center"><input type="checkbox" class="chkBox" /> </td>
							<td class="center" style="width:160px;">2</td>
							<td class="center" style="width:160px;">3</td>
							<td class="center" style="width:160px;">4</td>
							<td class="center" style="width:160px;">매장명</td>
						</tr>
						-->
					</tbody>
				
				</table>
			</form>
		</div>
		<!-- 검색결과를 보여주는 부분 끝 -->
		
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