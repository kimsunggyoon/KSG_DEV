package com.ksg.test.main.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.ksg.test.common.controller.CommonController;
import com.ksg.test.common.domain.CommonVO;
import com.ksg.test.common.service.CommonService;
import com.ksg.test.main.service.MainService;

@Controller
@RequestMapping("/main")
public class MainController {
	
	public static final Logger logger = LoggerFactory.getLogger(MainController.class);
	@Inject
	private CommonService cmService;
	
	@Inject
	private MainService service;
	
	@RequestMapping(value="/main",method=RequestMethod.GET)
	public String go_main(HttpSession session , Model model) throws Exception {
		logger.info("go_main IN");
		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		
		HashMap<String,Object> map = new HashMap();
		map.put("REGISTRANT_ID", vo.getID());
		List<?> art_List = service.selectArticle(map);
		
		model.addAttribute("USERINFO",vo);
		model.addAttribute("ART_LIST",art_List);
		logger.info("go_main vo = "+vo);
		
		logger.info("go_main OUT");
		return cmService.getViewPath("/main/main");
	}
	@RequestMapping(value="/fileUpload", method = RequestMethod.POST)
	@ResponseBody
	 public HashMap<String,Object> uploadContent(MultipartHttpServletRequest req,HttpSession session) throws Exception{
		logger.info("uploadContent IN");
		logger.info("uploadContent req"+req.getFileNames());

		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		
		HashMap<String,Object> retMap = new HashMap<String,Object>();
		retMap.put("KEY", "");
		
		String article_cd = req.getParameter("ACTICLE_CD");
		String registrant_id = req.getParameter("REGISTRANT_ID");
		String title = req.getParameter("TITLE");
		String description = req.getParameter("DESCRIPTION");
        
		HashMap<String,Object> map = new HashMap<String,Object>();
		HashMap<String,Object> resMap = new HashMap<String,Object>();
		
		List<MultipartFile> mf = req.getFiles("file[]");
        
		SimpleDateFormat format = new SimpleDateFormat ( "yyyy년MM월dd일HH시mm분ss초");
		Date date = new Date();
		
		for (int i = 0; i < mf.size(); i++) {
			
			String today = format.format(date);
			String originName = i+","+today+vo.getID()+"_"+mf.get(i).getOriginalFilename();
			String FILE_EXTENSION = originName.substring(originName.lastIndexOf(".")+1);
			String FILE_PATH = "E:\\upload";
			String FULL_PATH = FILE_PATH + "\\" + originName;
			FULL_PATH = FULL_PATH.trim();
			
			logger.info("FULL_PATH : "+FULL_PATH);
			
			long FILE_SIZE = mf.get(i).getSize();
			File file = new File(FILE_PATH+"/"+originName);
			try {
				mf.get(i).transferTo(new File(FILE_PATH + "/" + originName)); // 파일 저장

			} catch (Exception e) {
				retMap.put("USERALERT", "파일생성 실패");
				return retMap;
			}
			
			map =  new HashMap<String, Object>();
			map.put("FILE_NM",originName);
			map.put("ARTICLE_CD",article_cd );
			map.put("REGISTRANT_ID", registrant_id);
			map.put("FILE_PATH", FILE_PATH);
			map.put("FULL_PATH", FULL_PATH);
			map.put("FILE_SIZE", FILE_SIZE);
			map.put("FILE_EXTENSION", FILE_EXTENSION);
			map.put("USE_YN", "Y");
			
			resMap = service.uploadContent(map);
			if(!resMap.get("USERALERT").equals("N")) {
				retMap.put("USERALERT", resMap.get("USERALERT"));
				return retMap;
			}
			
			if(!resMap.get("USERALERT").equals("N")) {
				retMap.put("USERALERT",resMap.get("USERALERT"));
				return retMap;
			}
		}
		
		map.put("ARTICLE_CD", article_cd);
		map.put("REGISTRANT_ID", registrant_id);
		map.put("TITLE", title);
		map.put("DESCRIPTION", description);
		
		resMap = service.insertArticle(map);
		
		retMap.put("KEY","OK");
        logger.info("uploadContent OUT");
        return retMap;
	}
	
	@RequestMapping(value="write",method=RequestMethod.GET)
	public String write(HttpSession session ,Model model) throws Exception {
		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		String uuid = UUID.randomUUID().toString();
		model.addAttribute("USERINFO",vo );
		model.addAttribute("UUID",uuid );
		
		return cmService.getViewPath("/article/write");
		
	}
}
