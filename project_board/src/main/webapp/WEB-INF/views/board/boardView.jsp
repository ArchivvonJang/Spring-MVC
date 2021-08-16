<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View</title>
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
<style>
	.menu{margin-right:10px; font-weight: bold; }
	#btnLine{margin:0 auto; text-algin:center; width: 100%; }
	.menuLine:first-child{margin-top:50px;}
	.menuLine{margin: 20px 0 20px 0;}
	#sub{
		font-size:1em; border: 1px solid lightgray; overflow: auto;
		padding:10px; height:30px auto;
		white-space:normal; word-break:break-all;  text-overflow:ellipsis;
		width: 100%; 
		margin-bottom:15px; 
	 }
	#content{
		 padding:10px; width: 100%; height:500px auto; border:1px solid lightgray; word-break:break-all; overflow:auto;
		margin-bottom:15px; 
	}
	.note-editor.note-airframe .note-editing-area .note-editable[contenteditable=false], .note-editor.note-frame .note-editing-area .note-editable[contenteditable=false] {
    background-color: white; min-height: 350px;
	}
	#commentContainer{margin-top:20px;}
	#numColor{color:#062136;}
	#commentList{margin-bottom:30px;}
	input[type="text"]::-webkit-outer-spin-button,
	input[type="text"]::-webkit-inner-spin-button,
	#content,
	input[type="text"]
	 {
    -webkit-appearance: none;
    margin: 0;
    -ms-overflow-style: none; /* IE and Edge */
    scrollbar-height: none; /* Firefox */
    scrollbar-width: none; 
	}
	#commentForm{height: 130px auto;}
	
	.edit, .delete{border:none;}
	#useridLength, #userpwdLength, #commentLengt{ width: 35px; margin:0; padding:0; }
</style>
<script type="text/javascript">
// -----------------------  파일 다운로드 ------------------------
$(function(){
		/* $("#viewUl a").click(function(){
			var params = "no="+${vo.no};
			console.log("params -", params);
			$.ajax({
				url : '/myapp/downcount',
				data:params,
				success: function(result){
					var arr = result.split("<hr class='down'/>");
					${"span"}.text(arr[1].trim());
				},error: function(){
					console.log("downcount error");
				}
			});
		}); */
	})


//------------------------ 게시판 글보기 -------------------------

	// $(function(){	}); 아래랑 같은기능을 하는 다른표기법 $(()=>{});
		//$("#boardDel").click(()=>{
			/* if(confirm("삭제하시겠습니까?")){
				location.href="boardDelete?no=${vo.no}";
			}; */
		//$("#boardEdit").click(()=>{
		/* 	if(confirm("수정하시겠습니까?")){	
				location.href="boardEdit?no=${vo.no}";
			}; */
		function boardDelete(){
			console.log(" onclick delete");	
			//var url ="/myapp/getUserpwd";
			var loc = "/myapp/boardDelete?no=${vo.no}";	 //이동할 주소
			var data = "no=${vo.no}&userpwd=";	//필요한 데이터 값
			var state = "delete";
			getUserpwd( data, loc, state);//1
			//console.log(" onclick delete data : ", data, " loc :", loc);
		};

		function boardEdit(){
			console.log(" onclick edit");	
			//var url ="/myapp/getUserpwd";
			var loc = "/myapp/boardEdit?no=${vo.no}";
			var data = "no=${vo.no}&userpwd=";
			var state = "edit"
			//getUserpwd(data, loc);
			getUserpwd(data, loc, state);
			console.log("on click edit data : ", data, " loc :", loc);
		};
	
		function getUserpwd(data, loc, state){
			console.log("function getuserpwd in !!");
			var pwd = prompt("비밀번호를 입력해주세요.");
			var param = data + pwd;
			var url = "/myapp/getUserpwd";
			console.log("param: "+param);
			
			//if(pwd != null || pwd != " "){
			if(pwd != null ){
				console.log("pwd check ! go to check userpwd");
				//checkUserpwd(param, loc, data);
				$.ajax({
					url : url,
					data : param,
					success : function(result){
						if(result>0){
							if(state == "delete"){
								location.href = loc;
								console.log("url-->",url);
							}else if(state == "edit"){
								location.href = loc;
							}
				
						}else{
							alert("비밀번호를 다시 확인해주세요.");
							getUserpwd(data, loc, state);
							
						
						}
					},error:function(result){
						console.log(" << 게시글 수정삭제 실패 >> ");
						
					}
				});	
			}else{
				//alert("비밀번호를 확인해주세요.BB"); 여기가 문제였네!!
				//getUserpwd(data, loc, state);
				
			}
				
		//	return false;
		
		}
	//이것은 결국...사용하지 않는 함수가 되어버렸습니다. 	
		function checkUserpwd(param, loc, url){
			console.log("checkUserpwd ajax");
			var url = "/myapp/getUserpwd";
			$.ajax({
				url : url,
				data : param,
				success : function(result){
					
					if(result>0){
						location.href = url;
						console.log("url-->",url);
						console.log("result-->",result);
					}
					
					//else if(result==0){
					else{
						alert("비밀번호를 잘못 입력하였습니다.\n다시 입력해주세요.");		
						//getUserpwd(url, data, loc);
						console.log("checkuserpwd password is wrong or result is failed -> ajax check url : ", url, "result-->, result");
						console.log("chechk reuslt = 0 and url->"+url);
						//getUserpwd(param, loc);
						checkUserpwd(param, loc, url);
						return false;
					}
					
				}, error : function(){
					alert("비밀번호를 다시 확인해주세요.");		
					getUserpwd(data, loc);
					console.log("!!checkUserpwd ajax function error!!");
				}
			});
		}
