package com.spring.shopping.service;

import java.util.List;
import java.util.Map;

import com.spring.shopping.model.EmpVO;

public interface InterEmpService {

	// 로그인 요청
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

}
