package com.spring.shopping.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.spring.shopping.common.MyUtil;
import com.spring.shopping.common.SearchCriteria;
import com.spring.shopping.common.Sha256;
import com.spring.shopping.model.CustVO;
import com.spring.shopping.model.EmpVO;
import com.spring.shopping.model.HistVO;
import com.spring.shopping.service.InterEmpService;

@Controller
public class EmpController {
	
	@Autowired
	private InterEmpService empService;
	
	// 로그인 페이지 요청
	@RequestMapping(value="/login.dowell")
	public ModelAndView login(ModelAndView mav, HttpServletRequest request) {
		
		// getCurrentURL(request); // 로그인 또는 로그아웃을 했을 때 현재 보이던 그 페이지로 그대로 돌아가기 위한 메소드 호출 
		mav.setViewName("tiles1/emp/login");
		// /WEB-INF/views/tiles1/login.jsp 페이지를 만들어야 한다.
		
		return mav;
	} // public ModelAndView login(ModelAndView mav, HttpServletRequest request) ----
	
	
	// 로그인 처리하기  // 
	@RequestMapping(value="/loginEnd.dowell", method= {RequestMethod.POST})
	public ModelAndView loginEnd(ModelAndView mav, HttpServletRequest request) {
		
		String USER_ID = request.getParameter("USER_ID");
		String USE_PWD = request.getParameter("USE_PWD");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("USER_ID", USER_ID);
		paraMap.put("USE_PWD", USE_PWD);
		
		EmpVO loginuser = empService.getLoginMember(paraMap);
		
		if(loginuser == null) { // 로그인 실패시
			String message = "아이디 또는 암호가 틀립니다.";
			String loc = "javascript:history.back()";
			
			mav.addObject("message", message);
			mav.addObject("loc", loc);
		
			mav.setViewName("msg");
			// /WEB-INF/views/msg.jsp
		}
		else { // 아이디와 암호가 존재하는 경우
			
			
			HttpSession session = request.getSession();
			// 메모리에 생성되어져 있는 session 을 불러오는 것이다.
			
			session.setAttribute("loginuser", loginuser);
			// session(세션)에 로그인 되어진 사용자 정보인 loginuser 을 키이름을 "loginuser" 으로 저장시켜두는 것이다.
			
			
			if(loginuser.isRequirePwdChange() == true) { // 암호를 마지막으로 변경한 것이 3개월이 경과한 경우
				String message = "비밀번호를 변경하신지 3개월이 지났습니다.\\n암호를 변경하시기 바랍니다.";
				String loc = request.getContextPath()+"/index.dowell";
				// 원래는 위와 같이 index.action 이 아니라 휴면인 계정을 풀어주는 페이지로 잡아주어야 한다.
				
				mav.addObject("message", message);
				mav.addObject("loc", loc);
			
				mav.setViewName("msg");
			}
			else { // 암호를 마지막으로 변경한 것이 3개월 이내인 경우
				
				// 로그인을 해야만 접근할 수 있는 페이지에 로그인을 하지 않은 상태에서 접근을 시도한 경우 
                // "먼저 로그인을 하세요!!" 라는 메시지를 받고서 사용자가 로그인을 성공했다라면
                // 화면에 보여주는 페이지는 시작페이지로 가는 것이 아니라
                // 조금전 사용자가 시도하였던 로그인을 해야만 접근할 수 있는 페이지로 가기 위한 것이다.
				String goBackURL = (String) session.getAttribute("goBackURL");
				
				if(goBackURL != null) {
					mav.setViewName("redirect:"+goBackURL);
					session.removeAttribute("goBackURL"); // 세션에서 반드시 제거해주어야 한다.
				}
				else {
					mav.setViewName("redirect:/index.dowell"); // 시작페이지로 이동
				}
			} // end of if(loginuser.isRequirePwdChange() == true)-------
			
		}
		
		return mav;
		
	} // end of public ModelAndView loginEnd(ModelAndView mav, HttpServletRequest request)------

	
	// === 로그아웃 처리하기 === //
	@RequestMapping(value="/logout.dowell")
	public ModelAndView requiredLogin_logout(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		// 로그아웃시 현재 보았던 페이지로 돌아가는 것임
		HttpSession session = request.getSession();
		
		String goBackURL = (String) session.getAttribute("goBackURL");
		
		session.invalidate();
		
		String message = "로그아웃 되었습니다.";
		
		String loc = "";
		loc = request.getContextPath()+"/login.dowell";
		/*
		if(goBackURL != null) {
			mav.setViewName("redirect:"+goBackURL);
			session.removeAttribute("goBackURL"); // 세션에서 반드시 제거해주어야 한다.
		}
		else {
			
		}
		*/
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		mav.setViewName("msg");
		
		// 
		
		return mav;
		
	} // end of public ModelAndView logout(ModelAndView mav, HttpServletRequest request)--------------------
	