//summernote
$(function(){
	$("#summernote").summernote({
		disable: true,
		toolbar : false,
		disableDragAndDrop: true,
		tabDisable: false
	});
	$('#summernote').summernote('disable');
});
/////////////////////////////////////////////////////////////------------------------ ajax를 이용한 댓글처리 -------------------------/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//댓글목록
	function commentList(){
		var url = "/myapp/commentList";
	//var url = "/myapp/boardList";
		var params = "no=${vo.no}";
		var tag =""
		console.log("comment list url --> ",url);
		console.log("comment list data --> ", params);
		$.ajax({
			url:url,
			data:params,
			success:function(result){
				//console.log("ajax comment list in!!!!!!");
				//변수이름이 $result
				var $result = $(result);
				//console.log("ajax result !!!!!!!!!");
				var num = result.length; 
				//console.log("commentList num ->",num);
				tag=""
				//반복
					$result.each(function(i, o){
						console.log("comment List result function in!!!!!!!!!!!!");
					///////////////////////////////////////// 댓글 목록 ////////////////////////<input type='hidden' value='"+o.cno+"'>/////////////////////////////////////////
					/*	tag += "<div><ul>"
							tag += "<li> <span>("+ num +") </span> &nbsp; <span  escapeXml='true'> 작성자 : "+o.userid + "</span>&nbsp;  <span style='color:#9DA5AB;'>[ " + o.cdate + " ]</span> </li>";
							tag += "<li escapeXml='true' style='height:auto;margin-top:6px;'>";
							tag += "	<input type='text' value='" + o.content  + "'readonly  style='width:100%; height:100px;' class='wordcut'>";
							//tag += "	<span style='float:right;' class='"+o.cno+"'><button class='edit btn' >수정</button>&nbsp;&nbsp;<button class='delete btn'>삭제</button></span>"
							tag += "</li>";
							tag += "<li class='"+o.cno+"'><button class='edit btn' >수정</button>&nbsp;<button class='delete btn'>삭제</button</li>"
							tag += "<li><input type='hidden' value='"+o.userpwd+"'/></li>";
						
						tag+="</ul><br/>";
						tag+="</div>";
					*/
						tag += "<div><ul>"
							tag += "<li> <span>("+ num +") </span> &nbsp; <span  escapeXml='true'> 작성자 : "+o.userid + "</span> &nbsp;&nbsp; [ " + o.cdate + " ] </li>";
							tag += "<li style='margin-top:6px;'   escapeXml='true'>";
							//tag += "	<input type='text' value='" + o.content  + "'readonly class='wordcut' style='height:80px; width:100%;'>";
							tag += "	<textarea name='content' id='content'  id='sub' class='wordCut'  maxlength='150' style='margin-bottom:0px; width:100%; readonly '>"+o.content+"</textarea>";
							
							tag += "	<span  class='"+o.cno+"'><button class='edit btn' >수정</button><button class='delete btn'>삭제</button></span>"
							tag += "</li>";
							tag += "<li><input type='hidden' value='"+o.userpwd+"'/></li>";
						
						tag+="</ul><br/>";
						tag+="</div>";
						//console.log("commentList function cno -> ", o.cno)
						
					///////////////////////////////////////////// 댓글 수정 폼 ///////////////////////////////////////////////////////////////////
						tag += "<div class='editDiv' style='display:none; margin-bottom:15px;'>" ;
						tag += "<form class='editForm' method='post' onsubmit='return false'>";
							tag += "<input type='hidden' name='no' value='${vo.no}'/>" ;
							tag += "<input type='hidden' name='cno' value='"+o.cno+"'/>" ;
							tag += "<div class='cno'>("+num+")</div>";
							tag += "<div class='cPwdId' style='margin-bottom:6px;'> ";
							tag += "작성자 : </span> &nbsp; <span class='cId' escapeXml='true' > "+o.userid + "</span> "; 
						//	tag += "작성자 : <input class='cId' type='text' name='userid' value='"+o.userid+"' maxlength='10' readonly style='border:none; margin-bottom:6px;'> "; //<span id='editidcheck'>/10</span>&nbsp;&nbsp;";
						//	tag += " <input class='cPwd' type='password' name='userpwd' value='"+o.userpwd+"' maxlength='10' realonly > "; //<span id='editPwdcheck'>/10</span>";
							tag += "</div>";
							tag += "<div style='height:auto'><textarea class='wordcut' class='cContent' name='content' maxlength='150' wrap='hard' style='margin-bottom:0px; height:100px; width:100%'>"+o.content+"</textarea><br><span class='editContentWord'>/150</span>";
							tag += "&nbsp;&nbsp;&nbsp;&nbsp;<span class='"+o.cno+"' style='float:right'><input type='submit' class='finish btn' value='수정하기'></span>";
							tag += "</div>";
						//	tag += "<div class='"+o.cno+"'><button class='finish btn'>완료</button></div>";
							//tag += "<div class='"+o.cno+"'><button class='finish btn'>완료</button><button class='cancel btn' type='button'>취소</button></div>";
						tag += "</form></div>"
							num--;
						
					});//each end
					
					$("#commentList").html(tag);				
				
				
			}, error:function(){
				console.log("댓글 데이터 가져오기 에러 발생")
			}// success, error function end
		}); //ajax end
		
	} //commentList end
