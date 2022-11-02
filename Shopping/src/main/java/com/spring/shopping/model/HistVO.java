package com.spring.shopping.model;

import lombok.Data;

@Data
public class HistVO {
	private String CUST_NO;				// 고객번호
	private String CHG_CD;				// 변경항목코드
	private String CHG_BF_CNT;			// 변경전내용
	private String CHG_AFT_CNT;			// 변경후내용
	private String UPD_ID;				// 수정자 ID
}