	// 아이디찾기 페이지 요청
	@RequestMapping(value="/idFind.dowell", method = {RequestMethod.GET})
	public ModelAndView idFind(ModelAndView mav, HttpServletRequest request) {
		
		String method = request.getMethod();
		mav.addObject("method", method);
		
		mav.setViewName("/tiles1/emp/idFind");
		
		return mav;
	} // end of public ModelAndView idFind(ModelAndView mav, HttpServletRequest request) ---------------
	
	
	// 아이디찾기 버튼 클릭시(추후수정)
	/*
	@RequestMapping(value="/idFindEnd.dowell")
	public ModelAndView idFindEnd(ModelAndView mav, HttpServletRequest request) {
		
		String method = request.getMethod();
		mav.addObject("method", method);
		
		String USER_ID = request.getParameter("USER_ID");
		String USER_NM = request.getParameter("USER_NM");	
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("emp_name", emp_name);
		paraMap.put("uq_email", uq_email);
		
		String pk_emp_no = empService.findEmpNo(paraMap);
		
		mav.addObject("pk_emp_no", pk_emp_no);
		mav.setViewName("/tiles1/main/idFind");
		
		
		return mav;
	} 
	*/
	// public ModelAndView idFindEnd(ModelAndView mav, HttpServletRequest request)---------------
	
	// 비밀번호 찾기 페이지 요청
	@RequestMapping(value="/pwdFind.dowell", method = {RequestMethod.GET})
	public ModelAndView pwdFind(ModelAndView mav, HttpServletRequest request) {
		
		String method = request.getMethod();
		mav.addObject("method", method);
		
		mav.setViewName("/tiles1/emp/pwdFind");
		
		return mav;
	} // end of public ModelAndView pwdFind(ModelAndView mav, HttpServletRequest request)----------------
	
	// 비밀번호 찾기 버튼 클릭시(추후수정)
	@RequestMapping(value="/pwdFindEnd.dowell", method = {RequestMethod.POST})
	public ModelAndView pwdFindEnd(ModelAndView mav, HttpServletRequest request) {
		
		return mav;
	} // end of public ModelAndView fwdFindEnd(ModelAndView mav, HttpServletRequest request) {})------------
	
	
	// 비밀번호 찾기 페이지 요청(추후수정)
	@RequestMapping(value="/emp/verifyCertification.dowell", method = {RequestMethod.POST})
	public ModelAndView verifyCertification(ModelAndView mav, HttpServletRequest request) {
		
		String userCertificationCode = request.getParameter("userCertificationCode"); // view단에서 가져온 인증코드
		String pk_emp_no = request.getParameter("pk_emp_no");
		mav.addObject("pk_emp_no", pk_emp_no);
		
		HttpSession session = request.getSession(); // 세션 불러오기
		String certificationCode = (String) session.getAttribute("certificationCode"); // 세션에 저장된 인증코드 가져오기
		
		String message = "";
		String loc = "";
		
		if( certificationCode.equals(userCertificationCode) ) {
			message = "인증이 성공하였습니다.";
			loc = request.getContextPath()+"/pwdUpdate.bts?pk_emp_no="+pk_emp_no;
		}
		else {	
			message = "발급된 인증코드가 아닙니다. 인증코드를 다시 발급받으세요!!";
			loc = request.getContextPath()+"/pwdFind.bts"; 
		}
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		mav.setViewName("msg");
		
		// !!! 중요 !!!
		// !!! 세션에 저장된 인증코드를 삭제하기 !!! //
		session.removeAttribute("certificationCode");
		
		return mav;
	} // end of public ModelAndView pwdFind(ModelAndView mav, HttpServletRequest request)----------------
	
