package com.ksg.test.mbm.service;

import java.util.HashMap;
import java.util.List;

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
	 *	ȸ������ 
	 */
	public HashMap<String,Object> signUp_POST(HashMap<String, Object> reqMap) throws Exception {
		logger.debug("signUp_POST IN ");
		logger.debug("signUp_POST reqMap : "+reqMap);
		
		HashMap<String,Object> retMap = new HashMap();
		retMap.put("USERALERT","N");
		reqMap.put("TXT_PW_SHA", cmService.encodeSHA512((String) reqMap.get("PW")));
		
		try {
			
			if(dao.signUp_POST(reqMap) < 0 ) {
				
				retMap.put("USERALERT","���� ����");
			}
		} catch (Exception e) {
			retMap.put("USERALERT","ȸ������ ����");
		}
		logger.debug("signUp_POST OUT ");

		return retMap;
	}
	/**
	 *	ȸ������ �������� 
	 */
	public List<?> Select_Mem_Info() throws Exception{
		logger.debug("Select_Mem_Info IN");
		List<?> retList = dao.Select_Mem_Info();
		logger.debug("Select_Mem_Info IretList : "+retList);
		
		return retList;
		
	}
}