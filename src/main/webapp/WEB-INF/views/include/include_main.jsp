<%@ page import="com.ksg.test.common.domain.CommonVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%
	String contextName = pageContext.getServletContext().getContextPath();
	HttpSession loginSession = request.getSession();

	CommonVO loginVO = (CommonVO) loginSession.getAttribute("login");
%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
<script
  src="https://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
<link href="<%=contextName%>/resources/css/style.css" rel="stylesheet">
<title>Insert title here</title>
</head>
<script type="text/javascript">

	$(document).ready(function(){
		
		$("#btnLogout").click(function(){
			fn_Logout();
		})
	})
	
	function fn_Logout(){
		if(confirm("로그아웃?")){
			fn_Logout_Confirm();
		}
	}
	
	function fn_Logout_Confirm(){
		location.href="/common/logout";
	}
	
</script>
<body>
	<div id="container">
			<div class="header">
				<div class="logo" style="float:left;">
				    <a  href="#">
				    	<img src="/resources/images/logo/main_logo.jpg" width="100px" >
				    </a>
				</div>
				<div class="logon_list" style=" float:right;">
					<nav>
					    <div  id="">
					        <ul>
					            <li><a href="#" id="btnLogout">Logout</a></li>
					        </ul>
					    </div>
					</nav>
				</div>		
			</div>		

			<div class="contents_area"></div>
			
			<div class="footer">
				<p>푸터용</p>
			</div>
			
		</div>
</body>
</html>