$(function(){ 
	
	//댓글 목록 함수 부르기
	commentList();	

	//댓글쓰기
	$(document).on('click', '#commentBtn', function(){
		console.log("comment write in!!!!!!");
/* 		$('#useridLength').css('display','');
		$('#userpwdLength').css('display','');
		$('#commentLength').css('display','');
		$('#useridLength').val('');
		$('#userpwdLength').val('');
		$('#commentLength').val(''); */
	if(submitCheck()){
		//댓 작성
		if($("#content").val()!=''){
			var url ="/myapp/commentWriteOk"; 
			var params=$("#commentForm").serialize(); 
			console.log("comment write content->",$("#content").val());
			console.log("comment val not null ");
			$.ajax({
				url:url,
				data:params,
				success:function(){ //돌려받은 값을 아래에 적기
					console.log("댓글 달기 성공 ");
					commentList();
					$("#content").val("");
					$("#userid").val("");
					$("#userpwd").val("");
					$('#useridLength').val('');
					$('#userpwdLength').val('');
					$('#commentLength').val('');
					$('#useridLength').css('display','none');
					$('#userpwdLength').css('display','none');
					$('#commentLength').css('display','none');
					commentList();
				},error:function(){
					console.log("url->",url);
					console.log("params->",params);
					console.log("댓글 등록 에러 발생");
				} 
				
			});//ajax end
			$('#useridLength').css('display','block'); $('#userpwdLength').css('display','block');	$('#commentLength').css('display','block');
			console.log("length block");
		}//if  
		return false;
	}//submitCheck function end
	return false;
	});//btn end

		//댓삭
		$(document).on('click','.delete', function(){
			if(confirm("선택한 댓글을 삭제하겠습니까?")){
				var cno = $(this).parent().attr("class");
				console.log("click del check !!  cno !!-->" + cno);
				var url = "/myapp/commentCheck";
				var data = "cno="+cno+"&userpwd="; 
				var loc = "no=${vo.no}&cno="+cno; //delUrl
				var obj = $(this);
			
				console.log("delete clcik no --> ", ${vo.no});
				commentCheck(url, data, 'delete', loc, obj);
			}
		});

		//수정
		$(document).on('click','.edit', function(){
			var cno = $(this).parent().attr("class");
			//수정 삭제가 안되는 이유 : 댓글번호를 못갖고옴
			console.log("click edit check !!  cno 1 !!-->" + cno);
			console.log("click edit check !!  cno 2 !! ${cvo.cno}");
			var url = "/myapp/commentCheck";
			var data = "cno="+cno+"&userpwd=";
			var loc = "no=${vo.no}&cno="+cno;
			var obj = $(this);
			console.log("edit click obj ?? " + obj);
			commentCheck(url, data, 'edit', loc, obj);
		});
		//댓글 수정 OK
		$(document).on('submit', '.editForm', function(){
			var obj = $(this);
			//console.log("id, pwd ->" + $('#cId').val() + " , "+ $('#cPwd').val() )
			if(confirm('댓글을 수정하시겠습니까?')){
				if( editSubmitCheck(obj) ){
					$.ajax({
						url : "/myapp/commentEditOk",
						data : $(this).serialize(),
						success : function(result){
							console.log("edit result : sucess 1  or  fail 0 ->", result);
							if(result>0){//성공
								console.log("1. 댓글 수정 성공");
								commentList();
							}else{ //실패
								//alert("댓글 삭제가 실패했습니다.");
								console.log("2. 댓글 수정 실패");
								console.log("edit url -> ", url );
								console.log("edit -> ", data );
							}
						
							commentList();
							console.log("3.  댓글 수정 확인");
						}, error : function(){
							console.log("4. 댓글 수정 에러발생");
							
						}
					});
				}
			}
			return false;
		});
	//댓글 삭제
	function commentDelete(loc){
		var url ="/myapp/commentDelete"; 
		var data = loc;
		$.ajax({
			url : url,
			data : data,
			success : function(result){
				console.log("result : sucess 1  or  fail 0 ->", result);
				if(result>0){//성공
					console.log("댓글 삭제 성공");
					commentList();
				}else{ //실패
					//alert("댓글 삭제가 실패했습니다.");
					console.log("댓글 삭제 실패");
					console.log("delete url -> ", url );
					console.log("delete data -> ", data );
				}
			}, error : function(result){
				console.log("[ 댓삭 실패 ]");
			}
		});
	};
	
	//댓글 수정
	//댓글 수정창 보이기
	function commentEdit(obj){
		
		$(obj).parent().parent().parent().parent().css('display', 'none'); //원래 있던 댓글 숨기기
		$(obj).parent().parent().parent().parent().next().css('display', 'block');
		console.log("edit obj : " + obj);
		//$(this).parent().parent().parent().next().css('display', 'block'); //댓글 수정창 꺼내기
		
		
		var commentPwd =$(obj).parent().parent().parent().parent().next().children().children().eq(4).children().eq(3).val();
		var commentId = $(obj).parent().parent().parent().parent().next().children().children().eq(4).children().eq(1).val();
		var commentContent = $(obj).parent().parent().parent().parent().next().children().children().eq(4).children().val();

 	console.log("1 --> "+$(obj).parent().parent().parent().parent().next().children().children().eq(4).children().eq(5).children().val());
	console.log("2 --> "+$(obj).parent().parent().parent().parent().next().children().children().eq(5).children().val() );
	console.log("3 --> "+$(obj).parent().parent().parent().parent().next().children().children().eq(4).children().val() );
	console.log("4 --> "+$(obj).parent().parent().parent().parent().next().children().children().eq(3).children().val() );
	console.log("5 --> "+$(obj).parent().parent().parent().parent().next().children().children().eq(2).children().val() );
	console.log("6 --> "+$(obj).parent().parent().parent().parent().next().children().children().eq(6).children().val() );
	console.log("7 --> "+$(obj).parent().parent().parent().parent().next().children().children().eq(7).children().val() );
	
	console.log("contentEdit comment content : " + commentContent + "/ length: " + commentContent.length );
	console.log("contentEdit comment id : " + commentId );
	console.log("contentEdit comment pwd : " + commentPwd );
	
	 	
	//$(obj).parent().parent().parent().parent().next().children().children().eq(4).children().next().next().next().text(commentContent.length+"/150");
	$('.editContentWord').text(commentContent.length+"/150");
//	$(obj).parent().parent().parent().parent().next().children().children().eq(3).children().next().text(commentPwd.length+"/10");
//	$(obj).parent().parent().parent().next().children().children().eq(4).children().next().text(commentId.length+"/10");

	
	}
	//수정 확인
	
	
	//댓글 비밀번호 확인
	function commentCheck(url, data, state, loc, obj){
		var pwd = prompt("해당 댓글의 비밀번호를 입력하세요.");
		console.log("commentcheck userpwd ---> ", pwd);
		console.log("commentcheck url ---> ", url);
		console.log("commentcheck data ---> ", data);
		console.log("commentcheck state ---> ", state);
		console.log("commentcheck loc ---> ", loc);
		console.log("commentcheck obj ---> ", obj);
		
		
		if(pwd != null){
			console.log("pwd prompt not null !!");
			$.ajax({
				url : url,
				data : data+pwd,
				success : function(result){
					if(result>0){
						console.log("commentcheck result over 0 delete or edit go!");
						if(state == 'delete'){
							commentDelete(loc);
						}else if(state == 'edit'){
							commentEdit(obj);
						}
					}else{
						alert("비밀번호를 다시 확인해주세요.");
						commentCheck(url, data, state, loc, obj);
					}
				}, error : function(result){
					console.log("[comment check 실패]")	
				}
			})
		}
	} //check end
	
	// 댓글 입력 유효성 검사
	function submitCheck(){
		
		//작성자
		if($("#userid").val().trim()==""){
			alert("작성자를 입력하세요.")
			$("#userid").focus();
			return false;
		}
		if($("#userid").val().length > 10){
			alert("작성자는 10자리까지 입력가능합니다.");
			$("#userpwd").focus();
			return false;
	    }
		//비밀번호 
		var check = userpwd.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
		//var check = userpwd.value.match(/[0-9]/);
		var pw = $("#userpwd").val();
		
		if($("#userpwd").val().trim()==""){
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			$("#userpwd").focus();
			return false;
		}
		if($("#userpwd").val().length < 6){
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			$("#userpwd").focus();
			return false;
		}
		if($("#userpwd").val().length > 10 && !check){
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			$("#userpwd").focus();
			return false;
	    }
		if(pw.search(/\s/) != -1){
			alert("공백으로 비밀번호를 설정할 수 없습니다. \n 비밀번호를 다시 입력해주세요.")
			$("#userpwd").focus();
			return false;
		}
		
		//댓글
		if($("#content").val().trim()==""){
			alert("댓글 내용을 입력하세요.")
			$("#content").focus();
			return false;
		}
		if($("#content").val() =="" || $("#content").val() == null ){
			alert("댓글 내용을 입력하세요.")
			$("#content").focus();
			return false;
		}
		return true;
		//return false;
	}
	//-------- 댓글 수정 ------------
	//댓글 작성자 글자수
	$(document).on('input', '.cId', function(){
		var obj = $(this);
		var wordcheck = $(this).next();
		checkblank(obj, '댓글의 작성자')
		subjectWordCount(obj, wordcheck);
	})
	//댓글  비밀번호 글자수
	$(document).on('input', '.cPwd', function(){
		var obj = $(this);
		var wordcheck = $(this).next();
		checkblank(obj, '댓글의 비밀번호')
		subjectWordCount(obj, wordcheck);
	});
	//댓글 본문 글자수
	$(document).on('input', '.cContent', function(){
		var obj = $(this);
		var wordcheck = $(this).next().next();
		checkblank(obj, '댓글의 본문')
		subjectWordCount(obj, wordcheck);
	});



	//키보드 입력	
	//작성자 글자수
	userid.oninput = function(){
		$('#useridLength').css('display','block');
		var obj = $("#userid");
		var wordcheck = $("#useridLength");
		checkblank(obj, '작성자')
		subjectWordCount(obj, wordcheck);
	}
	//비밀번호 글자수 
	userpwd.oninput = function(e){
		$('#userpwdLength').css('display','block');
		var obj = $("#userpwd");
		var wordcheck = $("#userpwdLength");
		var pwdAlert = $("#pwdMsg");
		
		checkblank(obj, '비밀번호')
		subjectWordCount(obj, wordcheck);
	}
	
	//댓글 본문 글자수
	content.oninput = function(){
		$('#commentLength').css('display','block');
		var obj = $("#content");
		var wordcheck = $("#commentLength");
		checkblank(obj, '댓글')
		subjectWordCount(obj, wordcheck);
	}
	
	//글자수 보여주는 함수--------
	function subjectWordCount(obj, wordcheck){
		//wordcheck.text(obj.val().length + "/" + obj.attr("maxlength"));
		wordcheck.text(obj.val().length + "/" + obj.attr("maxlength"));
		if(obj.val().length > obj.attr("maxlength")){
			setTimeout(function(){
				//alert(obj.attr("maxlength")+"글자까지 입력 가능합니다.")	;	
			}, 100);
			alert(obj.attr("maxlength")+"글자까지 입력 가능합니다.")	;	
			obj.val(obj.val().substr(0, obj.attr("maxlength")));
			wordcheck.text(obj.attr("maxlength") + "/" + obj.attr("maxlength"));
		}
		return obj.val().length;;
		
	}
	//공백 방지하는 함수------------
	function checkblank(obj, title){
		if(obj.val().trim() == "" && obj.val().length > 0){
			alert(title+"의 시작으로 공백이 들어갈 수 없습니다.");
			obj.val('');
		}
	}
	//댓글 수정 유효성 검사
	function editSubmitCheck(obj){
		var flag = true;
	 	
		var idField = $('#cId').val();// $(obj).children().eq(4).children().eq(1); 
		var pwdField =$('#cPwd').val(); //$(obj).children().eq(3).children().eq(3);
		var contentField =  $(obj).children().eq(4).children();
	/*
		console.log(" [수정] editSubmitCheck obj :"+ obj.val()+" / pwd:  " + pwdField.val()+ " / id: " + idField.val() + "  content " + contentField.val());
		비밀번호 유효성 검사
		
		var check = pwdField.val().match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
		var check = pwdField.val().match(/([0-9])/);
		if(pwdField.val().length < 10){
			alert(" [수정] 비밀번호는 10자리까지 입력하세요.")
			pwdField.focus();
			flag = false;
		}
		if(pwdField.val().length > 10  && !check){
			alert(" [수정] 비밀번호는 숫자 10자리를 입력해주세요.");
			pwdField.focus();
			flag = false;
	    }
		if(pwdField.val().search(/\s/) != -1){
			alert("  [수정] 공백으로만 비밀번호를 설정할 수 없습니다. \n 비밀번호는 숫자 10자리를 입력해주세요.")
			pwdField.focus();
			flag = false;
		}
		//작성자 공백 유효성
		if(idField.val().trim()==""){
			alert("작성자를 입력하세요.  [수정]")
			idField.focus();
			flag = false;
		} */
		//글 내용 유효성
		if(contentField.val().trim()==""){
			alert("댓글 내용을 입력하세요. [수정]")
			contentField.focus();
			flag = false;
		}
		if(contentField.val().length > 150){
			alert("댓글 내용은 150자까지 입력가능합니다.");
			contentField.focus();
			return false;
		}
		return flag;
	}
}); //function end
//----------------------------------------------- 파일 업로드 ----------------------------------------------------------





