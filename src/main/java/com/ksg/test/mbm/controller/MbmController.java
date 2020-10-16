package com.ksg.test.mbm.controller;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonArrayFormatVisitor;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
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
	public String signUp(Model model) throws Exception{
		return "/mbm/signup";
	}
	@RequestMapping(value="/signup", method=RequestMethod.POST)
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
	
	@RequestMapping(value="/idCheck",method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String,Object> idCheck(HttpSession session,@RequestParam HashMap<String,Object> reqMap,Model model) throws Exception{
		logger.info("idCheck In");
		logger.info("idCheck ID"+reqMap);
		HashMap<String,Object> retMap = new HashMap<String,Object>();
		retMap.put("KEY","");
		
		int count = service.idCheck(reqMap);
		
		if(count > 0) {
			retMap.put("KEY","OK");
		}
		
		return retMap;
	}
	
}
