<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">
	var ID_CHECK = false;
	
	$(document).ready(function(){
		$("#btnLogout").hide();

		$("#ID").blur(function(){
			return fn_idCheck();
		});
		
		$("#EMAIL_CHOICE").change(function(){
			if($("#EMAIL_CHOICE").val() == "직접입력"){
				$("#END_EMAIL").attr("readonly",null);
			}else{
				$("#END_EMAIL").attr("readonly","readonly");
			}
			
			$("#END_EMAIL").val($("#EMAIL_CHOICE option:selected").val());
			
		})
		
		$("#signup").click(function(){
			fn_signUp();
		})
		$("#cancel").click(function(){
			fn_cancel();
		})
		$("#reset").click(function(){
			fn_reset();
		})
	});
	function fn_idCheck(){
		var id = $("#ID").val();
		console.log("아디 체크");
		console.log(id);
		$.ajax({
			url :'/mbm/idCheck',
			data : {"ID":id},
			dataType :'json',
			type :'POST',
			success:function(data){
				console.log("data");
				console.log(data);
				if(data.KEY == "OK"){
					$("#ID_MENT").text("중복있어요");
					ID_CHECK = false;
				}else{
					$("#ID_MENT").text("");
					ID_CHECK = true;
				}
			}
		});
	}
	function fn_Id_Validation(){
		var exp = "[a-zA-Z0-9]{4,15}";
		var id = $("#ID").val();
		var check = new RegExp(exp);
		return check.test(id);
	}
	function fn_Ph_Validation(){
		var exp = "[0-9]{10,11}";
		var ph = $("#PHONE").val();
		var check = new RegExp(exp);
		return check.test(ph);
	}
	
	function fn_Pw_Validation(){
		var check = true;
		if($("#PW").val() != $("#PW_CK").val()){
			check = false;
		}
		return check;
	}
	function pw_ck(){
		if(!fn_Pw_Validation()){
			$("#PW_MENT").text("비밀번호가 다릅니다여");
			
		}
		else{
			$("#PW_MENT").text("");
		}
	}
	function fn_inputValidation(){
		var id = $("#ID").val();
		var pw = $("#PW").val();
		var pw_ck = $("#PW_CK").val();
		var email = $("#EMAIL").val();
		var address = $("#ADDRESS").val();
		var address_no = $("#ADDRESS_NO").val();
		var check = true;
		if(id == "" || pw == "" || pw_ck == "" || email == "" || address == "" || address_no == ""){
			check = false;
		}
		return check;
	}
	
	function fn_signUp(){
		var pw_ck = fn_Pw_Validation();
		var id_ck = fn_Id_Validation();
		var ip_ck = fn_inputValidation();
		var ph_ck = fn_Ph_Validation();
		var email_choice = $("#EMAIL_CHOICE").val();
		if(!ip_ck){
			return alert("모두 입력해라");
		}
		if(!id_ck){
			return alert("아이디 확인해라");
		}
		if(!pw_ck){
			return alert("패스워드 확인해라");
		}
		if(!ph_ck){
			return alert("핸드폰번호를 확인햐");
		}
		if(!ID_CHECK){
			return alert("아이디 확인햐");
		}
		if(email_choice == "직접입력"){
			if($("#END_EMAIL").val() == "직접입력"){
				return alert("이메일을 확인하세요");
			}
		}
		
		var frmData = $("#frm_signup").serializeArray();
		console.log("폼데이타");
		console.log(frmData);
		$.ajax({
			url :'/mbm/signup',
			data : frmData,
			dataType :'json',
			type :'POST',
			success:function(data){
				if(data.KEY == "OK"){
					console.log(data);
					alert("회원가입 성공");
					window.location.href="/";
				}else{
					alert(data.USERALERT);
				}
			}
			
		});
	}
	function fn_cancel(){
		if(confirm("취소하시겟슴까여?")){
			location.href="/";
		}
	}
	function fn_reset(){
		if(confirm("초기화하시겠슴까여?")){
			$("#ID").val("");
			$("#PW").val("");
			$("#PW_CK").val("");
			$("#FRONT_EMAIL").val("");
			$("#ADDRESS").val("");
			$("#ADDRESS_NO").val("");
			$("#PHONE").val("");
			$("#EMAIL_CHOICE").val("google.com");
			$("#END_EMAIL").val("google.com");
		}
	}
	
	function goPopup(){
		// 주소검색을 수행할 팝업 페이지를 호출합니다.
		// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
		var pop = window.open("../../../popup/jusoPopup.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
		
		// 모바일 웹인 경우, 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
	    //var pop = window.open("/popup/jusoPopup.jsp","pop","scrollbars=yes, resizable=yes"); 
	}

	function jusoCallBack(roadFullAddr){
			// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.	
			$("#ADDRESS").val(roadFullAddr);		
	}
	function jusoNumCallBack(zipno){
			$("#ADDRESS_NO").val(zipno);		
	}
	
</script>
	<div style="position:absolute; top:40%; left:40%;">
		<form id="frm_signup" name="frm_signup" method="post">
			<table>
				<tr>
					<th>아이디</th>
					<td><input type="text" id="ID" name="ID" placeholder="4~15자리의 영문,숫자"></td>
					<td><span id="ID_MENT" style="color:red;"></span></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" id="PW" name="PW" onkeyup="javascript:pw_ck()"></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th>비밀번호 확인</th>
					<td><input type="password" id="PW_CK" onkeyup="javascript:pw_ck()"></td>
					<td><span id="PW_MENT" style="color:red;"></span></td>
				</tr>
				<tr>
					<th>이메일</th>
					<td><input type="text" id="FRONT_EMAIL" name="FRONT_EMAIL"></td>
					<td>
						<select id="EMAIL_CHOICE" name="EMAIL_CHOICE" value="google.com">
							<option>google.com</option>
							<option>naver.com</option>
							<option>직접입력</option>
						</select>
						<input type="text" id = "END_EMAIL" name="END_EMAIL" value="google.com" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th>우편번호</th>
					<td><input type="text" id="ADDRESS_NO" name="ADDRESS_NO" readonly></td>
					<td><button type="button" class="btn btn-warning" onclick="goPopup()">주소검색</button></td>
				</tr>
				<tr>
					<th>전체주소</th>
					<td colspan="2"><input type="text" id="ADDRESS" name="ADDRESS" readonly style="width:100%;"></td>
				</tr>
				<tr>
					<th>핸드폰</th>
					<td><input type="text" id="PHONE" name="PHONE" placeholder="-를 제외한 번호 입력"></td>
					<td></td>
				</tr>
				<tr>
					<td colspan="3">
						<a href="#" id="signup">확인</a>
						<a href="#" id="cancel">취소</a>
						<a href="#" id="reset">초기화</a>
					</td>
				</tr>
			</table>
		</form>
	</div>