	// 비밀번호 변경(추후수정)
	@RequestMapping(value="/pwdUpdate.dowell")
	public ModelAndView pwdUpdate(ModelAndView mav, HttpServletRequest request) {
		String method = request.getMethod();
		mav.addObject("method", method);
		String USER_ID = request.getParameter("USER_ID");
		mav.addObject("USER_ID", USER_ID);
		
		mav.setViewName("/tiles1/emp/pwdUpdate");
		
		return mav;
	}

	// ============================================= 과제1 시작 =============================================
	
	
	// 고객리스트 페이지 요청
	@RequestMapping(value="/customerList.dowell")
	public ModelAndView requiredLogin_customerList(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, @ModelAttribute("scri") SearchCriteria scri) throws Exception {
		
		List<Map<String, String>> prtCustList = empService.getCustStatusList();	// 고객상태 목록을 불러오기
		
		mav.addObject("prtCustList", prtCustList);
		mav.setViewName("customerList.report1"); // customerList.dowell(tiles : report1 레이아웃 적용된)으로 주소 지정
		
		return mav;
	}
	
	
	// 조건에 맞는 매장 / 고객정보의 개수를 세어오기
	@ResponseBody
	@RequestMapping(value = "/getTotalCount.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String getTotalCount(ModelAndView mav, @RequestParam Map<String, Object> map) {

		
		Map<String, String> totalCount = new HashMap<>();
		if( "true".equals(map.get("from_prt")) ) {					// 매장검색을 실행했다면
			// 매장을 조건으로 검색한 결과의 개수 가져오기
			totalCount = empService.getTotalCountPrt(map);			// map에 담은 조건에 맞는 매장의 개수를 조회한 뒤 totalCount에 담는다
			map.put("CUST_NO", "");									// 고객번호를 공백으로 설정하여 담는다
			map.put("CUST_NM", "");									// 고객명을 공백으로 설정하여 담는다
		}
		else if("true".equals(map.get("from_cust"))) {				// 고객검색을 실행했다면
			// 고객을 조건으로 검색한 결과의 개수 가져오기
			totalCount = empService.getTotalCountCust(map);			// map에 담은 조건에 맞는 고객의 개수를 조회한 뒤 totalCount에 담는다
			map.put("PRT_NM", "");									// 매장코드를 공백으로 설정하여 담는다
			map.put("PRT_CD", "");									// 매장명을 공백으로 설정하여 담는다
		}
		
		
		Map<String, String> result = new HashMap<>();				// 결과가 하나라면 결과에 대한 정보를 담을 Map<String, String> result를 선언
		
		JSONObject jsonObj = new JSONObject();						// JSON형태로 보내기 위한 jsonObj 객체 생성
		
		if( "1".equals(totalCount.get("PRT_CNT")) && "true".equals(map.get("from_prt")) ) {	// totalCount가 1이고, 매장검색이었다면
			
			result = empService.getResultPrt(map);					// 결과가 하나인 것에 대한 정보 가져오기
			jsonObj.put("PRT_NM", result.get("PRT_NM"));			// 매장명을 jsonObj에 담는다
			jsonObj.put("PRT_CD", result.get("PRT_CD"));			// 매장코드를 jsonObj에 담는다
			jsonObj.put("status", "1");								// 결과가 하나인지 아닌지 구분할 수 있는 Key status에 value "1"을 담는다
		}
		else if( "1".equals(totalCount.get("CUST_CNT")) && "true".equals(map.get("from_cust"))  ) {	// totalCount가 1이고, 고객검색이었다면
			
			result = empService.getResultCust(map);					// 결과가 하나인 것에 대한 정보 가져오기
			jsonObj.put("CUST_NO", result.get("CUST_NO"));			// 고객번호를 jsonObj에 담는다
			jsonObj.put("CUST_NM", result.get("CUST_NM"));			// 고객명을 jsonObj에 담는다	
			jsonObj.put("status", "1");								// 결과가 하나인지 아닌지 구분할 수 있는 Key status에 value "1"을 담는다
		}
		
		return jsonObj.toString();									// jsonObj를 화면단으로 return;
		
	} // end of public String getTotalCount(ModelAndView mav, @RequestParam Map<String, Object> map)--------------
	
