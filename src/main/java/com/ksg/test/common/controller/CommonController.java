package com.ksg.test.common.controller;

import java.util.HashMap;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ksg.test.common.config.Define.LayoutType;
import com.ksg.test.common.domain.CommonVO;
import com.ksg.test.common.dto.CommonDTO;
import com.ksg.test.common.service.CommonService;

@Controller
@RequestMapping("/common")
public class CommonController {
	private static final Logger logger = LoggerFactory.getLogger(CommonController.class);
	public static final String LOGIN = "login";
	
	@Inject
	private CommonService service;
	
	@RequestMapping(value="/login" ,method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String,Object> login_Post(HttpSession session, HttpServletRequest request, Model model, CommonDTO dto) throws Exception{
		HashMap<String,Object> retMap = new HashMap<String,Object>();
		logger.info("login_Post IN ");
		logger.info("login_Post DTO" + dto);
		retMap.put("KEY", "");
		
		CommonVO voLogin = null;
		voLogin = service.login_Post(dto);
		
		if(voLogin == null) {
			retMap.put("USERALERT", "일치한 회원정보가 없습니다. ID나 PW를 확인 ㄱ");
		}else {
			retMap.put("KEY", "OK");
			
		}
		session.setAttribute(LOGIN, voLogin);
		logger.info("login_Post OUT ");

		return retMap;
	}
	
	@RequestMapping(value="/logout",method=RequestMethod.GET)
	public String go_Logout(HttpSession session) throws Exception{
		session.setAttribute(LOGIN, "");
		return service.getViewPath("login");
		
	}
	
}
