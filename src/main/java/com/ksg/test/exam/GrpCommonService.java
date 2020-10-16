package com.hts.erpapp.groupware.comm.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hts.erpapp.groupware.comm.persistence.GrpCommonDAO;

/**
* GrpCommonService 클래스입니다.
*
* @author 배찬우
* @since 2018.09.04
* @version 1.0
* <pre>
* 2018.09.04 : 최초 작성
* </pre>
*/

@Service
public class GrpCommonService {
	
	@Inject
	GrpCommonDAO dao;
	
	/**
	* 그룹웨어 공통 메서드
	*
	* @param reqMap JSP에서 넘어온 정보를 포함하는 HashMap 객체
	* @param model 파리미터 및 request 정보를 담고 있는 객체  
	* @return 트랜잭션이 성공일 경우 SUCCESS 를 리턴하고, 실패일 경우 FAILED 를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@Transactional
	public List<?> GET_USER_TREE_S01(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_USER_TREE_S01(reqMap);
	}
	
	/**
	* 그룹웨어 공통 메서드
	*
	* @param reqMap JSP에서 넘어온 정보를 포함하는 HashMap 객체
	* @param model 파리미터 및 request 정보를 담고 있는 객체  
	* @return 트랜잭션이 성공일 경우 SUCCESS 를 리턴하고, 실패일 경우 FAILED 를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@Transactional
	public List<?> GET_USER_TREE_S02(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_USER_TREE_S02(reqMap);
	}
	
	/**
	* 파일 다운로드 조회 메서드
	*
	* @param reqMap JSP에서 넘어온 정보를 포함하는 HashMap 객체
	* @param model 파리미터 및 request 정보를 담고 있는 객체  
	* @return 트랜잭션이 성공일 경우 SUCCESS 를 리턴하고, 실패일 경우 FAILED 를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@Transactional
	public List<?> GET_FILE_DOWN_LIST(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_FILE_DOWN_LIST(reqMap);	//전체
	}
	
	/**
	* 파일 리스트 조회 메서드
	*
	* @param reqMap JSP에서 넘어온 정보를 포함하는 HashMap 객체
	* @param model 파리미터 및 request 정보를 담고 있는 객체  
	* @return 트랜잭션이 성공일 경우 SUCCESS 를 리턴하고, 실패일 경우 FAILED 를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@Transactional
	public List<?> GET_FILE_LIST_ALL(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_FILE_LIST_ALL(reqMap);	//전체
	}
	@Transactional
	public List<?> GET_FILE_LIST_S01(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_FILE_LIST_S01(reqMap);	//전자결재
	}
	@Transactional
	public List<?> GET_FILE_LIST_S02(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_FILE_LIST_S02(reqMap);	//게시판
	}
	@Transactional
	public List<?> GET_FILE_LIST_S03(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_FILE_LIST_S03(reqMap);	//공사
	}
	@Transactional
	public List<?> GET_FILE_LIST_S04(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_FILE_LIST_S04(reqMap);	//기타(일반)
	}
	
	/**
	* 파일명, 파일Path 조회 메서드
	*
	* @param reqMap JSP에서 넘어온 정보를 포함하는 HashMap 객체
	* @param model 파리미터 및 request 정보를 담고 있는 객체  
	* @return 트랜잭션이 성공일 경우 SUCCESS 를 리턴하고, 실패일 경우 FAILED 를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	public List<?> GET_FILE_PATH_NAME_S01(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_FILE_PATH_NAME_S01(reqMap);	//전체
	}
	
	/**
	* 지출결의서 프로젝트 예산 조회 메서드
	*
	* @param reqMap JSP에서 넘어온 정보를 포함하는 HashMap 객체
	* @param model 파리미터 및 request 정보를 담고 있는 객체  
	* @return 트랜잭션이 성공일 경우 SUCCESS 를 리턴하고, 실패일 경우 FAILED 를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@Transactional
	public List<?> GET_EXP_PJT_BUDGET_S01(HashMap<String, Object> reqMap) throws Exception{
		return dao.GET_EXP_PJT_BUDGET_S01(reqMap);	//전체
	}
	
	/**
	 * 그룹웨어 - 사용자ID / 휴대폰번호 조회 쿼리
	 * @param reqMap
	 * @return 
	 * @throws Exception
	 */	
	@Transactional	
	public List<?> selectUserInfo(HashMap<String, Object> reqMap) throws Exception {
		return dao.selectUserInfo(reqMap);
	}
	
	/**
	 * 부서 및 유저 리스트 호출 메서드
	 * @param reqMap
	 * @return 
	 * @throws Exception
	 */
	@Transactional
	public List<?> selectDeptUserList(HashMap<String, Object> reqMap) throws Exception {
		return dao.selectDeptUserList(reqMap);
	}
}