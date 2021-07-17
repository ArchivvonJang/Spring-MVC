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
		//vo에서 가져온 글자 수 표시 count
		var subjectLength = "${vo.subject}";
		var useridLength = "${vo.userid}";
		var userpwdLength = "${vo.userpwd}";
		//길이표시
		$("#count").text(subjectLength.length);
		$("#useridLength").text(useridLength.length);
		$("#userpwdLength").text(userpwdLength.length);

		//글자 수 입력 표시 및 제한
		//제목
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
		$("#userid").keyup(function(){
			var content = $(this).val();//입력된 상품명의 value
			var count = content.length;
			$("#useridLength").html(count);
			
			if(count>=10){
				alert('작성자는 10글자까지 입력 가능합니다.').
				$(this).val(content.substring(0,10));
				$("#useridLength").html(10);
			}
		});
		$("#userpwd").keyup(function(){
			var content = $(this).val();//입력된 상품명의 value
			var count = content.length;
			$('#userpwdLength').html(count);
			
			if(count>=4){
				alert('비밀번호는 4자리까지 입력 가능합니다.').
				$(this).val(content.substring(0,4));
				$('#userpwdLength').html(4);
			}
			pwdCheck(obj, pwdAlert, clipboard);
		});
		$("#content").keyup(function(){
			var content = $(this).val();//입력된 상품명의 value
			var count = content.length;
			//$('#').html(count);
			
			if(count>=500){
				alert('글은 500자리까지 작성가능합니다.').
				$(this).val(content.substring(0,500));
			}
		});
		$("textarea").keyup(function(){
			var content = $(this).val();//입력된 상품명의 value
			var count = content.length;
			//$('#').html(count);
			
			if(count>=500){
				alert('글은 500자리까지 작성가능합니다.').
				$(this).val(content.substring(0,500));
			}
		}); //keyup end
	/* 	
		// 작성자
		userid.oninput = function(){
			var obj = $("#userid");
			var wordcheck = $("#useridLength");
			blankCheck(obj, '작성자')
			textCount(obj, txtcheck);
		}
		//비밀번호
		userpwd.oninput = function(e){
			var obj = $("#password");
			var wordcheck = $("#userpwdLength");
			var pwdMsg = $("#pwdApproval");
			
			blankCheck(obj, '비밀번호')
			textCount(obj, txtcheck);

		} */
	//========================= 서머노트 =================================
		 $('#summernote').summernote({
			height: 500,    
			focus: true,
			lang: "ko-KR",	
			placeholder: '내용을 입력해주세요. 최대 500자까지 쓸 수 있습니다',	
			maxlength: 500,
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
		 }); //summernote end

		//====================== submit 넘기기 전에 유효성 검사 ========================================	

			//정규식 유효성검사
			//var subcheck = subject.value.test(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
			//var pwdcheck = userpwd.value.test(pwdreg);
			//var idcheck = userid.value.test(idreg);		

});			
	$("#boardForm").on('submit',function(){
		//유효성검사
		var idreg = /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|]+$/;
		var pwdreg = /[0-9]$/;
		var none=/^<p>(\s*&nbsp;\s*)*<\/p>$/;
		//변수에 각 input의 value 담기	
		var subject = $('#subject').val(); 
		var userid = $('#userid').val();	
		var userpwd = $('#userpwd').val();
		var content = $('#content').val();
		console.log("subject : ", subject, " , userid : ", userid);
			//공백 제거
			$.trim($('#subject').val());
			
			//-----------------------------제목------------------------------------
			// 공백이나 null
			if(subject == '' ){
				alert("제목을 입력해주세요.1");
				$('#subject').focus(); 
				console.log('subject -->', $('#subject').val());
				return false;
			}  
			if( subject == null){
				alert("제목을 입력해주세요.1-1");
				$('#subject').focus(); 
				return false;
			}
			// 공백문자
			if(subject.text()=='&nbsp' || subject.equals('&nbsp')){
				alert("제목을 다시 입력해주세요.");
				$('#subject').focus(); 
				return false;	
			}	
			//공백 유효성검사
			if($("#subject").val().trim()==""){
				alert("제목을 입력하세요2.")
				$("#subject").focus();
				return false;
			}
			// 글자수 초과 
			if(subject.val.length>100){
				alert("제목을 다시 입력해주세요.");
				$('#subject').focus(); 
				return false;	
			}
			//정규식 유효성검사
			if(none.test(document.getElementById("subject").value)){
				alert("제목을 다시 입력해주세요.");
				return false;
			}
			if(!idreg.test(document.getElementById("subject").value)){
				alert("제목은 한글 또는 영어, 숫자로 입력해주세요");
				return false;
			}
			if(!idreg.test(subject)){
				alert("제목은 한글 또는 영어, 숫자로 입력해주세요");
				return false;
			}
			//-----------------------------작성자 ---------------------------------
			if(userid=='' || userid==null){
				alert("작성자를 입력해주세요.");
				$('#userid').focus(); 	
				return false;
			}
			//공백
			if($("#userid").val().trim()==""){
				alert("작성자를 입력하세요.")
				$("#userid").focus();
				return false;
			}
			/* if(userid.length>10 ){
				alert("작성자는 6자 미만으로 입력해주세요.");
				$('#userid').focus(); 	
				return false;
			} */
			//정규식 유효성검사
			if(!idreg.test(document.getElementById("userid").value)){
				alert("작성자를 다시 입력해주세요.");
				$('#userid').focus(); 	
				return false;
			}
			if(none.test(document.getElementById("userid").value)){
				alert("작성자를 다시 입력해주세요.");
				$('#userid').focus(); 	
				return false;
			}
			console.log("first check");
			//-------------------------비밀번호----------------------------------
			if(userpwd==' ' || userpwd==null){
				alert("비밀번호를 입력해주세요.");
				$('#userpwd').focus(); 	
				return false;
			}
			if($('#userpwd')==null){
				alert("비밀번호를 입력해주세요.");
				$('#userpwd').focus(); 	
				return false;
			}
			//비밀번호 4자리 숫자만 입력하도록 조건 걸어놓기
			if(userpwd.length>4){
				alert("비밀번호는 4자리만 입력해주세요.");
				return false;
				$('#userpwd').focus(); 	
			}
			if($('#userpwd').length>4){
				alert("비밀번호는 4자리만 입력해주세요.");
				return false;
				$('#userpwd').focus(); 	
			}
			//정규식
			if(!pwdreg.test(document.getElementById("userpwd").value)){
				alert("비밀번호는 4자리 숫자만 입력 가능합니다.");
				return false;
			}
			if(none.test(document.getElementById("userpwd").value)){
				alert("비밀번호를 다시 입력해주세요.");
				return false;
			}
			if($("#userpwd").val().length >= 4 && !pwdreg){
				console.log(check)
				alert("비밀번호는 4자리만 사용 가능합니다.");
				$("#userpwd").focus();
				return false;
		    }
			if(userpwd.search(/\s/) != -1){
				alert("공백으로만 비밀번호를 설정할 수 없습니다. \n 숫자 4자리를 입력해주세요.")
				$("#userpwd").focus();
				return false;
			}
			//-----------------------------내용------------------------------
			//summernote
			var content = $($("#content").summernote("code")).text();
			
			if(content.trim()==""){
				alert("내용을 입력해주세요.")	
				$('#content').summernote('focus');
				return false;
			}
			if ($('#content').summernote('isEmpty')) {
				alert("내용을 입력해주세요.");
				$('#content').summernote('focus');
				return false;
			}
				
		//	return true; 
		}); //submit end

	// 작성자
	function useridInput(e){
		var obj = $("#userid");
		var wordcheck = $("#useridLength");
		blankCheck(obj, '작성자')
		textCount(obj, txtcheck);
	}
	//비밀번호
	function userpwdInput(e){
		var obj = $("#password");
		var wordcheck = $("#userpwdLength");
		var pwdMsg = $("#pwdApproval");
		
		blankCheck(obj, '비밀번호')
		textCount(obj, txtcheck);
		pwdCheck(obj, pwdAlert, clipboard);

	}

	//textCount 글자수세기 함수
	function textCount(obj, txtcheck){
		wordcheck.text(obj.val().length + "/" + obj.attr("maxlength"));
		if(obj.val().length >= obj.attr("maxlength")){
			setTimeout(function(){
				alert(obj.attr("maxlength")+"글자까지 입력 가능합니다.")
			}, 100);
			obj.val(obj.val().substr(0, obj.attr("maxlength")));
			wordcheck.text(obj.attr("maxlength") + "/" + obj.attr("maxlength"));
		}
		return obj.val().length;;
	}
	//blackcheck 공백 알람 
	function blankCheck(obj, title){
		if(obj.val().trim() == "" && obj.val().length > 0){
			alert(title+"의 시작으로 공백이 들어갈 수 없습니다.");
			obj.val('');
		}
	}
	//userpwdCheck 비밀번호 확인
	function pwdCheck(obj, pwdAlert, clipboard){
	//function userpwdCheck(){
			console.log(clipboard)
			var userpwd = $("#userpwd").val();
			var pwdreg = password.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
					
			if(userpwd.length == 0 || clipboard == 0){
	 				pwdAlert.text("");
					$("#pwdGo").css("display","none");
					return false;
				}else if(userpwd.search(/\s/) != -1){
	 				checkblank(obj, '비밀번호');
	 				$("#pwdApproval").css("display","none");
					return false;
				}else if(pw.length < 4 || clipboard < 4){
	 				pwdAlert.text("4자리를 입력해주세요.");
	 				alert("4자리를 입력해주세요.");
	 				$("#pwdApproval").css("display","none");
					return false;
				}else if(!check){
//	 				비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력
					pwdMsg.text("비밀번호는 숫자 4자리만 입력해주세요.");
					alert("비밀번호를 확인해주세요.");
					$("#pwdApproval").css("display","none");
	 				if(userpwd.length >= 9 || clipboard >= 9){
	 					setTimeout(function(){
	 						alert("올바르지 않은 비밀번호입니다. 다시 확인해주세요");
	 					}, 100);
	 				}
					return false;
			    }else{
			    	$("#pwdApproval").css("display",'inline-block')
			    	pwdAlert.text("");
			    }
				
			}

