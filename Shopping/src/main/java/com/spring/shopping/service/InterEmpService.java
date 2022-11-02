package com.spring.shopping.service;

import java.util.List;
import java.util.Map;

import com.spring.shopping.model.CustVO;
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

	// 고객의 변경이력 불러오기(팝업)
	List<Map<String, String>> getPopUpHistoryList(Map<String, Object> map);

	// 고객의 정보를 조회(팝업)
	Map<String, String> getCustInfoPopUp(Map<String, Object> map);

	// 고객상태 목록을 불러오기
	List<Map<String, String>> getCustStatusList();

	// 공통테이블 코드목록 조회
	List<Map<String, String>> getCodeList();

	// 코드별 세부코드 목록 가져오기
	List<Map<String, String>> getcodeDetailList(Map<String, String> code);

	// 고객정보 조회
	List<Map<String, String>> readCustInfo(String viewCust);

	// DB를 통해 비교하여 중복검사를 실행하는 함수
	String compareItem(Map<String, Object> map);

	// 고객 등록 요청
	int registerCust(Map<String, Object> map);

	// 최초등록고객 포인트 테이블 생성
	int insert_TBL_PNT(Map<String, Object> map);

	// 고객정보 수정
	int updateCustInfo(Map<String, Object> map);

	// 변경이력 추가
	int insertHistory(Map<String, Object> paraMap);

	// 포인트 상세테이블에 방금 가입한 회원의 정보를 insert
	int insert_TBL_PNT_D(Map<String, Object> map);

	// 포인트 마스터테이블에 방금 가입한 회원의 정보를 insert
	int insert_TBL_PNT_M(Map<String, Object> map);

}
