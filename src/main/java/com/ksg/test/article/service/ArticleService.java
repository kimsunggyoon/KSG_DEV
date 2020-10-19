package com.ksg.test.article.service;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.ksg.test.article.controller.ArticleController;
import com.ksg.test.article.persistence.ArticleDAO;

@Service
public class ArticleService {
	
	public static final Logger logger = LoggerFactory.getLogger(ArticleService.class);

	@Inject
	private ArticleDAO dao;

	public HashMap<String,Object> getArticle(HashMap<String, Object> map) throws Exception{
		return dao.getArticle(map);
	}

	public List<?> getFileList(HashMap<String, Object> map) throws Exception{
		return dao.getFileList(map);
	}
	
	
	
}
