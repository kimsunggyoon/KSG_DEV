package com.ksg.test.mypage.controller;

import java.util.ArrayList;
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

import com.ksg.test.common.controller.CommonController;
import com.ksg.test.common.domain.CommonVO;
import com.ksg.test.common.service.CommonService;
import com.ksg.test.main.controller.MainController;
import com.ksg.test.mypage.service.MypageService;

@Controller
@RequestMapping("/mypage")
public class MypageController {
	
	public static final Logger logger = LoggerFactory.getLogger(MypageController.class);
	@Inject
	private CommonService cmService;
	
	@Inject
	private MypageService service;
	
	@RequestMapping(value="/mypage",method=RequestMethod.GET)
	public String go_Mypage(HttpSession session , Model model) throws Exception {
		logger.info("go_Mypage IN");
		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		
		HashMap<String,Object> map = new HashMap();
		map.put("REGISTRANT_ID", vo.getID());
		List<?> art_List = service.selectArticle(map);
		
		model.addAttribute("USERINFO",vo);
		model.addAttribute("ART_LIST",art_List);
		logger.info("go_Mypage vo = "+vo);
		
		logger.info("go_Mypage OUT");
		return cmService.getViewPath("/mypage/mypage");
	}
	
	@RequestMapping(value="delete_Article",method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String,Object> delete_Article(HttpSession session,@RequestParam HashMap<String,Object> reqMap,Model model) throws Exception{
		logger.info("delete_Article IN");
		logger.info("delete_Article reqMap"+reqMap);
		
		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		
		HashMap<String,Object> retMap = new HashMap();
		retMap.put("KEY", "");
		
		String art_cd = (String) reqMap.get("ARTICLE_CD");
		String art_cd_arr[] = art_cd.split(",");
		
		
		for (int i = 0; i < art_cd_arr.length; i++) {
			
			HashMap<String,Object> map = new HashMap();
			map.put("ARTICLE_CD",art_cd_arr[i]);
			map.put("REGISTRANT_ID", vo.getID());
			
			try {
				
				int file_result = service.deleteFile(map);
				int art_result = service.deleteArticle(map);
				retMap.put("KEY", "OK");
				
			} catch (Exception e) {
				retMap.put("USERALERT", "삭제 실패");
			}
			
		}
		
		return retMap;
	}
}
