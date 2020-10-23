package com.ksg.test.main.dao;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Repository
public class MainDao {
	
	public static final String namespace = "com.ksg.test.mapper.main.mainMapper";
	
	@Inject
	private SqlSession session;

	public int uploadContent(HashMap<String, Object> reqMap) throws Exception{
		return session.insert(namespace+".uploadContent",reqMap);
	}

	public int insertArticle(HashMap<String, Object> reqMap) throws Exception{
		return session.insert(namespace+".insertArticle",reqMap);
	}

	public List<?> selectArticle(HashMap<String, Object> reqMap) throws Exception {
		return session.selectList(namespace+".selectArticle",reqMap);
	}

	
}
