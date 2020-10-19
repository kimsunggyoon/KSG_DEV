package com.ksg.test.article.persistence;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class ArticleDAO {

	public static final String namespace = "com.ksg.test.article.articleMapper";
	@Inject
	private SqlSession session;

	public HashMap<String,Object> getArticle(HashMap<String, Object> map) throws Exception{
		return session.selectOne(namespace+".getArticle",map);
	}

	public List<?> getFileList(HashMap<String, Object> map) throws Exception{
		return session.selectList(namespace+".getFileList",map);
	}
}