</script>
<style>
	#pwdMsg{color:red;}
	#pwdApproval{color:green; display:none;}
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
				<li class="menu"><label class="label">제목</label><input type="text" name="subject" id="subject" class="wordcut" maxlength="100" size="100" />
					&nbsp;<span id="count"></span>/<span id="max_count">100</span><br/>
				</li>
				<li>
					<label class="label">작성자</label> <input type="text" name="userid" id="userid" class="wordcut" maxlength="10"/>
					<span id="useridLength"></span>/<span id="max_count">10</span><br/>
				</li>
				<li>
					<label class="label">비밀번호</label> <input type="password" name="userpwd" id="userpwd" maxlength="4" class="wordcut"/>
					<span id="userpwdLength"></span>/<span id="max_count">4</span><br/>
					
					</span> <span id="pwdMsg"></span>
					<span id="pwdApproval">사용가능</span>
				</li>
				<li>
					<textarea id="summernote"  name="content" id="content"  maxlength="200"  placeholder="내용을 입력해주세요." rows="10" cols="" maxlength="500"></textarea >
				</li>
				<li id="btnLine">
					<input type="submit" value="등록하기" class="btn"/>
					<input type="button" value="목록" class="btn"  onClick="location.href='<%=request.getContextPath() %>/boardList'"/> 
				<!-- 	<input type="button" value="목록" class="btn" id="returnList"/> -->
				</li>
			</ul>
		</form>
	</div>
</body>
</html>