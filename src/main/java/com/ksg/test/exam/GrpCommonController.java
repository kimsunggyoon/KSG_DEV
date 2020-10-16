package com.hts.erpapp.groupware.comm.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.activation.MimetypesFileTypeMap;
import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
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
import org.springframework.web.servlet.ModelAndView;

import com.hts.erpapp.common.controller.CommonController;
import com.hts.erpapp.common.domain.CommonVO;
import com.hts.erpapp.common.service.CommonService;
import com.hts.erpapp.groupware.board.service.BoardService;
import com.hts.erpapp.groupware.comm.service.GrpApprovalService;
import com.hts.erpapp.groupware.comm.service.GrpCommonService;

/**
* GrpCommonController 공콩 처리 Controller 클래스입니다.
*
* @author 배찬우
* @since 2018.09.04
* @version 1.0
* <pre>
* 2018.09.04 : 최초 작성
* </pre>
*/
@Controller
@RequestMapping("/groupware/comm")
public class GrpCommonController {
	
	public static final Logger logger = LoggerFactory.getLogger(GrpCommonController.class);
	
	@Inject
	GrpCommonService GrpCommonService;
	
	@Inject
	GrpApprovalService GrpApprovalService;
	
	@Inject
	BoardService BoardService;
	
	@Inject
	CommonController commonController;
	
	@Inject
	CommonService commonService;
	
	@Resource(name = "Upload_Path")
	private String Upload_Path;
	
