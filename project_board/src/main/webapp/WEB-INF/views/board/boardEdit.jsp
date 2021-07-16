<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content ="width=device-width, initial-scale=1"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>	
		<!-- include libraries(jQuery, bootstrap) -->
		<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
		<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
		
		<!-- include summernote css/js -->
		<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/boardStyle.css">
</head>
<script>

$(function(){
	
		//글자 수 입력 표시 및 제한
		$("#subject").keyup(function(){
			var content = $(this).val();//입력된 상품명의 value
			var count = content.length;
			$('#count').html(count);
			
			if(count>100){
				alert('제목은 최대 100자까지 입력 가능합니다.').
				$(this).val(content.substring(0,100));
				$('#count').html(100);
			}
		});
	//서머노트
	 $('#summernote').summernote({
		height: 500,    
		focus: true,
		lang: "ko-KR",	
		placeholder: '최대 2048자까지 쓸 수 있습니다',	
		//콜백 함수
	    callbacks : { 
	      onImageUpload : function(files, editor, welEditable) {
	      // 파일 업로드(다중업로드를 위해 반복문 사용)
		      for (var i = files.length - 1; i >= 0; i--) {
		      uploadSummernoteImageFile(files[i],
		      this);
		      }
	      }
	    }
	 });

	//유효성 검사
	$("#boardEditFrm").on('submit',function(){
		//공백 제거
		$.trim($('#subject').val());
		//공백 유효성검사
		if($("#subject").val().trim()==""){
			alert("제목을 입력하세요.")
			$("#subject").focus();
			return false;
		}
		if($("#userid").val().trim()==""){
			alert("작성자를 입력하세요.")
			$("#userid").focus();
			return false;
		}
		//유효성검사
		var idreg = /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|]+$/;
		var none=/^<p>(\s*&nbsp;\s*)*<\/p>$/ig;
		if($('#userid').val().length()>10 ){
			alert("작성자는 6자 미만으로 입력해주세요.");
			return false;
			$('#userid').focus(); 	
		}
		if($('#subject').val()==''){
			alert("제목을 입력해주세요.");
			$('#subject').focus(); 
			return false;
		}
		if($('#subject').val()==null ){
			alert("제목을 다시 입력해주세요.");
			$('#subject').focus(); 
			return false;
		}
		if($('#userid').val()==''){
			alert("작성자를 입력해주세요.");
			$('#userid').focus(); 
			return false;
		}
		if($('#userid').val()==null){
			alert("작성자를 입력해주세요.");
			$('#userid').focus(); 
			return false;
		}
	
		if($('#userpwd').val()==''){
			alert("비밀번호를 입력해주세요.");
			$('#userpwd').focus(); 
			return false;
		}
		if($('#userpwd').val()==null){
			alert("비밀번호를 다시 입력해주세요.");
			$('#userpwd').focus(); 
			return false;
		}
		//summernote
		var content = $($("#content").summernote("code")).text();
		
		if(content.trim()==""){
			alert("내용을 입력해주세요.")	
			$('#content').summernote('focus');
			return false;
		}
		if ($('#content').summernote('isEmpty')) {
			alert("내용을 입력해주세요.");
			$('#summernote').focus(); 
			$('#content').summernote('focus');
			return false;
		}

		return true; 
		});
	//목록 돌아가기
	$(function(){
		$("#returnList").click(function(){
			if(confirm("목록으로 돌아가시겠습니까?")){
				//location.href='/boardList';
				if($('#userpwd').val()==''){
					alert("비밀번호를 입력해주세요.");
					//비밀번호 확인하는 함수 추가하기 
					$('#userpwd').focus(); 
					return false;
				}
				history.back();
			}else{
				return false;
			}
		});
	});
});

</script>
<style>
	.btnLine{margin-top:10px;}

	.label{
		font-weight:bold;
		margin:10px 0 10px;
	}	
	h2{margin-bottom:40px;}
	li{margin-bottom:20px;}
	
</style>
<body>
	<div class="container">
	<h2>게시판</h2>
		<form method="post" name="boardEditFrm" id="boardEditFrm" action="boardEditOk">
			<input type="hidden" name="no" value="${vo.no}"/>
			<ul>
				<li class="menu"><label class="label">제목</label><input type="text" name="subject" id="subject" value="${vo.subject }" class="wordcut" size="100"  maxlength="100"/>&nbsp;<span id="count"></span>/<span id="max_count">100</span><br/></li>
				<li><label class="label">작성자</label> <input type="text" name="userid" id="userid"  value="${vo.userid}" maxlength="6"></li>
				<li><label class="label">비밀번호</label><input type="password" name="userpwd" id="userpwd" class="wordcut" maxlength="4" value="${vo.userpwd}"></li>
				<li><textarea id="summernote" name="content" id="content">${vo.content}</textarea>
				<li id="btnLine">
					<input type="submit" value="수정하기" class="btn"/>
					<input type="button" value="목록" class="btn" id="returnList"/>
				</li>
			</ul>
		</form>
	</div>
</body>
</html>