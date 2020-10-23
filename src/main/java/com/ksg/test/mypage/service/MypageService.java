package com.ksg.test.mypage.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.ksg.test.main.service.MainService;
import com.ksg.test.mypage.persistence.MypageDAO;

@Service
public class MypageService {

	public static final Logger logger = LoggerFactory.getLogger(MainService.class);
	
	@Inject
	private MypageDAO dao;
	
	public List<?> selectArticle(HashMap<String,Object> reqMap) throws Exception {
		return dao.selectArticle(reqMap);
	}


	public List<?> selectFile(HashMap<String, Object> reqMap) throws Exception{
		return dao.selectFile(reqMap);
	}


	public int deleteArticle(HashMap<String, Object> map) throws Exception{
		
		return dao.deleteArticle(map);
	}


	public int deleteFile(HashMap<String, Object> map) throws Exception{
		return dao.deleteFile(map);
	}
	
	
	
	
}