	@ResponseBody
	@RequestMapping(value = "/readCust.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String readCust(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		List<Map<String, String>> custList = empService.getCustList(map);
		// parameter로 map을 담아 getCustList를 실행한 뒤 결과값을 담는 custList 생성
		
		JSONArray jsonArr = new JSONArray();
		// 결과값을 화면에 출력하기 위해 JSON타입인 jsonArr 생성
		
		if(custList != null && custList.size() > 0) {
			
			for(Map<String, String> custMap : custList) {
				// 반복대상 : custList ( 데이터 타입 : List<Map<String, String>> )
				// 반복할 값의 데이터 타입 : Map<String, String>
				// 반복할 값을 담을 변수명 : custMap
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("CUST_NO", custMap.get("CUST_NO"));
				jsonObj.put("CUST_NM", custMap.get("CUST_NM"));
				jsonObj.put("MBL_NO", custMap.get("MBL_NO"));
				jsonObj.put("CUST_SS_CD", custMap.get("CUST_SS_CD"));
				jsonObj.put("JS_DT", custMap.get("JS_DT"));
				jsonObj.put("PRT_NM", custMap.get("PRT_NM"));
				jsonObj.put("USER_NM", custMap.get("USER_NM"));
				jsonObj.put("LST_UPD_DT", custMap.get("LST_UPD_DT"));
				jsonArr.put(jsonObj); 
				// Map에서 받아온 값들은 jsonObj에 저장한 뒤, jsonObj를 배열 형태인 jsonArr에 담는다.
			}
			
		}
		
		return jsonArr.toString(); // 배열 형태인 jsonArr을 String 형태로 변환하여 return 한다.
	} // end of public String readCust(ModelAndView mav, @RequestParam Map<String, Object> map) {}-------------
	
	
	// 매장조회 테이블 매장목록 불러오기(팝업)
	@ResponseBody
	@RequestMapping(value = "/getPrtList.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String getPrtList(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		List<Map<String, String>> prtList = empService.getPrtList(map);
		// parameter로 map을 담아 getPrtList를 실행한 뒤 결과값을 담는 prtList 생성
		
		JSONArray jsonArr = new JSONArray();
		// 결과값을 화면에 출력하기 위해 JSON타입인 jsonArr 생성
		
		if(prtList != null && prtList.size() > 0) {
			
			for(Map<String, String> prtMap : prtList) {
				// 반복대상 : prtList ( 데이터 타입 : List<Map<String, String>> )
				// 반복할 값의 데이터 타입 : Map<String, String>
				// 반복할 값을 담을 변수명 : prtMap
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("PRT_CD", prtMap.get("PRT_CD"));
				jsonObj.put("PRT_NM", prtMap.get("PRT_NM"));
				jsonObj.put("PRT_SS_CD", prtMap.get("PRT_SS_CD"));
				jsonObj.put("PRT_DT_CD", prtMap.get("PRT_DT_CD"));
				jsonArr.put(jsonObj); 
				// Map에서 받아온 값들은 jsonObj에 저장한 뒤, jsonObj를 배열 형태인 jsonArr에 담는다.
			}
			
		}
		
		return jsonArr.toString(); // 배열 형태인 jsonArr을 String 형태로 변환하여 return 한다.
	} // end of public String getPrtList(ModelAndView mav, @RequestParam Map<String, Object> map)------------------------
	
	
	// 고객조회 테이블 고객목록 불러오기(팝업)
	@ResponseBody
	@RequestMapping(value = "/getPopUpCustList.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String getPopUpCustList(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		List<Map<String, String>> popUpCustList = empService.getPopUpCustList(map);
		// parameter로 map을 담아 getPopUpCustList를 실행한 뒤 결과값을 담는 popUpCustList 생성
		
		JSONArray jsonArr = new JSONArray();
		// 결과값을 화면에 출력하기 위해 JSON타입인 jsonArr 생성
		
		if(popUpCustList != null && popUpCustList.size() > 0) {
			
			for(Map<String, String> custList : popUpCustList) {
				// 반복대상 : custList ( 데이터 타입 : List<Map<String, String>> )
				// 반복할 값의 데이터 타입 : Map<String, String>
				// 반복할 값을 담을 변수명 : custMap
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("CUST_NO", custList.get("CUST_NO"));
				jsonObj.put("CUST_NM", custList.get("CUST_NM"));
				jsonObj.put("MBL_NO", custList.get("MBL_NO"));
				jsonObj.put("CUST_SS_CD", custList.get("CUST_SS_CD"));
				jsonObj.put("AVB_PNT", custList.get("AVB_PNT"));
				jsonArr.put(jsonObj); 
				// Map에서 받아온 값들은 jsonObj에 저장한 뒤, jsonObj를 배열 형태인 jsonArr에 담는다.
			}
			
		}
		
		return jsonArr.toString(); // 배열 형태인 jsonArr을 String 형태로 변환하여 return 한다.
	} // end of public String getPopUpCustList(ModelAndView mav, @RequestParam Map<String, Object> map)------------------------	
	
	
	// 고객조회 페이지에서 고객검색버튼 및 고객명입력시 페이지 요청
	@RequestMapping(value="/search_cust.dowell")
	public ModelAndView requiredLogin_search_cust(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		mav.setViewName("tiles1/search_cust");
		
		return mav;
	} // end of public requiredLogin_search_cust(ModelAndView mav, HttpServletRequest request)-----------
	
	
	// 고객조회 페이지에서 변경이력버튼 클릭시 팝업 요청
	@RequestMapping(value="/change_history.dowell")
	public ModelAndView requiredLogin_changeHistory(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		mav.setViewName("tiles1/change_history");
		
		return mav;
	} // end of public requiredLogin_changeHistory(ModelAndView mav, HttpServletRequest request)-----------
	
