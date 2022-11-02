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
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.spring.shopping.common.FileManager;
import com.spring.shopping.common.MyUtil;
import com.spring.shopping.common.PageMaker;
import com.spring.shopping.common.SearchCriteria;
import com.spring.shopping.model.ShoppingVO;
import com.spring.shopping.service.InterEmpService;
import com.spring.shopping.service.InterShoppingService;

@Controller
public class ShoppingController {
	
	private static final Logger logger = LoggerFactory.getLogger(ShoppingController.class);
	
	@Autowired
	private InterEmpService empService;
	
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
	
	
	// ========================================= 과제3 시작 =========================================
	
	// 고객판매관리 페이지 요청
	@RequestMapping(value="/custSalManagement.dowell")
	public ModelAndView requiredLogin_viewCustomer(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		mav.setViewName("custSalManagement.report1"); // viewCustomer.dowell(tiles : report1 레이아웃 적용된)으로 주소 지정
		
		return mav;
	} // end of public ModelAndView requiredLogin_viewCustomer(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {}-----
	
	// 고객판매관리 페이지에서 판매상세조회 팝업페이지 요청
	@RequestMapping(value="/viewSalDetail.dowell")
	public ModelAndView requiredLogin_viewSalDetail(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		mav.setViewName("tiles1/viewSalDetail");
		
		return mav;
	} // end of public requiredLogin_viewSalDetail(ModelAndView mav, HttpServletRequest request)-----------
	
	// ##2-3. 고객판매관리 페이지에서 고객판매수금등록 페이지 요청
	@RequestMapping(value="/registerSal.dowell")
	public ModelAndView requiredLogin_registerSal(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		// 공통테이블 코드목록 조회
		List<Map<String, String>> codeList = empService.getCodeList();						// 코드목록을 가져온다
		
		if(codeList != null && codeList.size() > 0) {										// 가져온 결과가 존재한다면		
			for(Map<String, String> code : codeList) {										// code의 개수만큼 반복한다	
				List<Map<String, String>> codeDetailList = empService.getcodeDetailList(code); // 세부코드의 목록을 가져온다
				mav.addObject(code.get("CODE_CD"), codeDetailList);							// mav에 key, value형태로 담는다
			}
		}
		
		mav.setViewName("tiles1/registerSal");
		
		return mav;
	} // end of public requiredLogin_registerSal(ModelAndView mav, HttpServletRequest request)-----------

	// 고객판매관리에서 상세버튼 클릭시 해당 정보를 조회(팝업)
	@RequestMapping(value="/searchPrd.dowell")
	public ModelAndView requiredLogin_searchPrd(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		mav.setViewName("tiles1/searchPrd");
		
		return mav;
	} // end of public requiredLogin_searchPrd(ModelAndView mav, HttpServletRequest request)-----------
		
	// 고객판매수금등록에서 상품코드를 검색시 페이지 요청
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/getProductList.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String getProductList(ModelAndView mav, @RequestParam Map<String, Object> map) {
	
		List<Map<String, String>> productList = service.getProductList(map);
		// ##4-3. parameter로 map을 담아 getProductList를 실행한 뒤 결과값을 담는 productList 생성
		
		JSONArray jsonArr = new JSONArray();
		// 결과값을 화면에 출력하기 위해 JSON타입인 jsonArr 생성
		
		if(productList != null && productList.size() > 0) {
			
			for(Map<String, String> product : productList) {
				
				JSONObject jsonObj = new JSONObject();
				for (Map.Entry<String, String> prd : product.entrySet()) {	// 맵에 key와 value를 한 쌍으로 존재하는 만큼 반복
					jsonObj.put(prd.getKey(), prd.getValue());				// key/value로 jsonObj에 넣는다
				}
				jsonObj.put("FROM", map.get("FROM"));						// 대상이 어느것인지 담아준다
				
				jsonArr.put(jsonObj); 
				// Map에서 받아온 값들은 jsonObj에 저장한 뒤, jsonObj를 배열 형태인 jsonArr에 담는다.
				
			}
			
		}
		
		return jsonArr.toString(); // 배열 형태인 jsonArr을 String 형태로 변환하여 return 한다.
	} // end of public String getCustInfoPopUp(ModelAndView mav, @RequestParam Map<String, Object> map)--------------
		
	
	
