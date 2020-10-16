package com.ksg.test.mbm.service;

import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ksg.test.common.service.CommonService;
import com.ksg.test.mbm.controller.MbmController;
import com.ksg.test.mbm.dao.MbmDAO;

@Service
public class MbmService {
	
	
	private static final Logger logger = LoggerFactory.getLogger(MbmController.class);

	@Inject
	private CommonService cmService;
	
	@Inject
	private MbmDAO dao;

	/**
	 *	회원가입 
	 */
	public HashMap<String,Object> signUp_POST(HashMap<String, Object> reqMap) throws Exception {
		logger.info("signUp_POST IN ");
		logger.info("signUp_POST reqMap : "+reqMap);
		
		HashMap<String,Object> retMap = new HashMap();
		retMap.put("USERALERT","N");
		
		String email = "";
		
		if(reqMap.get("FRONT_EMAIL")==null) {
			email = "";
		}else {
			email = reqMap.get("FRONT_EMAIL")+"@"+reqMap.get("END_EMAIL");
		}
		
		reqMap.put("EMAIL", email);
		reqMap.put("TXT_PW_SHA", cmService.encodeSHA512((String) reqMap.get("PW")));
		String uuid = UUID.randomUUID().toString();
		reqMap.put("MEM_CD", uuid);
		logger.info("추가된 reqMap : "+reqMap);
		try {
			
			if(dao.signUp_POST(reqMap) < 0 ) {
				
				retMap.put("USERALERT","들어간거 없음");
			}
		} catch (Exception e) {
			e.getStackTrace();
			retMap.put("USERALERT","회원가입 실패");
		}
		logger.debug("signUp_POST OUT ");

		return retMap;
	}
	/**
	 *	회원정보 가져오기 
	 */
	public List<HashMap<String,Object>> Select_Mem_Info() throws Exception{
		logger.debug("Select_Mem_Info IN");
		List<HashMap<String,Object>> retList = dao.Select_Mem_Info();
		logger.debug("Select_Mem_Info IretList : "+retList);
		
		return retList;
		
	}
	public int idCheck(HashMap<String, Object> reqMap) throws Exception{
		return dao.idCheck(reqMap);
	}
}
