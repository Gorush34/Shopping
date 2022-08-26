package com.spring.shopping.common;

//리스트 + 검색 + 페이징처리를 위해 검색타입과 검색어를 담는 클래스
public class SearchCriteria extends Criteria {
	
	  private String searchType = ""; // 검색 타입(카테고리)
	  
	  private String keyword = ""; // 검색 키워드
	   
	  public String getSearchType() {
	      return searchType;
	  }
	  
	  public void setSearchType(String searchType) {
	      this.searchType = searchType;
	  }
	  
	  public String getKeyword() {
	      return keyword;
	  }
	  
	  public void setKeyword(String keyword) {
	      this.keyword = keyword;
	  }
	  
	  @Override
	  public String toString() {
	      return "SearchCriteria [searchType=" + searchType + ", keyword=" + keyword + "]";
	  }
	
}
