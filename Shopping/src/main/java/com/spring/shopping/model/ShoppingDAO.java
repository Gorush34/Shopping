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
	
	

}
