package com.spring.shopping.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.shopping.common.SearchCriteria;
import com.spring.shopping.model.InterShoppingDAO;
import com.spring.shopping.model.ShoppingVO;

@Service
public class ShoppingService implements InterShoppingService {

	@Autowired
	private InterShoppingDAO dao;
	
	@Override
	public int insertTest() {
		
		int n = dao.testInsert();
		
		return n;
	}

	@Override
	public int write(ShoppingVO shopping) {
		int n = dao.write(shopping);
		return n;
	}

	@Override
	public List<Map<String, Object>> getBoardList() {
		List<Map<String, Object>> boardList = dao.getBoardList();
		return boardList;
	}

	@Override
	public ShoppingVO getView(String seq) {
		ShoppingVO shoppingvo = dao.getView(seq);
		return shoppingvo;
	}

	@Override
	public int remove(String seq) {
		int n = dao.remove(seq);
		return n;
	}

	@Override
	public int update(ShoppingVO shoppingVO) {
		int n = dao.update(shoppingVO);
		return n;
	}

	@Override
	public List<ShoppingVO> getListWithPaging(SearchCriteria scri) throws Exception {
		List<ShoppingVO> list = dao.getListWithPaging(scri);
		return list;
	}

	@Override
	public int getTotalCount(SearchCriteria scri) throws Exception {
		int totalCount = dao.getTotalCount(scri);
		return totalCount;
	}

	// 매장별 월별실적 불러오기
	@Override
	public List<Map<String, String>> getPerformanceList(Map<String, Object> map) {
		
		return dao.getPerformanceList(map);
	}

	// 제품목록을 조회하기
	@Override
	public List<Map<String, String>> getProductList(Map<String, Object> map) {
		
		return dao.getProductList(map);
	}

	// ##1-8. 고객판매관리 목록조회하기
	@Override
	public List<Map<String, String>> getSalList(Map<String, Object> map) {
		
		String sdate = String.valueOf(map.get("SDATE"));
		String edate = String.valueOf(map.get("EDATE"));
		
		map.put("SDATE", sdate.replaceAll("-", ""));				// 시작일자 파라미터 값 사이의 - 제거
		map.put("EDATE", edate.replaceAll("-", ""));				// 종료일 파라미터 값 사이의 - 제거
		
		return dao.getSalList(map);
	}
	
	// ## 피드백 이후 반품여부 가져오기
	@Override
	public String getReturnYN(Map<String, Object> map) {
		
		return dao.getReturnYN(map);
	}
	
	// 판매상세조회 리스트 조회하기
	@Override
	public List<Map<String, String>> getsalDetailList(Map<String, Object> map) {
		
		return dao.getsalDetailList(map);
	}

	// ##피드백 이후 마스터테이블 판매 및 반품 insert
	@Override
	public int insertSalMT(Map<String, Object> masterMap) {
		
		String edate = String.valueOf(masterMap.get("EDATE"));
		String csh = String.valueOf(masterMap.get("CSH_STLM_AMT"));		// 현금결제금액을 얻어온다
		String crd = String.valueOf(masterMap.get("CRD_STLM_AMT"));		// 카드결제금액을 얻어온다
		String pnt = String.valueOf(masterMap.get("PNT_STLM_AMT"));		// 포인트결제금액을 얻어온다
		
		masterMap.put("EDATE", edate.replaceAll("-", ""));				// 일자 파라미터 값 사이의 - 제거
		masterMap.put("CSH_STLM_AMT", csh.replaceAll(",", ""));			// 현금결제금액 파라미터 값 사이의 , 제거
		masterMap.put("CRD_STLM_AMT", crd.replaceAll(",", ""));			// 카드결제금액 파라미터 값 사이의 , 제거
		masterMap.put("PNT_STLM_AMT", pnt.replaceAll(",", ""));			// 포인트결제금액 파라미터 값 사이의 , 제거
		
		return dao.insertSalMT(masterMap);
	}

	// ##피드백 이후 상세테이블 insert
	@Override
	public int insertSalDT(Map<String, Object> detail) {
		
		return dao.insertSalDT(detail);
	}
	
	// ##피드백 이후 상세테이블 재고 update
	@Override
	public int updateIvcoQty(Map<String, Object> detail) {
		
		return dao.updateIvcoQty(detail);
	}

	// ## 피드백 이후 포인트상세테이블 insert
	@Override
	public int insertPNT_D(Map<String, Object> masterMap) {
		
		return dao.insertPNT_D(masterMap);
	}

	// ## 피드백 이후 포인트마스터테이블 update
	@Override
	public int updatePNT_M(Map<String, Object> masterMap) {
		
		return dao.updatePNT_M(masterMap);
	}

	// 실시간 고객상태 알아오기
	@Override
	public Map<String, String> getCUstStatus(Map<String, String> ssParam) {
		
		return dao.getCUstStatus(ssParam);
	}

	// 실시간 상품상태 알아오기
	@Override
	public Map<String, String> getPrd(Map<String, String> prd) {
		
		return dao.getPrd(prd);
	}



}
