package com.ksg.test.common.service;

import java.math.BigInteger;
import java.security.MessageDigest;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ksg.test.common.config.Define.LayoutType;
import com.ksg.test.common.domain.CommonVO;
import com.ksg.test.common.dto.CommonDTO;
import com.ksg.test.common.persistence.CommonDAO;
import com.sun.org.apache.xml.internal.security.utils.JavaUtils;
import com.sun.xml.internal.ws.util.StringUtils;

@Service
public class CommonService {

	public static final Logger logger = LoggerFactory.getLogger(CommonService.class);
	
	@Inject
	private CommonDAO dao;

	@Transactional
	public CommonVO login_Post(CommonDTO dto) throws Exception{
		logger.info("login_Post IN");
		
		dto.setTXT_PW_SHA(encodeSHA512(dto.getTXT_PW()));
		logger.info("login_post "+ dto.getTXT_PW_SHA());
		
		
		logger.info("login_Post OUT");
		return dao.login_Post(dto);
		
	}
	
	
	public String encodeSHA512(String pswd) {
		MessageDigest md;
		String SHA512_PW = "";
		
		try {
			
			md = MessageDigest.getInstance("SHA-512");
			md.update(pswd.getBytes());
			SHA512_PW = String.format("%0128x", new BigInteger(1,md.digest()));
			
		} catch (Exception e) {
			
			e.getStackTrace();
		}
		return SHA512_PW;
	}
	
	
	public String getViewPath(String path) throws Exception {
		return getViewPath(path, LayoutType.DEFAULT);
	}

	public String getViewPath(String path, LayoutType layout) throws Exception {
		if (path.startsWith("/")) {
			path = path.substring(1);
		}
		if (layout == LayoutType.EMPTY) {
			return "empty/" + path;
		}
		if (layout == LayoutType.BLANK) {
			return "blank/" + path;
		}
		return path;
	}
}
