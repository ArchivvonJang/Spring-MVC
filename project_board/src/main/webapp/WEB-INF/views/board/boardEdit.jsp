<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Form</title>
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
		//var subjectLength = $("#subject").val();
		//var subjectLength = "<c:out value='${vo.subject}'></c:out>";
		var useridLength = "${vo.userid}";
		var userpwdLength = "${vo.userpwd}";
		 var note = $($("#summernote").summernote("code")).text();		
		//길이표시
		$("#count").text(subjectLength.length);
		$("#useridLength").text(useridLength.length);
		$("#userpwdLength").text(userpwdLength.length);
		$("#contentLength").text(note.length);
		//========================= 서머노트 =================================
		 $('#summernote').summernote({
			height: 500,    
			lang: "ko-KR",	
			maxHeight: null,   
			placeholder: '내용을 입력해주세요. 최대 500자까지 쓸 수 있습니다',	
			maxlength:500,
			focus : true,
			//콜백 함수
		    callbacks : { 
		    	lengthCheck : function(){
		    		var content = $(this).val();//입력된 상품명의 value
					var count = content.length;
					//$('#').html(count);
					
					if(count>=500){
						$(this).val(content.substring(0,500));
						alert('내용은 500자리까지 작성가능합니다.');
						console.log("summernote lengthcheck if alert");
						return false;
					}
					console.log("summernote lengthcheck function");
		      },
		      onImageUpload : function(files, editor, welEditable) {
		      // 파일 업로드(다중업로드를 위해 반복문 사용)
			      for (var i = files.length - 1; i >= 0; i--) {
			      uploadSummernoteImageFile(files[i],
			      this);
			      }
		      },
		  	/* onKeydown: function(e) {
		  		console.log("summernote keydown1");
		  		 var t = e.currentTarget.innerText;
		  	   $("#contentLength").html(t.length);
	            if ($(".note-editable").text().length >= 500){
	            	alert('내용은 500자리까지 작성가능합니다.');
	            	$(this).val(t.substring(0,500));
	                e.preventDefault();
	                return false;
	            };
	            
		    }, */
		    onKeydown: function(e) {    	
		    	console.log("summernote keydown2");
		    
		          $("#contentLength").html(t.length);
		          if (t.length > 500) {
		        	  $(this).val(t.substring(0,500));
		        	  console.log("keydown2 fucntion check");
		        	//delete keys, arrow keys, copy, cut, select all
                      if (e.keyCode != 8 && !(e.keyCode >=37 && e.keyCode <=40) && e.keyCode != 46 && !(e.keyCode == 88 && e.ctrlKey) && !(e.keyCode == 67 && e.ctrlKey) && !(e.keyCode == 65 && e.ctrlKey))
                    	e.preventDefault(); 
                  		console.log("keydown2  if  check");
                  		return false;
		         	 }
		    },
		    onKeyup: function(e) {
		    	console.log("summernote keyup2 function check");
		         var t = e.currentTarget.innerText;
		      	
		         //글자수
		         $("#contentLength").html(t.length);
		         console.log("contentlength t.length :" , t.length);
		         
		         if (typeof callbackMax == 'function') {
		        	 console.log("summernote keyup2-1 if callbackMax check");	
		        	 
		            callbackMax(500 - t.length);
		            $(this).text(t.substring(0,500));
		            $("#contentLength").html(t.length);
		            alert("내용은 500자까지 작성가능합니다.");
		            $('#summernote').focus(); 
		            e.preventDefault(); 
		            return false;
		         }
	    		if(t.length > 500){ //이 함수가 제일 잘 작동함
	    			console.log("summernote keyup2-2 t.length check");	
	    			//수정 전 현재텍스트 길이 표시
	    			 $("#contentLength").html(t.length);
	    			
	    			$("#summernote").text(note.substring(0,500));
	    			$(this).text(note.substring(0,500));
	    			$(this).text(t.substring(0,500));
	    			$(".note-editable").html(t.substring(0,500));
	    			console.log('substring(0,500)', t.substring(0,500));
	    		
	    			 $("#contentLength").html(t.length);
	    			 alert("내용은 500자까지 작성가능합니다.");
	    			 $('#summernote').html(t.substring(0,500));
	    			 
	    			 console.log('substring(0,500) 적용된 summernote -->',t.length);
	    			 $("#contentLength").html(t.length);
	    			 $('#summernote').focus(); 
	    			e.preventDefault(); 
	    			return false;
	    		}
	        
	    		 
		     },
		     onPaste: function(e) {	    	 
		    	 console.log("summernote onPaste function check");
		          var t = e.currentTarget.innerText;
		          $("#contentLength").html(t.length);
		          var bufferText = ((e.originalEvent || e).clipboardData || window.clipboardData).getData('Text');
		          e.preventDefault();
		          var maxPaste = bufferText.length;
		          var all = t + bufferText;
		        /*   document.execCommand('insertText', false, all.trim().substring(0, 500)); */
		         document.execCommand('insertText', false, all.substring(0, 500));
		        if(t.length + bufferText.length > 500){
                      maxPaste = 500 - t.length;
                      console.log("summernote onPaste bufferText.length check");
                  }
		          if(maxPaste > 0){
                      document.execCommand('insertText', false, bufferText.substring(0, maxPaste));
                      console.log("summernote onPaste maxPaste check");
                  }
                  $('#maxContentPost').text(500 - t.length);
		          if (typeof callbackMax == 'function') {
		            callbackMax(500 - t.length);
		            $(this).text(t.substring(0,500));
		            console.log("summernote onPaste callbackMax check");
		            return false;
		          }
		        }
		      } //callbacks end
		 }); //summernote end
			//글자 수 입력 표시 및 제한
			$(".note-editable").on("keypress", function(){
				console.log("note-editable function keypress");
				
			    var limiteTxt= 500;
			    var txt= $(this).text();
			    var totalTxt = txt.length;
			    //Update value
			    $("#contentLength").html(totalTxt);
			    //Check and Limit Charaters
			    if(totalTxt > limiteTxt){
			    	console.log("note-editable function  if check ");
			        return false;
			    }
			});			
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
				
				if(count>10){
					alert('작성자는 10글자까지 입력 가능합니다.');
					$(this).val(content.substring(0,10));
					$("#useridLength").html(10);
				}
			});
			$("#userpwd").keyup(function(){
				var content = $(this).val();//입력된 상품명의 value
				var count = content.length;
				var pwdreg = /[0-9]$/; //유효성검사
				$('#userpwdLength').html(count);
				
				//비밀번호가 숫자가 아니라면,
				if(!pwdreg.test(document.getElementById("userpwd").value)){
					//alert("비밀번호는 4자리 숫자만 입력 가능합니다.");
					$('#userpwd').val('');
					$("#userpwd").focus();
					alert("비밀번호는 4자리 숫자만 입력 가능합니다.");
					return false; 
				}
				//비밀번호가 4자리 초과라면,
				if(count>4){
					alert('비밀번호는 4자리까지 입력 가능합니다.');
					$("#userpwd").focus();
					$(this).val(content.substring(0,4));
					$('#userpwdLength').html(4);
				}
				
				//pwdCheck();
		 	//	if($("#userpwd").val()<4){
			//		alert('비밀번호는 4자리를 입력해주세요.');
			//	} 
			});

				
