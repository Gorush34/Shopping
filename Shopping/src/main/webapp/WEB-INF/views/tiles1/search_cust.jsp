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
	
	let from_name = false;							// 고객이름을 검색하는지 알아오는 변수
	let from_mobile = false;						// 핸드폰번호를 검색하는지 알아오는 변수
	var CUST_NO = "";
	var searchWord_nm = "";
	var searchWord_mobile = "";
	let flag = false;
	
		$(document).ready(function(){
			
			var CUST_NO = opener.$("input#IN_CUST_NO").val(); //부모창에서 id가 IN_CUST_NO인 input태그의 val()
			// alert(CUST_NO);
			$("input#CUST_NO").val(CUST_NO); //자식창에서 id가 CUST_NO인 val에 값을 넣기
			
			getPopUpCustList(); // 검색어로 고객목록을 가져오는 함수 실행 
			
			
			// 닫기 버튼을 눌렀을 때
			$("button#test").click(function(){			
				
		        closeTabClick(); // 팝업창 닫는 함수 실행
		        
		    }); // end of $("button#test").click(function(){})------------
	    	
		 	// 검색버튼 클릭시
		    $("button#btn_custSearch").click(function() {
		    	checkWord(); // 검색어에 대한 유효성 검사 실행
		    });
		    
		    // 체크박스를 클릭시
			$("input.chkBox").click(function() {
			    $("input.chkBox").not(this).prop('checked', false); // 클릭하지 않은 다른 체크박스의 체크를 해제한다.
			});
			
		    // 적용버튼 클릭시
		    $("button#apply").click(function(){	
		    	
				var TO_CUST_NO = $("input[name='chBox']:checked").attr('id');
		    	
		    	$("#CUST_NO", opener.document).val(TO_CUST_NO); 	 // 자식창에서 부모창으로 온전한 매장명 전달하기
		    	$("#IN_CUST_NO", opener.document).val(TO_CUST_NO); 		 // 자식창에서 부모창으로 온전한 매장번호 전달하기
		    	closeTabClick(); // 팝업창 닫는 함수 실행
		    	
		    });
		   
		});	// end of $(document).ready(function(){})----------
	
		// Function Declaration
		
		// 검색어로 고객목록을 가져오는 함수 실행 
		function getPopUpCustList() {
			
			CUST_NO = $("input#CUST_NO").val();
			
			if(CUST_NO == undefined) {
				CUST_NO = "";
			} 
			
			if(flag) {
				searchWord_nm = $("input#CUST_NM").val();
				if(searchWord_nm == undefined) {
					searchWord_nm = "";
				}
				searchWord_mobile = $("input#MBL_NO").val();
				if(searchWord_mobile == undefined) {
					searchWord_mobile = "";
				}
			}
			
			$.ajax({
				url:"<%= request.getContextPath()%>/getPopUpCustList.dowell",
				data: {"CUST_NO":CUST_NO,
					   "SEARCHWORD_NM":searchWord_nm,
					   "SEARCHWORD_MBL":searchWord_mobile}, 
				dataType:"JSON", 				// 데이터 타입을 JSON 형태로 전송
				success:function(json){ 		// return된 값이 존재한다면
					
					let html = "";				// html 태그를 담기위한 변수 생성
					if(json.length > 0) { 
						
						$.each(json, function(index, item){		// return된 json 배열의 각각의 값에 대해서 반복을 실시한다.
							
							html += "<tr style='width: 100%;'>";  
							html += "<td class='center'><input type='checkbox' name='chBox' class='chkBox' id='"+item.CUST_NO+"'/></td>";
							html += "<td class='center' ondblclick='sendPopupToOpener_cust()' style='width:160px;' id='CUST_NO'>"+item.CUST_NO+"</td>";
							html += "<td class='center' ondblclick='sendPopupToOpener_cust()' style='width:160px;' id='CUST_NM'>"+item.CUST_NM+"</td>";
							html += "<td class='center' ondblclick='sendPopupToOpener_cust()' style='width:160px;' id='MBL_NO'>"+item.MBL_NO+"</td>";
							html += "<td class='center' ondblclick='sendPopupToOpener_cust()' style='width:160px;' id='CUST_SS_CD'>"+item.CUST_SS_CD+"</td>";
							html += "</tr>";
							
						});
					}
					else {
						html += "<tr>";
						html += "<td colspan='5' id='no'>결과와 일치하는 고객이 없습니다.</td>";
						html += "</tr>";
					}
					
					$("tbody#CUST_DISPLAY").html(html); // tbody의 id가 PRT_DISPLAY인 부분에 html 변수에 담긴 html 태그를 놓는다.
	
				},
				error: function(request, status, error){
					// alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
					
			});
			
			$("input#CUST_NO").val("");
			flag = false;
			
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
				// alert("성공!");
				
				if(!mofmt.test(mobile) && mobile_length != 0){							// 핸드폰번호가 공란이 아니거나 정규표현식에 맞지 않다면
					alert("핸드폰번호는 정확히 입력하셔야 합니다!");
					return false;														// 함수 종료
				}
				else{																	// 공란이거나 핸드폰번호 정규표현식에 맞다면
					flag = true;
					// alert(flag);
					// alert("정확히 입력했음!");
					getPopUpCustList();
					
				}
			}
			
		} // end of function checkWord() {})---------------------
		
		// 팝업창의 값을 부모 페이지로 전달하는 함수
		function sendPopupToOpener_cust() {
			const $target = $(event.target);			// 더블클릭이 된 해당 위치를 담는다
			var tr = $target.parent();					// 해당 위치의 부모(tr)의 위치를 담는다
			var td = tr.children();						// tr의 자식(td)의 위치를 담는다.
			
 
			var cst_no = td.eq(1).text();				// tr안에 있는 td에서 index가 1인 td의 text(매장명)를 담는다
    		
		    $("#IN_CUST_NO", opener.document).val(cst_no); 	 // 자식창에서 부모창으로 온전한 매장명 전달하기
	    	$("#CUST_NO", opener.document).val(cst_no); 		 // 자식창에서 부모창으로 온전한 매장번호 전달하기
	    	closeTabClick(); // 팝업창 닫는 함수 실행
		} // end of function sendPopupToOpener_cust()---------------
		
		// 팝업창 닫기를 클릭했을때 실행되는 함수
		function closeTabClick() {
			window.close();
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
		
		<form>
			<table id="tbl_searchCustmor">
				<thead>
					<tr>
						<td class="pd_td pd_left" style="float:right;">고객이름&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<input type="text" id="CUST_NM" autofocus />&nbsp;
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
		
		<div id="popup_table_container">
			<form>
				<table id="custList"  class="scrolltable" style="margin: 15px auto;">
					<thead id="custList_header" style="width: 100%;">
						<tr>
							<th class="center pd_td">선택</th>
							<th class="center" style="width:160px;">고객번호</th>
							<th class="center" style="width:160px;">고객명</th>
							<th class="center" style="width:160px;">핸드폰번호</th>
							<th class="center" style="width:160px;">고객상태</th>
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
		
	</div>

	<div id="container_btn" style="padding: 0 auto; text-align: center;">
		<button type="button" id="test" class="btn btn-secondary" >닫기</button>
		<span style="padding: 10px 20px 10px 0;"></span>
		<button type="button" id="apply" class="btn btn-secondary" >적용</button>
	</div>
</body>
</html>