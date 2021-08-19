<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head >
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
// --------------------------------------- 파일수정 -------------------------------------------------
$(function(){
	//파일 체킹 함수
	$('#filename').on('change',checkFile);
	//파일 삭제 버튼
	$(".delBtn").click(function(){
		//if(confirm('해당 파일을 삭제하시겠습니까?')){
			$(this).prev().attr('name', '');
			$(this).parent().next().attr('name', 'delFile');
			$(this).parent().css('display','none');
		//}
	});
})
//파일 업로드 제한되는 파일 형식
	var fileReg = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	//최대 크기 
	var maxSize = 3*1024*1024 //1048579==1MB
	//파일 크기
	//var fileSize = $('#filename').getMaxSize();
	var fileSize=0;
	// 파일 현재 필드 숫자 totalCount랑 비교값
	var fileCount = 0;
	// 해당 숫자를 수정하여 전체 업로드 갯수를 정한다.
	var totalCount = 5;
	// 파일 고유넘버
	var fileNum = 0;
	// 첨부파일 배열
	var attachFiles = new Array();
	//var filename = $('#filename').val();
	
	//파일용량, 확장자 체크	
	function checkFileSize(fileName, fileSize){
		if(fileSize >= maxSize){
			alert("파일 사이즈가 초과되었습니다.\n파일은 1MB미만으로 첨부해주세요.");
			 $("#filename").val(""); 
			 $('#articlefileChange').html("");
			return false;
		}
		if(fileReg.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			 $("#filename").val(""); 
			 $('#articlefileChange').html("");
			return false;
		}
	}
	//파일 리스트 나오게 하기, 삭제는 주석처리함 
	function checkFile(e){
		console.log("check file function in!");
		//$('#filename').val("");
		var files = e.target.files;
	    // 파일 배열 담기
	    var filesArr = Array.prototype.slice.call(files);
	    //초기화
	    $('#articlefileChange').html("");
	  
	    //수정전 기존의 파일 배열
	    var initialFiles = new Array();
	    $('#initialFileDiv').each(function(){
	    	initialFiles.push($(this));
	    })
	    
	    var initialFilesArr = Array.prototype.slice.call(initialFiles);
	    
	    console.log("initialFiles : " + initialFiles );
	    console.log("initialFilesArr : " + initialFilesArr );
	    
	    // 파일 개수 확인 및 제한
	    if (fileCount + filesArr.length > totalCount) {
	       	alert('파일은 최대 '+totalCount+'개까지 업로드 할 수 있습니다.\n다시 시도해주세요.');
	        $("#filename").val("");  
	      return false;
	    } else {
	    	 fileCount = fileCount + filesArr.length;
	    }
	    
	 // 각각의 파일 배열담기 및 기타
	    filesArr.forEach(function (f) {
	      var reader = new FileReader();
	      reader.onload = function (e) {
	        attachFiles.push(f);
	    
	        $('#articlefileChange').append(
	        // 	'<div id="file' + fileNum + '" onclick="fileDelete(\'file' + fileNum + '\')">'
	       		'<div id="file' + fileNum + '"  >'
	       		//+ '<font style="font-size:12px"> ' + f.name + '</font>'  
	       		+ '<label for="firstFile"></label>'
	      		+ '<input type="text" value="'+f.name+'" name="firstFile" style="border:none;" readonly/>'
				+ '<a class="delBtn" href="" onclick="fileDelete(\'file' + fileNum + '\') style="margin-left:10px; color:gray; font-weight: bold;">⛝</a><br>'
	      		+ '<div/>'
	      	
			);
	        fileNum ++;
	        //파일 용량과 확장자를 제한하는 함수로 넘겨준다 
	        checkFileSize(f.name, f.size);
	        console.log("check f name : " , f.name," /f size : " ,f.size);
	      };
	      reader.readAsDataURL(f);
	    });
	    console.log("check attachFiles : " , attachFiles);
	    console.log("check filesArr : ", filesArr);
	    console.log("check fileNum : " ,fileNum);
	   
	    //초기화 한다.
	 //  $("#filename").val("");  
	}
	// 파일 부분 삭제 함수
	function fileDelete(fileNum){
		$(this).prev().attr('name', '');
		$(this).parent().next().attr('name', 'delFile');
		$(this).parent().css('display','none');
		
	    var no = fileNum.replace(/[^0-9]/g, ""); 
	    attachFiles[no].is_delete = true;
		$('#file' + fileNum).remove();
		fileCount --;
	    console.log("delete attachFiles : "+attachFiles);
	}
	
	//폼을 submit
	function registerAction(){
		
		var form = $("form")[0];        
		var formData = new FormData(form);
		for (var i = 0; i < attachFiles.length; i++) {
			console.log("attachFiles length : " + attachFiles.length);
			// 삭제 안한것만 담아 준다. 
			if(!attachFiles[i].is_delete){
				formData.append("file", attachFiles[i]);
			}
		}//for end

	//파일업로드 multiple ajax처리
    
		$.ajax({
	   	      type: "POST",
	   	   	  enctype: "multipart/form-data",
	   	      url: "/upload",
	       	  data : formData,
	       	  processData: false,
	   	      contentType: false,
	   	      success: function (data) {
	   	    	if(JSON.parse(data)['result'] == "OK"){
	   	    		alert("파일업로드 성공");
				} else
					alert("서버내 오류로 처리가 지연되고있습니다. 잠시 후 다시 시도해주세요");
	   	      },
	   	      error: function () {
	   	    	alert("서버오류로 지연되고있습니다. 잠시 후 다시 시도해주시기 바랍니다.");
	   	     return false;
	   	      }
	   	    }); //ajax end
	   	    return false;
	} // function registerAction end
	
