<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">

	$(document).ready(function(){
		$("#btnLogout").hide();
		if($("#PW").val() != $("#PW_CK").val()){
			$("#PW_MENT").val("비밀번호가 다릅니다여");
		}
	})
	
	
	function fn_Id_Validation(){
		var exp = "^[a-zA-Z0-9]*$";
		var id = $("#ID").val();
		var check = new RegExp(exp);
		console.log("id 체크");
		console.log(check.test(id));
		return check.test(id);
	}
	
	function fn_Pw_Validation(){
		var check = true;
		if($("#PW").val() != $("#PW_CK").val()){
			check = false;
		}
		console.log("pw 체크");
		console.log(check);

		return check;
	}
	function fn_inputValidation(){
		var id = $("#ID").val();
		var pw = $("#PW").val();
		var pw_ck = $("#PW_CK").val();
		var email = $("#EMAIL").val();
		var address = $("#ADDRESS").val();
		var check = true;
		if(id=='' || pw==''||pw_ck=''||email==''||address==''){
			check = false;
		}
		return check;
	}
	
	function fn_signUp(){
		var pw_ck = fn_Pw_Validation();
		var id_ck = fn_Id_Validation();
		var ip_ck = fn_inputValidation();
		if(!id_ck){
			return alert("아이디 확인해라");
		}
		if(!pw_ck){
			return alert("패스워드 확인해라");
		}
		if(!ip_ck){
			return alert("모두 입력해라");
		}
		
		$.ajax({
			url :'/mbm/signUp_POST',
			data : {
				"ID" : $("#ID").val(),
				"PW" : $("#PW").val(),
				"EMAIL" : $("#EMAIL").val(),
				"ADDRESS" : $("#ADDRESS").val(),
				"PHONE" : $("#PHONE").val()
			},
			dataType :'json',
			type :'POST',
			success:function(data){
				console.log("가입성공");
				console.log(data);
				if(data.KEY == "OK"){
					window.location.href="/";
				}else{
					alert(data.USERALERT);
				}
				
					
			}
			
		});
	}
	function fn_cancel(){
		location.href="/";
	}
	function fn_reset(){
		$("#ID").val("");
		$("#PW").val("");
		$("#PW_CK").val("");
		$("#EMAIL").val("");
		$("#ADDRESS").val("");
	}
</script>
	<div style="position:absolute; top:40%; left:40%;">
		<table>
			<tr>
				<th>아이디</th>
				<td><input type="text" id="ID" required></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" id="PW" required></td>
				<td></td>
			</tr>
			<tr>
				<th>비밀번호 확인</th>
				<td><input type="password" id="PW_CK" required></td>
				<td><span id="PW_MENT"></span></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="text" id="EMAIL" required></td>
				<td>
					<select>
						<option>naver.com</option>
						<option>google.com</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>주소</th>
				<td><input type="text" id="ADDRESS" required></td>
				<td></td>
			</tr>
			<tr>
				<th>핸드폰</th>
				<td><input type="text" id="PHONE" required></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="3">
					<button onclick="fn_signUp()">확인</button>
					<button onclick="fn_cancel()">취소</button>
					<button onclick="fn_reset()">초기화</button>
				</td>
			</tr>
		</table>
	</div>