/* 			$("#summernote").keyup(function(){
				var note = $($("#summernote").summernote("code")).text();	
				var content = note.val();//입력된 상품명의 value
				var count = content.length;
				$('#contentLegnth').html(count);
				console.log("summernote keyup note version check");
				if(count>=500){
					alert('내용은 500글자까지 입력 가능합니다.');
					$(this).val(note.substring(0,500));
					$('#contentLegnth').text(500);
					console.log("summernote keyup note version if -->", note.substring(0,500));
					return false;
				}
			}); */
//==========================!!!!! 수정 폼에서는 이 부분이 작동함 =========================================
			$(".note-editable").keyup(function(){
				var content = $(this).text();//입력된 상품명의 value
				var count = $(this).text().length;
				//$('#contentLegnth').text(count);
				$('#contentLegnth').html(count);
				console.log("note-editable keyup ver. check");
			    console.log("note-editable keyup ver. content :" , content);
			    console.log("note-editable keyup ver. length :" , $(this).text().length);
				if(count>500){
					console.log("note-editable keyup ver. if!!!");
				
					alert('내용은 500글자까지 입력 가능합니다.');
					$(this).text(content.substring(0,500));
					$('#contentLegnth').html(count);
				}
			}); //keyup end
			$(".note-editable").on('paste', function(){
				var content = $(this).text();//입력된 상품명의 value
				var count = $(this).text().length;
				$('#contentLegnth').text(count);
				$('#contentLegnth').html(count);
				console.log("note-editable paste ver. check");
			    console.log("note-editable paste ver. content :" , content);
			    console.log("note-editable paste ver. length :" ,count);dsfsaf
				if(count=500){
					console.log("note-editable keyup ver. if!!!");
								
					$(this).text(content.substring(0,500));
					$('#contentLegnth').html(count);
					alert('내용은 500글자까지 입력 가능합니다.');
				}
			}); //keyup end
			$("#content").keyup(function(){
				var content = note.val();//입력된 상품명의 value
				var count = content.length;
				console.log("content keyup function --> contentelength : ",count);
				$('#contentLength').text(count);
				
				if(count>500){
					console.log("content keyup check");
				
					alert('내용은 500글자까지 입력 가능합니다.');
					$(this).val(note.substring(0,500));
					$('#contentLegnth').html(500);
				}
			}); //keyup end

});
$(function(){

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

	
	
		//제목 공백 제거
		$.trim($('#subject').val());
		console.log("submit check");
		// -----------------비어져있는지, 공백이나 null 먼저 확인 
		//제목
		if(subject == '' ){
			alert("제목을 입력해주세요.");
			console.log("subject blank");
			$('#subject').focus(); 
			console.log('subject -->', $('#subject').val());
			return false;
		}  
		if( subject == null){
			console.log("submit subject blank");
			alert("제목을 입력해주세요.");
			$('#subject').focus(); 
			return false;
		}
		if( subject.text()==' '){
			console.log("submit subject text blank");
			alert("제목을 입력해주세요.");
			$('#subject').focus(); 
			return false;
		}
		//작성자
		if(userid=='' || userid==null){
			console.log("submit userid null and blank");
			alert("작성자를 입력해주세요.");
			$('#userid').focus(); 	
			return false;
		}
		//비밀번호

		if($("#userpwd").val().length<4){
			console.log("submit userpwd length");
			console.log("password length : ", $("#userpwd").val().length);
			alert('비밀번호는 4자리를 입력해주세요.');
			$('#userpwd').focus(); 	
			return false;
		} 
		if(userpwd==' ' || userpwd==null){
			console.log("submit userpwd null and blank");
			//alert("비밀번호를 입력해주세요.");
			alert('비밀번호는 4자리를 입력해주세요.');
			$('#userpwd').focus(); 	
			return false;
		}
		if($('#userpwd').val()==null ||$('#userpwd').val() =='' ){
			console.log("submit userpwd null");
			//alert("비밀번호를 입력해주세요.");
			alert('비밀번호는 4자리를 입력해주세요.');
			$('#userpwd').focus(); 	
			return false;
		}
		//summernote
		var content = $($("#summernote").summernote("code")).text();
		var maxlength = 500;
		var conlength = content.length;
		console.log("content.length : ",content.length);
		if ($('#summernote').summernote('isEmpty')) {
			
			console.log("submit - summernote text is empty");
			alert("내용을 입력해주세요.");
			$('#summernote').summernote('focus');
			return false;
		}
		if(conlength > maxlength){
			
			console.log("submit conlength and maxlength 확인");
			alert("maxlength 내용은 500자까지 입력해주세요.");	
			content.val(content.substring(0,500));
			$(this).val(content.substring(0,500));
			$('#summernote').summernote('focus');
			return false;
		}
		if(content.length > 500){
			alert(content.length+"자를 입력하셨습니다. 내용은 500자까지 입력해주세요.");	
			console.log("submit content substring 확인");
			$(content).val(content.substring(0,500));
			$('#summernote').summernote('focus');
			return false;
		}
         var t = $('#summernote').currentTarget.innerText;
         console.log("submit check t.length :" , t.length);         
		if(t.length > 500){
			
			console.log("submit content t.length 확인");
			
			alert("내용은 500자까지 작성가능합니다.");
			$(this).text(t.substring(0,500));
			return false;
		}
		//---------------- 공백문자
		if(subject.text()=='&nbsp' || subject.equals('&nbsp')){
			
			console.log("submit subject &nbsp");
			alert("제목을 다시 입력해주세요.");
			$('#subject').focus(); 
			return false;	
		}	
		//-------------------공백 trim 유효성검사
		//제목
		if($("#subject").val().trim()==""){
			console.log("submit subject trim ");
			alert("제목을 입력하세요.")
			$("#subject").focus();
			return false;
		}
		//작성자
		if($("#userid").val().trim()==" "){
			console.log("submit userid trim");
			alert("작성자를 입력하세요.")
			$("#userid").focus();
			return false;
		}
		//비밀번호 
		if($("#userpwd").val().trim()==" "){
			console.log("submit userpwd trim");
			alert("작성자를 입력하세요.")
			$("#userpwd").focus();
			return false;
		}
		//내용
		
		if(content.trim()==""){
			
			console.log("submit content trim");
			alert("내용을 입력해주세요.")	
			$('#content').summernote('focus');
			return false;
		}
		// ----------------글자 수 
		//제목
		if(subject.val.length>100){
			console.log("submit subject value length check");
			alert("제목을 다시 입력해주세요.");
			$('#subject').focus(); 
			return false;	
		}
		//비밀번호 4자리 숫자만 입력하도록 조건 걸어놓기
		if($("#userpwd").val().length < 4){
			console.log("submit userpwd value length check");
			alert('비밀번호는 4자리를 입력해주세요.');
			//alert("비밀번호는 4자리 숫자를 입력해주세요.");
			$("#userpwd").focus();
			return false;
		}
		if(userpwd.length<4){
			console.log("submit userpwd length under 4 check 1");
			alert('비밀번호는 4자리를 입력해주세요.');
			//alert("비밀번호는 4자리 숫자를 입력해주세요.");
			$('#userpwd').focus(); 
			return false;	
		}
		if(userpwd.length>4){
			console.log("submit userpwd value length excess 4 check");
			alert("비밀번호는 4자리만 입력해주세요.");
			$('#userpwd').focus(); 	
			return false;
		
		}
		if($('#userpwd').val().length>4){
			console.log("submit userpwd length under 4 check 2");
			alert("비밀번호는 4자리만 입력해주세요.");
			$('#userpwd').focus(); 	
			return false;
		}
		
		/* if(userid.length>10 ){
		alert("작성자는 10자 미만으로 입력해주세요.");
		$('#userid').focus(); 	
		return false;
	} */
		//----------정규식 유효성검사
		//제목
		if(none.test(document.getElementById("subject").value)){
			console.log("regular expression none + subject");
			alert("제목을 다시 입력해주세요.");
			return false;
		}
		if(!idreg.test(document.getElementById("subject").value)){
			console.log("regexp idreg + subject 1");
			alert("제목은 한글 또는 영어, 숫자로 입력해주세요");
			return false;
		}
		if(!idreg.test(subject)){
			console.log("regexp idreg + subject 2");
			alert("제목은 한글 또는 영어, 숫자로 입력해주세요");
			return false;
		}
		
		//작성자
		if(!idreg.test(document.getElementById("userid").value)){
			console.log("regexp idreg + userid");
			alert("작성자를 다시 입력해주세요.");
			$('#userid').focus(); 	
			return false;
		}
		if(none.test(document.getElementById("userid").value)){
			console.log("regexp none + userid");
			alert("작성자를 다시 입력해주세요.");
			$('#userid').focus(); 	
			return false;
		}
		console.log("-------------여기까지 오긴하니?-----------------");
		
		//비밀번호
		if(!pwdreg.test(document.getElementById("userpwd").value)){
			//alert("비밀번호는 4자리 숫자만 입력 가능합니다.");
			alert('비밀번호는 4자리를 입력해주세요.');
			return false;
		}
		if(!pwdreg.match(document.getElementById("userpwd").value)){
			//alert("비밀번호는 4자리 숫자만 입력 가능합니다.");
			alert('비밀번호는 4자리를 입력해주세요.');
			return false;
		}
		if(none.test(document.getElementById("userpwd").value)){
			alert("비밀번호를 다시 입력해주세요.");
			return false;
		}
		if($("#userpwd").val().length > 4 && !pwdreg){
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

		return false; 
		console.log("----------submit end-------")
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
	console.log("useridInput function test");
	var obj = $("#userid");
	var wordcheck = $("#useridLength");
	blankCheck(obj, '작성자')
	textCount(obj, txtcheck);
}
//비밀번호
function userpwdInput(e){
	console.log("userpwdInput function test");
	var obj = $("#password");
	var wordcheck = $("#userpwdLength");
	var pwdMsg = $("#pwdApproval");
	
	blankCheck(obj, '비밀번호')
	textCount(obj, txtcheck);

}


//textCount 글자수세기 함수
function textCount(obj, txtcheck){
	console.log("???textCount function working?");
	wordcheck.text(obj.val().length + "/" + obj.attr("maxlength"));
	if(obj.val().length >= obj.attr("maxlength")){
		setTimeout(function(){
			alert(obj.attr("maxlength")+"글자까지 입력 가능합니다.");
			console.log("textCount setTimeout working?");
		}, 100);
		obj.val(obj.val().substr(0, obj.attr("maxlength")));
		wordcheck.text(obj.attr("maxlength") + "/" + obj.attr("maxlength"));
	};
	return obj.val().length;;
}
//blackcheck 공백 알람 
function blankCheck(obj, title){
	console.log("???blankCheck function working?");
	//if(obj.val().trim() == "" && obj.val().length > 0){
	if(obj.val() == "" && obj.val().length > 0){
		console.log("???blankCheck value check is working??");
		alert(title+"의 시작으로 공백이 들어갈 수 없습니다.");
		obj.val('');
	};
}
//userpwdCheck 비밀번호 확인
function userpwdCheck(){
		console.log(clipboard);
		console.log("userpwdCheck function 0");
		var userpwd = $("#userpwd").val();
		var pwdreg = password.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
				
		if(userpwd.length == 0 || clipboard == 0){
			console.log("userpwdCheck function 1");
 				pwdAlert.text("");
				$("#pwdApproval").css("display","none");
				return false;
			}else if(userpwd.search(/\s/) != -1){
				console.log("userpwdCheck function 2");
 				checkblank(obj, '비밀번호');
 				$("#pwdApproval").css("display","none");
				return false;
			}else if(pw.length < 4 || clipboard < 4){
				console.log("userpwdCheck function 3");
 				pwdAlert.text("4자리를 입력해주세요.");
 				alert("4자리를 입력해주세요.");
 				$("#pwdApproval").css("display","none");
				return false;
			}else if(!check){
				pwdMsg.text("비밀번호는 숫자 4자리만 입력해주세요.");
				console.log("userpwdCheck function 4");
				alert("비밀번호를 확인해주세요.");
				$("#pwdApproval").css("display","none");
 				if(userpwd.length > 4 || clipboard >4){
 					setTimeout(function(){
 						alert("올바르지 않은 비밀번호입니다. 다시 확인해주세요");
 					}, 100);
 				}
				return false;
		    }else{
				console.log("userpwdCheck function else");
		    	$("#pwdApproval").css("display",'inline-block');
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
					<label class="label">작성자</label> <input type="text" name="userid" id="userid" maxlength="10"  class="wordcut"  value="<c:out value="${vo.userid}"></c:out>" required oninput="useridInput(this.value);">
					<span id="useridLength"></span>/<span id="max_count">10</span><br/>
				</li>
				<li>
					<label class="label">비밀번호</label>
					<%-- <input type="password" name="userpwd" id="userpwd" class="wordcut" maxlength="4" value="<c:out value="${vo.userpwd}"></c:out>" required oninput="userpwdInput(this.val);"> --%>
					<input type="number" name="userpwd" id="userpwd" inputmode="numeric" class="input-number-password"  maxlength="4" class="wordcut" value="<c:out value="${vo.userpwd}"></c:out>" required oninput="userpwdInput(this.val);"/>
					
					<span id="userpwdLength"></span>/<span id="max_count">4</span><br/>
					
					</span> <span id="pwdMsg"></span>
					<span id="pwdApproval">사용가능</span>
					
				</li>
				<li>
			<!-- 내용 -->
				<li>
					<textarea id="summernote"  name="content" id="content"  rows="10" cols="" maxlength="500"  oninput="lengthCheck();"> ${vo.content}</textarea >
					<span id= "contentLength"></span>/<span id="max_count">500</span><br/>
				</li>
				<li id="btnLine">
					<input type="submit" value="수정하기" class="btn"/>
					 <input type="button" value="목록" class="btn" onClick="location.href='<%=request.getContextPath()%>/boardList'" /> 
			<!-- 		<input type="button" value="목록" class="btn" id="returnList" />  -->
				</li>
			</ul>
		</form>
	</div>
</body>
</html>