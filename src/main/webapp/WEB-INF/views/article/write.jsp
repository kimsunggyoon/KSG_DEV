<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
	$(document).ready(function(){
		$("#save").click(function(){
			fn_save();
		})
		$("#cancel").click(function(){
			if(confirm("취소하실꺼?")){
				location.href="/main/main";
			}
		})
		$("#file_upload").change(function(){
			console.log("file change")
			fileBuffer = [];
	        const target = document.getElementsByName('files[]');
	        console.log(target[0].files)
	        Array.prototype.push.apply(fileBuffer, target[0].files);
	        var html = '';
	        $.each(target[0].files, function(index, file){
	            const fileName = file.name;
	            html += '<div class="file">';
	            html += '<img style="width:400px" src="'+URL.createObjectURL(file)+'">'
	            html += '<span>'+fileName+'</span>';
	            html += '<a href="#" id="removeImg">╳</a>';
	            html += '</div>';
	            const fileEx = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
	            if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp" && fileEx != "wmv" && fileEx != "mp4" && fileEx != "avi"){
	                alert("파일은 (jpg, png, gif, bmp, wmv, mp4, avi) 형식만 등록 가능합니다.");
	                resetFile();
	                return false;
	            }
	            $('.fileList').html(html);
	        });
	        
		});
	
	})
	function fn_fileUpload(){
		
		var UUID = '${UUID}';
		var ID = '${USERINFO.ID}';
		var TITLE = $("#TITLE").val();
		var DESCRIPTION = $("#DESCRIPTION").val();

		console.log(typeof data);
    	const target = document.getElementsByName('files[]');
		var formdata=new FormData();
		formdata.append("ACTICLE_CD",UUID);
		formdata.append("REGISTRANT_ID",ID);
		formdata.append("TITLE",TITLE);
		formdata.append("DESCRIPTION",DESCRIPTION);
		$.each(target[0].files, function(index, file){
			formdata.append("file[]",file);
		});
	    
	    $.ajax({
	        url : "/main/fileUpload",
	        data : formdata,
	        type : "POST",
	        enctype : "multipart/form-data",
	        processData: false,
	        contentType: false,
	        async : false,
	        success : function(data){
	            if(data.KEY =="OK"){
	            	location.href="/main/main";
	            	
	            }else{
	            	alert(data.USERALERT);
	            }
	        }
	    });
	}
	
	$(document).on('click', '#removeImg', function(){
	    const fileIndex = $(this).parent().index();
	    fileBuffer.splice(fileIndex,1);
	    $('.fileList>div:eq('+fileIndex+')').remove();
	});

	function fn_save(){
		if(confirm("저장하실꺼?")){
// 			article_Upload();
			fn_fileUpload();
		}
	}
</script>
<div style="width:99%; text-align:center;" >
	<div>
		<div style="width:80%; margin:0px; float:left;">
			<h1>쓰기</h1>
		</div>
		<div style="width:10%; float:right;">
			<a href="#" id="save">저장</a>
			<a href="#" id="cancel" style="margin-left:10px;">닫기</a>
		</div>
		<div style="width:99%; display:flex; justify-content:center;">
			<div style="width:70%;">
				<table style="width:99%; margin:0 auto; ">
					<colgroup>
						<col width="20%">
						<col width="80%">
					</colgroup>
					<tr>
						<th>TITLE</th>
						<td><input type="text" id="TITLE" name="TITLE" style="width:100%;"></td>
					</tr>
					<tr>
						<th>ID</th>
						<td>${USERINFO.ID}</td>
					</tr>
					<tr>
						<th>EMAIL</th>
						<td>${USERINFO.EMAIL}</td>
					</tr>
					<tr>
						<th>PHONE</th>
						<td>${USERINFO.PHONE}</td>
					</tr>
					<tr>
						<th>DESCRIPTION</th>
						<td><textarea name="DESCRIPTION" id="DESCRIPTION" style="resize:none; width:100%; height:300px;"></textarea><td>
						
					</tr>
				</table>
			</div>
			<div style="width:30%; height:33px; float:right;">
				<form id="frm" name="frm" enctype="multipart/form-data" method="post" >
					<input type="file" multiple="multiple" name="files[]" id="file_upload" />
				</form>
			</div>
		</div>
	</div>
	<div class="fileList"></div>
</div>
