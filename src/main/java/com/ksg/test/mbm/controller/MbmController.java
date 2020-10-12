package com.ksg.test.mbm.controller;

import java.util.HashMap;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ksg.test.common.service.CommonService;
import com.ksg.test.mbm.service.MbmService;

@Controller
@RequestMapping("/mbm")
public class MbmController {
	
	private static final Logger logger = LoggerFactory.getLogger(MbmController.class);
	
	@Inject
	private CommonService cmService;
	@Inject
	private MbmService service;
	
	@RequestMapping(value="/signup", method=RequestMethod.GET)
	public String signUp() {
		return "/mbm/signup";
	}
	@RequestMapping(value="/signUp_POST", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String,Object> signUp_POST(@RequestParam HashMap<String,Object> reqMap) throws Exception {
		logger.info("signUp_POST IN ");
		logger.info("signUp_POST reqMap : "+reqMap);
		HashMap<String,Object> retMap = new HashMap();
		HashMap<String,Object> resMap = new HashMap();
		retMap.put("KEY", "");

		resMap = service.signUp_POST(reqMap);
		if(!resMap.get("USERALERT").equals("N")) {
			retMap.put("USERALERT",resMap.get("USERALERT"));
		}else {
			retMap.put("KEY", "OK");
		}
		
		logger.debug("signUp_POST OUT ");

		return retMap;

	}
	
}
