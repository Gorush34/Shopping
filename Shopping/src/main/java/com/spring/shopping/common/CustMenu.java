package com.spring.shopping.common;

import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;

public class CustMenu {
	
	@Autowired
	private SqlSessionTemplate sqlsession;
	
	public ModelAndView getCustMenu(ModelAndView mav) {
		
		List<Map<String, String>> codeList = sqlsession.selectList("menu.getCode"); 	// CODE_MT에 있는 코드목록을 가져온다.
		if(codeList != null && codeList.size() > 0) {									// 가져온 결과가 존재한다면	
			for(Map<String, String> code : codeList) {									// code의 개수만큼 반복한다	
				List<Map<String, String>> codeDetailList = sqlsession.selectList("menu.getCodeDetailList", code); // 세부코드의 목록을 가져온다
				mav.addObject(code.get("CODE_CD"), codeDetailList);						// mav에 key, value형태로 담는다
			}
		}
		
		return mav;
	}
}
