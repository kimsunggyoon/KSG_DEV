package com.ksg.test.mbm.dao;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MbmDAO {
	public static final String namespace = "com.ksg.test.mapper.mbm.mbmMapper";
	
	@Inject
	private SqlSession session;
	
	public int signUp_POST(HashMap<String, Object> reqMap) throws Exception {
		return session.insert(namespace+".signUp_POST",reqMap);
	}

	public List<HashMap<String,Object>>Select_Mem_Info()throws Exception {
		return session.selectList(namespace+".Select_Mem_Info");
	}

	public int idCheck(HashMap<String, Object> reqMap) {
		return session.selectOne(namespace+".idCheck",reqMap);
	}
	
}
