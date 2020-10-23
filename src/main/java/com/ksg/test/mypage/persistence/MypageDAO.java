package com.ksg.test.mypage.persistence;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class MypageDAO {

	public static final String namespace = "com.ksg.test.mapper.mypage.mypageMapper";
	
	@Inject
	private SqlSession session;
	
	
	
	public List<?> selectArticle(HashMap<String, Object> reqMap) throws Exception {
		return session.selectList(namespace+".selectArticle",reqMap);
	}

	public List<?> selectFile(HashMap<String, Object> reqMap) throws Exception {
		return session.selectList(namespace+".selectFile",reqMap);
	}

	public int deleteArticle(HashMap<String, Object> map) throws Exception{
		return session.delete(namespace+".deleteArticle",map);
	}

	public int deleteFile(HashMap<String, Object> map) throws Exception{
		return session.delete(namespace+".deleteFile",map);
	}
	
}
