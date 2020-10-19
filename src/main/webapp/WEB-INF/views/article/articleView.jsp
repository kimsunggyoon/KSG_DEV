<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h1>articleView 페이지</h1>

<h2>ID : ${USERINFO.ID}</h2>
<h2>EMAIL : ${USERINFO.EMAIL}</h2>
<h2>PHONE : ${USERINFO.PHONE}</h2>
<h2>TITLE : ${ARTICLE.TITLE}</h2>
<h2>ARTICLE_CD : ${ARTICLE.ARTICLE_CD}</h2>
<table>
	
	<tr>
		<th>ㄱㄱㄱㄱ</th>
	</tr>
	<c:forEach var="item" items="${FILELIST}" varStatus="status">
		<tr>
			<td><img src="${item.FULL_PATH}"></td>
		</tr>
	</c:forEach>
</table>
