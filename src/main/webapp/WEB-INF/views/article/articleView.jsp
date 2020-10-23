<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<<script type="text/javascript">
	var FILELIST = '${FILELIST}';
	var FILE_LIST_ARR = ${FILE_LIST_ARR};
	var fileBuffer = [];
	
	$(document).ready(function(){
		
		Array.prototype.push.apply(fileBuffer, FILE_LIST_ARR);
		
		$("#file_upload").change(function(){
			fileBuffer = [];
	        const target = document.getElementsByName('files[]');
	        Array.prototype.push.apply(fileBuffer, target[0].files);
	        var html = '';
	        $.each(fileBuffer, function(index, file){
	        	var type = file.type;
	        	type = type.substr(0,type.indexOf("/"));
	            const fileName = file.name;
	            html += '<div class="file">';
	            if(type == "image"){
	            	html += '<img style="width:400px" src="'+URL.createObjectURL(file)+'">'
	            }else if (type == "video"){
	            	html += '<video style="width:400px" src="'+URL.createObjectURL(file)+'" controls>지원하지 않는 브라우저</video>'
	            }
	            html += '<span>'+fileName+'</span>';
	            html += '<a href="#" id="removeImg">╳</a>';
	            html += '</div>';
	            const fileEx = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
	            if(fileEx != "jpg" && fileEx != "ogv" && fileEx != "png" &&  fileEx != "gif" && fileEx != "mp4" && fileEx != "avi"){
	                alert("파일은 (jpg, ogv, png, gif, mp4, avi) 형식만 등록 가능합니다.");
	                resetFile();
	                return false;
	            }
	            $('.fileList').html(html);
	        });
	        
		});
// 		$("#btnUPDATE").hide();
		$("#btnUPDATE").click(function(){
			
			var formdata=new FormData();
			formdata.append("ACTICLE_CD",'${ARTICLE.ARTICLE_CD}');
			formdata.append("REGISTRANT_ID",'${ARTICLE.REGISTRANT_ID}');
// 			formdata.append("TITLE",TITLE);
// 			formdata.append("DESCRIPTION",DESCRIPTION);
			formdata.append("file[]",fileBuffer);
			console.log("data");
			console.log(fileBuffer);
			console.log(formdata);
			$.ajax({
				url : "/article/update",
				data : formdata,
		        type : "POST",
		        enctype : "multipart/form-data",
		        processData: false,
		        contentType: false,
		        async : false,
				success : function(data){
					console.log("업뎃 성공");
				}
				
			});
		})
		$(document).on('click', '#removeImg', function(){
		    const fileIndex = $(this).parent().index();
		    fileBuffer.splice(fileIndex,1);
		    $('.fileList>div:eq('+fileIndex+')').remove();
		});
		
	})
</script>

<h1>articleView 페이지</h1>
<div>
	<h2>ID : ${USERINFO.ID}</h2>
	<h2>EMAIL : ${USERINFO.EMAIL}</h2>
	<h2>PHONE : ${USERINFO.PHONE}</h2>
	<h2>TITLE : ${ARTICLE.TITLE}</h2>
	<h2>ARTICLE_CD : ${ARTICLE.ARTICLE_CD}</h2>
</div>

<div>
	<a href="#" id="btnUPDATE">수정</a>
</div>
<div>
	<h1>게시</h1>
</div>
<div style="width:30%; height:33px; float:right;">
	<form id="frm" name="frm" enctype="multipart/form-data" method="post" >
		<input type="file" multiple="multiple" name="files[]" id="file_upload" />
	</form>
</div>
<div class="fileList">
<c:forEach var="item" items="${FILELIST}" varStatus="status">
		<c:choose>
			<c:when test="${item.FILE_TYPE eq 'image'}">
				<div class="file">
					<img src="/file_path/${item.FILE_NM}" style="width:200px;"/><a href="#" id="removeImg">╳</a>
				</div>
			</c:when>
			<c:otherwise>
				<div class="file">
					<video src="/file_path/${item.FILE_NM}" style="width:200px;" controls></video><a href="#" id="removeImg">╳</a>
				</div>
			</c:otherwise>
		</c:choose>
</c:forEach>
</div>
