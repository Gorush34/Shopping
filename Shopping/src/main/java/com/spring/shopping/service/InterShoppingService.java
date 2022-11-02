package com.spring.shopping.service;

import java.util.*;

import com.spring.shopping.common.SearchCriteria;
import com.spring.shopping.model.ShoppingVO;

public interface InterShoppingService {

	int insertTest();

	int write(ShoppingVO shopping);

	List<Map<String, Object>> getBoardList();

	ShoppingVO getView(String seq);

	int remove(String seq);

	int update(ShoppingVO shoppingVO);
	
	// 검색 및 페이징처리가 된 목록 불러오기
	public List<ShoppingVO> getListWithPaging(SearchCriteria scri) throws Exception;
	
	// 총 게시글 개수 구하기
	public int getTotalCount(SearchCriteria scri) throws Exception;

	// 매장별 월별실적 불러오기
	List<Map<String, String>> getPerformanceList(Map<String, Object> map);

	// 제품목록을 조회하기
	List<Map<String, String>> getProductList(Map<String, Object> map);

	// ##1-7. 고객판매관리 목록조회하기
	List<Map<String, String>> getSalList(Map<String, Object> map);

	// ## 피드백 이후 반품여부를 구해오기
	String getReturnYN(Map<String, Object> map);
	
	// 판매상세조회 리스트 조회하기
	List<Map<String, String>> getsalDetailList(Map<String, Object> map);

	// ##피드백 이후 마스터테이블 판매 및 반품 insert
	int insertSalMT(Map<String, Object> masterMap);

	// ##피드백 이후 판매상세테이블 insert
	int insertSalDT(Map<String, Object> detail);
	
	// ##피드백 이후 재고수량테이블 update
	int updateIvcoQty(Map<String, Object> detail);

	// ## 피드백 이후 포인트상세테이블 insert
	int insertPNT_D(Map<String, Object> masterMap);

	// ## 피드백 이후 포인트마스터테이블 update
	int updatePNT_M(Map<String, Object> masterMap);

	// 실시간 고객상태 알아오기
	Map<String, String> getCUstStatus(Map<String, String> ssParam);

	// 실시간 상품상태 알아오기
	Map<String, String> getPrd(Map<String, String> prd);




}
