package com.spring.shopping.common;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

// 페이지바 생성을 위한 클래스
public class PageMaker {

	  private Criteria cri; // Criteria를 주입받는다.
	  private int totalCount; // 게시판 전체 게시글 개수
	  private int startPage; // 현재 화면에서 보이는 startPage 번호
	  private int endPage; // 현재 화면에 보이는 endPage 번호
	  private boolean prev; // 페이징 이전 버튼 활성화 여부
	  private boolean next; // 페이징 다음 버튼 활성화 여부
	  private int displayPageNum = 10; // 게시판 화면에서 한번에 보여질 페이지 번호의 개수 // 1,2,3,4,5,6,7,9,10
	  
	  public Criteria getCri() {
	      return cri;
	  }
	  public void setCri(Criteria cri) {
	      this.cri = cri;
	  }
	  public int getTotalCount() {
	      return totalCount;
	  }
	  public void setTotalCount(int totalCount) { // 전체 게시글 개수
	      this.totalCount = totalCount;
	      calcData(); // 전체 개시글 개수를 가져온 뒤 시작/끝페이지번호 설정
	  }
	  
	  private void calcData() {
	      
	      endPage = (int) (Math.ceil(cri.getPage() / (double) displayPageNum) * displayPageNum);

	      startPage = (endPage - displayPageNum) + 1;
	      if(startPage <= 0) startPage = 1;
	      
	      int tempEndPage = (int) (Math.ceil(totalCount / (double) cri.getPerPageNum()));
	      if (endPage > tempEndPage) {
	          endPage = tempEndPage;
	      }

	      prev = startPage == 1 ? false : true; // 맨처음 페이지번호가 1이면 false, 아니면 true
	      next = endPage * cri.getPerPageNum() < totalCount ? true : false; // 총 페이지번호보다 현재 페이지번호가 작으면 true, 아니면 false
	      
	  }
	  
	  public int getStartPage() {
	      return startPage;
	  }
	  public void setStartPage(int startPage) {
	      this.startPage = startPage;
	  }
	  public int getEndPage() {
	      return endPage;
	  }
	  public void setEndPage(int endPage) {
	      this.endPage = endPage;
	  }
	  public boolean isPrev() {
	      return prev;
	  }
	  public void setPrev(boolean prev) {
	      this.prev = prev;
	  }
	  public boolean isNext() {
	      return next;
	  }
	  public void setNext(boolean next) {
	      this.next = next;
	  }
	  public int getDisplayPageNum() {
	      return displayPageNum;
	  }
	  public void setDisplayPageNum(int displayPageNum) {
	      this.displayPageNum = displayPageNum;
	  }
	  
	  @Override
	  public String toString() {
	    return "PageMaker [cri=" + cri + ", totalCount=" + totalCount + ", startPage=" + startPage
	        + ", endPage=" + endPage + ", prev=" + prev + ", next=" + next + ", displayPageNum="
	        + displayPageNum + "]";
	  }
	  
	  // 페이지 쿼리 만드는 메소드
	  public String makeQuery(int page) {
	    UriComponents uri = UriComponentsBuilder.newInstance()
	            .queryParam("page", page)
	            .queryParam("perPageNum", cri.getPerPageNum())
	            .build();
	    return uri.toUriString();
	  }

	  public String makeQuery(int idx, int page) {
	    UriComponents uri = UriComponentsBuilder.newInstance()
	            .queryParam("idx", idx)
	            .queryParam("page", page)
	            .queryParam("perPageNum", cri.getPerPageNum())
	            .build();
	    return uri.toUriString();
	  }

	  // 리스트 + 검색 + 페이징
	  public String makeSearch(int page) {
	    UriComponents uriComponents =
	              UriComponentsBuilder.newInstance()
	              .queryParam("page", page)
	              .queryParam("perPageNum", cri.getPerPageNum())
	              .queryParam("searchType", ((SearchCriteria)cri).getSearchType())
	              .queryParam("keyword", encoding(((SearchCriteria)cri).getKeyword()))
	              .build(); 
	      return uriComponents.toUriString();  
	  }

	  private String encoding(String keyword) {
	      if(keyword == null || keyword.trim().length() == 0) { 
	          return "";
	      }
	       
	      try {
	          return URLEncoder.encode(keyword, "UTF-8");
	      } catch(UnsupportedEncodingException e) { 
	          return ""; 
	      }
	  }
	
}
