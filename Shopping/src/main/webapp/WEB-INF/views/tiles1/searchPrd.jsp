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
	<link rel="stylesheet" type="text/css" href="<%=ctxPath %>/resources/css/popupPage.css" />
	
	<!-- Optional JavaScript -->
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.6.0.min.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> 
	
 	<%-- *** ajax로 파일을 업로드할때 가장 널리 사용하는 방법 ==> ajaxForm *** --%>
 	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery.form.min.js"></script>
     
    <!-- 구글 폰트를 쓰기 위한 링크 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Noto+Sans+KR&display=swap" rel="stylesheet">
	 
	<style type="text/css">
		
	</style> 
	
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/common.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/search.js"></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/check.js"></script> 
	<script type="text/javascript">
	
		$(document).ready(function(){
			
			$(".ui-datepicker-trigger").addClass("hide");					// 달력아이콘 비활성화
			
			$("#PRD_CD_NM").val(opener.$("#SEARCH_PRD_CD_NM").val());
			getProductList();												// 제품목록 조회함수 실행(4-1)
			
			$("button#btnSearchPrd").click(function(){						// 우측 검색버튼 클릭시
				if(checkWord($("input#PRD_CD_NM").val()) === true ){		// 검색조건에 위배되지 않는다면
					getProductList();										// 제품목록 조회함수 실행(4-1)
				}
			}); // end of $("button#btnSearchPrd").click(function(){}-------------
			
			$(document).on("click", ".checkBox", function(){							// 상품코드 input tag 클릭시
				$("input.checkBox").not(this).prop('checked', false); 		// 클릭하지 않은 다른 체크박스의 체크를 해제한다.
		    }); // end of $(document).on("click", ".checkBox", function(){})------------		
			
			// 적용버튼 클릭시
		    $("button#apply").click(function(){	
		    	let is_checked = $("input:checkbox[name='chBox']").is(":checked");		// 체크박스가 하나라도 체크되었는지 확인하는 변수
		    	if(!is_checked) {														// 하나도 체크가 안되어있다면
		    		alert("항목을 선택한 후 적용버튼을 눌러주세요!");
		    		return false;														// 종료
		    	}
		    	
		    	sMethodName = "GETPRODUCTLIST";											// 메소드이름을 지정(제품목록가져오기)
		    	dataToOpener(sMethodName);												// 부모창에 값을 넘겨주는 함수실행(4-5)
	    		opener.setPrdInfo();													// 부모창에서 값을 해당 row에 설정하는 함수실행(4-6)
	    		closeTabClick(); 														// 팝업창 닫는 함수 실행
		    });
		   
		    $("button#close").click(function(){											// 닫기버튼을 눌렀을 때
				closeTabClick();														// 팝업을 닫는다
		    }); // end of $("button#test").click(function(){})------------
			
		    $(opener).one('beforeunload', function() {							// 부모창의 새로고침/닫기/앞으로/뒤로
				closeTabClick();												// 팝업을 닫는다
            });	// end of $(opener).one('beforeunload', function() {}--------------------
		    
		});	// end of $(document).ready(function(){})----------
	
		// Function Declaration
		
        // 닫기 버튼을 클릭했을 때 실행하는 함수
		function closeTabClick() {
			window.close();												// 팝업을 닫는다
        } // end of function closeTabClick(){}------------
        
        // ##4-1. 제품목록을 조회하는 함수(7까지있음)
        function getProductList(){
        	sMethodName = "GETPRODUCTLIST";								// 메소드이름을 판매상세조회로 저장
			sArgument = func_createArgument(sMethodName);				// 메소드이름으로 인자를 생성(4-2)
			$.ajax(sArgument);	
        } // end of function getProductList(){}-----------
        
        // ##4-7. 더블클릭시 상품정보를 부모창으로 보내주는 함수
        function sendPopupToOpener_prd() {
        	var row = $(event.target).closest('tr');					// 더블클릭한 row의 위치를 담는다
        	if(row.find("#PRD_SS_NM").text() == "해지"){					// 해당 row의 상품상태가 해지라면
        		alert("해지상품은 담을 수 없습니다.");
        	}
        	else if( row.find("#IVCO_QTY").text() == "0" ){				// 해당 row의 재고수량이 0이라면
        		alert("재고가 없는 상품은 담을 수 없습니다.");
        	}
        	else if( row.find("#PRD_CSMR_UPR").text() == "0"){			// 해당 row의 소비자가가 0이라면
        		alert("소비자단가가 0인 상품은 담을 수 없습니다.");
        	}
        	else{														// 모든 조건을 만족한다면
        		$("#RCV_PRD_CD", opener.document).val(row.find("#PRD_CD").text()); 	 			// 자식창에서 부모창으로 온전한 상품번호 전달하기(hidden태그)
        		$("#HD_PRD_CD", opener.document).val(row.find("#PRD_CD").text()); 	 			// 자식창에서 부모창으로 온전한 상품번호 전달하기(hidden태그)
        	    $("#RCV_PRD_NM", opener.document).val(row.find("#PRD_NM").text()); 	 			// 자식창에서 부모창으로 온전한 상품명 전달하기(hidden태그)
        	    $("#RCV_IVCO_QTY", opener.document).val(row.find("#IVCO_QTY").text()); 	 		// 자식창에서 부모창으로 온전한 재고수량 전달하기(hidden태그)
        	    $("#RCV_PRD_CSMR_UPR", opener.document).val(row.find("#PRD_CSMR_UPR").text()); 	// 자식창에서 부모창으로 온전한 소비자가 전달하기(hidden태그)
        		opener.setPrdInfo();											// 부모창의 상품정보 설정해주는 함수 실행
		    	closeTabClick(); 												// 팝업창 닫는 함수 실행
        	}
        } // end of function sendPopupToOpener_prd() {}---------------
        
	</script>