// ----------------------------------------- 수정하기 ------------------------------------------------

//작성자
function useridInput(e){
	console.log("useridInput function test");
	var obj = $("#userid");
	var txtcheck = $("#useridLength");
	blankCheck(obj, '작성자')
	textCount(obj, txtcheck);
}
//비밀번호
function userpwdInput(e){
	console.log("userpwdInput function test");
	var obj = $("#password");
	var txtcheck = $("#userpwdLength");
	var pwdMsg = $("#pwdApproval");
	
	blankCheck(obj, '비밀번호')
	textCount(obj, txtcheck);

}


//textCount 글자수세기 함수
function textCount(obj, txtcheck){
	console.log("???textCount function working?");
	//txtcheck.text(obj.val().length + "/" + obj.attr("maxlength"));
	txtcheck.text(obj.val().length);
	if(obj.val().length >= obj.attr("maxlength")){
		setTimeout(function(){
			alert(obj.attr("maxlength")+"글자까지 입력 가능합니다.");
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
 				pwdAlert.text("");
				$("#pwdApproval").css("display","none");
				return false;
			}else if(userpwd.search(/\s/) != -1){
				console.log("userpwdCheck function 2");
				blankCheck(obj, '비밀번호');
 				$("#pwdApproval").css("display","none");
				return false;
 			}else if(userpwd.length < 10 ){
				console.log("userpwdCheck function 3");
				pwdMsg.text("10자리를 입력해주세요.");
 				//alert("10자리를 입력해주세요.");
 				$("#pwdApproval").css("display","none");
 				if(userpwd.length == 10 ){
 					pwdMsg.css("display","none");
 				}
				return false; 
			}else if(!pwdreg){
				pwdMsg.text("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				console.log("userpwdCheck function 10");
				alert("비밀번호를 확인해주세요.");
				$("#pwdApproval").css("display","none");
 				if(userpwd.length > 10){
 					setTimeout(function(){
 						alert("올바르지 않은 비밀번호입니다. 다시 확인해주세요");
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
	//vo에서 가져온 글자 수 표시 count
		//var subjectLength = "${vo.subject}";
		var subjectLength = $("#subject").val();
		//var subjectLength = "<c:out value='${vo.subject}'></c:out>";
		var useridLength = "${vo.userid}";
		var userpwdLength = "${vo.userpwd}";
		//var note = $($("#summernote").summernote("code")).val().length;		
	
		//길이표시
		$("#count").text(subjectLength.length);
		$("#useridLength").text(useridLength.length);
		$("#userpwdLength").text(userpwdLength.length);
		//$("#contentLength").text(note);
		
		
		
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
					
					if(count>500){ //if(count>=500){
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
		    	 var t = e.currentTarget.innerText;
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
	    			 //var note = $($("#summernote").summernote("code")).val().length;	
	    		//	t.text(note.substring(0,500));
	    		//	$(this).text(note.substring(0,500));
	    			$(this).text(t.substring(0,500));
	    			$(".note-editable").html(t.substring(0,500));
	    			console.log('substring(0,500)', t.substring(0,500));
	    		
	    			 $("#contentLength").html(t.length);
	    			// alert("내용은 500자까지 작성가능합니다.");
	    			 $('#summernote').html(t.substring(0,500));
	    			 
	    			 console.log('substring(0,500) 적용된 summernote -->',t.length);
	    			 console.log('substring(0,500) 적용된 summernote -->',$(".note-editable").val());
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
			//글자 수 입력 표시 및 제한
			//제목
			$("#subject").keyup(function(){
					var content = $(this).val();//입력된 상품명의 value
					var count = content.length;
					$('#count').html(count);
					console.log("subject keyup ");
					if(count>100){
						console.log("subject keyup count 100");
						alert('제목은 최대 100자까지 입력 가능합니다.').
						$(this).val(content.substring(0,100));
						$('#count').html(100);
					}
					if(content.replace(/\s| /gi, '').length== 0){
						console.log("subject keyup regexp length spacebar ");
						alert("제목의 시작으로 공백이 들어갈 수 없습니다.");
						$(this).val('');
						$('#count').html(count);
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
			//	$("#useridLength").html(count);

				if(count>10){
					alert('작성자는 10글자까지 입력 가능합니다.');
					$(this).val(content.substring(0,10));
					//$("#useridLength").html(10);
					$("#userid").focus();
					return false;	
				}
				if(content.replace(/\s| /gi, '').length== 0){
					console.log("userid keyup regexp length spacebar ");
					//alert("작성자를 다시 입력하세요.");
					$(this).val('');
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
				var content = $(this).val();//입력된 상품명의 value
				var count = content.length;
				//var pwdreg = /[0-9]$/; //유효성검사
				var pwdreg = userpwd.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
				$('#userpwdLength').html(count);
				
				//비밀번호가 숫자가 아니라면,
				if(!pwdreg.test(document.getElementById("userpwd").value)){
					//alert("비밀번호는 10자리 숫자만 입력 가능합니다.");
					$('#userpwd').val('');
					$("#userpwd").focus();
					alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
					return false; 
				}
				//비밀번호가 10자리 초과라면,
				if(count>10){
					alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
					$("#userpwd").focus();
					$(this).val(content.substring(0,10));
					$('#userpwdLength').html(10);
				}
				
				//pwdCheck();
		 	//	if($("#userpwd").val()<6){
			//		alert('비밀번호는 10자리를 입력해주세요.');
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
			    $("#contentLength").html(count);
				if(count>500){
					console.log("note-editable keyup ver. if!!!");
					alert('내용은 500글자까지 입력 가능합니다.');
					$(this).text(content.substring(0,500));
					$('#contentLegnth').html(500);
					return false;
				}
				//delete keys, arrow keys, copy, cut, select all
                if (e.keyCode != 8 && !(e.keyCode >=37 && e.keyCode <=40) && e.keyCode != 46 && !(e.keyCode == 88 && e.ctrlKey) && !(e.keyCode == 67 && e.ctrlKey) && !(e.keyCode == 65 && e.ctrlKey)){
              	e.preventDefault(); 
            		console.log("note-editable keyup  if  check");
            		return false;
	         	 }
	
			}); 	
			var e = $.Event("keyup", {which:32});
			$(".note-editable").trigger(e);
			$("#subject").trigger($.Event("keydown", {
			    which: 32
			}));
			$(".note-editable").on('paste', function(){
				var content = $(this).text();//입력된 상품명의 value
				var count = $(this).text().length;
				$('#contentLegnth').text(count);
				$('#contentLegnth').html(count);
				console.log("note-editable paste ver. check");
			    console.log("note-editable paste ver. content :" , content);
			    console.log("note-editable paste ver. length :" ,count);
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
//====================== submit 넘기기 전에 유효성 검사 ========================================	
$(function(){
	 $("#boardEditFrm").on('submit',function(){
		//파일	 
		var fileCnt = 0;
		if($("#filename").val()!=""){
			//해당 아이디에 첨부파일이 선택되어 있으면,
			fileCnt++;
		}
		if($("#filename").val()==""){ //올려진 파일이 0개
			//alert("파일을 첨부하세요.");
			//return false;
			$("#filename").val(null);
		}
	 
		//유효성검사
		var idreg = /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|]+$/;
		//var pwdreg = /[0-9]$/;
		var pwdreg = userpwd.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
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

		if($("#userpwd").val().length<6){
			console.log("submit userpwd length");
			console.log("password length : ", $("#userpwd").val().length);
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			$('#userpwd').focus(); 	
			return false;
		} 
		if(userpwd==' ' || userpwd==null){
			console.log("submit userpwd null and blank");
			//alert("비밀번호를 입력해주세요.");
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			$('#userpwd').focus(); 	
			return false;
		}
		if($('#userpwd').val()==null ||$('#userpwd').val() =='' ){
			console.log("submit userpwd null");
			//alert("비밀번호를 입력해주세요.");
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
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
			alert("사용자를 다시 입력하세요.");
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
			console.log("submit userpwd value length check");
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			//alert("비밀번호는 10자리 숫자를 입력해주세요.");
			$("#userpwd").focus();
			return false;
		}
		if(userpwd.length<6){
			console.log("submit userpwd length under 10 check 1");
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			//alert("비밀번호는 10자리 숫자를 입력해주세요.");
			$('#userpwd').focus(); 
			return false;	
		}
		if(userpwd.length>10){
			console.log("submit userpwd value length excess 10 check");
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			$('#userpwd').focus(); 	
			return false;
		
		}
		if($('#userpwd').val().length>10){
			console.log("submit userpwd length under 10 check 2");
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
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
			//alert("비밀번호는 10자리 숫자만 입력 가능합니다.");
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			return false;
		}
		if(!pwdreg.match(document.getElementById("userpwd").value)){
			//alert("비밀번호는 10자리 숫자만 입력 가능합니다.");
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			return false;
		}
		if(none.test(document.getElementById("userpwd").value)){
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			return false;
		}
		if($("#userpwd").val().length > 10 && !pwdreg){
			console.log("userpwd value + pwdreg");
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			$("#userpwd").focus();
			return false;
	    }
		if(userpwd.search(/\s/) != -1){
			alert("공백으로만 비밀번호를 설정할 수 없습니다. \n 숫자 10자리를 입력해주세요.")
			$("#userpwd").focus();
			return false;
		}
	return true;
		
	}); //submit end
	console.log("----------submit end-------")
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
	textarea{width:100%;}
	#notice{margin-top:5px; color:#919C9A; font-size:0.9em;}
	input[type="file"]{font-color:#BDC5C9; margin:10px; width:800px;}
	#articlefileChange input[type="text"]{width:250px;}
	#initialFile{margin-left:10px; width:250px;}
	#initialFileDiv a{margin:0;}
	.delBtn{color:gray;}
</style>
<body>
	<div class="container">
	<h2>글 수정</h2>
		<form method="post" name="boardEditFrm" id="boardEditFrm" action="boardEditOk" enctype="multipart/form-data">
			<input type="hidden" name="no" value="${vo.no}"/>
			<ul>
				<li class="menu"><label for="subject" class="label">제목</label><input type="text" name="subject" id="subject" value="<c:out value="${vo.subject}" escapeXml="true"></c:out>" required  class="wordcut" size="100"  maxlength="100" oninput="useridInput(this.val)"/>
					&nbsp;<span id="count"></span>/<span id="max_count">100</span><br/>
				</li>
				<li>
					<label for="userid" for="userid" class="label">작성자</label> <input type="text" name="userid" id="userid" maxlength="10"  class="wordcut"  value="<c:out value="${vo.userid}"  escapeXml="true"></c:out>" required oninput="useridInput(this.value);">
					<span id="useridLength"></span>/<span id="max_count">10</span><br/>
				</li>
				<!-- 첫번째 첨부파일 :vo.filename1 = vo.filename[0] -->
			<%-- 	<li>첨부파일 
					<div>${vo.filename} <b class="f"></b></span></div>
					<input type="hidden" name="filename" id="filename"/>
					<!-- 삭제파일명: 사용자는 안보이게 -->
					<input type="hidden" name="" id="delfile" value="${vo.filename}"/>
				</li> --%>
			
				<%-- 
				<li>
				
					<label class="label">비밀번호</label>
					<input type="number" name="userpwd" id="userpwd" inputmode="numeric" class="input-number-password"  maxlength="4" class="wordcut" value="<c:out value="${vo.userpwd}"  escapeXml="true"></c:out>" required oninput="userpwdCheck()"/>
					
					<span id="userpwdLength"></span>/<span id="max_count">10</span><br/>
					
					</span> <span id="pwdMsg"></span>
					<span id="pwdApproval">사용가능</span>
					
				</li>
				--%>
				<li>
			<!-- 내용 -->
				<li>
					<textarea id="summernote"  name="content" id="content"  rows="10" cols="" maxlength="500"  oninput="lengthCheck()"><c:out value="${vo.content}" escapeXml="true"></c:out></textarea >	
				<%-- 		<textarea name="content" id="content" required><c:out value="${vo.content}"></c:out></textarea> --%>
					<span id= "contentLength"></span>/<span id="max_count">500</span><br/>
				</li>
				<li >
					<label for="file" for="filename" class="label">첨부파일</label> <span id="notice">첨부파일은 최대 1MB, 최대 5개까지 업로드 가능합니다.</span> <br/>
							<c:forEach var="file" items="${file}" varStatus="idx">
								
								<div id="initialFileDiv">
						<!-- 			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
									<label for="initialFile" style="display:none;"></label>
									<input type="text" value="${file}" name="initialFile" style="border:none;" id="initialFile" readonly/>
									<a class="delBtn" href="" onclick="return false;" style=" color:gray; ">⛝</a><br>
								</div>
								<input type="hidden" name="" value="${file}">
							</c:forEach>
					<div id="articlefileChange"></div>
					<input type="file" name="file" id="filename" accept="application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, text/plain, image/*, text/html, video/*, audio/*, .pdf" multiple="multiple" />
				</li>
				<li id="btnLine">
					<input type="submit" value="수정하기" class="btn"/>
					 <input type="button" value="목록" class="btn" onClick="location.href='<%=request.getContextPath()%>/boardList?pageNum=${sapvo.pageNum}'" /> 
			<!-- 		<input type="button" value="목록" class="btn" id="returnList" />  -->
				</li>
			</ul>
		</form>
		
	</div>
</body>
</html>