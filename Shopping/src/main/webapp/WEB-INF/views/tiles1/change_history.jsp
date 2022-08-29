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
		
	</style> 
	 
	 
	<script type="text/javascript">
	
		$(document).ready(function(){
			
			var his_cust_no = opener.$("input#HIS_CUST_NO").val(); //부모창에서 id가 parent인 태그의 val()
			$("input#HIS_CUST_NO").val(his_cust_no); //자식창에서 id가 child인 val에 id를 넣기

			getCustInfo(his_cust_no);		
			getCustHistory(his_cust_no);
			
			$("button#close").click(function(){
		        
				closeTabClick();
		        
		   }); // end of $("button#test").click(function(){})------------
	    	
			$("input.chkBox").click(function() {
			    $("input.chkBox").not(this).prop('checked', false);
			});
		   
		});	// end of $(document).ready(function(){})----------
	
		// Function Declaration
		
		// 고객정보를 조회해오는 함수
		function getCustInfo(CUST_NO) {
			var cust_no = CUST_NO;
			
			$.ajax({
    			url:"<%= request.getContextPath()%>/getCustInfoPopUp.dowell",
    			data: {"SEARCHWORD":cust_no}, 
    			dataType:"JSON", 								// 데이터 타입을 JSON 형태로 전송
    			success:function(json){ 						// return된 값이 존재한다면
    				
    				let info = "";								// html 태그를 담기위한 변수 생성
    				info = "<td style='padding-left:20px;'>고객&nbsp;&nbsp;&nbsp;"+json.CUST_NO+"&nbsp;&nbsp;&nbsp;"+json.CUST_NM+"</td>";
    				
    				$("tr#info").html(info); // tr의 id가 info인 부분에 html 변수에 담긴 html 태그를 놓는다.
    				
    			},
    			error: function(request, status, error){
    				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    			}
    			
    		}); // end of $.ajax()-----------------------
        	
		}
		
        // 고객이력을 조회해오는 함수
        
        function getCustHistory(CUST_NO) {
        	
        	var cust_no = CUST_NO;
        	
        	$.ajax({
    			url:"<%= request.getContextPath()%>/getCustHistoryPopUp.dowell",
    			data: {"SEARCHWORD":cust_no}, 
    			dataType:"JSON", 								// 데이터 타입을 JSON 형태로 전송
    			success:function(json){ 						// return된 값이 존재한다면
    				
    				
    				 // let info = "";								// 고객 정보를 담기 위한 
    				let html = "";								// html 태그를 담기위한 변수 생성
    				if(json.length > 0) { 
    					
    					/*
    					$.each(json, function(index, item){
    						info = "<td style='padding-left:20px;'>고객&nbsp;&nbsp;&nbsp;"+item.CUST_NO+"&nbsp;&nbsp;&nbsp;"+item.CUST_NM+"</td>";
    						alert(info);
    						return false;
    					});
    					*/
    					
    					$.each(json, function(index, item){		// return된 json 배열의 각각의 값에 대해서 반복을 실시한다.
    						
    						html += "<tr style='width: 100%;'>";  
    						html += "<td class='center' style='width:100px;'>"+item.CHG_DT+"</td>";
    						html += "<td class='center' style='width:100px;'>"+item.CHG_CD+"</td>";
    						html += "<td class='left' 	style='width:150px;'>"+item.CHG_BF_CNT+"</td>";
    						html += "<td class='left' 	style='width:150px;'>"+item.CHG_AFT_CNT+"</td>";
    						html += "<td class='left' 	style='width:150px;'>"+item.LST_UPD_ID+"</td>";
    						html += "<td class='center' style='width:130px;'>"+item.LST_UPD_DT+"</td>";
    						html += "</tr>";
    					
    					});
    				}
    				else {
    					html += "<tr>";
    					html += "<td colspan='6' class='center' id='no' style='width:780px;'>변경된 고객이력이 존재하지 않습니다.</td>";
    					html += "</tr>";
    				}
    				
    				// $("tr#info").html(info); // tr의 id가 info인 부분에 html 변수에 담긴 html 태그를 놓는다.
    				$("tbody#HISTORY_DISPLAY").html(html); // tbody의 id가 CUST_DISPLAY인 부분에 html 변수에 담긴 html 태그를 놓는다.
    				
    			},
    			error: function(request, status, error){
    				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    			}
    		}); // end of $.ajax()-----------------------
        	
        } // end of function getCustHistory(his_cust_no)------------
        
        // 닫기 버튼을 클릭했을 때 실행하는 함수
		function closeTabClick() {
			window.close();
        } // end of function closeTabClick()
        
	</script>

<meta charset="UTF-8">
<title>고객이력조회</title>
</head>
<body>

	<div id="contentContainer">
		
		<div style="margin: auto 0; padding: 20px 10px 5px 10px;">
			<span style="font-size: 20px; padding-left: 10px;">변경이력</span>&nbsp;&nbsp;
		</div>
		
		<form>
			<table id="tbl_searchCustmor">
				<thead>
					<tr id="info">
						<td class="pd_td pd_left"  style="padding-left: 20px;">
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
							<th class="center" style="width:100px;">변경일자</th>
							<th class="center" style="width:100px;">변경항목</th>
							<th class="center" style="width:150px;">변경전</th>
							<th class="center" style="width:150px;">변경후</th>
							<th class="center" style="width:150px;">최종수정자</th>
							<th class="center" style="width:130px;">최종수정일시</th>
						</tr>
					</thead>
				
					<tbody id="HISTORY_DISPLAY">
					</tbody>
				
				</table>
				<input type="hidden" name="HIS_CUST_NO" id="HIS_CUST_NO" value="" />
			</form>
		</div>
		
	</div>

	<div id="container_btn" style="padding: 0 auto; text-align: center;">
		<button type="button" id="close" class="btn btn-secondary" >닫기</button>
		<span style="padding: 10px 20px 10px 0;"></span>
	</div>
</body>
</html>