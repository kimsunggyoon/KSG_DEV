<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script
  src="https://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
<script>
	var USERINFO = JSON.parse(JSON.stringify('${MEMINFO}'));
	
	$(document).ready(function(){
		$("#login").click(function(){
			fn_signIn();
		})
		$("#signup").click(function(){
			fn_signUp();
		})
	})
	function fn_signUp(){
		window.location.href='/mbm/signup';
	}
	function fn_init(){
		$("#TXT_ID").val("");
		$("#TXT_PW").val("");
	}
	function fn_signIn(){
		
		console.log("로그인 들어옴");
		var fData = $("#frm_login").serializeArray();
		$.ajax({
			url:'/common/login',
			data:fData,
			type:"POST",
			dataType:"json",
			success:function(data){
				console.log("로그인 성공");
				console.log(data);
				if(data.KEY == "OK"){
					window.location.href="/main/main"
					
				}else{
					fn_init();
					$("#TXT_ID").focus();
					alert(data.USERALERT);
				}
				
			}
		});
	}
</script>
</head>
<body>
	<dir style="position:absolute; top:40%; left:40%;">
		<form id="frm_login" name="frm_login" method="post">
			<table>
				<thead>
					<th colspan="2">로그인</th>				
				</thead>
				<tbody>
					<tr>
						<td><label for="TXT_ID">ID</label></td>
						<td><input type="text" id="TXT_ID" name="TXT_ID"></td>
					</tr>
					<tr>
						<td><label for="TXT_PW">PW</label></td>
						<td><input type="password" id="TXT_PW" name="TXT_PW"></td>
					</tr>
					<tr>
						<td colspan="2">
							<a href="#" id = "login">로그인</a>
							<a href="#" id = "signup">회원가입</a>
						</td>
					</tr>
				</tbody>
			</table>
		</form>	
	</dir>	
</body>
</html>