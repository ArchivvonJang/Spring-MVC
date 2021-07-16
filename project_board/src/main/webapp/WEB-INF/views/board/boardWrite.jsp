<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>write form</title>
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
	//목록 돌아가기
	$(function(){
		$("#returnList").click(function(){
			if(confirm("목록으로 돌아가시겠습니까?")){
				//location.href='/boardList';
				history.back();
			}else{
				return false;
			}
		});
	});

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
	
		
		$("#boardForm").on('submit',function(){
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
			//var check = password.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
			
			if($('#subject').val()==''){
				alert("제목을 입력해주세요.");
				return false;
				$('#subject').focus(); 
			}
			if($('#subject').val()== '&nbsp' ||$('#subject').val().equals('&nbsp')){
				alert("공백문자는 입력불가능합니다.");
				return false;
				$('#subject').focus(); 
			}
			if($('#subject').val()==null ){
				alert("제목을 다시 입력해주세요.");
				return false;
				$('#subject').focus(); 
			}
			
			if($('#userid').val()==''){
				alert("작성자를 입력해주세요.");
				return false;
				$('#userid').focus(); 			
			}
			if($('#userid').val()==null){
				alert("작성자를 입력해주세요.");
				return false;
				$('#userid').focus(); 	
			}
			if($('#userid').val().length()>10 ){
				alert("작성자는 6자 미만으로 입력해주세요.");
				return false;
				$('#userid').focus(); 	
			}
			if($('#userpwd').val()==''){
				alert("비밀번호를 입력해주세요.");
				return false;
				$('#userpwd').focus(); 	
			}
			if($('#userpwd').val()==null){
				alert("비밀번호를 다시 입력해주세요.");
				return false;
				$('#userpwd').focus(); 	
			}
			//비밀번호 4자리 숫자만 입력하도록 조건 걸어놓기
			if($("#userpwd").val().length()>5){
				alert("비밀번호는 4자리만 입력해주세요.");
				return false;
				$('#userpwd').focus(); 	
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
			//제목검사
			if(none.test(document.getElementById("subject").value)){
				alert("제목을 다시 입력해주세요.");
				return false;
			}
			if(!idreg.test(document.getElementById("subject").value)){
				alert("제목은 한글 또는 영어, 숫자로 입력해주세요");
				return false;
			}
			// 아이디 검사
			if(!idreg.test(document.getElementById("userid").value)){
				alert("작성자는 6~15자리 사이의 영어와 숫자만 사용할 수 있습니다.");
				return false;
			}
			if(none.test(document.getElementById("userid").value)){
				alert("작성자를 다시 입력해주세요.");
				return false;
			}
			// 비밀번호 검사
			if(!idreg.test(document.getElementById("userpwd").value)){
				alert("비밀번호는 4자리만 사용 가능합니다.");
				return false;
			}
			if(none.test(document.getElementById("userpwd").value)){
				alert("비밀번호를 다시 입력해주세요.");
				return false;
			}
		
			return true; 
		});
	});
	//초기화
	//
</script>
<style>
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
		<form method="post" name="boardForm" id="boardForm" action="boardWriteOk" >
			<ul>
				<li class="menu"><label class="label">제목</label><input type="text" name="subject" id="subject" class="wordcut" maxlength="100" size="100" />&nbsp;<span id="count"></span>/<span id="max_count">100</span><br/></li>
				<li><label class="label">작성자</label> <input type="text" name="userid" id="userid" class="wordcut" maxlength="6"/></li>
				<li><label class="label">비밀번호</label> <input type="password" name="userpwd" id="userpwd" maxlength="4" class="wordcut"/></li>
				<li><textarea id="summernote"  name="content" id="content"  maxlength="200"  placeholder="내용을 입력해주세요." rows="10" cols=""></textarea ></li>
				<li id="btnLine">
					<input type="submit" value="등록하기" class="btn"/>
					<!-- <input type="button" value="목록" class="btn" id="returnList" onClick="location.href='<%=request.getContextPath() %>/boardList'"/> -->
					<input type="button" value="목록" class="btn" id="returnList"/>
				</li>
			</ul>
		</form>
	</div>
</body>
</html>