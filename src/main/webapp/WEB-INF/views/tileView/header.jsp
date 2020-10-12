<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<header class="navbar navbar-expand-lg navbar-light" style="border-bottom: 1px solid #f0f0f0;">
	<a class="navbar-brand" href="/main/main">
		<img src="/resources/images/logo/main_logo.jpg" style="height: 100px;" class="d-inline-block align-top">
	</a>
	<h1>Title</h1>
	<ul class="navbar-nav mr-auto">
		<img src=""/>
		<li class="nav-item"><a class="nav-link" href="#"></a></li>
		<li class="nav-item"><a class="nav-link" href="#"></a></li>
		<li class="nav-item"><a class="nav-link" href="#"></a></li>
	</ul>
	<form class="form-inline">
		
		<div class="input-group mb-3">
			<input type="text" class="form-control" placeholder="통합검색" aria-label="통합검색" aria-describedby="button-search">
			<div class="input-group-append">
				<button class="btn btn-outline-secondary" type="button" id="button-search">검색</button>
			</div>
		</div>
	</form>
	<a class="slash-circle-fill" href="#" id="btnLogout" style="margin-left:20px;">
		<svg width="4em" height="4em" viewBox="0 0 16 16" class="bi bi-x-circle-fill" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
  			<path fill-rule="evenodd" d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293 5.354 4.646z"/>
		</svg>
	</a>
</header>
