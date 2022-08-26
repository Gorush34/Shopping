package com.spring.shopping.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class EmpDAO implements InterEmpDAO {

	@Autowired
	private SqlSessionTemplate sqlsession;
	// Type 에 따라 Spring 컨테이너가 알아서 root-context.xml 에 생성된 org.mybatis.spring.SqlSessionTemplate 의 bean 을  sqlsession 에 주입시켜준다. 
	// 그러므로 sqlsession 는 null 이 아니다. 이름 맘대로해도됨
	
	// 로그인 요청하기
	@Override
	public EmpVO getLoginMember(Map<String, String> paraMap) {
		EmpVO loginuser = sqlsession.selectOne("shopping.getLoginMember", paraMap);
		return loginuser;
	}

	// 고객조회 목록 가져오기
	@Override
	public List<Map<String, String>> getCustList(Map<String, Object> map) {
		
		return sqlsession.selectList("shopping.getCustList", map);
	}

	// 매장조회 테이블 매장목록 불러오기(팝업)
	@Override
	public List<Map<String, String>> getPrtList(Map<String, Object> map) {
		
		return sqlsession.selectList("shopping.getPrtList", map);
	}

	// 고객조회 테이블 고객목록 불러오기(팝업)
	@Override
	public List<Map<String, String>> getPopUpCustList(Map<String, Object> map) {
		
		return sqlsession.selectList("shopping.getPopUpCustList", map);
	}

	// 매장을 조건으로 검색한 결과의 개수 가져오기
	@Override
	public Map<String, String> getTotalCountPrt(Map<String, Object> map) {

		return sqlsession.selectOne("shopping.getTotalCountPrt", map);
	}

	// 고객을 조건으로 검색한 결과의 개수 가져오기
	@Override
	public Map<String, String> getTotalCountCust(Map<String, Object> map) {

		return sqlsession.selectOne("shopping.getTotalCountCust", map);
	}

	// 매장검색 결과가 하나인 것에 대한 정보 가져오기
	@Override
	public Map<String, String> getResultPrt(Map<String, Object> map) {
		
		return sqlsession.selectOne("shopping.getResultPrt", map);
	}

	// 고객검색 결과가 하나인 것에 대한 정보 가져오기
	@Override
	public Map<String, String> getResultCust(Map<String, Object> map) {
		
		return sqlsession.selectOne("shopping.getResultCust", map);
	}



	

}