	/**
	* 유저선택 트리구조 호출 메서드
	*
	* @param 없음
	* @return 공통코드 화면을 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/grpUserTreeSel", method = RequestMethod.GET)
	@SuppressWarnings (value="unchecked")
	public ModelAndView grpUserTreeSel(Model model, HttpServletRequest request, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		logger.info("grpUserTreeSel in");
		logger.info("grpUserTreeSel reqMap : " + reqMap);
		
		// PopupValue Setting
		JSONObject PvjsonObject = new JSONObject();
		for (String key : reqMap.keySet()) {
			if ( StringUtils.startsWith( key, "P_") && StringUtils.isNotBlank( (String) reqMap.get( key))) {
				PvjsonObject.put( key, (String) reqMap.get( key));
			}
		 }
		
        model.addAttribute("OBJ_PARAM", PvjsonObject);
		model.addAttribute("BTN_JSON", commonController.GET_AUTH_MENU_BTN_JSON(reqMap));
		
		logger.info("grpUserTreeSel out");
		return mv;
	}
	
	/**
	* 유저선택 트리구조 호출 메서드
	*
	* @param 없음
	* @return 공통코드 화면을 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/grpUpFileSel", method = RequestMethod.GET)
	@SuppressWarnings (value="unchecked")
	public ModelAndView grpUpFileSel(Model model, HttpServletRequest request, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		logger.info("grpUpFileSel in");
		logger.info("grpUpFileSel reqMap : " + reqMap);
		
		// PopupValue Setting
		JSONObject PvjsonObject = new JSONObject();
		for (String key : reqMap.keySet()) {
			if ( StringUtils.startsWith( key, "P_") && StringUtils.isNotBlank( (String) reqMap.get( key))) {
				PvjsonObject.put( key, (String) reqMap.get( key));
			}
		}
		
		JSONObject jsonObject = new JSONObject();
        //첨부파일 업무구분
		HashMap<String,Object> map = new HashMap<String,Object>();	
		map.put("GRP_CD", "GRP036");
		map.put("ORDER_COND","CD_SORT");
		List<?> BIZ_TYPE = commonService.CODE_MST_LIST(map);
		jsonObject.put("BIZ_TYPE", BIZ_TYPE);
		
        model.addAttribute("COMM_CODE", jsonObject);
        model.addAttribute("OBJ_PARAM", PvjsonObject);
		model.addAttribute("BTN_JSON", commonController.GET_AUTH_MENU_BTN_JSON(reqMap));
		
		logger.info("grpUpFileSel out");
		return mv;
	}
	
	/**
	* 지출결의서(프로젝트) 예산 선택 팝업 호출 메서드
	*
	* @param 없음
	* @return 공통코드 화면을 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/grpExpPjtSel", method = RequestMethod.GET)
	@SuppressWarnings (value="unchecked")
	public ModelAndView grpExpPjtSel(Model model, HttpServletRequest request, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		logger.info("grpExpPjtSel in");
		logger.info("grpExpPjtSel reqMap : " + reqMap);

		//model.addAttribute("BTN_JSON", commonController.GET_AUTH_MENU_BTN_JSON(reqMap));
		
		logger.info("grpExpPjtSel out");
		return mv;
	}
	
	/**
	* 유저 트리(templete) 조회 메서드
	*
	* @param model 파리미터 및 request 정보를 담고 있는 객체 
	* @return 결재선 조회결과를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/getUserTree", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> getUserTreeSel(Model model, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		logger.info("getUserTreeSel in");
		logger.info("getUserTreeSel reqMap : " + reqMap);

		HashMap<String, Object> returnMap = new HashMap<String, Object>();
				
		List<?> returnList = GrpCommonService.GET_USER_TREE_S01(reqMap);
		returnMap.put("ds_UserTree", returnList);
		returnMap.put("RESULT", "OK");
		
		logger.info("getUserTreeSel out");
		return returnMap;
	}
	
	/**
	* 유저 트리(templete) 조회 메서드
	*
	* @param model 파리미터 및 request 정보를 담고 있는 객체 
	* @return 결재선 조회결과를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/getUserTree_Auth", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> getUserTreeSel_Auth(Model model, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		logger.info("getUserTreeSel in");
		logger.info("getUserTreeSel reqMap : " + reqMap);

		HashMap<String, Object> returnMap = new HashMap<String, Object>();
				
		List<?> returnList = GrpCommonService.GET_USER_TREE_S02(reqMap);
		returnMap.put("ds_UserTree", returnList);
		returnMap.put("RESULT", "OK");
		
		logger.info("getUserTreeSel out");
		return returnMap;
	}
	
	/**
	* 파일리스트 조회 메서드
	*
	* @param model 파리미터 및 request 정보를 담고 있는 객체 
	* @return 결재선 조회결과를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/getFileList", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> getFileList(HttpSession session, Model model, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		logger.info("getUserTreeSel in");
		logger.info("getUserTreeSel reqMap : " + reqMap);
		
		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		reqMap.put("USER_ID", vo.getUSER_ID());
		reqMap.put("DPT_CD", vo.getDPT_CD());

		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		List<?> returnList = null ;
		String bizType = (String) reqMap.get("BIZ_TYPE");
		if (bizType == null || "".equals(bizType)) {	//전체
			returnList = GrpCommonService.GET_FILE_LIST_ALL(reqMap);
		} else if ("RQST".equals(bizType)) {			//전자결재
			returnList = GrpCommonService.GET_FILE_LIST_S01(reqMap);
		} else if ("BOARD".equals(bizType)) {			//게시판
			returnList = GrpCommonService.GET_FILE_LIST_S02(reqMap);
		} else if ("CON".equals(bizType)) {				//공사
			returnList = GrpCommonService.GET_FILE_LIST_S03(reqMap);
		}
		
		returnMap.put("ds_FileList", returnList);
		returnMap.put("RESULT", "OK");
		
		logger.info("getFileList out");
		return returnMap;
	}
	
	/**
	* 파일리스트 조회 메서드
	*
	* @param model 파리미터 및 request 정보를 담고 있는 객체 
	* @return 결재선 조회결과를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/FileUpload", method = RequestMethod.POST)
	@SuppressWarnings (value="unchecked")
	@ResponseBody
	public HashMap<String, Object> FileUpload(HttpSession session, Model model, MultipartHttpServletRequest mFile) throws Exception{
		logger.info("FileUpload in");
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("UPLOAD_BIZ_TYPE", mFile.getParameter("upload_biztype"));
		List<?> fileinfo = GrpCommonService.GET_FILE_PATH_NAME_S01(map);
		
		HashMap<String, Object> fileinfomap = (HashMap<String, Object>) fileinfo.get(0);
		//String root = mFile.getSession().getServletContext().getRealPath("/");
		//String storagepath =  "/resources/storage";
		String root = Upload_Path;
		String filepath = (String) fileinfomap.get("FILE_PATH");
		
		SimpleDateFormat Fym = new SimpleDateFormat("yyyyMM");
		SimpleDateFormat Fymd = new SimpleDateFormat("yyyyMMdd");
		Date dt = new Date();
		String ym = Fym.format(dt);
		String ymd = Fymd.format(dt);
		String filepathDtl = "/"+ym+"/"+ymd;
		
		String filename = (String) fileinfomap.get("FILE_SERVER_NAME");
		
		String paths[] = (root+filepath+filepathDtl).split("/");
		String path = "";
		for(int i=0; i<paths.length; i++){
			path += paths[i]+"/";
		
			File dirPath = new File(path);
			if(! dirPath.exists() ){
				dirPath.mkdir();
			}
		}
		
		List<MultipartFile> mf = mFile.getFiles("file[]");
		String[] mp = mFile.getParameterValues("keyVal[]");
		List<Object> returnkeyValList = new ArrayList<Object>();
		
		for (int i = 0; i < mf.size(); i++) {
			// 본래 파일명
			String originalfileName = mf.get(i).getOriginalFilename();
			String fileExtension = originalfileName.substring(originalfileName.lastIndexOf(".")+1);
			String RealFilePath = root+filepath+filepathDtl;
			String RealFileName = filename + "_" + (i+1) + "." + fileExtension;
			//long fileSize = mf.get(i).getSize(); // 파일 사이즈
			
			mf.get(i).transferTo(new File(RealFilePath + "/" + RealFileName)); // 파일 저장
			
			HashMap<String, Object> datamap =  new HashMap<String, Object>();
			datamap.put("keyVal", mp[i]);
			datamap.put("FILE_PATH", RealFilePath);
			datamap.put("FILE_ORIGINAL_NAME", originalfileName);
			datamap.put("FILE_SERVER_NAME", RealFileName);
			datamap.put("FILE_EXT_NAME", fileExtension);
			returnkeyValList.add(datamap);
		}
		
		returnMap.put("ds_keyVal", returnkeyValList);
		returnMap.put("RESULT", "OK");
		
		logger.info("FileUpload out");
		return returnMap;
	}
	
	/**
	* 첨부 파일 다운로드
	*
	* @param 없음
	* @return 기준정보를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/FileDownload", method = RequestMethod.POST)
	@SuppressWarnings (value="unchecked")
	@ResponseBody
	public void FileDownload(HttpSession session, @RequestParam HashMap<String, Object> reqMap, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.info("FileDownload reqMap : " + reqMap);
		
		List<?> returnList = null ;
		
		String fileName = ""; 
		String filePath = "";
		String fileOriginalName = "";
		
		returnList = GrpCommonService.GET_FILE_DOWN_LIST(reqMap);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map =  (HashMap<String, Object>) returnList.get(0);
		
		filePath = (String) map.get("FILE_PATH");
		fileName = (String) map.get("FILE_SERVER_NAME");
		fileOriginalName = (String) map.get("FILE_ORIGINAL_NAME");
		
		/*
		String bizType = (String) reqMap.get("BIZ_TYPE");
		if ("RQST".equals(bizType)) {			//전자결재
			returnList = GrpApprovalService.GRP_RQST_FILE_ATTACH_S01(reqMap);
			map =  (HashMap<String, Object>) returnList.get(0);
			filePath = (String) map.get("FILE_PATH");
			fileName = (String) map.get("FILE_SERVER_NAME");
			fileOriginalName = (String) map.get("FILE_ORIGINAL_NAME");
		} else if ("BOARD".equals(bizType)) {			//게시판
			returnList = BoardService.GRP_BOARD_FILE_ATTACH_S01(reqMap);
			map =  (HashMap<String, Object>) returnList.get(0);
			filePath = (String) map.get("FILE_PATH");
			fileName = (String) map.get("FILE_SERVER_NAME");
			fileOriginalName = (String) map.get("FILE_ORIGINAL_NAME");
		}
		*/
		
