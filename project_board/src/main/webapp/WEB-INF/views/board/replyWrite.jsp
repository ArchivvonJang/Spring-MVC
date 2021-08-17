<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>답글쓰기</title>
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
	//제목
	function subInput(e){
		console.log("subInput function test");
		var obj = $("#subject");
		var txtcheck = $("#count");
		blankCheck(obj, '제목');
		textCount(obj, txtcheck, '제목');
	}
	//작성자
	function useridInput(e){
		console.log("useridInput function test");
		var obj = $("#userid");
		var txtcheck = $("#useridLength");
		blankCheck(obj, '작성자');
		textCount(obj, txtcheck, '작성자');
	}
	//비밀번호
	function userpwdInput(e){
		console.log("userpwdInput function test");
		var obj = $("#password");
		var txtcheck = $("#userpwdLength");
		var pwdMsg = $("#pwdApproval");
		blankCheck(obj, '비밀번호');
		textCount(obj, txtcheck, '비밀번호');
	}

	//textCount 글자수세기 함수
	function textCount(obj, txtcheck, title){
		console.log("???textCount function working?");
		//txtcheck.text(obj.val().length + "/" + obj.attr("maxlength"));
		txtcheck.text(obj.val().length);
		if(obj.val().length >= obj.attr("maxlength")){
			setTimeout(function(){
				alert(title +"은 " + obj.attr("maxlength") + "글자까지 입력 가능합니다.");
				console.log("textCount setTimeout working?");
			}, 100);
			obj.val(obj.val().substr(0, obj.attr("maxlength")));
			//txtcheck.text(obj.attr("maxlength") + "/" + obj.attr("maxlength"));
		};
		return obj.val().length;;
	}
	//blackcheck 공백 알람 
	function blankCheck(obj, title){
		console.log("???blankCheck function working?");
		//if(obj.val().trim() == "" && obj.val().length > 0){
		if(obj.val() == " " && obj.val().length > 0){
			console.log("???blankCheck value check  1");
			alert(title+"의 시작으로 공백이 들어갈 수 없습니다.");
			obj.val('');
		};
		if(obj.val().replace(/\s| /gi, '').length== 0){
			console.log("???blankCheck value check  2");
			//alert(title+"의 시작으로 공백이 들어갈 수 없습니다.");
			obj.val('');
			return false;	
		}
		if(obj.val().replace(/\s| /gi, '')== ''){
			console.log("???blankCheck value check  2");
			alert(title+"의 시작으로 공백이 들어갈 수 없습니다.");
			obj.val('');
		    document.getElementById(obj).value ='';
			return false;	
		}
	}
	//userpwdCheck 비밀번호 확인
	function userpwdCheck(){
			console.log("userpwdCheck function 0");
			var userpwd = $("#userpwd").val();
			var pwdMsg =$("#pwdMsg");
			var pwdreg = userpwd.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
			//var pwdreg = userpwd.match(/([0-9])/);	
			if(userpwd.length == 0 ){
					console.log("userpwdCheck function 1");
				    pwdMsg.text("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요. ");
					$("#pwdApproval").css("display","none");
					return false;
				}else if(userpwd.search(/\s/) != -1){
					console.log("userpwdCheck function 2");
					blankCheck(obj, '비밀번호');
	 				$("#pwdApproval").css("display","none");
					return false;
	 			}else if(userpwd.length < 6 ){
					console.log("userpwdCheck function 3");
					pwdMsg.text("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
	 				//alert("10자리를 입력해주세요.");
	 				$("#pwdApproval").css("display","none");
	 				if(userpwd.length == 10 ){
	 					pwdMsg.css("display","none");
	 				}
					return false; 
				}else if(!pwdreg){
					pwdMsg.text("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요. ");
					console.log("userpwdCheck function 10");
					//alert("비밀번호를 확인해주세요.");
					$("#pwdApproval").css("display","none");
	 				if(userpwd.length > 10){
	 					setTimeout(function(){
	 						alert("올바르지 않은 비밀번호입니다.\n비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
	 					}, 100);
	 				}
					return false;
			    }else{
					console.log("userpwdCheck function else");
					pwdMsg.css("display","none");
			    	$("#pwdApproval").css("display",'inline-block');
			    	pwdMsg.text("");
			    }
				
	};
$(function(){ 
	//목록이동 물어보기 ---------------  >  작동 안함^^
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
		var contentLength = "${vo.content}";
		//길이표시
		$("#count").text(subjectLength.length);
		$("#useridLength").text(useridLength.length);
		$("#userpwdLength").text(userpwdLength.length);
		$("#contentLength").text(contentLength.length);
		
		
		//========================= 서머노트 =================================
		 $('#summernote').summernote({
			height: 500,    
			lang: "ko-KR",	
			maxHeight: null,   
			placeholder: '답글 내용을 입력해주세요. 최대 500자까지 쓸 수 있습니다',	
			maxlength:500,
			focus : true,
			airMode: false,
			//콜백 함수
		    callbacks : { 
		    	lengthCheck : function(){
		    		console.log("summernote lengthcheck ");
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
		      console.log("onImgupload");
			      for (var i = files.length - 1; i >= 0; i--) {
			      uploadSummernoteImageFile(files[i],
			      this);
			      }
		      },
		    onKeydown: function(e) {    	
		    	console.log("summernote keydown2");
		          var t = e.currentTarget.innerText;
		          //var note = $($("#summernote").summernote("code")).text();		
		          $("#contentLength").html(t.length);
		          if (t.length > 500) {
		        	  $(this).val(t.substring(0,500));
		        	  console.log("summernote keydown2 fucntion check");
		        	//delete keys, arrow keys, copy, cut, select all
                      if (e.keyCode != 8 && !(e.keyCode >=37 && e.keyCode <=40) && e.keyCode != 46 && !(e.keyCode == 88 && e.ctrlKey) && !(e.keyCode == 67 && e.ctrlKey) && !(e.keyCode == 65 && e.ctrlKey))
                    	e.preventDefault(); 
                  		console.log("summernote keydown2  if  check");
                  		return false;
		         	 }
		    },
		    onKeyup: function(e) {
		    	console.log("summernote keyup2 function check");
		         var t = e.currentTarget.innerText;
		         console.log("t.length :" , t.length);
		         
		         if (typeof callbackMax == 'function') {
		        	 console.log("summernote keyup2-1 if callbackMax check");	
		        	 
		            callbackMax(500 - t.length);
		           // $(this).text(note.substring(0,500));
		            $(this).text(t.substring(0,500));
		            $("#contentLength").html(t.length);
		            alert("내용은 500자까지 작성가능합니다.");
		            $('#summernote').focus(); 
		            e.preventDefault(); 
		            return false;
		         }
	    		if(t.length > 500){ //이 함수가 제일 잘 작동함
	    			console.log("summernote keyup2-2 t.length check");		
	    			
	    			$("#summernote").text(note.substring(0,500));
	    			$(this).text(note.substring(0,500));
	    			//$(this).text(t.substring(0,500));
	    			$(".note-editable").html(t.substring(0,500));
	    			console.log('substring(0,500)', t.substring(0,500));
	    			//================== summernote 여기서 컷팅됨 !!!!!!!!!!!!!!==========================================
	    			 $("#contentLength").html(t.length);
	    			 alert("내용은 500자까지 작성가능합니다.");
	    			 $('#summernote').html(t.substring(0,500));
	    	  			
	    			 console.log('substring(0,500) 적용된 summernote -->',$(".note-editable").val());
	    			 //$("#contentLength").html(t.length);
	    			 $("#contentLength").html(500);
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
		          //document.execCommand('insertText', false, all.trim().substring(0, 500));
		          document.execCommand('insertText', false, all.substring(0, 500));
		          if(t.length + bufferText.length > 500){
                      maxPaste = 500 - t.length;
                      $("#contentLength").html(t.length);
                      console.log("summernote onPaste bufferText.length check");
                  }
		          if(maxPaste > 0){
                      document.execCommand('insertText', false, bufferText.substring(0, maxPaste));
                      console.log("summernote onPaste maxPaste check");
                      $("#contentLength").html(document.execCommand('insertText').length);
                  }
                  $('#maxContentPost').text(500 - t.length);
		          if (typeof callbackMax == 'function') {
		            callbackMax(500 - t.length);
		            $("#contentLength").html(t.length);
		            $(this).text(t.substring(0,500));
		            console.log("summernote onPaste callbackMax check");
		            return false;
		          }
		        }
		      } //callbacks end
		      
		 }); //summernote end
			//내용 글자수 
		$(".note-editable").on("keypress", function(){
				console.log("note-editable function keypress");
				
			    var limiteTxt= 500;
			    var txt= $(this).text();
			    var totalTxt= txt.length;
			    //Update value
			    $("#contentLength").html(totalTxt);
			    //Check and Limit Charaters
			    if(totalTxt >= limiteTxt){
			    	console.log("note-editable function  if check ");
			        return false;
			    }
		});
		//글자 수 입력 표시 및 제한
		//제목
		$("#subject").keyup(function(){
				var content = $(this).val();//입력된 상품명의 value
				var count = content.length;
				$('#count').html(count);
				console.log("subject keyup ");
				if(count>100){
					console.log("subject keyup count 100");
					alert('제목은 최대 100자까지 입력 가능합니다.');
					$(this).val(content.substring(0,100));
					$('#count').html(100);
					$("#subject").focus();
					return false;	
				}
				if(content.replace(/\s| /gi, '').length== 0){
					console.log("subject keyup regexp length spacebar ");
					alert("제목의 시작으로 공백이 들어갈 수 없습니다.");
					$(this).val('');
					$('#count').html(0);
					$("#subject").focus();
					return false;	
				}
				if(content.replace(/\s| /gi, '')== ''){
					console.log("subject keyup regexp spacebar ");
					//alert("제목을 다시 입력하세요.");
					$(this).val('');
					$("#subject").focus();
					return false;	
				}
			});

		$("#userid").keyup(function(){
			console.log("userid keyup");
			var content = $(this).val();//입력된 상품명의 value
			var count = content.length;
			$("#useridLength").html(count);
			
			if(count>10){
				console.log("userid keyup count 10");
				alert('작성자는 10글자까지 입력 가능합니다.');
				$(this).val(content.substring(0,10));
				$("#useridLength").html(10);
				$("#userid").focus();
				return false;	
			}
			if(content.replace(/\s| /gi, '').length== 0){
				console.log("userid keyup regexp length spacebar ");
				//alert("작성자를 다시 입력하세요.");
				$(this).val('');
				$("#useridLength").html(0);
				$("#userid").focus();
				return false;	
			}
			if(content.replace(/\s| /gi, '')== ''){
				console.log("userid keyup regexp spacebar ");
				//alert("작성자를 다시 입력하세요.");
				$(this).val('');
				$("#userid").focus();
				return false;	
			}
		});
		$("#userpwd").keyup(function(){
			console.log("userpwd keyup");
			var content = $(this).val();//입력된 상품명의 value
			var count = content.length;
			var pwdreg = /([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/;
			$('#userpwdLength').html(count);
			
			//비밀번호가 숫자가 아니라면,
			/* if(!pwdreg.test(document.getElementById("userpwd").value)){
				console.log("userid keyup regexp - pwdreg");
				//alert("비밀번호는 10자리 숫자만 입력 가능합니다.");
				$('#userpwd').val('');
				$("#userpwd").focus();
				alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				return false; 
			} */
			//비밀번호가 10자리 초과라면,
			if(count>10){
				console.log("userid keyup over 10 ");
				alert('비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.');
				$("#userpwd").focus();
				$(this).val(content.substring(0,10));
				$('#userpwdLength').html(10);
			}
			
			//pwdCheck();
	 	
		});
		
		var note = $($("#summernote").summernote("code")).text();		
		$("#summernote").keyup(function(){
			var content = note.val();//입력된 상품명의 value
			var count = content.length;
			$('#contentLegnth').html(count);
			console.log("summernote keyup note version check");
			if(count>500){
				alert('내용은 500글자까지 입력 가능합니다.');
				$(this).val(note.substring(0,500));
				$('#contentLegnth').html(count);
				console.log("summernote keyup note version if -->", note.substring(0,500));
				return false;
			}
		});
		$(".note-editable").keyup(function(){
			var content = $(this).text();//입력된 상품명의 value
			var count = $(".note-editable").text().length;
			$('#contentLegnth').html(count);
			console.log("note-editable keyup ver. check");
			if(count>500){
				console.log("note-editable keyup ver.  note check");
				alert('내용은 500글자까지 입력 가능합니다');
				$(this).val(note.substring(0,500));
				$('#contentLegnth').html(count);
				return false;
			}
			//delete keys, arrow keys, copy, cut, select all
            if (e.keyCode != 8 && !(e.keyCode >=37 && e.keyCode <=40) && e.keyCode != 46 && !(e.keyCode == 88 && e.ctrlKey) && !(e.keyCode == 67 && e.ctrlKey) && !(e.keyCode == 65 && e.ctrlKey)){
            	$('#contentLegnth').html(count);
            	e.preventDefault(); 
        		console.log("note-editable keyup  if  check");
        		return false;
         	 }
		}); //keyup end
		var e = $.Event("keyup", {which:32});
		$(".note-editable").trigger(e);
		$("#subject").trigger($.Event("keydown", {
		    which: 32
		}));
		$(".note-editable").on('paste', function(){
			var content = $(this).text();//입력된 상품명의 value
			var count = $(".note-editable").text().length;
			$('#contentLegnth').text(count);
			$(".note-editable").text().html(count);
			console.log("note-editable paste ver. check");
		    console.log("note-editable paste ver. content :" , content);
		    console.log("note-editable paste ver. length :" ,count);
			if(count>500){
				console.log("note-editable keyup ver. if!!!");			
				$(this).text(content.substring(0,500));
				
				alert('내용은 500글자까지 입력 가능합니다.');
				$('#contentLegnth').html(count);
			}
		}); //keyup end
		$("#content").keyup(function(){
			var content = note.val();//입력된 상품명의 value
			var count = content.length;
			console.log("content keyup function --> contentelength : ",count);
			$('#contentLength').text(count);
			console.log("content keyup ver. check");
			if(count>500){
				console.log("content keyup ver. check");
				alert('내용은 500글자까지 입력 가능합니다.');
				$(this).val(note.substring(0,500));
				$('#contentLegnth').html(count);
				return false;
			}
		}); //keyup end

});
//====================== submit 넘기기 전에 유효성 검사 ========================================	

			//정규식 유효성검사
			//var subcheck = subject.value.test(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
			//var pwdcheck = userpwd.value.test(pwdreg);
			//var idcheck = userid.value.test(idreg);		
$(function(){
	$("#replyForm").on('submit',function(){
		console.log("~~~~~~~~~~~submit~~~~~~~~~~~~~~~");
		// 첨부파일
		var fileCnt = 0;
		if($("#filename").val()!=""){
			//해당 아이디에 첨부파일이 선택되어 있으면,
			fileCnt++;
		}
		if(fileCnt<1){ //올려진 파일이 0개
			//alert("파일을 첨부하세요.");
			//return false;
			$("#filename").val(null);
		}
		//유효성검사
		var idreg = /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|]+$/;
		var pwdreg = /([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])$/;
		var none=/^<p>(\s*&nbsp;\s*)*<\/p>$/;
		//변수에 각 input의 value 담기	
		var subject = $('#subject').val(); 
		var userid = $('#userid').val();	
		var userpwd = $('#userpwd').val();
		var content = $('#content').val();
		console.log("subject : ", subject, " , userid : ", userid);
			//제목 공백 제거
			$.trim($('#subject').val());
			
			// -----------------비어져있는지, 공백이나 null 먼저 확인 
			//제목
			if(subject == '' ){
				console.log("submit subject check");
				alert("제목을 입력해주세요.");
				$('#subject').focus(); 
				console.log('subject -->', $('#subject').val());
				return false;
			}  
			if( subject == null){
				console.log("submit subject null check");
				alert("제목을 입력해주세요.");
				$('#subject').focus(); 
				return false;
			}
			//작성자
			if(userid=='' || userid==null){
				console.log("submit userid check");
				alert("작성자를 입력해주세요.");
				$('#userid').focus(); 	
				return false;
			}
			//비밀번호
			
			if($("#userpwd").val().length<6){
				console.log("AAAA submit userpwd length check");
				alert('비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.');
				$('#userpwd').focus(); 	
				return false;
			} 
			if(userpwd==' ' || userpwd==null){
				console.log("BBBB submit userpwd check");
				alert("비밀번호를 입력해주세요.");
				$('#userpwd').focus(); 	
				return false;
			}
			if($('#userpwd')==null){
				console.log("CCCC submit userid null check");
				alert("비밀번호를 입력해주세요.");
				$('#userpwd').focus(); 	
				return false;
			}
			//summernote
			var content = $($("#summernote").summernote("code")).text();
			var maxlength = 500;
			var conlength = content.length;
			console.log("content.length : ",content.length);
			if($('#contentLength').val() >500){
				 console.log("submit conlength check");
				alert("!!!!!내용은 500자까지 입력해주세요.");	
				$('#content').val().substring(0,500);
				$('#summernote').summernote('focus');
				return false;
			}
			if ($('#summernote').summernote('isEmpty')) {
				console.log("submit summernote is empty");
				alert("내용을 입력해주세요.");
				$('#summernote').summernote('focus');
				return false;
			}
			if(conlength > maxlength){
				alert("내용은 500자까지 입력해주세요.");	
				//content.val(content.substring(0,500));
				 $('#content').val($('#content').val().slice(0, 500));
				 console.log("submit content value slice check");
				$('#summernote').summernote('focus');
				return false;
			}
			if(content.length > 500){
				alert(content.length+"자를 입력하셨습니다. 내용은 500자까지 입력해주세요.");	
				$(this).val(content.substring(0,500));
				 console.log("submit content length check");
				$('#summernote').summernote('focus');
				return false;
			}
	         var t = $('#summernote').currentTarget.innerText;
	         console.log("submit check t.length :" , t.length);         
    		if(t.length > 500){
    			
    			 console.log("submit summernote currentTarget check");
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
			
			//-------------------공백 , trim, 정규식 공백 유효성검사
			//제목
			if($("#subject").val().trim()==""){
				console.log("submit subject trim ");
				alert("제목을 입력하세요.")
				$("#subject").focus();
				return false;
			}
			if(subject.replace(/\s| /gi, '').length== 0){
				console.log("submit subject regexp spacebar ");
				alert("제목을 다시 입력하세요.");
				$("#subject").focus();
				return false;	
			}
			if(subject.replace(/\s| /gi, '')== ''){
				alert("제목을 다시 입력하세요.");
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
			if(userid.replace(/\s| /gi, '').length== 0){
				console.log("submit subject regexp spacebar ");
				alert("작성자를 다시 입력하세요.");
				$("#userid").focus();
				return false;	
			}
			if(userid.replace(/\s| /gi, '')== ''){
				console.log("submit userid regexp spacebar ");
				alert("작성자를 다시 입력하세요.");
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
			if(userpwd.replace(/\s| /gi, '')== ''){
				console.log("submit pwd regexp spacebar ");
				alert("작성자를 다시 입력하세요.");
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
			//비밀번호 10자리 숫자만 입력하도록 조건 걸어놓기
			if($("#userpwd").val().length < 6){
				c
				alert("D 비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				$("#userpwd").focus();
				return false;
			}
			if(userpwd.length<6){
				console.log("E submit userpwd length check");
				$('#userpwd').focus(); 	
				alert("비밀번호 10자리를 입력해주세요.");
				return false;
			}
			if(userpwd.length>10){
				console.log("F submit userpwd.length over 10 check 1");
				alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				$('#userpwd').focus(); 	
				return false;
			}
			if($('#userpwd').length>10){
				console.log("G submit userpwd.length over 10 check 2");			
				alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				$('#userpwd').focus(); 	
				return false;
			}
			//----------정규식 유효성검사
			//제목
			if(none.test(document.getElementById("subject").value)){
				console.log("submit regexp subject + none");
				alert("제목을 다시 입력해주세요.");
				return false;
			}
			if(!idreg.test(document.getElementById("subject").value)){
				console.log("submit regexp subject + idreg 1");
				alert("제목은 한글 또는 영어, 숫자로 입력해주세요");
				return false;
			}
			if(!idreg.test(subject)){
				console.log("submit regexp subject + idreg 2");
				alert("제목은 한글 또는 영어, 숫자로 입력해주세요");
				return false;
			}
			
			//작성자
			if(!idreg.test(document.getElementById("userid").value)){
				console.log("submit regexp userid + idreg 2");
				alert("작성자를 다시 입력해주세요.");
				$('#userid').focus(); 	
				return false;
			}
			if(none.test(document.getElementById("userid").value)){
				console.log("submit regexp userid + none");
				alert("작성자를 다시 입력해주세요.");
				$('#userid').focus(); 	
				return false;
			}
			console.log("--reg check--");
			
			//비밀번호
			if(!pwdreg.test(document.getElementById("userpwd").value)){
				//alert("비밀번호는 10자리 숫자만 입력 가능합니다.");
					console.log("H submit regexp pwd + pwdreg test ");
				alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				return false;
			}
			if(!pwdreg.match(document.getElementById("userpwd").value)){
				console.log("I submit regexp pwd + pwdreg match");
				alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				return false;
			}
			if(none.test(document.getElementById("userpwd").value)){
				console.log("Jsubmit regexp pwd + none");
				alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				return false;
			}
			if($("#userpwd").val().length >10 && !pwdreg){
				console.log("K submit pwd length + pwdreg");
				console.log(check)
				alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				$("#userpwd").focus();
				return false;
		    }
			if(userpwd.search(/\s/) != -1){
				console.log("L submit pwd search check");
				alert("공백으로만 비밀번호를 설정할 수 없습니다. \n 비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.")
				$("#userpwd").focus();
				return false;
			}
			return true;
		//	return true; 
		}); //submit end
});	


//]]>
</script>
<style>
	#pwdMsg{color:red;}
	#pwdApproval{color:green; display:none;}
	.label{
		font-weight:bold;
		margin:10px 0 10px;
	}	
	h2{font-color:navy; margin-bottom:40px;}
	li{margin-bottom:20px;}

}
</style>
<body>
	<div class="container">
	<h2>답글쓰기</h2>
		<form method="post" name="replyForm" id="replyForm" action="replyWriteOk" enctype="multipart/form-data" >
		<input type="hidden" name="no" value="${no}"/>
			<ul>
			
				<li class="menu"><label class="label">제목</label><input type="text" name="subject" id="subject" class="wordcut" maxlength="100" size="100" required oninput="subInput(this.val)"/>
								&nbsp;<span id="count"></span>/<span id="max_count">100</span><br/>
				</li>
				<li>
					<label class="label">작성자</label> <input type="text" name="userid" id="userid" class="wordcut" maxlength="10" required oninput="useridInput(this.val)"/>
					<span id="useridLength"></span>/<span id="max_count">10</span><br/>
				</li>
				<li>
					<!-- <label class="label">비밀번호</label> <input type="number" name="userpwd" id="userpwd" inputmode="numeric" class="input-number-password"  maxlength="10" class="wordcut" required oninput="userpwdCheck()"/> -->
					<label class="label">비밀번호</label> <input type="password" name="userpwd" id="userpwd" maxlength="10" class="wordcut" required oninput="userpwdCheck()"/>
					<span id="userpwdLength"></span>/<span id="max_count">10</span><br/>
					
					</span> <span id="pwdMsg"></span>
					<span id="pwdApproval">사용가능한 비밀번호입니다.</span>
				</li>
				<!-- 내용 -->
				<li>
					<textarea id="summernote"  name="content" id="content"  rows="10" cols="" maxlength="500"  oninput="lengthCheck()"></textarea >
					<span id= "contentLength"></span>/<span id="max_count">500</span><br/>
				</li>
				<!-- 첨부파일 -->
				<li>
					<label class="label"><span id="fileUpload">첨부파일 </span></label>
					<input type="file" name="file" accept="application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, text/plain, image/*, text/html, video/*, audio/*, .pdf" id="filename"  multiple="multiple" > 
				</li>
				<li id="btnLine">
					<input type="submit" value="답글등록" class="btn"/>
					<input type="button" value="목록" class="btn"  onClick="location.href='<%=request.getContextPath() %>/boardList?pageNum=${sapvo.pageNum}'"/> 
				<!-- 	<input type="button" value="목록" class="btn" id="returnList"/> -->
				</li>
			</ul>
		</form>
	</div>
</body>
</html>