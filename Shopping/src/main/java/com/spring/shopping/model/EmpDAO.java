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

	// 고객의 변경이력 불러오기(팝업)
	@Override
	public List<Map<String, String>> getPopUpHistoryList(Map<String, Object> map) {
		
		return sqlsession.selectList("shopping.getPopUpHistoryList", map);
	}

	// 고객의 정보를 조회(팝업)
	@Override
	public Map<String, String> getCustInfoPopUp(Map<String, Object> map) {
		
		return sqlsession.selectOne("shopping.getCustInfoPopUp", map);
	}

	// 고객상태 목록을 불러오기
	@Override
	public List<Map<String, String>> getCustStatusList() {
		
		return sqlsession.selectList("shopping.getCustStatusList");
	}

	// 공통테이블 코드목록 조회
	@Override
	public List<Map<String, String>> getCodeList() {
		
		return sqlsession.selectList("menu.getCodeList");
	}

	// 코드별 세부코드 목록 가져오기
	@Override
	public List<Map<String, String>> getcodeDetailList(Map<String, String> code) {
		
		return sqlsession.selectList("menu.getCodeDetailList", code);
	}

	// 고객정보 조회
	@Override
	public List<Map<String, String>> readCustInfo(String viewCust) {
		
		return sqlsession.selectList("shopping.readCustInfo", viewCust);
	}

	// DB를 통해 비교하여 중복검사를 실행하는 함수
	@Override
	public String compareItem(Map<String, Object> map) {
		
		return sqlsession.selectOne("shopping.compareItem", map);
	}

	// 고객 등록 요청
	@Override
	public int registerCust(Map<String, Object> map) {
		
		return sqlsession.insert("shopping.registerCust", map);
	}

	// 최초등록고객 포인트 테이블 생성
	@Override
	public int insert_TBL_PNT(Map<String, Object> map) {
		
		return sqlsession.insert("shopping.insert_TBL_PNT", map);
	}

	// 고객정보 수정
	@Override
	public int updateCustInfo(Map<String, Object> map) {
		
		return sqlsession.update("shopping.updateCustInfo", map);
	}

	// 변경이력 추가
	@Override
	public int insertHistory(Map<String, Object> paraMap) {
		
		return sqlsession.insert("shopping.insertHistory", paraMap);
	}

	// 포인트 상세테이블에 방금 가입한 회원의 정보를 insert
	@Override
	public int insert_TBL_PNT_D(Map<String, Object> map) {
		
		return sqlsession.insert("shopping.insert_TBL_PNT_D", map);
	}

	// 포인트 마스터테이블에 방금 가입한 회원의 정보를 insert
	@Override
	public int insert_TBL_PNT_M(Map<String, Object> map) {
		
		return sqlsession.insert("shopping.insert_TBL_PNT_M", map);
	}



	

}