	// 고객의 정보를 조회(팝업)
	@ResponseBody
	@RequestMapping(value = "/getCustInfoPopUp.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String getCustInfoPopUp(ModelAndView mav, @RequestParam Map<String, Object> map) {
	
		Map<String, String> custInfo = empService.getCustInfoPopUp(map);		// 고객의 정보를 담을 Map 생성과 동시에 Service 실행
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("CUST_NO", custInfo.get("CUST_NO"));						// 고객번호를 담는다
		jsonObj.put("CUST_NM", custInfo.get("CUST_NM"));						// 고객명을 담는다
		
		return jsonObj.toString();
	} // end of public String getCustInfoPopUp(ModelAndView mav, @RequestParam Map<String, Object> map)--------------
	
	// 고객의 변경이력을 조회 요청(팝업)
	@ResponseBody
	@RequestMapping(value = "/getCustHistoryPopUp.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String getCustHistoryPopUp(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		List<Map<String, String>> popUpHistoryList = empService.getPopUpHistoryList(map);
		// parameter로 map을 담아 getPopUpHistotyList를 실행한 뒤 결과값을 담는 popUpHistoryList 생성
		
		JSONArray jsonArr = new JSONArray();
		// 결과값을 화면에 출력하기 위해 JSON타입인 jsonArr 생성
		
		if(popUpHistoryList != null && popUpHistoryList.size() > 0) {
			
			for(Map<String, String> hisList : popUpHistoryList) {
				// 반복대상 : popUpHistoryList ( 데이터 타입 : List<Map<String, String>> )
				// 반복할 값의 데이터 타입 : Map<String, String>
				// 반복할 값을 담을 변수명 : hisList
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("CHG_DT", hisList.get("CHG_DT"));
				jsonObj.put("CHG_CD", hisList.get("CHG_CD"));
				jsonObj.put("CHG_BF_CNT", hisList.get("CHG_BF_CNT"));
				jsonObj.put("CHG_AFT_CNT", hisList.get("CHG_AFT_CNT"));
				jsonObj.put("LST_UPD_ID", hisList.get("LST_UPD_ID"));
				jsonObj.put("LST_UPD_DT", hisList.get("LST_UPD_DT"));
				jsonArr.put(jsonObj); 
				// Map에서 받아온 값들은 jsonObj에 저장한 뒤, jsonObj를 배열 형태인 jsonArr에 담는다.
			}
			
		}
		
		return jsonArr.toString(); // 배열 형태인 jsonArr을 String 형태로 변환하여 return 한다.
	} // end of public String getCustHistoryPopUp(ModelAndView mav, @RequestParam Map<String, Object> map)------------------------	
	
	
	/* ================================ 과제2 시작 ================================== */
	