	// ##1-6. 고객판매관리에서 목록 조회시 페이지 요청(윗부분 판매정보)
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/getSalList.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String getSalList(ModelAndView mav, @RequestParam Map<String, Object> map) {
	
		List<Map<String, String>> salList = service.getSalList(map);		// parameter로 map을 담아 getSalList를 실행한 뒤 결과값을 담는 salList 생성
		
		JSONArray jsonArr = new JSONArray();								// 결과값을 화면에 출력하기 위해 JSON타입인 jsonArr 생성
		
		if(salList != null && salList.size() > 0) {							// 불러온 결과가 비어있지 않고 하나 이상 존재한다면
			
			for(Map<String, String> salMap : salList) {						// 인덱스 안에 포함된 salMap에 대한 반복문 실행(배열의 길이만큼)
			
				JSONObject jsonObj = new JSONObject();						// JSON 객체 생성
				for (Map.Entry<String, String> sal : salMap.entrySet()) {	// 맵에 key와 value를 한 쌍으로 존재하는 만큼 반복
					jsonObj.put(sal.getKey(), sal.getValue());				// key/value로 jsonObj에 넣는다
				}
				
				jsonArr.put(jsonObj);										// Map에서 받아온 값들은 jsonObj에 저장한 뒤, jsonObj를 배열 형태인 jsonArr에 담는다
				
			}
			
		}
		
		return jsonArr.toString(); // 배열 형태인 jsonArr을 String 형태로 변환하여 return 한다
	
	} // end of public String getSalList(ModelAndView mav, @RequestParam Map<String, Object> map)--------------
			
	
	// 고객판매관리에서 목록 조회시 페이지 요청(아랫부분 상품정보)
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/getSalDetailList.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String getSalDetail(ModelAndView mav, @RequestParam Map<String, Object> map) {

		String RTN_YN = service.getReturnYN(map);	// 반품여부를 구해오기
		
		List<Map<String, String>> salDetailList = service.getsalDetailList(map);
		// ##3-5. parameter로 map을 담아 getsalDetailList를 실행한 뒤 결과값을 담는 salDetailList 생성
		
		JSONArray jsonArr = new JSONArray();
		// 결과값을 화면에 출력하기 위해 JSON타입인 jsonArr 생성
		
		if(salDetailList != null && salDetailList.size() > 0) {
			
			for(Map<String, String> salDtMap : salDetailList) {
				
				JSONObject jsonObj = new JSONObject();
				for (Map.Entry<String, String> salDt : salDtMap.entrySet()) {	// 맵에 key와 value를 한 쌍으로 존재하는 만큼 반복
					jsonObj.put(salDt.getKey(), salDt.getValue());				// key/value로 jsonObj에 넣는다
				}
				
				jsonArr.put(jsonObj); 
				// Map에서 받아온 값들은 jsonObj에 저장한 뒤, jsonObj를 배열 형태인 jsonArr에 담는다.
				
			}
			jsonArr.put(RTN_YN);	// 반품여부를 jsonArr 마지막 인덱스에 저장
		}
		
		return jsonArr.toString(); // 배열 형태인 jsonArr을 String 형태로 변환하여 return 한다.
	} // end of public String getSalDetailList(ModelAndView mav, @RequestParam Map<String, Object> map)--------------
	
	
	// ##피드백2. 고객판매수금등록 / 반품
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/insertSal.dowell", method = {RequestMethod.POST}, produces = "application/json")
	public String insertSal(ModelAndView mav, @RequestBody Map<String, Object> map) {
		int result = 0;	// update 성공여부 담는 변수 선언
		
		Map<String, Object> masterMap = (Map<String, Object>) map.get("masterMap");					// 마스터테이블에 insert할 정보를 masterMap에 담는다
		result = service.insertSalMT(masterMap);			// 판매관리 마스터테이블에 insert를 실시한다(상세테이블에 입력할 SAL_NO 채번도 실시)
		
		List<Map<String, Object>> detailList = (List<Map<String, Object>>) map.get("detailList");	// 상세테이블에 insert할 정보를 detailList에 담는다
		
		for (Map<String, Object> detail : detailList) { 	// 리스트 detailList에 있는 Map 요소인 detail에 대한 반복문 실행
			detail.put("SAL_NO", masterMap.get("SAL_NO"));	// 마스터테이블에서 채번한 판매번호를 넣는다
			result = service.insertSalDT(detail); 			// 판매상세 data를 insert(판매 / 반품)
			if(result != 1) { 								// insert가 정상적으로 성공하지 않았다면
				 System.out.println("잘못됐다"); 
				 break; 									// 반복문 탈출
			}
			else {											// insert가 정상적으로 성공하였다면
				if( "SAL".equals( String.valueOf(detail.get("SAL_TP")) ) ){	// 판매구분이 판매라면
					detail.put( "SAL_QTY", Integer.parseInt( String.valueOf(detail.get("SAL_QTY")) ) * -1 );	// 판매수량을 음수로 한다
				}
				result = service.updateIvcoQty(detail);		// 매장현재고를 update한다(판매 / 반품)
			}
		} // end of for (Map<String, Object> detail : detailList) {}-----------------
		
		if( String.valueOf(masterMap.get("RSVG_PNT")) != null && !"0".equals( String.valueOf(masterMap.get("RSVG_PNT")) ) ) { // 적립금액이 있다면
			masterMap.put("PNT", masterMap.get("RSVG_PNT"));				// 포인트금액을 적립포인트로 설정
			masterMap.put("PNT_DS_CD", "100");								// 포인트구분코드를 적립으로 설정
			if( "SAL".equals( String.valueOf(masterMap.get("SAL_TP_CD")) ) ) {	// 판매구분코드가 판매라면
				masterMap.put("PNT_DS_DT_CD", "101");							// 포인트상세구분코드를 구매적립으로 설정
			}
			else {																// 판매구분코드가 반품이라면
				masterMap.put("PNT_DS_DT_CD", "104");							// 포인트상세구분코드를 구매적립취소로 설정
			}
			result = service.insertPNT_D(masterMap);							// 포인트상세테이블에 insert
		}
		
		if( String.valueOf(masterMap.get("US_PNT")) != null && !"0".equals( String.valueOf(masterMap.get("US_PNT")) ) ) { // 사용포인트가 있다면
			masterMap.put("PNT", masterMap.get("US_PNT"));					// 포인트금액을 사용포인트로 설정
			masterMap.put("PNT_DS_CD", "200");								// 포인트구분코드를 사용으로 설정
			if( "SAL".equals( String.valueOf(masterMap.get("SAL_TP_CD")) ) ) {	// 판매구분코드가 판매라면
				masterMap.put("PNT_DS_DT_CD", "201");							// 포인트상세구분코드를 구매사용으로 설정
			}
			else {																// 판매구분코드가 반품이라면
				masterMap.put("PNT_DS_DT_CD", "202");							// 포인트상세구분코드를 구매사용취소로 설정
			}
			result = service.insertPNT_D(masterMap);							// 포인트상세테이블에 insert
		}
		
		result = service.updatePNT_M(masterMap);								// 포인트마스터테이블에 update(순서변경가능)

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("status", masterMap.get("SAL_TP_CD"));						// 판매구분코드를 담는다(성공메시지 출력구분 목적)
		
		
		return jsonObj.toString();
	} // end of public String insertSalDetail(ModelAndView mav, @RequestParam Map<String, Object> map)-----------------------
	