</script>
</head>
<body>
<div class="container">
	<h2>글 보기</h2>
	<input type="hidden" name="no" value="${vo.no}"/>
		<ul id="viewUl">
			<!-- 작성자 -->
			<li class="menuLine">
				<span class="menu">작성자</span>  <span><c:out value="${vo.userid}"  escapeXml="true"></c:out></span>
			<li>
			<li class="menuLine"><span class="menu">등록일</span> ${vo.writedate}</li>
			 <li class="menuLine"><span class="menu">조회수</span> ${vo.hit} </span></li> 
			<!-- 제목 -->
			<%-- <li class="menuLine" id="sub" >${vo.subject}</li> --%>
			<%-- <li> <input id="sub" type="text" value="<c:out value="${vo.subject}"></c:out>"  readonly></li> --%>
			<li> <textarea id="sub" readonly><c:out value="${vo.subject}" escapeXml="true"></c:out></textarea></li>
			
		
			
			<!-- 내용 -->
			<%-- <li>< id="content"><c:out value="${vo.content}" escapeXml="true"></c:out></li> --%>
			<%-- 	<li><textarea id="content" readonly>${vo.content}</textarea></li>  --%>
			<li><textarea id="summernote"  id="content" readonly><c:out value="${vo.content}" escapeXml="true"></c:out></textarea></li> 
			
			<!-- 첨부파일 -->
			<c:if test="${vo.filename != null }">
			<li>
				<span class="menu">첨부파일</span> 
				<div style="margin-left:5px">
				<!-- filename -->
 				<%-- <a href="<%=request.getContextPath()%>/upload/${vo.filename}" download>${vo.filename}</a>
 --%> 					<c:forEach var="file" items="${file}" varStatus="idx">
						<%-- 		
								<c:forEach var="orifile" items="${orifile}">
									<a href="<%=request.getContextPath()%>/WEB-INF/upload/${file}" download>${orifile}</a><br>
								</c:forEach>
						--%>
							
						<!-- 수정해서 orifile이 존재하지 않을 때  -->
						<%-- 	<c:if test="${orifile==null}"> --%>
								<c:forEach var="file" items="${file}">
										<a href="/WEB-INF/upload/${file}" download>${file}</a><br>
							
								</c:forEach>
						<%-- 	</c:if> --%>
							
					</c:forEach>
				</div>
			 </li>
			 </c:if>
		</ul>
		<div id="btnLine">
		<!-- 삭제된 글이면 수정, 삭제 불가능  -->
			<c:if test="${vo.subject ne '삭제된 글입니다.'}">

			<button class="btn" onClick="boardEdit()">수정하기</button>
			<button class="btn" onClick="boardDelete()">삭제하기</button>	
		
			<button class="btn" onClick="location.href='<%=request.getContextPath()%>/replyWrite?no=${vo.no}&pageNum=${sapvo.pageNum}'">답글쓰기</button>	
			</c:if>
			
			<input type="button" value="목록" class="btn" onClick="location.href='<%=request.getContextPath()%>/boardList?pageNum=${sapvo.pageNum}'"/>
		</div>
		<br/>
		<hr/>
		
		<!------------------- 댓글 작성 ----------------------->
		<h4>comment</h4>
		<div id="commentContainer">
		<form method="post" id="commentForm" >
		<div style="margin-bottom:7px;" id="commentIdPwdDiv">
			<input type="hidden" name="no" value="${vo.no}">
			<label style="margin-right:16px;">작성자&nbsp;</label>&nbsp;<input type="text" name="userid" id="userid" maxlength="10"> <span id="useridLength"></span><!-- /<span id="max_count">10</span> --><br/>
			 <label style="margin-top:12px;">비밀번호</label><input type="password" name="userpwd" id="userpwd" inputmode="numeric" class="input-number-password"  maxlength="10"> <span id="userpwdLength"></span><!-- /<span id="max_count">4</span> -->
			 <input type ="submit" value="댓글등록" id="commentBtn" class="btn" style="float:right;"><br/>
		</div >
			<textarea name="content" id="content"  id="sub" class="wordCut" maxlength="150" style="margin-bottom:0px; height: 100px; width:100%;"></textarea><span id="commentLength"></span><!-- /<span id="max_count">150</span> -->
				 
		</form>
		</div>
		<hr/>
		<!-- 댓글 목록 -->
	<%-- 	<span>[전체 댓글 수 : ${list.size} ] </span> --%>
		<div id="commentList" > <!-- webSpring01 -->
		</div>
</div>
</body>
</html>