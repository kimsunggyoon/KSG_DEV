<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<script src = "../../../resources/js/jquery.form.min.js"></script>
<script type="text/javascript">

	var USER_ID = '${USER_ID}';

</script>
<div style="width:100%; border:1px solid red;">
	<div style="float:right;">
		<a href="/main/write" id="write">쓰기</a>
	</div>
	<div>
		<h1>Main Page</h1>
		<c:if test="${!empty USERINFO}">
			<p>유저 ID :  ${USERINFO.ID}</p>
			<p>유저 EMAIL :  ${USERINFO.EMAIL}</p>
			<p>유저 ADDRESS : (${USERINFO.ADDRESS_NO}) ${USER_INFO.ADDRESS}</p>
			<p>유저 PHONE:  ${USERINFO.PHONE}</p>
		</c:if>
	</div>
	<div>
		<table>
			<tr>
				<th>순서</th>
				<th>No.</th>
				<th>제목</th>
				<th>등록자</th>
				<th>등록일</th>
			</tr>
			<c:forEach var="item" items="${ART_LIST}" varStatus="status">
				<tr>
					<th><c:out value="${status.index}"></c:out></th>
					<th><c:out value="${item.ART_SEQ}"></c:out></th>
					<th><c:out value="${item.TITLE}"></c:out></th>
					<th><c:out value="${item.REGISTRANT_ID}"></c:out></th>
					<th><c:out value="${item.REGISTRANT_DT}"></c:out></th>
				</tr>
			</c:forEach>
		</table>
	</div>
	
</div>

