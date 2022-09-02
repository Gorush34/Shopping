function welcome(){
        return 'Hello world';
}
		
		
// 적용버튼을 누를시 실행하는 함수
function apply() {
	let is_checked = $('input.chkBox').prop('checked');
	alert(is_checked);
	
	if(!is_checked) {
		alert("항목을 선택한 후 적용버튼을 눌러주세요!");
		return false;
	}
	
	var PRT_CD_NM = $("input[name='chBox']:checked").attr('id');								// name 이 chBox인 체크박스의 id(매장명)를 가져온다
	var PRT_CD = $("input[name='chBox']:checked").parent().parent().children().eq(1).text();	// 체크한 위치를 기반으로 매장코드를 가져온다
	
	$("#PRT_CD_NM", opener.document).val(PRT_CD_NM); 	 										// 자식창에서 부모창으로 온전한 매장명 전달하기
	$("#JN_PRT_CD", opener.document).val(PRT_CD); 		 										// 자식창에서 부모창으로 온전한 매장번호 전달하기
	closeTabClick(); 																			// 팝업창 닫는 함수 실행
} // end of function apply() {}----------------------