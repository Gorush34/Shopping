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
import org.springframework.web.bind.annotation.RequestParam;
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
	public ModelAndView requiredLogin_viewCustomer(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, @ModelAttribute("scri") SearchCriteria scri) throws Exception {
		
		
		mav.setViewName("viewCustomer.report1"); // viewCustomer.dowell(tiles : report1 레이아웃 적용된)으로 주소 지정
		
		return mav;
	}
	
	
	// 매장월별실적조회 페이지 요청
	@RequestMapping(value="/viewStorePerformance.dowell")
	public ModelAndView requiredLogin_viewStorePerformance(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, @ModelAttribute("scri") SearchCriteria scri) throws Exception {
		
		
		mav.setViewName("viewStorePerformance.report1"); // viewCustomer.dowell(tiles : report1 레이아웃 적용된)으로 주소 지정
		
		return mav;
	}
	
	
	// 매장별 월별실적 불러오기
	@ResponseBody
	@RequestMapping(value = "/searchPerformance.dowell", method= {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String searchPerfomance(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		List<Map<String, String>> performList = service.getPerformanceList(map);
		// parameter로 map을 담아 getPerformanceList를 실행한 뒤 결과값을 담는 performList 생성
		
		JSONArray jsonArr = new JSONArray();
		// 결과값을 화면에 출력하기 위해 JSON타입인 jsonArr 생성
		
		if(performList != null && performList.size() > 0) {	
		// 받아온 값이 있다면
			
			for(Map<String, String> performMap : performList) {
				// 반복대상 : performList ( 데이터 타입 : List<Map<String, String>> )
				// 반복할 값의 데이터 타입 : Map<String, String>
				// 반복할 값을 담을 변수명 : performMap
				
				// 매장별로 일별 판매수량 및 매장의 해당월 총합계를 담아준다
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("PRT_CD", performMap.get("PRT_CD"));
				jsonObj.put("PRT_NM", performMap.get("PRT_NM"));
				jsonObj.put("D01", performMap.get("D01"));
				jsonObj.put("D02", performMap.get("D02"));
				jsonObj.put("D03", performMap.get("D03"));
				jsonObj.put("D04", performMap.get("D04"));
				jsonObj.put("D05", performMap.get("D05"));
				jsonObj.put("D06", performMap.get("D06"));
				jsonObj.put("D07", performMap.get("D07"));
				jsonObj.put("D08", performMap.get("D08"));
				jsonObj.put("D09", performMap.get("D09"));
				jsonObj.put("D10", performMap.get("D10"));
				jsonObj.put("D11", performMap.get("D11"));
				jsonObj.put("D12", performMap.get("D12"));
				jsonObj.put("D13", performMap.get("D13"));
				jsonObj.put("D14", performMap.get("D14"));
				jsonObj.put("D15", performMap.get("D15"));
				jsonObj.put("D16", performMap.get("D16"));
				jsonObj.put("D17", performMap.get("D17"));
				jsonObj.put("D18", performMap.get("D18"));
				jsonObj.put("D19", performMap.get("D19"));
				jsonObj.put("D20", performMap.get("D20"));
				jsonObj.put("D21", performMap.get("D21"));
				jsonObj.put("D22", performMap.get("D22"));
				jsonObj.put("D23", performMap.get("D23"));
				jsonObj.put("D24", performMap.get("D24"));
				jsonObj.put("D25", performMap.get("D25"));
				jsonObj.put("D26", performMap.get("D26"));
				jsonObj.put("D27", performMap.get("D27"));
				jsonObj.put("D28", performMap.get("D28"));
				jsonObj.put("D29", performMap.get("D29"));
				jsonObj.put("D30", performMap.get("D30"));
				jsonObj.put("D31", performMap.get("D31"));
				jsonObj.put("SUM", performMap.get("SUM"));
				jsonArr.put(jsonObj); 
				// Map에서 받아온 값들은 jsonObj에 저장한 뒤, jsonObj를 배열 형태인 jsonArr에 담는다.
			}
			
		}
		
		return jsonArr.toString(); // 배열 형태인 jsonArr을 String 형태로 변환하여 return 한다.
	} // end of public String searchPerfomance(ModelAndView mav, @RequestParam Map<String, Object> map) {}-------------
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	// === 로그인 또는 로그아웃을 했을 때 현재 보이던 그 페이지로 그대로 돌아가기 위한 메소드 생성 === //
	public void getCurrentURL(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute("goBackURL", MyUtil.getCurrentURL(request));
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////	
	
	
}
