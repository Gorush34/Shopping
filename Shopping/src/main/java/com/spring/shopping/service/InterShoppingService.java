package com.spring.shopping.service;

import java.util.List;

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

}