	// 고객정보조회 페이지 요청
	@RequestMapping(value="/viewCustomer.dowell")
	public ModelAndView requiredLogin_viewCustomer(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		String viewCust = request.getParameter("viewCust");									// form 안에 있는 데이터(고객번호)를 가져온다
		if(viewCust == null) {																// 고객번호가 비었다면
			viewCust = "";																	// 공란처리
		}
		else if(viewCust != null) {															// 고객번호가 비어있지 않다면
			List<Map<String, String>> custInfo = empService.readCustInfo(viewCust);							// 고객번호를 parameter로 고객정보를 조회
			if(custInfo != null) {															// 조회된 결과가 비어있지 않다면
				mav.addObject("custInfo", custInfo);										// mav에 담는다
			}
		}
		
		// 공통테이블 코드목록 조회
		List<Map<String, String>> codeList = empService.getCodeList();						// 코드목록을 가져온다
		
		if(codeList != null && codeList.size() > 0) {										// 가져온 결과가 존재한다면		
			for(Map<String, String> code : codeList) {										// code의 개수만큼 반복한다	
				List<Map<String, String>> codeDetailList = empService.getcodeDetailList(code); // 세부코드의 목록을 가져온다
				mav.addObject(code.get("CODE_CD"), codeDetailList);							// mav에 key, value형태로 담는다
			}
		}
		
		mav.setViewName("viewCustomer.report1"); // viewCustomer.dowell(tiles : report1 레이아웃 적용된)으로 주소 지정
		
		return mav;
	} // end of public ModelAndView requiredLogin_viewCustomer(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {}-----
	
	// 고객정보조회 페이지 요청
	@RequestMapping(value="/register_cust.dowell")
	public ModelAndView requiredLogin_register_cust(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		// 공통테이블 코드목록 조회
		List<Map<String, String>> codeList = empService.getCodeList();						// 코드목록을 가져온다
		
		if(codeList != null && codeList.size() > 0) {										// 가져온 결과가 존재한다면		
			for(Map<String, String> code : codeList) {										// code의 개수만큼 반복한다	
				List<Map<String, String>> codeDetailList = empService.getcodeDetailList(code); // 세부코드의 목록을 가져온다
				mav.addObject(code.get("CODE_CD"), codeDetailList);							// mav에 key, value형태로 담는다
			}
		}
		
		mav.setViewName("tiles1/register_cust");
		
		return mav;
	} // end of public requiredLogin_search_cust(ModelAndView mav, HttpServletRequest request)-----------
	
	// DB를 통해 비교하여 중복검사를 실행하는 함수
	@ResponseBody
	@RequestMapping(value = "/compareItem.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String compareItem(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		String result = empService.compareItem(map);		// DB에 중복된 값이 존재하는지 확인
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);						// 결과를 담는다
		
