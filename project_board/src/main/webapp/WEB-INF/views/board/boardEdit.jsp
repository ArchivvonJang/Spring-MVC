<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content ="width=device-width, initial-scale=1"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css" integrity="sha384-B0vP5xmATw1+K9KRQjQERJvTumQW0nPEzvF6L/Z6nronJ3oUOFUFpCjEUQouq2+l" crossorigin="anonymous">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.min.js" integrity="sha384-+YQ4JLhjyBLPDQt//I+STsc9iw4uQqACwlvpslubQzn4u2UU2UFM80nGisd026JF" crossorigin="anonymous"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/boardStyle.css">
</head>
<script>

$(function(){
	//vo에서 가져온 글자 수 표시 count
	var subjectLength = "${vo.subject}";
	var useridLength = "${vo.userid}";
	var userpwdLength = "${vo.userpwd}";
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
	}); //subject keyup end
	$("#userid").keyup(function(){
		var content = $(this).val();//입력된 상품명의 value
		var count = content.length;
		$("#useridLength").html(count);
		
		if(count>10){
			alert('작성자는 10글자까지 입력 가능합니다.').
			$(this).val(content.substring(0,10));
			$("#useridLength").html(100);
		}
	}); // userid keyup end
	$("#userpwd").keyup(function(){
		var content = $(this).val();//입력된 상품명의 value
		var count = content.length;
		$('#userpwdLength').html(count);
		
		if(count>4){
			alert('비밀번호는 4자리까지 입력 가능합니다.').
			$(this).val(content.substring(0,4));
			$('#userpwdLength').html(100);
		}
	}); // userpwd keyup end
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
		maxlength : 500,
		
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

	 $("#boardEditFrm").on('submit',function(){
	//====================== submit 넘기기 전에 유효성 검사 ========================================	
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
		//정규식 유효성검사
		//var subcheck = subject.value.test(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
		//var pwdcheck = userpwd.value.test(pwdreg);
		//var idcheck = userid.value.test(idreg);		

	
	
		//공백 제거
		$.trim($('#subject').val());
		
		//-----------------------------제목------------------------------------
		// 공백이나 null
		if(subject =='' ||  $('#subject').val()==null){
			alert("제목을 입력해주세요.");
			$('#subject').focus(); 
			return false;
		}
		// 공백문자
		if(subject.text()== '&nbsp' || subject.equals('&nbsp')){
			alert("제목을 다시 입력해주세요.");
			$('#subject').focus(); 
			return false;	
		}	
		//공백 유효성검사
		if($("#subject").val().trim()==""){
			alert("제목을 입력하세요.")
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
		//공백
		if($("#userid").val().trim()==""){
			alert("작성자를 입력하세요.")
			$("#userid").focus();
			return false;
		}

		if(userid=='' || userid==null){
			alert("작성자를 입력해주세요.");
			$('#userid').focus(); 	
			return false;
		}
		if(userid.length>10 ){
			alert("작성자는 6자 미만으로 입력해주세요.");
			$('#userid').focus(); 	
			return false;
		}
		//정규식 유효성검사
		if(!idreg.test(document.getElementById("userid").value)){
			alert("작성자는 6~15자리 사이의 영어와 숫자만 사용할 수 있습니다.");
			$('#userid').focus(); 	
			return false;
		}
		if(none.test(document.getElementById("userid").value)){
			alert("작성자를 다시 입력해주세요.");
			$('#userid').focus(); 	
			return false;
		}
		
		//-------------------------비밀번호----------------------------------
		if(userpwd=='' || userpwd==null){
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
			alert("비밀번호는 4자리만 사용 가능합니다.");
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
		
		
		
		return true; 
	}); //submit end

	//목록 돌아가기
	/* 	$(function(){
			$("#returnList").click(function(){
				if(confirm("목록으로 돌아가시겠습니까?")){
					location.href='/boardList';
				}else{
					return false;
				}
			});

	 */
});
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
	};
	return obj.val().length;;
}
//blackcheck 공백 알람 
function blankCheck(obj, title){
	if(obj.val().trim() == "" && obj.val().length > 0){
		alert(title+"의 시작으로 공백이 들어갈 수 없습니다.");
		obj.val('');
	};
}
//userpwdCheck 비밀번호 확인
function userpwdCheck(){
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
// 				비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력
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
			
		};

</script>
<style>
	.btnLine{margin-top:10px;}

	.label{
		font-weight:bold;
		margin:10px 0 10px;
	}	
	h2{margin-bottom:40px;}
	li{margin-bottom:20px;}
	#pwdMsg{color:red;}
	#pwdApproval{color:green; display:none;}
</style>
<body>
	<div class="container">
	<h2>게시판</h2>
		<form method="post" name="boardEditFrm" id="boardEditFrm" action="boardEditOk">
			<input type="hidden" name="no" value="${vo.no}"/>
			<ul>
				<li class="menu"><label class="label">제목</label><input type="text" name="subject" id="subject" value="<c:out value="${vo.subject}" escapeXml="true"></c:out>" required  class="wordcut" size="100"  maxlength="100" />
					&nbsp;<span id="count"></span>/<span id="max_count">100</span><br/>
				</li>
				<li>
					<label class="label">작성자</label> <input type="text" name="userid" id="userid" maxlength="10"  value="<c:out value="${vo.userid}"></c:out>" required oninput="useridInput(this.value);">
					<span id="useridLength"></span>/<span id="max_count">10</span><br/>
				</li>
				<li>
					<label class="label">비밀번호</label><input type="password" name="userpwd" id="userpwd" class="wordcut" maxlength="4" value="<c:out value="${vo.userpwd}"></c:out>" required oninput="userpwdInput(this.val);">
					<span id="userpwdLength"></span>/<span id="max_count">4</span><br/>
					
					</span> <span id="pwdMsg"></span>
					<span id="pwdApproval">사용가능</span>
					
				</li>
				<li>
					<textarea id="summernote" name="content" id="content"><c:out value="${vo.content}"></c:out></textarea>
				</li>
				<li id="btnLine">
					<input type="submit" value="수정하기" class="btn"/>
					 <input type="button" value="목록" class="btn" onClick="location.href='<%=request.getContextPath() %>/boardList'"/> 
			<!-- 		<input type="button" value="목록" class="btn" id="returnList" />  -->
				</li>
			</ul>
		</form>
	</div>
</body>
</html>