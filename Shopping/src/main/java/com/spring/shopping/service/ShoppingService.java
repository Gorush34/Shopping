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

}