<meta charset="UTF-8">
<title>매장재고조회</title>
</head>
<body>

	<div id="contentContainer">
		
		<div style="margin: auto 0; padding: 20px 10px 5px 10px;">
			<span style="font-size: 20px; padding-left: 10px;">매장재고조회</span>&nbsp;&nbsp;
		</div>
		
		<!-- 고객판매수금등록의 판매구분 항목 시작 -->
		<div id="searchContainer">
			<div id="rowContainer">
				<div class="inline">
					<span class="title_text">매장</span>
					<span id="input_text"><input type="text"  id="PRT_CD_NM" name="PRT_CD_NM" class="large" value="${sessionScope.loginuser.PRT_NM}" spellcheck="false" readonly /></span>
				</div>
				<button type="button" style="margin: 5px 20px 5px 0; width: 50px; height: 50px; padding: 0 20px 0 7px; float:right;" id="btnSearchPrd" class="btn btn-secondary">
						<span style="padding-right: 10px;"><i class="fa fa-search" aria-hidden="true" style="font-size:35px;"></i></span>
				</button>
			</div>
			<div id="rowContainer">
				<div class="inline">
					<span class="title_text">상품(코드+명)</span>
					<span id="input_text">
						<input type="text" class="large" name="PRD_CD_NM" id="PRD_CD_NM" value="" autofocus />&nbsp;
					</span>
				</div>
				
			</div>
		</div>
		<!-- 고객판매수금등록의 판매구분 항목 끝 -->
		
		<!-- 조회한 결과들을 보여주는 부분 시작 -->
		<div id="popup_table_container">
			<form>
				<table id="tbl_detail"  class="scrolltable" style="margin: 15px auto;">
					<thead id="tbl_header" style="width: 100%;">
						<tr>
							<th class="center" style="width:50px; min-width:50px; max-width: 50px;">선택</th>
							<th class="center" style="width:150px; min-width:150px; max-width:150px;">상품코드</th>
							<th class="center" style="width:150px; min-width:150px; max-width:150px;">상품명</th>
							<th class="center" style="width:100px; min-width:100px; max-width:50px;">재고수량</th>
							<th class="center" style="width:180px; min-width:180px; max-width:100px;">소비자가</th>
						</tr>
					</thead>
				
					<tbody id="TBODY">
					</tbody>
					<!-- 
					<tfoot id="TFOOT">
	    		       	
		     		</tfoot>
		     		 -->
				</table>
				<input type="hidden" name="SE_PRT_CD" id="SE_PRT_CD" value="${sessionScope.loginuser.PRT_CD}" />
				<input type="hidden" name="SE_PRT_NM" id="SE_PRT_NM" value="${sessionScope.loginuser.PRT_NM}" />
			</form>
		</div>
		<!-- 조회한 결과들을 보여주는 부분 끝 -->
		
	</div>

	<!-- 닫기 버튼이 포함된 부분 시작 -->
	<div id="container_btn" style="padding: 0 auto; text-align: center;">
		<button type="button" id="close" class="btn btn-secondary" >닫기</button>
		<span style="padding: 10px 20px 10px 0;"></span>
		<button type="button" id="apply" class="btn btn-secondary" >적용</button>
	</div>
	<!-- 닫기 버튼이 포함된 부분 끝 -->
	
</body>
</html>