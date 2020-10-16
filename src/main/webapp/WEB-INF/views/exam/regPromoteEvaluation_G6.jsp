<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %><%@ 
page session="true" %><%@ 
page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
	String strMenuName = request.getParameter("AUTH_GRP_MENU_NM");
%>
<%
/* =================================================================
 * 
 * 작성일 : 2019.12.19
 * 작성자 : 김성균
 * 상세설명 : 승진 평가서(G6)
 *   
 * =================================================================
 * 수정일           작성자             내용     
 * -----------------------------------------------------------------------
 * 20191219	  김성균	     초기작성
 * =================================================================
 */ 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>한수테크니컬서비스 - HTS ERP SYSTEM</title>
    
    <%@include file="../include/common.jsp"%>
	
	<style type="text/css">
    .attach-link-style2{
		color: #0000FF;
	    font-weight: bold;
	    text-decoration: underline;
	    vertical-align: middle;
	    cursor: pointer;
	    padding-left: 3px;
	}
		table{
		    text-align: center;
		    margin:5px 0;
		    border-spacing: 1px;
  			border-collapse: separate;
			word-break : keep-all;
		}
		
		table thead , table th{
			background: #eee;
		    font-size: 14px;
		    line-height: 28px;
		}
		
		textarea{
			width:100%;
			height:225px;
			resize:none;
			font-family: "HY";
			
		}
		
  		.hts_01, .hts_02, .hts_03{
			font-family: "HY";
		}
		
		.pdf-page {
			font-family: "HY";
		}
		
		kendo-pdf-document {
	    	font-size: 15px;
	    	color: #000;
	    	font-weight: 900;
	    }
	</style>
	<script type="text/javascript">
    /* =================================================================
     * Global 함수 시작
     * ================================================================= */   	   	     	
    // AUI Grid ID 생성
    var gGridID;
 	
 	// AUI Grid Columns Layout 생성
 	var gGridColumnsLayout;
 	
 	// Kendo UI Dialog 생성
 	var gTxnNewModalDialog;
 	
	var gDivMap; 	

	var ACHI_CAPA_LIST = [], ACH_T_SCORE, CAP_T_SCORE, ACH_CAP_TOT_SCORE, EVAL_DATA_LIST = [], DEPT_EMP_CD = [];
   	var _COMM_CODE = eval(${COMM_CODE})==null?"":JSON.parse(JSON.stringify(eval(${COMM_CODE})));
   	var _OBJ_PARAM = eval(${OBJ_PARAM})==null?"":JSON.parse(JSON.stringify(eval(${OBJ_PARAM})));
    var gAuth_POSITION 	= JSON.parse('${BTN_JSON.AUTH_PER_POSITION}');
    
	var ARR_FILE_LIST = new Array();	//첨부파일 File List
	var ARR_ADD_FILE = new Array();		//추가되는 첨부파일
	var v_file_list;
	var v_BIZ_GB =  "EVALUATION_G6";
	//성능향상을 위해 StringBuffer 생성
	var StringBuffer = function() {
	    this.buffer = new Array();
	}
	StringBuffer.prototype.append = function(obj) {
	     this.buffer.push(obj);
	}
	StringBuffer.prototype.toString = function(){
	     return this.buffer.join("");
	}

 	/* =================================================================
     * Global 함수 끝
     * ================================================================= */
     /* =================================================================
      * Local 함수 시작
      * ================================================================= */
  	
   /**********************************************************************************
    * Function    : $(document).ready
    * Description : Document Ready
    * parameter   : 
    * return      : 
    **********************************************************************************/
    $(document).ready(function(){
    	// 버튼 생성
//   		gfn_setMenuAuthBtn(JSON.parse('${BTN_JSON.AUTH_BTN}'));

    	// 출력에 사용할 글자체를 설정한다.
    	kendo.pdf.defineFont({
    	    "HY" : "/resources/kendoui.for.jquery.2018.2.516.trial/font/H2GTRM.TTF",
   	    	"HY|Bold" : "/resources/kendoui.for.jquery.2018.2.516.trial/font/H2GPRM.TTF"
    	    
    	});
    	
  		fn_search();
  		
     	// 단위화면 Resize
     	fn_resize();
		
  	});

	
    /*******************************************************************************
	 * Function    : eventBind
	 * Description : 이벤트바인드 
	 * parameter   : 
	 * return      :   
	******************************************************************************/
	$(document).on("change", "#up_file", function(e){
		fn_addFile(this);
	});
	
    /**********************************************************************************
     * Function    : 
     * Description : 평가에 등급이 바뀔떄 마다 평가점수 , 최종점수 자동계산
     * parameter   : 
     * return      : 
     **********************************************************************************/
    $(document).on("change","input[class='EVAL']",function(){
		var score = 0;
		var TOT_SCORE = '';

		//평가점수 합계
		score = fn_sum_eval_score();
		first_score = score;
		
		$("#EVAL_SCORE").text(score);

		//가산(벌)점 합계
		TOT_SCORE = fn_sum_addPoint();
		
		if(!gfn_IsNull(TOT_SCORE)){
			TOT_SCORE *= 1; 
			TOT_SCORE = score + TOT_SCORE;
			$("#TOT_SCORE").text(TOT_SCORE);
		}else{
			$("#TOT_SCORE").text(score);

		}
	});

    /**********************************************************************************
     * Function    : 
     * Description : 평가 등급,가산(벌)점이 바뀔때마다 최종 점수 자동 계산
     * parameter   : 
     * return      : 
     **********************************************************************************/
    $(document).on("change","input[class='ADD_POINT']",function(){
    	var sub_score;
		var pResult = 0;
		
		pResult = fn_sum_addPoint();
		
		if(!gfn_IsNull($("#EVAL_SCORE").text())){
			sub_score = $("#EVAL_SCORE").text();
			sub_score *= 1; 
			pResult = pResult + sub_score;
		}
		
		second_score = pResult;
		$("#TOT_SCORE").text(pResult);
	});
 	
    /**********************************************************************************
     * Function    : fn_sum_eval_score
     * Description : 평가점수 합계
     * parameter   : 
     * return      : 
     **********************************************************************************/
  	function fn_sum_eval_score(){
    	var eval, rate, grade;
		var score = 0;
		
   	 	for(var i = 1; i <= 5; i++){
			eval = $("#EVAL_"+i).data("kendoSEDropDownList").value();
			
			if(eval == "S"){
				grade = 5;
			}else if(eval == "A"){
				grade = 4;
			}else if(eval == "B"){
				grade = 3;
			}else if(eval == "C"){
				grade = 2;
			}else if(eval == "D"){
				grade = 1;
			}else{
				grade = 0;
			}

			rate = $("#RATE_"+i).text();

			score += rate/5*grade;				
		}
		return score;
  	}
   	
   /**********************************************************************************
    * Function    : fn_sum_addPoint
    * Description : 가산(벌)점 합계
    * parameter   : 
    * return      : 
    **********************************************************************************/
 	function fn_sum_addPoint(){
 		var point ,score 
		var pResult = 0;
		
 		for(var i = 1; i<=5; i++){
			point = $("#add_point_"+i).data("kendoSEDropDownList").value();
			if(point == "1"){
				score = 1;
			}else if(point == "2"){
				score = 2;
			}else if(point == "3"){
				score = 3;
			}else{
				score = 0;
			}
			pResult += score;
		}

		for(var i=1; i <= 2; i++){
			point = $("#penalty_point_"+i).data("kendoSEDropDownList").value();

			if(point == "1"){
				score = 1;
			}else if(point == "2"){
				score = 2;
			}else if(point == "3"){
				score = 3;
			}else{
				score = 0;
			}
			pResult -= score;
		}
		return pResult;
 	}
	
 	
	/**********************************************************************************
     * Function    : createKendoConponents
     * Description : Kendo UI Component 생성
     * parameter   : 
     * return      : 
     **********************************************************************************/
 	function createKendoConponents()
 	{

 	}
	/**********************************************************************************
     * Function    : fn_user_auth
     * Description : 유저 권한
     *				 item.ATTRIBUTE1 : _PER 유무
     *				 - 유 -> 인사팀
     *				 - 무 -> 인사팀을 뺀 사원들
     *				H:소속장, D:부서장, T:팀장, A:ALL, N:사원
     * parameter   : item
     * return      :  
     **********************************************************************************/
 	function fn_user_auth(item)
 	{
    	$("#TOTAL_DT").attr("readOnly",true);
 		$("#BASE_ST_DT").attr("readOnly",true);
 		$("#EMP_CD").attr("readOnly",true);
 		$("#EMP_NM").attr("readOnly",true);
  		$("#EMP_DT").attr("readOnly",true);
 		$("input[name=HQ_CD]").data("kendoSEDropDownList").readonly(true);
 		$("input[name=DEPT_CD]").data("kendoSEDropDownList").readonly(true);
 		$("input[name=TEAM_CD]").data("kendoSEDropDownList").readonly(true);
 		$("input[name=POSITION]").data("kendoSEDropDownList").readonly(true);

 		if(item.ATTRIBUTE1 != "_PER") {
    		$("#EVAL_EDU_COMPLETE").attr("readOnly",true);
    		
    		$("#APP_REMARK").attr("readOnly",true);
    		$("#EVAL_SAVE_EDU_COMPLETE").attr("readOnly",true);
        	
        	if(item.AUTH == "H"){
			
        	}else if(item.AUTH == "D"){
				
        	}else if(item.AUTH == "T"){
				$("#btn_next").hide();
	 			// 팀코드 21, 22 (공사지원팀) 27,28(신사업팀) 인 경우 팀장은 두개의 팀을 모두 조회해야함
		   		if (item.TEAM_CD == '21' ||  item.TEAM_CD == '22') {
 	 				var teamList = $.grep (gJson_CODE_TYPE.EDT_DPT_LIST, function (n, i) { return n.DTL_CD == '21' || n.DTL_CD == '22'})
 	 				
	 			} else if (item.TEAM_CD == '27' ||  item.TEAM_CD == '29') {
	 				var teamList = $.grep (gJson_CODE_TYPE.EDT_DPT_LIST, function (n, i) { return n.DTL_CD == '27' || n.DTL_CD == '29'})
 	 				
	 			} else {

	 			}
		   		
    		}else if(item.AUTH == "N"){
    			$("#btn_save").hide();
				$("#btn_next").hide();
				fn_lock();
			}
    	}
   		
 	}
     /**********************************************************************************
      * Function    : fn_lock
      * Description : 데이터 변경불가하게 
      * parameter   : 
      * return      : 
      **********************************************************************************/
 	function fn_lock(){
 		$("input").attr("readOnly",true);
		$("textarea").attr("readOnly",true);
		$("#EVAL_1").data("kendoSEDropDownList").readonly(true);         
		$("#EVAL_2").data("kendoSEDropDownList").readonly(true);         
		$("#EVAL_3").data("kendoSEDropDownList").readonly(true);         
		$("#EVAL_4").data("kendoSEDropDownList").readonly(true);         
		$("#EVAL_5").data("kendoSEDropDownList").readonly(true);         
		$("#add_point_1").data("kendoSEDropDownList").readonly(true);    
		$("#add_point_2").data("kendoSEDropDownList").readonly(true);    
		$("#add_point_3").data("kendoSEDropDownList").readonly(true);    
		$("#add_point_4").data("kendoSEDropDownList").readonly(true);    
		$("#add_point_5").data("kendoSEDropDownList").readonly(true);    
		$("#penalty_point_1").data("kendoSEDropDownList").readonly(true);
		$("#penalty_point_2").data("kendoSEDropDownList").readonly(true);
    }
    
	/**********************************************************************************
     * Function    : fn_createCode
     * Description : 해당 코드에 대한 자식 코드를 가져온다.
     * parameter   : 
     * return      : 
     **********************************************************************************/
	function fn_createCode(val){
		var List = [];
    	// 해당 부모에 해당하는 부서 코드를 찾는다.
    	for(var i = 0; i <= _COMM_CODE.DPT_LIST.length-1; i++){
    		if( val == _COMM_CODE.DPT_LIST[i].UP_DPT_CD){
    			var data = new Object();
    			data["DTL_CD"] = _COMM_CODE.DPT_LIST[i].DTL_CD;
    			data["DTL_NM"] = _COMM_CODE.DPT_LIST[i].DTL_NM;
    			List.push(data);
    		}
    	}
    	return List;
	}

	/**********************************************************************************
     * Function    : fn_changeDept
     * Description : 소속가 바뀔때 부서에 대한 코드를 가져온다.
     * parameter   : 
     * return      : 
     **********************************************************************************/
  	function fn_changeDept(){
      	 
      	var hqValue = $("#HQ_CD").val(); //소속에서 선택한 값을 가져온다
      	
      	var List = fn_createCode(hqValue);
      	
      	if(!gfn_IsNull(hqValue)){
      		$("#DEPT_CD").kendoSEDropDownList({dataSource:List, dataValueField:"DTL_CD", dataTextField:"DTL_NM", change:fn_changeTeam }); // 부서
      	}
      	else{
      		$("#DEPT_CD").kendoSEDropDownList();
      	}
     	   
  	}
  	
  	/**********************************************************************************
       * Function    : fn_changeTeam
       * Description : 부서가 바뀔때 팀에 대한 정보를 가져온다.
       * parameter   : 
       * return      : 
       **********************************************************************************/
  	function fn_changeTeam(){
      	var deptValue = $("#DEPT_CD").val(); // 부서에 값을 가져온다.
      	 
      	var List = fn_createCode(deptValue);
      	 
   		if(!gfn_IsNull(deptValue)){
       		$("#TEAM_CD").kendoSEDropDownList({dataSource:List, dataValueField:"DTL_CD", dataTextField:"DTL_NM" }); // 부서
       	}
       	else{
       		$("#TEAM_CD").kendoSEDropDownList();
       	}
      	 
  	}

   
   	/**********************************************************************************
       * Function    : fn_resize 
       * Description : Flexible 화면 Component Height 자동 조절
       * parameter   : 
       * return      : 
       **********************************************************************************/
   	function fn_resize()
 	{
   	   if(!gfn_IsNull($("#divMstGridArea").height()))
  		{
      		// Flexible array Div Grid ID
  			var arrFlexDivId    = ["divMstGridArea"];
  			
  			// Fix array Div ID
  			var arrFixDivId     = ["divTitleArea"];
  			
  			// Flexible Window Screen Height 공통 함수 호출
  			var nFlexibleHeight = gfn_resizeHeight(arrFlexDivId, arrFixDivId);
  			
  			AUIGrid.resize(gGridID, $("#divMstGridArea").width(), $("#divMstGridArea").height());
  		}
  	}

   	/**********************************************************************************
       * Function    : $(window).resize 
       * Description : 화면 리사이즈 이벤트 함수
       * parameter   : 
       * return      : 
       **********************************************************************************/
  	$(window).resize(function(){
  		//코드 넣는 곳
  		fn_resize();
  	}).resize();

  	/*******************************************************************************
	* Function    : fn_search
	* Description : 조회 
	* parameter   : 
	* return      : 
	******************************************************************************/
	function fn_search()
	{
		$.ajax({
			url : "/person/regPromote_Eval_Rec_List",
			data : {
				"P_EMP_CD"  : _OBJ_PARAM.P_EMP_CD,
				"P_EMP_DT"  : _OBJ_PARAM.P_EMP_DT,
				"P_EANN"    : _OBJ_PARAM.P_EANN,
				"P_TYPE" 	: _OBJ_PARAM.P_TYPE
				
			},
			dataType : "json",
			type : "POST",
			success : function(data){
				ACHI_CAPA_LIST = data.ACHI_CAPA_LIST.ACHI_CAPA_LIST;
				ACH_T_SCORE = data.ACHI_CAPA_LIST.ACH_T_SCORE;
				CAP_T_SCORE = data.ACHI_CAPA_LIST.CAP_T_SCORE;
				ACH_CAP_TOT_SCORE = data.ACHI_CAPA_LIST.ACH_CAP_TOT_SCORE;
				EVAL_DATA_LIST = data.EVAL_DATA_LIST;
				DEPT_EMP_CD = data.DEPT_EMP_CD;
				
				fn_create();
				
			}
		});

	}
	
	/**********************************************************************************
    * Function    : fn_save 
    * Description : 저장
    * parameter   : 
    * return      : 
    **********************************************************************************/
	function fn_save()
	{
		gfn_kendoConfirmMessageBox(gTxnNewModalDialog, null, null, '<spring:message code="msg.common.confirm" arguments="저장" javaScriptEscape="true"/>', null, fn_save_confirm, null);	
	}

	
	function fn_save_confirm()
	{
		
		fn_uploadFile();
		
		var data = $("#formData").serializeArray();
		var EVAL_SCORE = $("#EVAL_SCORE").text();
		var TOT_SCORE = $("#TOT_SCORE").text();
		
		var array = {
				 "ADD" : data,
				 "EVAL_SCORE" : EVAL_SCORE,
				 "TOT_SCORE"  : TOT_SCORE,
				 "P_EANN" 	  : _OBJ_PARAM.P_EANN,
				 "P_TYPE" 	  : _OBJ_PARAM.P_TYPE,
				 "ARR_FILE_LIST": ARR_FILE_LIST
		}
		 
		 $.ajax({
	  			url: "/person/regPromote_Eval_Rec_Save",
	  			data: JSON.stringify(array),
	  			contentType: "application/json; charset=utf-8",
	  			dataType:"json",
	  			type: "POST",
	  			beforeSend: function() {
	  				//마우스 커서를 로딩 중 커서로 변경
	  				$("html").css("cursor", "wait");
	  			},
	  			success : function(data){
	  				//마우스 커서를 원래대로 돌린다
	  				$("html").css("cursor", "auto");
	  				
	  				if(data.KEY == "OK")
	  				{
	  					gfn_kendoMessageBox(null, null, '저장 되었습니다.', null, null);
	  					fn_search();
	  					
	  				}
	  				else
	  				{
	  					gfn_kendoMessageBox(null, null, '저장 실패 했습니다.', null, null);
	  				}
	  			},
	  			complete : function(data) {
	  				//마우스 커서를 원래대로 돌린다
	  				$("html").css("cursor", "auto");
	  			}
	  		});
	}

	/**********************************************************************************
    * Function    : fn_next 
    * Description : 다음
    * parameter   : 
    * return      : 
    **********************************************************************************/
	function fn_next()
	{
		if(!fn_validation()){
    		gfn_kendoCallBackMessageBox(null, null, '모두 입력해주시기 바랍니다.' , null, null);
		}else{
			gfn_kendoConfirmMessageBox(gTxnNewModalDialog, null, null, '완료 하시겠습니까?', null, fn_next_confirm, null);	

		}
	}

	function fn_next_confirm()
	{
		$.ajax({
			url : "/person/regPromote_Eval_Rec_Next",
			data : {
				"P_HQ_CD" : _OBJ_PARAM.P_HQ_CD,
				"P_DEPT_CD" : _OBJ_PARAM.P_DEPT_CD,
				"P_TEAM_CD" : _OBJ_PARAM.P_TEAM_CD,
				"P_EMP_CD" : _OBJ_PARAM.P_EMP_CD,
				"P_EANN" : _OBJ_PARAM.P_EANN,
				"P_TYPE" : _OBJ_PARAM.P_TYPE
			},
			dataType : "json",
			type : "POST",
			success : function(data){
				if(data.KEY == "OK"){
					gfn_kendoCallBackMessageBox(null, null, '평가가 완료되었습니다.', null,null);
					$("#DEPT_SIGN_NM").text(DEPT_EMP_CD.UP_EMP_NM);
					$("#btn_save").hide();
					$("#btn_next").hide();
					$("#btn_print").show();
					fn_lock();
					
				}else{
					gfn_kendoCallBackMessageBox(null, null, data.USERALERT, null,null);

				}
			}
		});
	}
		
	/**********************************************************************************
     * Function    : fn_close
     * Description : 닫기 함수
     * parameter   : 
     * return      : 
     **********************************************************************************/
	function fn_close()
	{
		if(typeof _OBJ_PARAM.P_PARENT_URL != "undefined"){
      		var currPage = window.location.pathname, splitG_Id = currPage.split('/'), currId = splitG_Id[splitG_Id.length - 1];
      		$windowiframe = $(window.frameElement.ownerDocument).find("iframe[src*='"+currId+"']");
      		
      		if($windowiframe.length > 1) {
      			$windowiframe = $(window.frameElement.ownerDocument).find("iframe[src*='"+currId+"'][style*='block']");
      		}
      		
      		var params  = "AUTH_GRP_MENU_NM=승진 평가서"; //닫기후 리턴받는 창의 제목
	  		    params += "&P_MENU_ID="+_OBJ_PARAM.P_MENU_ID; //닫기후 리턴받는 창의 메뉴ID(버튼 조회)
	  		    params += "&P_EANN=" +_OBJ_PARAM.P_EANN; // 기수
      		
     		$windowiframe.attr('src', '/person/'+_OBJ_PARAM.P_PARENT_URL+"?"+params);    		
    	} else {
    		Global.closeCurrentFrame();
    	}
	}

 	/**********************************************************************************
     * Function    : fn_create 
     * Description : 기존 데이터 셋팅
     * parameter   : 
     * return      : 
     **********************************************************************************/
 	function fn_create(){
 		var TEMPLATE = "";
 		var ACHI_T_SCORE = 0 , CAPA_T_SCORE = 0 , TOTAL_SCORE = 0;

		TEMPLATE += '<form name="formData" id="formData" method="post">';
		TEMPLATE += '					<div id="divMstGrid" style="width:99%; color:#000;">';
		TEMPLATE += '			     		<div>';
		TEMPLATE += '			     			<div>';
		TEMPLATE += '				     			<div class="hts_R_subTitle">';
		TEMPLATE += '									<h1><span class="k-icon k-i-list-bulleted"></span>기본 사항</h1>';
		TEMPLATE += '								</div>';
		TEMPLATE += '				     			<table class="table" style="width: 100%; text-align:center;" border="2";>';
		TEMPLATE += '									<colgroup>';
		TEMPLATE += '										<col width="5%">';
		TEMPLATE += '										<col width="10%">';
		TEMPLATE += '										<col width="5%">';
		TEMPLATE += '										<col width="10%">';
		TEMPLATE += '										<col width="5%">';
		TEMPLATE += '										<col width="10%">';
		TEMPLATE += '									</colgroup>';
		TEMPLATE += '									<tbody>';
		TEMPLATE += '										<tr>';
		TEMPLATE += '											<th>본 부</th>';
		TEMPLATE += '											<td><input id="HQ_CD" name="HQ_CD" style="width:100%;"></td>';
		TEMPLATE += '											<th>부 서</th>';
		TEMPLATE += '											<td><input id="DEPT_CD" name="DEPT_CD" style="width:100%;"></td>';
		TEMPLATE += '											<th>팀</th>';
		TEMPLATE += '											<td><input id="TEAM_CD" name="TEAM_CD" style="width:100%;"></td>';
		TEMPLATE += '										</tr>';
		TEMPLATE += '										<tr>';
		TEMPLATE += '											<th>직 급</th>';
		TEMPLATE += '											<td><input id="POSITION" name="POSITION" style="width:100%;"></td>';
		TEMPLATE += '											<th>사원코드</th>';
		TEMPLATE += '											<td>';
		TEMPLATE += '												<input class="k-textbox" id="EMP_CD" name="EMP_CD" style="width : 100%;" />';
		TEMPLATE += '											</td>';
		TEMPLATE += '											<th>사원명</th>';
		TEMPLATE += '											<td><input class="k-textbox" id="EMP_NM" name="EMP_NM" style="width : 100%;" /></td>';
		TEMPLATE += '										</tr>';
		TEMPLATE += '										<tr>';
		TEMPLATE += '											<th>입사년월일</th>';
		TEMPLATE += '											<td><input class="k-textbox" id="EMP_DT" name="EMP_DT" style="width: 100%"/></td>';
		TEMPLATE += '											<th>근무연수</th>';
		TEMPLATE += '											<td><input class="k-textbox" id="TOTAL_DT" name="TOTAL_DT" style="width:100%;"></td>';
		TEMPLATE += '											<th>현 직급 체류연수</th>';
		TEMPLATE += '											<td><input class="k-textbox" id="BASE_ST_DT" name="BASE_ST_DT" style="width:100%;"></td>';
		TEMPLATE += '										</tr>';
		TEMPLATE += '										<tr>'; //!
		TEMPLATE += '											<th></th>';
		TEMPLATE += '											<td></td>';
		TEMPLATE += '											<th></th>';
		TEMPLATE += '											<td></td>';
		TEMPLATE += '											<th>경력인정연수</th>';
		TEMPLATE += '											<td><input class="k-textbox" id="APP_REMARK"  name="APP_REMARK" style="width:100%;"></td>';
		TEMPLATE += '										</tr>';		
		TEMPLATE += '									</tbody>';
		TEMPLATE += '								</table>';
		TEMPLATE += '							</div>';
		TEMPLATE += '							';
		TEMPLATE += '							<!-- 업적, 역량 평가 결과 -->';
		TEMPLATE += '							<div id="ACHI_CAPA_DIV" name = "ACHI_CAPA_DIV">';
		TEMPLATE +='              			        <div class="hts_R_subTitle">';
		TEMPLATE +='                        			<h1><span class="k-icon k-i-list-bulleted"></span>업적/역량 평가결과 사항</h1>';
		TEMPLATE +='                        		</div>';
		TEMPLATE +='                        		<table class="table" style="width: 100%; text-align:center;" border="2";>';
		TEMPLATE +='                        			<thead >';
		TEMPLATE +='                        				<th>구분</th>';

		if(ACHI_CAPA_LIST.length > 0){

    	 	for(var i = 0; i < ACHI_CAPA_LIST.length; i++){
    	 		if(ACHI_CAPA_LIST[i] != null){
					TEMPLATE +='                        				<th><span id="ACHI_CAPA_DT_'+i+'">'+ACHI_CAPA_LIST[i].CAL_YEAR+'</span></th>';
    	 		}	
    	 	}	
		}	

		TEMPLATE +='                        				<th>점수</th>';
		TEMPLATE +='                        				<th>총 합</th>';
		TEMPLATE +='                        			</thead>';
		TEMPLATE +='                        			<tbody>';
		TEMPLATE +='                        				<tr style="height:30px;">';
		TEMPLATE +='                        					<td>업적 등급</td>';

		if(ACHI_CAPA_LIST.length > 0){

    	 	for(var i = 0; i < ACHI_CAPA_LIST.length; i++){

    	 		if(ACHI_CAPA_LIST[i] != null ){

					TEMPLATE +='                        					<td><span id="ACHI_'+i+'">'+ACHI_CAPA_LIST[i].ACH_SCORE+'</span></td>';
    	 		}	
    	 	}	
        }                                            

		TEMPLATE +='                      		  				<td><span id= "ACH_T_SCORE" >'+ACH_T_SCORE+'</span></td>';
		TEMPLATE +='                      		  				<td rowspan="2"><span id= "ACH_CAP_TOT_SCORE" >'+ACH_CAP_TOT_SCORE+'</span></td>';
		TEMPLATE +='                        				</tr>';
		TEMPLATE +='                        				<tr style="height:30px;">';
		TEMPLATE +='                        					<td>역량 등급</td>';

		if(ACHI_CAPA_LIST.length > 0){

    	 	for(var i = 0; i < ACHI_CAPA_LIST.length; i++){

    	 		if(ACHI_CAPA_LIST[i] != null ){

    				TEMPLATE +='                       			 			<td><span id="CAPA_'+i+'">'+ACHI_CAPA_LIST[i].CAP_SCORE+'</span></td>';
    				
    	 		}
    	 	}
		}                                   
		TEMPLATE +='                      		  				<td><span id= "CAP_T_SCORE">'+CAP_T_SCORE+'</span></td>';
		TEMPLATE +='                        				</tr>';
		TEMPLATE +='                        			</tbody>';
		TEMPLATE +='                      			  </table>';
		TEMPLATE += '							</div>';
		TEMPLATE += '							<div style="height:100px;" >';
		TEMPLATE += '				     			<div class="hts_R_subTitle">';
		TEMPLATE += '									<h1><span class="k-icon k-i-list-bulleted"></span>교육이수결과 사항</h1>';
		TEMPLATE += '								</div>';
		TEMPLATE += '				     			<table style="width: 40%; float:left" border="2";>';
		TEMPLATE += '				     				<thead >';
		TEMPLATE += '				     					<th>구분</th>';
		TEMPLATE += '				     					<th colspan="2">내용</th>';
		TEMPLATE += '				     				</thead>';
		TEMPLATE += '				     				<tbody>';
		TEMPLATE += '				     					<tr style="height:30px;">';
		TEMPLATE += '				     						<td><span>교육이수여부</span></td>';
		
		TEMPLATE += '				     						<td colspan="2">';
		TEMPLATE += '				     						<div style="border-width: 1px; border-style: solid; border-color:#999; text-align:left;">';
		TEMPLATE += '												<input type="file" id="up_file" style="display: none;"/>';
		TEMPLATE += '												<button id="btn_fileupload" type="button" class="k-button" onclick="fn_fileupload()" style="margin: 2px;">파일 첨부</button>';
		TEMPLATE += '												<span id="file_list"></span>';
		TEMPLATE += '											</td>';
		
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     				</tbody>';
		TEMPLATE += '								</table>';
		TEMPLATE += '								';
		TEMPLATE +='								<table style="width: 40%; float:right;" border="2";>'; //!
		TEMPLATE +='			     					<colgroup>';
		TEMPLATE +='			     						<col width="40px">';
		TEMPLATE +='			     						<col width="20px">';
		TEMPLATE +='			     					</colgroup>';
		TEMPLATE +='				     				<tbody>';
		TEMPLATE +='				     					<th>사내 안전보건교육 이수 여부</th>';
		TEMPLATE +='			     						<td><input class="k-textbox" id="EVAL_SAVE_EDU_COMPLETE" name="EVAL_SAVE_EDU_COMPLETE" style="width:100%;"></td>';
		TEMPLATE +='				     				</tbody>';
		TEMPLATE +='								</table>';
		TEMPLATE +='								';		
		TEMPLATE += '							</div>';
		TEMPLATE += '							<div>';
		TEMPLATE += '				     			<div class="hts_R_subTitle">';
		TEMPLATE += '									<h1><span class="k-icon k-i-list-bulleted"></span>근무평가 항목 (G6급)</h1>';
		TEMPLATE += '								</div>';
		TEMPLATE += '				     			<table class="table" style="width: 100%; " border="2";>';
		TEMPLATE += '				     				<colgroup>';
		TEMPLATE += '				     					<col style="width:30px;">';
		TEMPLATE += '				     					<col style="width:50px;">';
		TEMPLATE += '				     					<col style="width:20px;">';
		TEMPLATE += '				     					<col style="width:240px;">';
		TEMPLATE += '				     					<col style="width:60px;">';
		TEMPLATE += '				     					<col style="width:30px;">';
		TEMPLATE += '				     				</colgroup>';
		TEMPLATE += '				     				<thead >';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '					     					<th rowspan="2">구분</th>';
		TEMPLATE += '					     					<th rowspan="2">평가요소</th>';
		TEMPLATE += '					     					<th>비중</th>';
		TEMPLATE += '					     					<th rowspan="2">정의</th>';
		TEMPLATE += '					     					<th rowspan="2">평가</th>';
		TEMPLATE += '					     					<th rowspan="2">평가 점수</th>';
		TEMPLATE += '					     				</tr>';
		TEMPLATE += '					     				<tr>';
		TEMPLATE += '					     				 <th>100%</th>';
		TEMPLATE += '					     				</tr>';
		TEMPLATE += '				     				</thead>';
		TEMPLATE += '				     				<tbody>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td rowspan="4">근무평가</td>';
		TEMPLATE += '				     						<td>직무별 전문지식</td>';
		TEMPLATE += '				     						<td><span id="RATE_1">25</span></td>';
		TEMPLATE += '				     						<td style="text-align:left;">담당직무 수행에 필요한 지식과 기술은 어느정도 갖추고 있는가?</td>';
		TEMPLATE += '				     						<td><input class="EVAL" id="EVAL_1" name="EVAL_WORK_KNOWLEDGE"></td>';
		TEMPLATE += '				     						<td rowspan="5"><span id="EVAL_SCORE" name="EVAL_SCORE"></span></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td>조직통솔력 (인재관리)</td>';
		TEMPLATE += '				     						<td><span id="RATE_2">25</span></td>';
		TEMPLATE += '				     						<td style="text-align:left;">인재개발의 중요성을 인식하고, 부서원의 의견과 능력을 바르게 파악하여 조직을 효율적으로 운영하고, 다양한 육성방법을 활용하여 부서원의 능력을 지속적으로 향상시키고 관리하는가?</td>';
		TEMPLATE += '				     						<td><input class="EVAL" id="EVAL_2" name="EVAL_WORK_TEAM"></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td>위기관리</td>';
		TEMPLATE += '				     						<td><span id="RATE_3">12.5</span></td>';
		TEMPLATE += '				     						<td style="text-align:left;">어려운 문제나 현장 상황에 따른 변수 등에 직면하였을 경우, 이를 지각하고 신속하게 판단하며, 재조정 등을 통해 업무의 방향을 설정하고 관리하는가?</td>';
		TEMPLATE += '				     						<td><input class="EVAL" id="EVAL_3" name="EVAL_WORK_SOLUTION"></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td>부서운영 조정능력</td>';
		TEMPLATE += '				     						<td><span id="RATE_4">25</span></td>';
		TEMPLATE += '				     						<td style="text-align:left;">조직의 의견과 갈등을 명확하게 파악하고 열린 자세로 대응하고 조정하며, 갈등이 있다면 긍정적인 업무관계를 유지하면서 발전적인 해결책에 도달할 수 있게 도움을 줄 수 있도록 관리하는가?</td>';
		TEMPLATE += '				     						<td><input class="EVAL" id="EVAL_4" name="EVAL_WORK_LEADERSHIP"></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td>혁신평가</td>';
		TEMPLATE += '				     						<td>혁신활동</td>';
		TEMPLATE += '				     						<td><span id="RATE_5">12.5</span></td>';
		TEMPLATE += '				     						<td style="text-align:left;">혁신활동(제안제도)에 얼마나 적극적으로 참여하고 활동하였는가?</td>';
		TEMPLATE += '				     						<td><input class="EVAL" id="EVAL_5" name="EVAL_INNOVATION_JOIN"></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     				</tbody>';
		TEMPLATE += '								</table>';
		TEMPLATE += '							</div>';
		
		TEMPLATE += '							<div>';
		TEMPLATE += '				     			<div class="hts_R_subTitle">';
		TEMPLATE += '									<h1><span class="k-icon k-i-list-bulleted"></span>가산(벌)점 부분</h1>';
		TEMPLATE += '								</div>';
		TEMPLATE += '				     			<table class="table" style="width: 100%;" border="2">';
		TEMPLATE += '				     				<colgroup>';
		TEMPLATE += '				     					<col style="width:40px;">';
		TEMPLATE += '				     					<col style="width:50px;">';
		TEMPLATE += '				     					<col style="width:60px;">';
		TEMPLATE += '				     					<col style="width:70px;">';
		TEMPLATE += '				     					<col style="width:190px;">';
		TEMPLATE += '				     				</colgroup>';
		TEMPLATE += '				     				<thead >';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '					     					<th>구분</th>';
		TEMPLATE += '					     					<th>세부항목</th>';
		TEMPLATE += '					     					<th>점수체크</th>';
		TEMPLATE += '					     					<th>점수구간</th>';
		TEMPLATE += '					     					<th>비고</th>';
		TEMPLATE += '										</tr>';
		TEMPLATE += '				     				</thead>';
		TEMPLATE += '				     				<tbody>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td rowspan="5">가산점 부분</td>';
		TEMPLATE += '				     						<td>우수사원</td>';
		TEMPLATE += '				     						<td><input class="ADD_POINT" id="add_point_1" name="EVAL_ADD_EXC_EMP_SCORE"></td>';
		TEMPLATE += '				     						<td>1~2점 내</td>';
		TEMPLATE += '				     						<td style="text-align:left;"><p>우수사원 포상자<br>';
		TEMPLATE += '				     								직급내 횟수당 1점(최대 2점까지 허용)';
		TEMPLATE += '				     						</p></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td>회사기여도</td>';
		TEMPLATE += '				     						<td><input class="ADD_POINT" id="add_point_2" name="EVAL_ADD_CON_SCORE"></td>';
		TEMPLATE += '				     						<td>';
		TEMPLATE += '				     							<p>대내외 포상자 2점<br>공식 업무 인정자 1점</p>';
		TEMPLATE += '				     						</td>';
		TEMPLATE += '				     						<td style="text-align:left;">';
		TEMPLATE += '				     							<p>대내외 포상자<br>	공식적 업무결과 (예: 특허 및 관련상황 인정자)</p>';
		TEMPLATE += '				     						</td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td>제안혁신제도 성과</td>';
		TEMPLATE += '				     						<td><input class="ADD_POINT" id="add_point_3" name="EVAL_ADD_PRO_SCORE"></td>';
		TEMPLATE += '				     						<td>1~2점 내</td>';
		TEMPLATE += '				     						<td style="text-align:left;"><p>최우수제안 : 2점<br>우수제안 : 1점</p></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td>외국어 능력</td>';
		TEMPLATE += '				     						<td><input class="ADD_POINT" id="add_point_4" name="EVAL_ADD_LANG_SCORE"></td>';
		TEMPLATE += '				     						<td>1~2점 내</td>';
		TEMPLATE += '				     						<td style="text-align:left;"><p>해당직급내 취득기준<br>외국어 공인인증 1급 기준 : 2점<br>외국어 공인인증 2급 이하 : 1점</p></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td>회사업무 겸임여부<br>(품보팀, 기타 TF업무)</td>';
		TEMPLATE += '				     						<td><input class="ADD_POINT" id="add_point_5" name="EVAL_ADD_ADJUNCT_SCORE"></td>';
		TEMPLATE += '				     						<td>1~2점 내</td>';
		TEMPLATE += '				     						<td style="text-align:left;"><p>직급기간 내 TFT 겸임 1개 : 1점<br>직급기간 내 TFT 겸임 2개 이상 :2점</p></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td rowspan="2">벌점 부분</td>';
		TEMPLATE += '				     						<td>회사 이미지 손상</td>';
		TEMPLATE += '				     						<td><input class="ADD_POINT" id="penalty_point_1" name="EVAL_PENALTY_IMG_DMG"></td>';
		TEMPLATE += '				     						<td>2점</td>';
		TEMPLATE += '				     						<td style="text-align:left;"><p>고객사에 대한 이미지 회손 등</p></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     					<tr>';
		TEMPLATE += '				     						<td>회사 견책 처분자</td>';
		TEMPLATE += '				     						<td><input class="ADD_POINT" id="penalty_point_2" name="EVAL_PENALTY_REPRIMAND"></td>';
		TEMPLATE += '				     						<td>1점~3점 내</td>';
		TEMPLATE += '				     						<td style="text-align:left;"><p>경고 1점, 견책 2점, 감급이상자 3점</p></td>';
		TEMPLATE += '				     					</tr>';
		TEMPLATE += '				     				</tbody>';
		TEMPLATE += '								</table>';
		TEMPLATE += '							</div>';
		TEMPLATE += '							<div>';
		TEMPLATE += '				     			<div class="hts_R_subTitle">';
		TEMPLATE += '									<h1><span class="k-icon k-i-list-bulleted"></span>평가자 의견</h1>';
		TEMPLATE += '								</div>';
		TEMPLATE += '								<div>';
		TEMPLATE += '									<textarea id="CMT" name="CMT" style="width:100%; height:80px; padding: 10px;" ></textarea>';
		TEMPLATE += '								</div>					';
		TEMPLATE += '							</div>';
		TEMPLATE +='							<div style = "width:40%; float: left;">';
		TEMPLATE +='				     			<div class="hts_R_subTitle">';
		TEMPLATE +='									<h1><span class="k-icon k-i-list-bulleted"></span>최종 점수</h1>';
		TEMPLATE +='								</div>';
		TEMPLATE +='								<div>';
		TEMPLATE +='									<table style="width:80%;" border="2">';
		TEMPLATE +='										<th>최종 점수</th>';
		TEMPLATE +='										<td><span id="TOT_SCORE" name="TOT_SCORE"></span></td>';
		TEMPLATE +='									</table>';
		TEMPLATE +='								</div>';
		TEMPLATE +='							</div>';
		
		TEMPLATE +='							<div style = "float: right; text-align:center; width:40%;">';
		TEMPLATE +='				     			<div class="hts_R_subTitle" style="text-align:left;">';
		TEMPLATE +='									<h1><span class="k-icon k-i-list-bulleted"></span>서명</h1>';
		TEMPLATE +='								</div>';
		TEMPLATE +='								<div>';
		TEMPLATE +='									<table class="table" border="2">';
		TEMPLATE +='										<th>평가자</th>';
		TEMPLATE += '										<td> ';
		TEMPLATE += '											<span id="DEPT_SIGN_NM"></span> ';
		TEMPLATE += '										</td> ';
		TEMPLATE +='									</table>';
		TEMPLATE +='								</div>';
		TEMPLATE +='							</div>';
		TEMPLATE += '							';
		TEMPLATE += '						</div>';
		TEMPLATE += '					</div>';
		TEMPLATE += '				</form>';

		$("#main-content").html(TEMPLATE);
		
		var point =
        [
			{"DTL_CD":1,"DTL_NM":"1"},
			{"DTL_CD":2,"DTL_NM":"2"},
			{"DTL_CD":3,"DTL_NM":"3"}
    	];

		var point1 =
        [
			{"DTL_CD":1,"DTL_NM":"1"},
			{"DTL_CD":2,"DTL_NM":"2"}
    	];
    	
		var point2 =
        [
			{"DTL_CD":2,"DTL_NM":"2"}
    	];

   	   	$(".EVAL").kendoSEDropDownList({dataSource:_COMM_CODE.GRADE_CD, dataValueField:"DTL_CD", dataTextField:"DTL_NM" , optionLabel: "선택"});
   	   	$("#HQ_CD").kendoSEDropDownList({dataSource:_COMM_CODE.HQ_LIST, dataValueField:"DTL_CD", dataTextField:"DTL_NM" , optionLabel: "선택" ,change:fn_changeDept});
   	   	$("#DEPT_CD").kendoSEDropDownList({dataSource:_COMM_CODE.DPT_LIST, dataValueField:"DTL_CD", dataTextField:"DTL_NM" , optionLabel: "선택"});
   	   	$("#TEAM_CD").kendoSEDropDownList({dataSource:_COMM_CODE.DPT_LIST, dataValueField:"DTL_CD", dataTextField:"DTL_NM" , optionLabel: "선택"});
   	   	$("#POSITION").kendoSEDropDownList({dataSource:_COMM_CODE.POSITION_LIST, dataValueField:"DTL_NM", dataTextField:"DTL_NM" , optionLabel: "선택"});
   	   	$(".ADD_POINT").kendoSEDropDownList({dataSource:point1, dataValueField:"DTL_CD", dataTextField:"DTL_NM" , optionLabel: "선택"});
   		$("#penalty_point_1").kendoSEDropDownList({dataSource:point1, dataValueField:"DTL_CD", dataTextField:"DTL_NM" , optionLabel: "선택"});
	   	$("#penalty_point_2").kendoSEDropDownList({dataSource:point, dataValueField:"DTL_CD", dataTextField:"DTL_NM" , optionLabel: "선택"});
		fn_setting();
		
 	 }

 	/**********************************************************************************
     * Function    : fn_setting 
     * Description : 기존 데이터 셋팅
     * parameter   : 
     * return      : 
     **********************************************************************************/
 	function fn_setting(){
    	 	
	   	$("#EMP_DT").val(_OBJ_PARAM.P_EMP_DT);
 		$("#EMP_CD").val(_OBJ_PARAM.P_EMP_CD);
 		$("#EMP_NM").val(_OBJ_PARAM.P_EMP_NM);
 		$("#TOTAL_DT").val(_OBJ_PARAM.P_TOTAL_DT);
 		$("#BASE_ST_DT").val(_OBJ_PARAM.P_BASE_ST_DT);
 		$("#APP_REMARK").val(ACHI_CAPA_LIST[0].EXP_YEAR_REMARK);
     	$("#HQ_CD").data("kendoSEDropDownList").value(_OBJ_PARAM.P_HQ_CD);
 		$("#DEPT_CD").data("kendoSEDropDownList").value(_OBJ_PARAM.P_DEPT_CD);
 		$("#TEAM_CD").data("kendoSEDropDownList").value(_OBJ_PARAM.P_TEAM_CD);
 		$("#POSITION").data("kendoSEDropDownList").value(_OBJ_PARAM.P_POSITION);

		if(!gfn_IsNull(EVAL_DATA_LIST)){
			
			if(!gfn_IsNull(EVAL_DATA_LIST.EVAL_SCORE)){
				$("#EVAL_SCORE").text(EVAL_DATA_LIST.EVAL_SCORE);
			}
			if(!gfn_IsNull(EVAL_DATA_LIST.TOT_SCORE)){
				$("#TOT_SCORE").text(EVAL_DATA_LIST.TOT_SCORE);
			}
			if(!gfn_IsNull(EVAL_DATA_LIST.EVAL_EDU_COMPLETE)){
				$("#EVAL_EDU_COMPLETE").val(EVAL_DATA_LIST.EVAL_EDU_COMPLETE);
			}
			if(!gfn_IsNull(EVAL_DATA_LIST.CMT)){
				$("#CMT").val(EVAL_DATA_LIST.CMT);
			}
			if(!gfn_IsNull(EVAL_DATA_LIST.APP_REMARK)){ 
				$("#APP_REMARK").val(EVAL_DATA_LIST.APP_REMARK);
			}
			if(!gfn_IsNull(EVAL_DATA_LIST.EVAL_SAVE_EDU_COMPLETE)){ 
		 		$("#EVAL_SAVE_EDU_COMPLETE").val(EVAL_DATA_LIST.EVAL_SAVE_EDU_COMPLETE);
			}
	 		$("input[name=EVAL_WORK_KNOWLEDGE]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_WORK_KNOWLEDGE);
	 		$("input[name=EVAL_WORK_TEAM]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_WORK_TEAM);
	 		$("input[name=EVAL_WORK_SOLUTION]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_WORK_SOLUTION);
	 		$("input[name=EVAL_INNOVATION_JOIN]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_INNOVATION_JOIN);
	 		$("input[name=EVAL_WORK_LEADERSHIP]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_WORK_LEADERSHIP);
	 		$("input[name=EVAL_ADD_EXC_EMP_SCORE]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_ADD_EXC_EMP_SCORE);
	 		$("input[name=EVAL_ADD_CON_SCORE]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_ADD_CON_SCORE);
	 		$("input[name=EVAL_ADD_PRO_SCORE]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_ADD_PRO_SCORE);
	 		$("input[name=EVAL_ADD_LANG_SCORE]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_ADD_LANG_SCORE);
	 		$("input[name=EVAL_ADD_ADJUNCT_SCORE]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_ADD_ADJUNCT_SCORE);
	 		$("input[name=EVAL_PENALTY_IMG_DMG]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_PENALTY_IMG_DMG);
	 		$("input[name=EVAL_PENALTY_REPRIMAND]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_PENALTY_REPRIMAND);
	 		$("input[name=EVAL_WORK_KNOWLEDGE]").data("kendoSEDropDownList").value(EVAL_DATA_LIST.EVAL_WORK_KNOWLEDGE);
		}
		if(_OBJ_PARAM.P_STEP != 'I'){
			$("#DEPT_SIGN_NM").text(DEPT_EMP_CD.UP_EMP_NM);
			$("#btn_save").hide();
			$("#btn_next").hide();
			$("#btn_print").show();
			fn_lock();
			
		}
		
    	fn_user_auth(gAuth_POSITION[0]);    	
    	fn_searchFile(); 
 	 }

	/**********************************************************************************
     * Function    : fn_validation
     * Description : 다음버튼 validation
     * parameter   : 
     * return      : 
    **********************************************************************************/
  	function fn_validation(){

    	if(gfn_IsNull(EVAL_DATA_LIST)){
      		return false;
      	}
      	else{
	  		if(gfn_IsNull(EVAL_DATA_LIST.EVAL_WORK_KNOWLEDGE)){
				return false;
	  	  	}
	  	  	else if(gfn_IsNull(EVAL_DATA_LIST.EVAL_WORK_TEAM)){
				return false;
		  	}
	  	  	else if(gfn_IsNull(EVAL_DATA_LIST.EVAL_WORK_SOLUTION)){
				return false;
		  	}
	  	  	else if(gfn_IsNull(EVAL_DATA_LIST.EVAL_INNOVATION_JOIN)){
				return false;
		  	}
	  	  	else if(gfn_IsNull(EVAL_DATA_LIST.EVAL_WORK_LEADERSHIP)){
				return false;
		  	}
	  	    else if(gfn_IsNull(EVAL_DATA_LIST.EVAL_SAVE_EDU_COMPLETE)){ 
				return false;
	  	  	}
	  	  	else if(gfn_IsNull(EVAL_DATA_LIST.CMT)){
				return false;
	  	  	}
	  	  	else{
				return true;
	  	  	}
      	}
  	  	
    }

    /**********************************************************************************
     * Function    : fn_print 
     * Description : 출력
     * parameter   : 
     * return      : 
     **********************************************************************************/
  	function fn_print() {
		var param1 = '';
    	
    	for(var i = 0; i < ACHI_CAPA_LIST.length; i++){
    		var P = "Y"+(i+1); 
    		param1 += "|"+P+"|"+ACHI_CAPA_LIST[i].CAL_YEAR;
    	}
    	 
    	var param = "EMP_CD|"+_OBJ_PARAM.P_EMP_CD;
			param+= "|EANN|"+_OBJ_PARAM.P_EANN;
			param+= "|TYPE|"+_OBJ_PARAM.P_TYPE;
			param+= param1;
			param+= "|SIGN_PATH|"+self.location.protocol + '//' + self.location.host+DEPT_EMP_CD.UP_SIGN_DIR;
		var popup = Global.showUbiPopup("ubi_per_G6.jrf","평가서 출력",param,1200,800);
		popup.open();
    	 
//     	$("#divCommonBtnArea").css("display","none");
    	
// 	  	var draw = kendo.drawing;
		
// 	    draw.drawDOM($("body")).then(function (group) {
		
// 			return draw.exportPDF(group, {
				
// 			});	
// 		})
// 		.done(function(data){
// 			 kendo.saveAs({
// 		            dataURI:  data,
// 		            fileName: _OBJ_PARAM.P_EMP_NM+"_승진평가서.pdf"
// 		     });
// 		});

		
// 	    window.setTimeout(function(){
// 	    	$("#divCommonBtnArea").css("display","inline-block");

// 	  	},2000);
	  	
	}
    
  	
  	/**********************************************************************************
     * Function    : fn_addFile 
     * Description : 파일업로드
     * parameter   : 
     * return      : 
     **********************************************************************************/
 	function fn_addFile(obj){
    	 
 		var rkey = "new_" + Math.floor(Math.random() * 100000000);	//random 수를 임시키로 사용함
 	 	obj.files[0].keyVal = rkey;
 		ARR_ADD_FILE.push(obj.files[0]);
 		
 		var temp = new Object();
 		temp.FILE_NO =  rkey;
 		temp.UP_TYPE =  "DIRECT";
 		temp.BIZ_TYPE = v_BIZ_GB; //업무구분
 		temp.FILE_ORIGINAL_NAME = obj.files[0].name;
 		temp.FLAG = "I";
 		
 		var tempArr = new Array();
 		tempArr.push(temp);
 		
 		fn_setFile(tempArr);
 		$("#up_file").val("");
 	}
    
  	/**********************************************************************************
     * Function    : fn_setFile 
     * Description : 파일첨부 그리기
     * parameter   : obj, up_type(DIRECT(직접첨부-조회), SEARCH(검색첨부-조회), NEW(신규-등록))
     * return      : 
     **********************************************************************************/
	function fn_setFile(arrFile){
		 
		 var old_idx = $("span [id^='file_']").length;
	 
		for(var i=0; i<arrFile.length; i++){
		 	
	  		var fitem = arrFile[i];
	  		var fname = fitem.FILE_ORIGINAL_NAME.substring(0, fitem.FILE_ORIGINAL_NAME.indexOf("."));
	  		var fext  = fitem.FILE_ORIGINAL_NAME.substring(fitem.FILE_ORIGINAL_NAME.indexOf(".")+1);
	  		ARR_FILE_LIST.push(fitem);
	  		
	  		var fileAttach = new StringBuffer();
	  		
			switch(fext) {
		 		case "csv":
		 		case "xls":
		 		case "doc":
		 		case "mdb":
		 		case "ppt":
		 		case "pdf":
		 		case "psd":
		 			break;
		 		case "xlsx":
		 			fext = "xls";
		 			break;
		 		case "docx":
		 			fext = "doc";
		 			break;
		 		case "pptx":
		 			fext = "ppt";
		 			break;
		 		case "zip", "alz", "7z", "rar":
		 			fext = "zip";
		 			break;
		 		default:
		 			fext = "txt";
		 			break;
		 	}
			fileAttach.append("<span id=\"file_"+(old_idx+i)+"\">");
		 	fileAttach.append(	"<span class=\"k-icon k-i-file-"+fext+"\" style=\"color:#000; width: 16px; cursor: pointer;\"></span>");
		 	if(fitem.FLAG == "I") {
		 		fileAttach.append(	"<span style=\"vertical-align:middle; font-weight: bold; padding-left: 3px;\">"+fitem.FILE_ORIGINAL_NAME+"</span>");	
		 	} else {
		 		fileAttach.append(	"<span onclick=\"fn_filedownload('" + fitem.UPFILE_LIST_ID + "','" +fitem.FILE_NO + "','" + fitem.REF_CD3 + "','" + fitem.REF_CD4 + "','" + fitem.REF_CD5 + "')\""
			               + " class=\"attach-link-style2\">"+fitem.FILE_ORIGINAL_NAME+"</span>");
		 	}
	   	 	fileAttach.append(	"<span onclick=\"fn_removeFile("+(old_idx+i)+");\" class=\"k-icon k-i-close k-i-x\" style=\"color:#000; width: 16px; cursor: pointer;\"></span>");
	   	 	fileAttach.append(	"<input type=\"hidden\" name=\"fileno\" value=\""+fitem.FILE_NO+"\"/>");
	   	 	fileAttach.append(	"<input type=\"hidden\" name=\"uptype\" value=\""+fitem.UP_TYPE+"\"/>");
	       	fileAttach.append(	"<input type=\"hidden\" name=\"biztype\" value=\""+fitem.BIZ_TYPE+"\"/>");
	       	fileAttach.append(	"<input type=\"hidden\" name=\"flag\" value=\""+fitem.FLAG+"\"/>");
	       	fileAttach.append("</span>");
	       	
		 	$("#file_list").append(fileAttach.toString());
		}
		
		$( window).trigger('resize');
	
	}
  	
	/**********************************************************************************
	 * Function    : fn_removeFile 
	 * Description : 파일첨부 삭제 
	 * parameter   : obj, item
	 * return      : 
	 **********************************************************************************/
	function fn_removeFile(idx){
		//file_list
		var $tr = $("#file_"+idx);
		var fitem = new Object();
		
		fitem.FILE_NO = $tr.find("input[name='fileno']").val();
		fitem.UP_TYPE = $tr.find("input[name='uptype']").val();
		fitem.BIZ_TYPE = $tr.find("input[name='biztype']").val();
		fitem.FLAG = $tr.find("input[name='flag']").val();
		
		if(fitem.UP_TYPE == "DIRECT"){
			if(fitem.FLAG == "I"){
	  	  		var idx=-1;
	  	  		ARR_ADD_FILE.forEach(function(value, index){
	  	  			if(value.keyVal == fitem.FILE_NO) {
	  	  				idx = index;
	  	  			}
	  	  		});
	  	  		ARR_ADD_FILE.splice(idx, 1); //파일추가 삭제
	  	  		
	  	  		idx=-1;
	  			ARR_FILE_LIST.forEach(function(value, index){
	  				if(value.FILE_NO == fitem.FILE_NO) {
	  					idx = index;
	  				}
	  			});
	  			ARR_FILE_LIST.splice(idx, 1);  				
			} else {
	  			ARR_FILE_LIST.forEach(function(value, index){
	  				if(value.FILE_NO == fitem.FILE_NO) {
	  					value.FLAG = "D";
	  				}
	  			});  				
			}
		}
		
		$tr.remove();
	}
  	
	 /*******************************************************************************
	 * Function    : fn_uploadFile
	 * Description : 파일업로드 
	 * parameter   : 
	 * return      :   
	******************************************************************************/ 
	function fn_uploadFile(){
		 
		var gformData = new FormData();
			gformData.append('upload_biztype', 'NORMAL')
			gformData.append('user_id', "${login.USER_ID}");
			
		ARR_ADD_FILE.forEach(function(v, i){
			gformData.append('file[]', v);
			gformData.append('keyVal[]', v.keyVal);
		});
		
		$.ajax({		
			url: "/groupware/comm/FileUpload",
			data : gformData,
			type: "POST",
				contentType: false,
				processData: false,
		   	async:false,
			success : function (data) {
				if(data.RESULT == "OK") {
					data.ds_keyVal.forEach(function(value, index){
						for(var i=ARR_FILE_LIST.length-1; i>=0; i--){
							if(value.keyVal == ARR_FILE_LIST[i].FILE_NO) {
								ARR_FILE_LIST[i].FILE_PATH = value.FILE_PATH;
								ARR_FILE_LIST[i].FILE_ORIGINAL_NAME = value.FILE_ORIGINAL_NAME;
								ARR_FILE_LIST[i].FILE_SERVER_NAME = value.FILE_SERVER_NAME;
								ARR_FILE_LIST[i].FILE_EXT_NAME = value.FILE_EXT_NAME;
								break;
							}
						}
					});	
				} else {
					Global.showAlert("파일업로드에 실패하였습니다.");
					return;
				}
			}
		});
		 
	 }
	
	/*******************************************************************************
	 * Function    : fn_searchFile
	 * Description : 파일목록조회 
	 * parameter   : 
	 * return      :   
	******************************************************************************/ 
	function fn_searchFile(){
		 ARR_FILE_RQST_LIST = new Array();
		$.ajax({
			url:"/person/normal_file_list",
			type: "POST",
			data:{"PAGE_NAME":"regPromoteEvaluation_G6.jsp"
				 ,"EANN":_OBJ_PARAM.P_EANN
				 ,"TYPE":_OBJ_PARAM.P_TYPE
				 ,"EMP_CD":_OBJ_PARAM.P_EMP_CD}
			,async:false
			,success:function(data){
				//초기화
				ARR_FILE_LIST = [];
				ARR_ADD_FILE = [];
				$("#file_list").html("");
				
				if(data.RESULT=="SUCCESS"){
					if(data.RETURN_LIST.length > 0) {
						fn_setFile(data.RETURN_LIST);
						ARR_FILE_RQST_LIST = [];
  						ARR_FILE_RQST_LIST.push(v_BIZ_GB);
   	    				for(i=0; i<data.RETURN_LIST.length; i++) {
   	    					ARR_FILE_RQST_LIST.push(data.RETURN_LIST[i].UPFILE_LIST_ID);
   	    				}
						
					}
				}
			}
		});
		
	}
	 
	function fn_fileupload(){
		if(gAuth_POSITION[0].ATTRIBUTE1 == "_PER"){
			$("#up_file").click();
		} else {
			gfn_kendoMessageBox(null, null, '인사담당자만 첨부 가능합니다.', null, null);
		}
  		
  	}
	 
	/*******************************************************************************
	 * Function    : fn_filedownload
	 * Description : 파일다운로드  
	 * parameter   : 
	 * return      :   
	******************************************************************************/ 
	function fn_filedownload(upfilelistno, fileno, k3, k4, k5){
  		$.download2('/person/FileDownload','BIZ_GB='+v_BIZ_GB
  				+ '&KEY_FLD1=' + upfilelistno + '&KEY_FLD2=' + fileno + '&KEY_FLD3=' + k3 + '&KEY_FLD4=' + k4 + '&KEY_FLD5=' + k5, 'post', '');
  	}
	
	//Ajax 파일 다운로드
    jQuery.download2 = function(url, data, method, target){
        // url과 data를 입력받음
        if( url && data ){ 
        	// data 는  string 또는 array/object 를 파라미터로 받는다.
            data = typeof data == 'string' ? data : jQuery.param(data);
            // 파라미터를 form의  input으로 만든다.
            var inputs = '';
            jQuery.each(data.split('&'), function(){ 
                var pair = this.split('=');
                inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
            });
            // request를 보낸다.
            jQuery('<form action="'+ url +'" method="'+ (method||'post') +'" target="'+target+'">'+inputs+'</form>')
            .appendTo('body').submit().remove();
        };
    };
    
  	
  	</script>
</head>
<body>
<!--------------------------------------------------------------------
     	- 타이틀 영역 시작
     	--------------------------------------------------------------------->
		<div id="divTitleArea" class="hts_01">
			<h1><img src="/resources/hts/images/title_icon.png"><span>승 진 평 가 서 (G6 -> 임원)</span></h1>
			<div id="divCommonBtnArea" class="search_btn_arr" style="top:3px;">
				<button id="btn_save" class="k-button" onclick="fn_save()" style="vertical-align:top; ">저 장</button>
				<button id="btn_next" class="k-button" onclick="fn_next()" style="vertical-align:top; ">완 료</button>
				<button id="btn_print" class="k-button" onclick="fn_print()" style="vertical-align: top; display:none;">인 쇄</button>
				<button id="btn_close" class="k-button" onclick="fn_close()" style="vertical-align:top;">닫 기</button>
			</div>
		</div>
		<!--------------------------------------------------------------------
     	- 타이틀 영역 끝
     	--------------------------------------------------------------------->
     	
		<!--------------------------------------------------------------------
     	- 검색조건 영역 시작
     	--------------------------------------------------------------------->  
		<div id="divSearchArea" class="hts_02">					
			<div class="search_outline" ></div>
		</div>
		<!--------------------------------------------------------------------
     	- 검색조건 영역 끝
     	--------------------------------------------------------------------->  
     	
     	
     	<!--------------------------------------------------------------------
     	- 그리드 영역 시작
     	--------------------------------------------------------------------->
			<div id="divMstGridArea" class="hts_03" style="width:100%;">
				<div id="main-content" class="pdf-page"></div>
				
			</div>
		
		<!--------------------------------------------------------------------
     	- 그리드 영역 끝
     	--------------------------------------------------------------------->
     	
</body>
</html>