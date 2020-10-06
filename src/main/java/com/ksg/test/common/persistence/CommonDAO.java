package com.ksg.test.common.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.ksg.test.common.domain.CommonVO;
import com.ksg.test.common.dto.CommonDTO;

@Repository
public class CommonDAO {

	public static final String namespace = "com.ksg.test.mapper.common.commonMapper";
	
	@Inject
	private SqlSession session;
	
	public CommonVO login_Post(CommonDTO dto) throws Exception {
		return session.selectOne(namespace+".login_Post", dto);
	}

}
