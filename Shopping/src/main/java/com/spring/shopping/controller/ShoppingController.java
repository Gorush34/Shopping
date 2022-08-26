package com.spring.shopping.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.shopping.common.FileManager;
import com.spring.shopping.common.MyUtil;
import com.spring.shopping.common.PageMaker;
import com.spring.shopping.common.SearchCriteria;
import com.spring.shopping.model.ShoppingVO;
import com.spring.shopping.service.InterShoppingService;

@Controller
public class ShoppingController {
	
	private static final Logger logger = LoggerFactory.getLogger(ShoppingController.class);
	
	@Autowired
	private InterShoppingService service;
	
	@Autowired     // Type에 따라 알아서 Bean 을 주입해준다.
	private FileManager fileManager;

	@RequestMapping(value="/index.dowell")
	public ModelAndView requiredLogin_index(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		getCurrentURL(request); // 로그인 또는 로그아웃을 했을 때 현재 보이던 그 페이지로 그대로 돌아가기 위한 메소드 호출 
		
		// int n = service.insertTest();
		
		List<Map<String, Object>> boardList = service.getBoardList();
		
		mav.addObject("boardList", boardList);
		mav.setViewName("index.report1");
		// /WEB-INF/views/tiles1/index.jsp 페이지를 만들어야 한다.
		
		return mav;
	} // end of public ModelAndView index(ModelAndView mav, HttpServletRequest request) -------------

	
	// 프론트엔드 연습 페이지 요청
	@RequestMapping(value="/front.dowell")
	public ModelAndView front(ModelAndView mav, HttpServletRequest request) {
		
		mav.setViewName("practice.front");
		
		
		return mav;
	}
	
	@RequestMapping(value="/list.dowell")
	public ModelAndView list(ModelAndView mav, @ModelAttribute("scri") SearchCriteria scri) throws Exception {
		
		
		
		mav.addObject("list", service.getListWithPaging(scri)); // 게시판 내용 목록들을 저장
		logger.info("mav : " + mav.toString());
		
		PageMaker pageMaker = new PageMaker(); // 페이지바 구성을 위한 객체 생성
		pageMaker.setCri(scri); // 검색조건 저장
		pageMaker.setTotalCount(service.getTotalCount(scri)); // 페이지바의 마지막번호 가져옴
		
		mav.addObject("pageMaker", pageMaker); // 페이지바의 정보를 저장
		
		mav.setViewName("list.tiles1"); // list.dowell(tiles1 레이아웃 적용된)으로 주소 지정
		
		
		return mav;
	}
	
	
	/////////////////////////////////////////////// 과제1 시작 /////////////////////////////////////////////////
	
	// 고객조회 페이지에서 매장검색버튼 및 매장명입력시 페이지 요청
	@RequestMapping(value="/search_prt.dowell")
	public ModelAndView requiredLogin_search_prt(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		mav.setViewName("tiles1/search_prt");
		
		return mav;
	} // end of public update(ModelAndView mav, HttpServletRequest request)-----------
	
	
	// 고객정보조회 페이지 요청
	@RequestMapping(value="/viewCustomer.dowell")
	public ModelAndView viewCustomer(ModelAndView mav, @ModelAttribute("scri") SearchCriteria scri) throws Exception {
		
		
		mav.setViewName("viewCustomer.report1"); // viewCustomer.dowell(tiles : report1 레이아웃 적용된)으로 주소 지정
		
		return mav;
	}
	
	
	// 매장월별실적조회 페이지 요청
	@RequestMapping(value="/viewStorePerformance.dowell")
	public ModelAndView viewStorePerformance(ModelAndView mav, @ModelAttribute("scri") SearchCriteria scri) throws Exception {
		
		
		mav.setViewName("viewStorePerformance.report1"); // viewCustomer.dowell(tiles : report1 레이아웃 적용된)으로 주소 지정
		
		return mav;
	}
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	// === 로그인 또는 로그아웃을 했을 때 현재 보이던 그 페이지로 그대로 돌아가기 위한 메소드 생성 === //
	public void getCurrentURL(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute("goBackURL", MyUtil.getCurrentURL(request));
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////	
	
	
}
