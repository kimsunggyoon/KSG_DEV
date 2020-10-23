<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<script type="text/javascript">

	var USER_ID = '${USER_ID}';

	$(document).ready(function(){
		$("#all_check").click(function(){
			if($("#all_check").prop("checked")){
				$("input[name=chk]").prop("checked",true);
			}else{
				$("input[name=chk]").prop("checked",false);
			}
		});
		$("#delete").click(function(){
			var arr = new Array();
			$("input[name=chk]:checked").each(function(){
				arr.push($(this).val());
			});
			
			$.ajax({
				url : "delete_Article",
				data : "ARTICLE_CD="+arr,
				dataType : "json",
				type : "POST",
				success : function(data){
					console.log("삭제성공");
					console.log(data);
					if(data.KEY == "OK"){
						history.go();
					}else{
						alert(data.USERALERT);
					}
				}
			});
			
		});
	});
</script>
<div style="width:100%; border:1px solid red;">
	<div style="float:right;">
		<a href="#" id="delete">지우기</a>
	</div>
	<div>
		<h1>My page</h1>
		<p>유저 ID :  ${USERINFO.ID}</p>
		<p>유저 EMAIL :  ${USERINFO.EMAIL}</p>
		<p>유저 ADDRESS : (${USERINFO.ADDRESS_NO}) ${USER_INFO.ADDRESS}</p>
		<p>유저 PHONE:  ${USERINFO.PHONE}</p>
	</div>
	<div>
		<table>
			<tr>
				<th><input type ="checkbox" id="all_check" ></th>
				<th>순서</th>
				<th>No.</th>
				<th>제목</th>
				<th>등록자</th>
				<th>등록일</th>
			</tr>
			<c:forEach var="item" items="${ART_LIST}" varStatus="status">
				<tr>
					<td><input type="checkbox" name="chk" value="${item.ARTICLE_CD}"></td>
					<td><c:out value="${status.index}"></c:out></td>
					<td><c:out value="${item.ART_SEQ}"></c:out></td>
					<td><a href="/article/articleView/${item.ART_SEQ}"><c:out value="${item.TITLE}"></c:out></a></td>
					<td><c:out value="${item.REGISTRANT_ID}"></c:out></td>
					<td><c:out value="${item.REGISTRANT_DT}"></c:out></td>
					
				</tr>
			</c:forEach>
		</table>
	</div>
	
</div>