		String userAgent = request.getHeader("User-Agent");
		String encodedFilename = "";
        
        if (userAgent.indexOf("MSIE") > -1) {
        	encodedFilename = URLEncoder.encode(fileOriginalName, "UTF-8").replaceAll("\\+", "%20");
        } else if (userAgent.indexOf("Chrome") > -1 || userAgent.equals("Chrome")) {
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < fileOriginalName.length(); i++) {
                   char c = fileOriginalName.charAt(i);
                   if (c > '~') {
                         sb.append(URLEncoder.encode("" + c, "UTF-8"));
                   } else {
                         sb.append(c);
                   }
            }
            encodedFilename = sb.toString();
        } else {
        	encodedFilename = new String(fileOriginalName.getBytes("UTF-8"), "ISO-8859-1");
        }
		
		if(!fileName.trim().equals("")){
			try {
				fileName = URLDecoder.decode(fileName, "UTF-8");
				byte fileByte[] = FileUtils.readFileToByteArray(new File(filePath+"/"+fileName));

				// gets MIME type of the file
		        String mimeType = new MimetypesFileTypeMap().getContentType(new File(filePath+"/"+fileName)) ; 
		        if (mimeType == null) {         
		            // set to binary type if MIME mapping not found
		            mimeType = "application/octet-stream";
		        }
		        
		        
		        
			    response.setContentType(mimeType);
			    response.setContentLength(fileByte.length);
			    response.setHeader("Content-Disposition", "attachment; fileName=\"" + encodedFilename +"\";");
			    response.setHeader("Content-Transfer-Encoding", "binary");
			    response.setHeader("Cache-Control", "private;"); 
			    response.getOutputStream().write(fileByte);
			    response.getOutputStream().flush();
			    response.getOutputStream().close();
			} catch (FileNotFoundException e) {
				PrintWriter out = response.getWriter();
				out.write(makeFileNotFoundPage(request));
			}
		} else {
			PrintWriter out = response.getWriter();
			out.write(makeFileNotFoundPage(request));
			
			//파일 없을 경우 이전페이지 redirect
			//response.sendRedirect(request.getHeader("referer"));
		}
		logger.info("FileDownload out");
	}
	
	public String makeFileNotFoundPage (HttpServletRequest q) throws Exception {
		StringBuffer strHtml = new StringBuffer();
		strHtml.append("<!doctype html>												");
		strHtml.append("<html>														");
		strHtml.append("<head>														");
		strHtml.append("	<meta charset=\"UTF-8\">								");
		strHtml.append("	<title>File Not Found</title>							");
		strHtml.append("	<script type=\"text/javascript\">						");
		strHtml.append("		var cnt = 5;										");
		strHtml.append("		function countdown() {								");
		strHtml.append("			if(cnt == 0){									");
		strHtml.append("				sendRedirect();								");
		strHtml.append("			} else {										");
		strHtml.append("				document.all.TextDiv.innerHTML = \"Redirect after \"  + cnt + \" seconds.\";");
		strHtml.append("				setTimeout(\"countdown()\", 1000);			");
		strHtml.append("				cnt--;										");
		strHtml.append("			}												");
		strHtml.append("		}													");
		strHtml.append("		function sendRedirect() {							");
		strHtml.append("			window.location.href = \""+ q.getHeader("referer") +"\"; ");
		strHtml.append("		}													");
		strHtml.append("	</script>												");
		strHtml.append("</head>														");
		strHtml.append("<body>														");
		strHtml.append("	<h1>File Not Found</h1>									");
		strHtml.append("	<div id=\"TextDiv\"></div>								");
		strHtml.append("	<script>countdown();</script>							");
		strHtml.append("</body>														");
		strHtml.append("</html>														");
		return strHtml.toString();
	}
	
	/**
	* 파일리스트 조회 메서드
	*
	* @param model 파리미터 및 request 정보를 담고 있는 객체 
	* @return 결재선 조회결과를 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/getExpPjtSel", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> getExpPjtSel(HttpSession session, Model model, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		logger.info("getExpPjtSel in");
		logger.info("getExpPjtSel reqMap : " + reqMap);
		
		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		reqMap.put("USER_ID", vo.getUSER_ID());

		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		List<?> returnList = GrpCommonService.GET_EXP_PJT_BUDGET_S01(reqMap);
		
		returnMap.put("ds_ExpPjtList", returnList);
		returnMap.put("RESULT", "OK");
		
		logger.info("getExpPjtSel out");
		return returnMap;
	}
	
	/**
	*  그룹웨어 - 사용자ID / 휴대폰번호 조회 쿼리
	*
	* @param 없음
	* @return 
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
    @RequestMapping(value = "/common_user_info", method = RequestMethod.POST)
    @ResponseBody
    public HashMap<?, ?> common_user_info_Post(Model model, @RequestParam HashMap<String, Object> reqMap) throws Exception{
       
       logger.info("common_user_info_Post in");
       logger.info("reqMap: " + reqMap);
       
       HashMap<String, Object> returnMap = new HashMap<String, Object>();
       returnMap.put("ds_KEY", "");
       
       List<?> RETURN_LIST = GrpCommonService.selectUserInfo(reqMap);
       
       returnMap.put("ds_UserInfo", RETURN_LIST);
       
       logger.info("returnMap: " + returnMap);
       
       if(RETURN_LIST.size() > 0)
       {
          returnMap.put("ds_KEY", "OK");
       }
       
       logger.info("common_user_info_Post out");
       
       return returnMap;
    }
    
	/**
	* 그룹웨어 그룹핑된 DEPT USER LIST 화면 LOAD
	*
	* @param 없음
	* @return 그룹웨어 부서관리 화면을 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/CommonDeptUser_p01", method = RequestMethod.GET)
	@SuppressWarnings (value="unchecked")
	public String CommonDeptUser_p01_Get(HttpSession session, Model model, HttpServletRequest request, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		logger.info("CommonDeptUser_p01_Get in");
		logger.info("CommonDeptUser_p01_Get reqMap : " + reqMap);
		
		CommonVO vo = (CommonVO) session.getAttribute(CommonController.LOGIN);
		reqMap.put("USER_ID", vo.getUSER_ID());
		
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		model.addAttribute("BTN_JSON", commonController.GET_AUTH_MENU_BTN_JSON(reqMap));
		
		
		logger.info("CommonDeptUser_p01_Get out");
		
		return "/groupware/comm/CommonDeptUser_p01";
	}
	
	/**
	* 부서 및 유저 리스트 호출 메서드
	*
	* @param 없음
	* @return 
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
    @RequestMapping(value = "/dept_user_list", method = RequestMethod.POST)
    @ResponseBody
    public HashMap<?, ?> dept_user_list_Post(Model model, HttpServletRequest request, @RequestParam HashMap<String, Object> reqMap) throws Exception{
       
       logger.info("dept_user_list_Post in");
       logger.info("reqMap: " + reqMap);
       
       HashMap<String, Object> returnMap = new HashMap<String, Object>();
       returnMap.put("KEY", ""); 
       
       List<?> RETURN_LIST = GrpCommonService.selectDeptUserList(reqMap);
       
        returnMap.put("RETURN_LIST", RETURN_LIST);
       
        logger.info("returnMap: " + returnMap);
       
        if(RETURN_LIST.size() > 0)
       {
           returnMap.put("KEY", "OK");
       }
       
       logger.info("dept_user_list_Post out");
       
       return returnMap;
    }
    
	/**
	* 유저선택 트리구조 호출 메서드
	*
	* @param 없음
	* @return 공통코드 화면을 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/grpUserTreeSel_Auth_p01", method = RequestMethod.GET)
	@SuppressWarnings (value="unchecked")
	public ModelAndView grpUserTreeSel_Auth_p01(Model model, HttpServletRequest request, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		logger.info("grpUserTreeSel_Auth_p01 in");
		logger.info("grpUserTreeSel_Auth_p01 reqMap : " + reqMap);
		
		// PopupValue Setting
		JSONObject PvjsonObject = new JSONObject();
		for (String key : reqMap.keySet()) {
			if ( StringUtils.startsWith( key, "P_") && StringUtils.isNotBlank( (String) reqMap.get( key))) {
				PvjsonObject.put( key, (String) reqMap.get( key));
			}
		 }
		
        model.addAttribute("OBJ_PARAM", PvjsonObject);
		model.addAttribute("BTN_JSON", commonController.GET_AUTH_MENU_BTN_JSON(reqMap));
		
		logger.info("grpUserTreeSel_Auth_p01 out");
		return mv;
	}
	
	/**
	* 유저선택 트리구조 sms 호출 메서드
	*
	* @param 없음
	* @return 공통코드 화면을 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/grpUserTreeSms_p01", method = RequestMethod.GET)
	@SuppressWarnings (value="unchecked")
	public ModelAndView grpUserTreeSms_p01(Model model, HttpServletRequest request, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		logger.info("grpUserTreeSms_p01 in");
		logger.info("grpUserTreeSms_p01 reqMap : " + reqMap);
		
		// PopupValue Setting
		JSONObject PvjsonObject = new JSONObject();
		for (String key : reqMap.keySet()) {
			if ( StringUtils.startsWith( key, "P_") && StringUtils.isNotBlank( (String) reqMap.get( key))) {
				PvjsonObject.put( key, (String) reqMap.get( key));
			}
		 }
		
        model.addAttribute("OBJ_PARAM", PvjsonObject);
		model.addAttribute("BTN_JSON", commonController.GET_AUTH_MENU_BTN_JSON(reqMap));
		
		logger.info("grpUserTreeSms_p01 out");
		return mv;
	}
	
	/**
	* sms 발송이력 호출 메서드
	*
	* @param 없음
	* @return 공통코드 화면을 리턴한다.
	* @throws Exception Exception 이 발생 했을 경우 화면에 Exception을  리턴 한다.
	*/
	@RequestMapping(value = "/grpSmsHis_p01", method = RequestMethod.GET)
	@SuppressWarnings (value="unchecked")
	public ModelAndView grpSmsHis_p01(Model model, HttpServletRequest request, @RequestParam HashMap<String, Object> reqMap) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		logger.info("grpSmsHis_p01 in");
		logger.info("grpSmsHis_p01 reqMap : " + reqMap);
		
		// PopupValue Setting
		JSONObject PvjsonObject = new JSONObject();
		for (String key : reqMap.keySet()) {
			if ( StringUtils.startsWith( key, "P_") && StringUtils.isNotBlank( (String) reqMap.get( key))) {
				PvjsonObject.put( key, (String) reqMap.get( key));
			}
		 }
		
        model.addAttribute("OBJ_PARAM", PvjsonObject);
		model.addAttribute("BTN_JSON", commonController.GET_AUTH_MENU_BTN_JSON(reqMap));
		
		logger.info("grpSmsHis_p01 out");
		return mv;
	}
}