		return jsonObj.toString();
	} // end of public String compareItem(ModelAndView mav, @RequestParam Map<String, Object> map)------------------------	
		
	// DB를 통해 비교하여 중복검사를 실행하는 함수
	@ResponseBody
	@RequestMapping(value = "/registerCustSubmit.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String registerCustSubmit(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		int result = empService.registerCust(map);		// DB에 중복된 값이 존재하는지 확인
		
		if(result == 1) {
		int pnt = empService.insert_TBL_PNT_D(map);	// 포인트 상세테이블에 방금 가입한 회원의 정보를 insert
			if(pnt == 1) {
				pnt = empService.insert_TBL_PNT_M(map);	// 포인트 상세테이블 정보를 기반으로 마스터테이블에 방금 가입한 회원의 정보를 insert
				// int pnt = empService.insert_TBL_PNT(map); // 고장날시 단순하게 한 번에 insert하는 서비스
			}
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);						// 결과를 담는다
			
		return jsonObj.toString();
	} // end of public String compareItem(ModelAndView mav, @RequestParam Map<String, Object> map)------------------------	
		
	
	
	// 고객정보조회 페이지에서 고객정보를 조회
	@ResponseBody
	@RequestMapping(value = "/readCustInfo.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String readCustInfo(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		String viewCust = (String) map.get("viewCust");
		
		List<Map<String, String>> custInfo = empService.readCustInfo(viewCust);		// 고객 정보를 List에 담는다
		
		JSONObject jsonObj = new JSONObject();										// ajax 통신을 위한 jsonObj 선언
		
		for(Map<String, String> info : custInfo) {									// List에 담긴 map 각각에 대한 반복문 실행
			for(String key : info.keySet()) {										// map에 담긴 key의 이름을 가져오는 반복문 실행
				jsonObj.put(key, info.get(key));									// jsonObj에 key / value 형태로 넣는다.
			}
		}

		return jsonObj.toString();
	} // end of public String registerCustSubmit(ModelAndView mav, @RequestParam Map<String, Object> map)------------------------	
	
	// 고객정보 수정
	@ResponseBody
	@RequestMapping(value = "/updateCustInfo.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String updateCustInfo(ModelAndView mav, @RequestParam Map<String, Object> map) {
		
		int result = empService.updateCustInfo(map);		// 고객 정보를 update한다
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);						// 결과를 담는다

		return jsonObj.toString();
	} // end of public String registerCustSubmit(ModelAndView mav, @RequestParam Map<String, Object> map)------------------------	
	
	
	// 변경이력 삽입
	@ResponseBody
	@RequestMapping(value = "/insertHistory.dowell", method = {RequestMethod.POST}, produces="text/plain;charset=UTF-8")
	public String insertHistory(ModelAndView mav, String data) {
		
		int result = 0;	// update 성공여부 담는 변수 선언
		
		try {
		    List<Map<String, Object>> info = new Gson().fromJson(String.valueOf(data),	// view에서 보낸 data를 List<Map<String, Object>> 타입으로 받는다
		            new TypeToken<List<Map<String, Object>>>(){}.getType());
	
		    for (Map<String, Object> history : info) {					// 리스트 info에 있는 Map 요소인 history 에 대해 반복문 실행
		        // System.out.println(history.get("CUST_NO") + " : " + history.get("CHG_CD")+ " : " + history.get("CHG_BF_CNT")+ " : " + history.get("CHG_AFT_CNT")+ " : " + history.get("UPD_ID"));
				result = empService.insertHistory(history);				// 변경이력을 insert
		    	if(result != 1) {
		    		System.out.println("잘못됐다");
		    		break;
		    	}
		    }  
		} catch (Exception e) {
			
		}

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", String.valueOf(result));						// 결과를 담는다
		
		return jsonObj.toString();
	} // end of public String registerCustSubmit(ModelAndView mav, @RequestParam Map<String, Object> map)------------------------
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	// === 로그인 또는 로그아웃을 했을 때 현재 보이던 그 페이지로 그대로 돌아가기 위한 메소드 생성 === //
	public void getCurrentURL(HttpServletRequest request) {
	HttpSession session = request.getSession();
	session.setAttribute("goBackURL", MyUtil.getCurrentURL(request));
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	
}
