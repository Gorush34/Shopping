package com.spring.shopping.model;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.shopping.common.Criteria;
import com.spring.shopping.common.SearchCriteria;

@Repository
public class ShoppingDAO implements InterShoppingDAO {
	
	@Resource
	private SqlSessionTemplate sqlsession; // 로컬DB shopping 에 연결
	// Type 에 따라 Spring 컨테이너가 알아서 root-context.xml 에 생성된 org.mybatis.spring.SqlSessionTemplate 의  sqlsession bean 을  sqlsession 에 주입시켜준다. 
    // 그러므로 sqlsession 는 null 이 아니다.
	
	@Override
	public int testInsert() {
		
		// int n = sqlsession.insert("shopping.testInsert");
		
		int n = sqlsession.update("shopping.testUpdate");
		
		return n;
	}

	@Override
	public int write(ShoppingVO shopping) {
		int n = sqlsession.insert("shopping.write", shopping);
		return n;
	}

	@Override
	public List<Map<String, Object>> getBoardList() {
		List<Map<String, Object>> boardList = sqlsession.selectList("shopping.getBoardList");
		return boardList;
	}

	@Override
	public ShoppingVO getView(String seq) {
		ShoppingVO shoppingvo = sqlsession.selectOne("shopping.getView", seq);
		return shoppingvo;
	}

	@Override
	public int remove(String seq) {
		int n = sqlsession.delete("shopping.remove", seq);
		return n;
	}

	@Override
	public int update(ShoppingVO shoppingVO) {
		int n = sqlsession.update("shopping.update", shoppingVO);
		return n;
	}

	// 검색 및 페이징처리가 된 목록 불러오기
	@Override
	public List<ShoppingVO> getListWithPaging(SearchCriteria scri) throws Exception {
		List<ShoppingVO> List = sqlsession.selectList("shopping.getListWithPaging", scri);
		return List;
	}

	// 총 게시글 개수 구하기
	@Override
	public int getTotalCount(SearchCriteria scri) throws Exception {
		int totalCount = sqlsession.selectOne("shopping.getTotalCount", scri);
		return totalCount;
	}

	// 매장별 월별실적 불러오기
	@Override
	public List<Map<String, String>> getPerformanceList(Map<String, Object> map) {
		
		return sqlsession.selectList("shopping.getPerformanceList", map);
	}

	// 제품목록을 조회하기
	@Override
	public List<Map<String, String>> getProductList(Map<String, Object> map) {
		
		return sqlsession.selectList("shopping.getProductList", map);
	}

	// ##1-10. 고객판매관리 목록조회하기
	@Override
	public List<Map<String, String>> getSalList(Map<String, Object> map) {
		
		return sqlsession.selectList("shopping.getSalList", map);
	}

	// ## 피드백 이후 반품여부 가져오기
	@Override
	public String getReturnYN(Map<String, Object> map) {
		
		return sqlsession.selectOne("shopping.getReturnYN", map);
	}	
	
	// 판매상세조회 리스트 조회하기
	@Override
	public List<Map<String, String>> getsalDetailList(Map<String, Object> map) {
		
		return sqlsession.selectList("shopping.getsalDetailList", map);
	}

	// ##피드백 이후 마스터테이블 판매 및 반품 insert
	@Override
	public int insertSalMT(Map<String, Object> masterMap) {
		
		return sqlsession.insert("shopping.insertSalMT", masterMap);
	}

	// ##피드백 이후 판매상세테이블 insert
	@Override
	public int insertSalDT(Map<String, Object> detail) {
		
		return sqlsession.insert("shopping.insertSalDT", detail);
	}

	// ##피드백 이후 재고수량 테이블 update
	@Override
	public int updateIvcoQty(Map<String, Object> detail) {
		
		return sqlsession.update("shopping.updateIvcoQty", detail);
	}

	// ## 피드백 이후 포인트상세테이블 insert
	@Override
	public int insertPNT_D(Map<String, Object> masterMap) {
		
		return sqlsession.insert("shopping.insertPNT_D", masterMap);
	}

	// ## 피드백 이후 포인트마스터테이블 update
	@Override
	public int updatePNT_M(Map<String, Object> masterMap) {
		
		return sqlsession.update("shopping.updatePNT_M", masterMap);
	}

	// 실시간 고객상태 알아오기
	@Override
	public Map<String, String> getCUstStatus(Map<String, String> ssParam) {
		
		return (Map<String, String>) sqlsession.selectOne("shopping.getCUstStatus", ssParam);
	}

	// 실시간 상품상태 알아오기
	@Override
	public Map<String, String> getPrd(Map<String, String> prd) {
		
		return (Map<String, String>) sqlsession.selectOne("shopping.getPrd", prd);
	}


	
	

}
