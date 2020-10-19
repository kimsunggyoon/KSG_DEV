package com.ksg.test.article.controller;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;
import javax.websocket.server.PathParam;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.ksg.test.article.service.ArticleService;
import com.ksg.test.common.controller.CommonController;
import com.ksg.test.common.domain.CommonVO;
import com.ksg.test.common.service.CommonService;

@Controller
@RequestMapping("/article")
public class ArticleController {
	
	public static final Logger logger = LoggerFactory.getLogger(ArticleController.class);
	
	@Inject
	private ArticleService service;
	
	@Inject
	private CommonService cmService;
	
	@RequestMapping(value="/articleView/{ART_SEQ}",method=RequestMethod.GET)
	public String ArticleView(@PathVariable("ART_SEQ") int ART_SEQ,HttpSession session,Model model) throws Exception {
		logger.info("ArticleView IN");
		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		
		HashMap<String,Object> map = new HashMap();
		map.put("REGISTRANT_ID", vo.getID());
		map.put("ART_SEQ", ART_SEQ);
		
		HashMap<String,Object> artMap = service.getArticle(map);
		map.put("ARTICLE_CD", artMap.get("ARTICLE_CD"));
		
		List<?> fileList = service.getFileList(map);
		
		model.addAttribute("USERINFO",vo);
		model.addAttribute("ARTICLE",artMap); 
		model.addAttribute("FILELIST",fileList); 
		
		logger.info("ArticleView OUT");
		return cmService.getViewPath("/article/articleView");
	}
	
}
