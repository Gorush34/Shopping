package com.spring.shopping.model;

import java.util.List;
import java.util.Map;

public interface InterEmpDAO {

	// 로그인 요청하기
	EmpVO getLoginMember(Map<String, String> paraMap);

	// 고객조회 목록 가져오기
	List<Map<String, String>> getCustList(Map<String, Object> map);

	// 매장조회 테이블 매장목록 불러오기(팝업)
	List<Map<String, String>> getPrtList(Map<String, Object> map);

	// 고객조회 테이블 고객목록 불러오기(팝업)
	List<Map<String, String>> getPopUpCustList(Map<String, Object> map);

	// 매장을 조건으로 검색한 결과의 개수 가져오기
	Map<String, String> getTotalCountPrt(Map<String, Object> map);

	// 고객을 조건으로 검색한 결과의 개수 가져오기
	Map<String, String> getTotalCountCust(Map<String, Object> map);

	// 매장검색 결과가 하나인 것에 대한 정보 가져오기
	Map<String, String> getResultPrt(Map<String, Object> map);
	
	// 고객검색 결과가 하나인 것에 대한 정보 가져오기
	Map<String, String> getResultCust(Map<String, Object> map);

	// 고객의 변경이력 불러오기(팝업)
	List<Map<String, String>> getPopUpHistoryList(Map<String, Object> map);

	// 고객의 정보를 조회(팝업)
	Map<String, String> getCustInfoPopUp(Map<String, Object> map);

	// 고객상태 목록을 불러오기
	List<Map<String, String>> getCustStatusList();
	
}