	// ##################### 실시간체크 테스트
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/realTimeCheckProduct.dowell", method = {RequestMethod.POST}, produces = "application/json;charset=UTF-8")
	public String realTimeCheckProduct(ModelAndView mav, @RequestBody Map<String, Object> map) {

		JSONObject jsonObj = new JSONObject();	// 처리상태와 값들을 담아줄 jsonObj 선언
		
		// 고객상태 및 포인트 관련 유효성검사 시작 ===============================
		Map<String, String> ssParam = (Map<String, String>) map.get("custStatus");	// 고객상태를 알아오기 위한 파라미터를 선언
		Map<String, String> status = service.getCUstStatus(ssParam);				// 고객상태를 알아온다
		jsonObj.put("CUST_NO", "CUST_NO");					// jsonObj에 return할 상태를 담는다
		jsonObj.put("CUST_NM", "CUST_NM");					// jsonObj에 return할 상태를 담는다
		
		if( !"10".equals(status.get("CUST_SS_CD")) ) {				// 고객상태가 정상이 아닐 때
			jsonObj.put("status", "CUST_SS_CD");					// jsonObj에 return할 상태를 담는다
			jsonObj.put( "CUST_SS_CD", status.get("CUST_SS_CD"));	// jsonObj에 return할 값을 담는다
			return jsonObj.toString();								// 값을 담은 객체를 return
		}
		else if( Integer.parseInt(ssParam.get("AVB_PNT")) != Integer.parseInt(status.get("AVB_PNT")) ) {	// 가용포인트가 불일치할 때
			jsonObj.put("status", "AVB_PNT");						// jsonObj에 return할 상태를 담는다
			jsonObj.put( "AVB_PNT", status.get("AVB_PNT"));			// jsonObj에 return할 값을 담는다
			return jsonObj.toString();								// 값을 담은 객체를 return
		}
		else if( Integer.parseInt( String.valueOf(ssParam.get("USE_POINT")) ) > Integer.parseInt( String.valueOf(status.get("AVB_PNT")) )  ) {
			// 사용포인트보다 가용포인트가 클 때
			jsonObj.put("status", "USE_POINT");						// jsonObj에 return할 상태를 담는다
			jsonObj.put( "AVB_PNT", status.get("AVB_PNT"));			// jsonObj에 return할 값을 담는다
			return jsonObj.toString();								// 값을 담은 객체를 return
		}
		// 고객상태 및 포인트 관련 유효성검사 끝 ===============================
		
		// 상품 및 결제금액 관련 유효성검사 시작 ===============================
		List<Map<String, String>> prdList = (List<Map<String, String>>) map.get("prdList");	// 상품상태를 알아오기 위한 파라미터를 선언
		Long sum = 0L;
		for(Map<String, String> prd : prdList) {
			Map<String, String> org_prd = service.getPrd(prd);
			int qty = 0;
			int upr = 0;
			if( org_prd != null && !org_prd.isEmpty() ) {				// 상품정보를 읽어왔다면
				jsonObj.put( "ORG_PRD_CD", org_prd.get("PRD_CD"));		// jsonObj에 return할 값을 담는다
				jsonObj.put( "ORG_PRD_NM", org_prd.get("PRD_NM"));		// jsonObj에 return할 값을 담는다
				jsonObj.put( "ROW", prd.get("ROW"));		// jsonObj에 return할 값을 담는다
			}
			
			if( org_prd == null || org_prd.isEmpty() ) {				// 상품정보를 읽어오지 못했다면
				jsonObj.put("status", "PRD_EMPTY");						// jsonObj에 return할 상태를 담는다
				jsonObj.put( "PRD_CD", prd.get("PRD_CD"));				// jsonObj에 return할 값을 담는다
				return jsonObj.toString();								// 값을 담은 객체를 return
			}
			else if( !"10".equals(org_prd.get("PRD_TP_CD")) ) {			// 상품이 본품이 아니라면
				jsonObj.put("status", "PRD_TP_CD");						// jsonObj에 return할 상태를 담는다
				return jsonObj.toString();								// 값을 담은 객체를 return
			}
			else if( !"R".equals(org_prd.get("PRD_SS_CD")) ) {			// 상품상태가 R(런닝)이 아니라면
				jsonObj.put("status", "PRD_SS_CD");						// jsonObj에 return할 상태를 담는다
				return jsonObj.toString();								// 값을 담은 객체를 return
			}
			else if( Integer.parseInt(prd.get("PRD_CSMR_UPR")) != Integer.parseInt(org_prd.get("PRD_CSMR_UPR")) ) { // 소비자가 불일치시
				jsonObj.put("status", "PRD_CSMR_UPR");					// jsonObj에 return할 상태를 담는다
				jsonObj.put( "PRD_CSMR_UPR", org_prd.get("PRD_CSMR_UPR"));	// jsonObj에 return할 값을 담는다
				return jsonObj.toString();								// 값을 담은 객체를 return
			}
			else if( Integer.parseInt( String.valueOf(prd.get("SAL_QTY")) ) > Integer.parseInt( String.valueOf(org_prd.get("IVCO_QTY")) ) ) { 
				// 재고 부족시
				jsonObj.put("status", "IVCO_QTY");						// jsonObj에 return할 상태를 담는다
				jsonObj.put( "IVCO_QTY", org_prd.get("IVCO_QTY"));		// jsonObj에 return할 값을 담는다
				return jsonObj.toString();								// 값을 담은 객체를 return
			}
			else {														// 유효성 검사에 위배되지 않는다면
				qty = Integer.parseInt(String.valueOf(prd.get("SAL_QTY")));				// 입력한 판매수량을 담는다
				upr = Integer.parseInt(String.valueOf(org_prd.get("PRD_CSMR_UPR")));	// DB에서 받아온 소비자가를 담는다
				sum += (qty * upr);										// 수량*소비자가를 합계에 담는다
			}
		} // end of for-----------
		
		if( !String.valueOf(sum).equals( String.valueOf(ssParam.get("TOT_SAL_AMT")) ) ) {	// 총합계금액이 불일치시
			jsonObj.put("status", "SUM");					// jsonObj에 return할 상태를 담는다
			jsonObj.put("SUM", ssParam.get("TOT_SAL_AMT")); // jsonObj에 return할 값을 담는다
			jsonObj.put("ORG_SUM", sum);					// jsonObj에 return할 값을 담는다
			return jsonObj.toString();						// 값을 담은 객체를 return
		}
		else {												// 모든 유효성검사가 위배되지 않는다면
			jsonObj.put("status", "PASS");					// jsonObj에 return할 상태를 담는다
			return jsonObj.toString();						// 값을 담은 객체를 return
		}
		// 상품 및 결제금액 관련 유효성검사 끝 ===============================

	} // end of public String insertSalDetail(ModelAndView mav, @RequestParam Map<String, Object> map)-----------------------
	
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	// === 로그인 또는 로그아웃을 했을 때 현재 보이던 그 페이지로 그대로 돌아가기 위한 메소드 생성 === //
	public void getCurrentURL(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute("goBackURL", MyUtil.getCurrentURL(request));
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////	
	
	
}
