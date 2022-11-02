package com.spring.shopping.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SalDTO {
	private String PRT_CD;			// 매장코드
	private String SAL_DT;			// 판매일자
	private String SAL_NO;			// 판매번호
	private String SAL_TP_CD;		// 판매구분코드
	private String TOT_SAL_QTY;		// 총판매수량
	private String TOT_SAL_AMT;		// 총판매금액
	private String TOT_VOS_AMT;		// 총공급가액
	private String TOT_VAT_AMT;		// 총부가세액
	private String CSH_STLM_AMT;	// 현금결제금액
	private String CRD_STLM_AMT;	// 카드결제금액
	private String PNT_STLM_AMT;	// 포인트사용금액
	private String CUST_NO;			// 고객번호
	private String CRD_NO;			// 카드번호
	private String VLD_YM;			// 유효년월
	private String CRD_CO_CD;		// 카드회사
	private String FST_REG_DT;		// 최초등록일자
	private String FST_USER_ID;		// 최초등록자
	private String LST_UPD_DT;		// 최종수정일자
	private String LST_UPD_ID;		// 최종수정자
	private String ORG_SHOP_CD;		// 원매장코드
	private String ORG_SAL_DT;		// 원판매일자
	private String ORG_SAL_NO;		// 원판매번호
}
