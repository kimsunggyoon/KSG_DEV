package com.ksg.test.main.controller;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.ksg.test.common.controller.CommonController;
import com.ksg.test.common.domain.CommonVO;

@Controller
@RequestMapping("/main")
public class MainController {
	
	public static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@RequestMapping(value="/main",method=RequestMethod.GET)
	public String go_main(HttpSession session , Model model) {
		logger.info("go_main IN");
		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		model.addAttribute("USER_ID", vo.getID());
		
		logger.info("go_main vo = "+vo);
		logger.info("go_main OUT");
		return "/main/main";
	}
	
	
}
