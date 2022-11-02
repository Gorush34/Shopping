package com.spring.shopping.model;

import lombok.Data;


@Data
public class EmpVO {
	/*
	 * 안녕 지은아?
	 * 반가워
	 */
	private String USER_ID;						// 사용자ID
	private String USER_NM;						// 사용자명
	private String USER_DT_CD;					// 사용자구분코드
	private char USE_YN;						// 사용여부
	private String USE_PWD;						// 비밀번호
	private String ST_DT;						// 시작일자
	private String ED_DT;						// 종료일자
	private String PRT_CD;						// 거래처코드
	private String PRT_NM;						// 거래처명
	private String PWD_UPD_DT;					// 비밀번호변경일자
	private String FST_REG_DT;					// 최초등록일자
	private String FST_USER_ID;					// 최초등록자
	private String LST_UPD_DT;					// 최종수정일자
	private String LST_UPD_ID;					// 최종수정자
	
	
	private int pwdchangegap;	 // select 용. 지금으로 부터 마지막으로 암호를 변경한지가 몇개월인지 알려주는 개월수(3개월 동안 암호를 변경 안 했을시 암호를 변경하라는 메시지를 보여주기 위함)
	
	
	private boolean requirePwdChange = false;
	// 마지막으로 암호를 변경한 날짜가 현재시각으로 부터 3개월이 지났으면 true
	// 마지막으로 암호를 변경한 날짜가 현재시각으로 부터 3개월이 지나지 않았으면 false
	
	
	
}
