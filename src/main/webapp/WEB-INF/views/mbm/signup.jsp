<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">

	$(document).ready(function(){
		if($("#PW").val() != $("#PW_CK").val()){
			$("#PW_MENT").val("비밀번호가 다릅니다여");
		}
	})
	
	
	function fn_Id_Validation(val){
		var exp = "^[a-zA-Z0-9]*$";
		var check = true;
		if(!val.match(exp)){
			check = false;
			
		}
		console.log("id 체크");
		console.log(check);
		return check;
	}
	
	function fn_Pw_Validation(){
		var check = true;
		if($("#PW").val() != $("#PW_CK").val()){
			check = false;
		}
		console.log("pw 체크");

		return check;
	}
	
	function fn_signUp(){
		var pw_ck = fn_Pw_Validation();
		
		if(pw_ck == false){
			return alert("패스워드 확인해라");
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
		alert("취소");
	}
	function fn_reset(){
		alert("리셋");
	}
</script>
</head>
<body>
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
</body>
</html>