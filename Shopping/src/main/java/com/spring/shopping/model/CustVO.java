package com.spring.shopping.model;

import lombok.Data;

@Data
public class CustVO {
	private String CUST_NO;				// 고객번호
	private String CUST_NM;				// 고객명
	private String SEX_CD;				// 성별코드
	private String SCAL_YN;				// 양음력구분
	private String BRDY_DT;				// 생년월일
	private String MRRG_DT;				// 결혼기념일
	private String POC_CD;				// 직업코드
	private String MBL_NO;				// 휴대폰번호
	private String PSMT_GRC_CD;			// 우편물수령코드
	private String EMAIL;				// 이메일주소
	private String ZIP_CD;				// 우편번호코드
	private String ADDR;				// 주소
	private String ADDR_DTL;			// 상세주소
	private String CUST_SS_CD;			// 고객상태코드
	private String CNCL_CNTS;			// 해지사유내용
	private String JN_PRT_CD;			// 가입매장코드
	private String PRT_NM;				// 가입매장명
	private String EMAIL_RCV_YN;		// 이메일수신동의여부
	private String SMS_RCV_YN;			// SMS수신동의여부
	private String TM_RCV_YN;			// TM수신동의여부
	private String DM_RCV_YN;			// DM수신동의여부
	private String FST_JS_DT;			// 최초가입일자
	private String JS_DT;				// 가입일자
	private String STP_DT;				// 중지일자
	private String CNCL_DT;				// 해지일자
	private String FST_REG_DT;			// 최초등록일자
	private String FST_USER_ID;			// 최초등록자
	private String LST_UPD_DT;			// 최종수정일자
	private String LST_UPD_ID;			// 최종수정자
}
