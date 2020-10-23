package com.ksg.test.main.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.ksg.test.common.domain.CommonVO;
import com.ksg.test.main.dao.MainDao;

@Service
public class MainService {

	public static final Logger logger = LoggerFactory.getLogger(MainService.class);
	
	@Inject
	private MainDao dao;
	
	
	public HashMap<String,Object> uploadContent(HashMap<String,Object> reqMap) throws Exception {
		logger.info("uploadContent In");
		logger.info("uploadContent req"+reqMap);
		HashMap<String,Object> retMap = new HashMap<String,Object>();
		retMap.put("USERALERT", "N");
		int result = dao.uploadContent(reqMap);
		if(result < 0) {
			retMap.put("USERALERT", "파일 등록 실패");
		}
		return retMap;
	}


	public HashMap<String, Object> insertArticle(HashMap<String, Object> reqMap) throws Exception {
		logger.info("updateArticle In");
		logger.info("updateArticle req"+reqMap);
		
		HashMap<String, Object> retMap = new HashMap<String, Object>();
		
		retMap.put("USERALERT", "N");
		int result = dao.insertArticle(reqMap);
		
		if(result < 0 ) {
			retMap.put("USERALERT", "게시판 등록 실패");
			
		}
		
		return retMap;
	}

	public List<?> selectArticle(HashMap<String,Object> reqMap) throws Exception {
		return dao.selectArticle(reqMap);
	}

}
