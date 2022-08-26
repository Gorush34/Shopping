package com.spring.shopping.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.shopping.common.AES256;
import com.spring.shopping.model.EmpVO;
import com.spring.shopping.model.InterEmpDAO;

@Service
public class EmpService implements InterEmpService {

	@Autowired
	private InterEmpDAO empDAO;
	
	@Autowired
	private AES256 aes;
	// Type 에 따라 Spring 컨테이너가 알아서 bean 으로 등록된 com.spring.board.common.AES256 의 bean 을  aes 에 주입시켜준다. 
	// 그러므로 aes 는 null 이 아니다.

	// 로그인 요청하기
	@Override
	public EmpVO getLoginMember(Map<String, String> paraMap) {
		
		EmpVO loginuser = empDAO.getLoginMember(paraMap);
		if(loginuser != null && loginuser.getPwdchangegap() >= 3 ) {
			// 마지막으로 암호를 변경한 날짜가 현재시각으로부터 3개월이 지났으면
			loginuser.setRequirePwdChange(true); // 로그인시 암호를 변경하라는 alert를 띄우도록 한다.
		}
		
		return loginuser;
	} // end of public EmpVO getLoginMember(Map<String, String> paraMap)---------------
	
	// 고객조회 목록 가져오기
	@Override
	public List<Map<String, String>> getCustList(Map<String, Object> map) {
		
		return empDAO.getCustList(map);
	}

	// 매장조회 테이블 매장목록 불러오기(팝업)
	@Override
	public List<Map<String, String>> getPrtList(Map<String, Object> map) {
		
		return empDAO.getPrtList(map);
	}

	// 고객조회 테이블 고객목록 불러오기(팝업)
	@Override
	public List<Map<String, String>> getPopUpCustList(Map<String, Object> map) {
		
		return empDAO.getPopUpCustList(map);
	}

	// 매장을 조건으로 검색한 결과의 개수 가져오기
	@Override
	public Map<String, String> getTotalCountPrt(Map<String, Object> map) {
		
		return empDAO.getTotalCountPrt(map);
	}

	// 고객을 조건으로 검색한 결과의 개수 가져오기
	@Override
	public Map<String, String> getTotalCountCust(Map<String, Object> map) {
		
		return empDAO.getTotalCountCust(map);
	}

	// 매장검색 결과가 하나인 것에 대한 정보 가져오기
	@Override
	public Map<String, String> getResultPrt(Map<String, Object> map) {
		
		return empDAO.getResultPrt(map);
	}

	// 고객검색 결과가 하나인 것에 대한 정보 가져오기
	@Override
	public Map<String, String> getResultCust(Map<String, Object> map) {
		
		return empDAO.getResultCust(map);
	}


	
}