<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	String ctxPath = request.getContextPath();
%>    

<script type="text/javascript">

</script>

<div>

	고객정보조회 페이지입니다.
	
	<div id="contentContainer">
	
		<form>
			<table id="tbl_searchCustmor">
				<thead>
					<tr>
						<td style="height: 100%;">
							고객번호&nbsp;&nbsp;&nbsp;
							<input type="text" class="medium" />
							<i class="fas fa-search"></i>
							<input type="text" class="dark medium"/>
						</td>
						<td style="height: 100%; text-align: right; padding-right: 40px;">
							<i class="fas fa-search fa-3x"></i>
						</td>
					</tr>
				</thead>
			</table>	
		</form>
		
		<form>
			<!-- 고객기본정보 시작 -->
			<div style="margin: auto 0; padding: 5px 10px;">
				<span style="font-size: 25px;">고객기본정보</span>
			</div>
			<div id="custBasicStatus">
				<table id="tbl_custBasicStatus">
					<tr style="width:100%;">
						<td class="td1">
							<strong style="color:red;">*&nbsp;</strong>고객명
							<input type="text" class="small"/>
						</td>
						<td class="td2">
							<strong style="color:red;">*&nbsp;</strong>생년월일
							<input type="text" class="small"/>&nbsp;<i class="fas fa-calendar-alt"></i>
						</td>
						<td class="td3">
							성별
							<input type="radio" name="gender"/>&nbsp;남성
							<input type="radio" name="gender"/>&nbsp;여성
						</td>
					</tr>
					<tr>
						<td class="td1">
							<strong style="color:red;">*&nbsp;</strong>생일
							<input type="radio" name="birth"/>&nbsp;양력
							<input type="radio" name="birth"/>&nbsp;음력
						</td>
						<td class="td2">
							결혼기념일
							<input type="text" class="small"/>&nbsp;<i class="fas fa-calendar-alt"></i>
						</td>
						<td class="td3">
							<strong style="color:red;">*&nbsp;</strong>직업코드
							<select></select>
						</td>
					</tr>
					<tr>
						<td class="td1">
							<strong style="color:red;">*&nbsp;</strong>휴대폰번호
							<input type="text" class="small"/>
							<input type="text" class="small"/>
							<input type="text" class="small"/>
							<button type="button">변경</button>
						</td>
						<td class="td2">
							공란
						</td>
						<td class="td3">
							<strong style="color:red;">*&nbsp;</strong>가입매장
							<input type="text" class="small"/><i class="fas fa-search"></i> <input type="text" class="small"/>
						</td>
					</tr>
					<tr>
						<td class="td1">
							<strong style="color:red;">*&nbsp;</strong>우편물수령
							<input type="radio" name="postReceive"/>&nbsp;자택
							<input type="radio" name="postReceive"/>&nbsp;직장
						</td>
						<td class="td2">
							<strong style="color:red;">*&nbsp;</strong>이메일
							<input type="text" class="medium"/>@
							<input type="text" class="medium"/>
						</td>
						<td class="td3">
							공란
						</td>
					</tr>
					<tr>
						<td style="padding-left: 10px;">
							주소
							<input type="text" class="small"/>
							<input type="text" class="medium"/>
							<input type="text" class="large"/>
						</td>
					</tr>
					<tr>
						<td class="td1">
							<strong style="color:red;">*&nbsp;</strong>고객상태
							<input type="radio" name="custStatus"/>&nbsp;정상
							<input type="radio" name="custStatus"/>&nbsp;중지
							<input type="radio" name="custStatus"/>&nbsp;해지
						</td>
						<td class="td2">
							최초가입일자
							<input type="text" class="medium"/>
						</td>
						<td class="td3">
							가입일자
							<input type="text" class="medium"/>
						</td>
					</tr>
					<tr>
						<td class="td1">
							해지사유
							<input type="text" class="large"/>
						</td>
						<td class="td2">
							중지일자
							<input type="text" class="medium"/>
						</td>
						<td class="td3">
							해지일자
							<input type="text" class="medium"/>
						</td>
					</tr>
				</table>
			</div>
			<!-- 고객기본정보 끝 -->
			
			
			<!-- 구매 시작 -->
			<div style="margin: auto 0; padding: 5px 10px;">
				<span style="font-size: 25px;">구매</span>
			</div>
			
			<div id="purchase">
				<table id="tbl_purchase">
					<tr>
						<td class="td1">
							총구매금액
							<input type="text" class="medium"/>
						</td>
						<td class="td2">
							당월구매금액
							<input type="text" class="medium"/>
						</td>
						<td class="td3">
							최종구매일
							<input type="text" class="medium"/>
						</td>
					</tr>
				</table>
			</div>
			<!-- 구매 끝 -->
			
			
			<!-- 포인트 시작 -->
			<div style="margin: auto 0; padding: 5px 10px;">
				<span style="font-size: 25px;">포인트</span>
			</div>
			
			<div id="point">
				<table id="tbl_point">
					<tr>
						<td class="td1">
							총포인트
							<input type="text" class="medium"/>
						</td>
						<td class="td2">
							당월적립포인트
							<input type="text" class="medium"/>
						</td>
						<td class="td3">
							당월사용포인트
							<input type="text" class="medium"/>
						</td>
					</tr>
				</table>
			</div>
			<!-- 포인트 끝 -->
			
			
			<!-- 수신동의(통합) 시작 -->
			<div style="margin: auto 0; padding: 5px 10px;">
				<span style="font-size: 25px;">수신동의(통합)</span>
			</div>
			
			<div id="recieveAgreement">
				<table id="tbl_recieveAgreement">
					<tr>
						<td class="td1">
							<strong style="color:red;">*&nbsp;</strong>이메일수신동의
							<input type="radio" name="emailReceive"/>&nbsp;예
							<input type="radio" name="emailReceive"/>&nbsp;아니오
						</td>
						<td class="td2">
							<strong style="color:red;">*&nbsp;</strong>SMS수신동의
							<input type="radio" name="smsReceive"/>&nbsp;예
							<input type="radio" name="smsReceive"/>&nbsp;아니오
						</td>
						<td class="td3">
							<strong style="color:red;">*&nbsp;</strong>DM수신동의
							<input type="radio" name="dmReceive"/>&nbsp;예
							<input type="radio" name="dmReceive"/>&nbsp;아니오
						</td>
					</tr>
				</table>
			</div>
			<!-- 수신동의(통합) 끝 -->
		</form>
		
		<div style="float:right;">
			<button type="button" class="btn-secondary">닫기</button>
			<button type="button" class="btn-secondary">저장</button>
		</div>
	</div>

</div>