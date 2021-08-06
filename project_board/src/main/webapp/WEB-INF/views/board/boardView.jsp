<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>선택한 글보기</title>
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
</style>
<script type="text/javascript">

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
				//var url ="/myapp/getUserpwd";
				//getUserpwd(url, data, loc);
			var loc = "/myapp/boardDelete?no=${vo.no}";	
			var data = "no=${vo.no}&userpwd=";	
			getUserpwd(data, loc);
			console.log(" delete data : ", data, " loc :", loc);
		};

		function boardEdit(){
			var loc = "/myapp/boardEdit?no=${vo.no}";
			var data = "no=${vo.no}&userpwd=";
			getUserpwd(data, loc);
			//console.log("edit data : ", data, " loc :", loc);
		};
	
		function getUserpwd(data, loc){
			console.log("getuserpwd in !!")
			var pwd = prompt("비밀번호를 입력하세요");
			var param = data + pwd;
			if(pwd != null || pwd != " "){
				console.log("pwd check ! go to check userpwd")
				checkUserpwd(param, loc);
			}
			/* if(pwd != ''){
				checkUserpwd(pwd, window.location.href);
			} */
			if(pwd == '' || pwd==null){
				//alert("다시 입력해주세요");
				return false;
			}
		}
		//function checkUserpwd(url, param, loc){
		function checkUserpwd(param, url){
			console.log("checkUserpwd ajax");
			$.ajax({
				url : "/myapp/getUserpwd",
				data : param,
				success : function(result){
					if(result==0){
					
						//alert("비밀번호를 확인해주세요.");		
						getUserpwd(url);
						console.log("ajax check url : ", url, "result-->, result");
						
					}else if(result==1){
						location.href = url;
						console.log("url-->",url);
						console.log("result-->",result);
					}
				}, error : function(){
			
					console.log("!!checkUserpwd ajax function error!!")
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

//------------------------ ajax를 이용한 댓글처리 -------------------------
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
				console.log("ajax comment list in!!!!!!");
				//변수이름이 $result
				var $result = $(result);
				console.log("ajax result !!!!!!!!!");
				var num = result.length; 
				console.log("commentList num ->",num);
				tag="<ul>"
				//반복
					$result.each(function(i, o){
						console.log("result in!!!!!!!!!!!!");
						tag += "<li> <span id='numColor'>("+ num +")</span> &nbsp; <span  escapeXml='true'> 작성자 : "+o.userid + "</span> &nbsp; [ " + o.cdate + " ] </li>";
						tag += "<li escapeXml='true' ><input type='text' value='" + o.content  + "'readonly cols='20' style='width:89%'>";
						tag += "<span style='float:right;'><button class='edit btn' >수정</button>&nbsp;&nbsp;<button class='delete btn'>삭제</button></span>"
						tag += "</li>";
						tag += "<li><input type='hidden' value='"+o.userpwd+"'/></li>";
						
						tag+="</ul><br/>";
						
					
						tag += "<div class='editDiv' style='display:none;'><form class='editForm' method='post' onsubmit='return false'>"
							tag += "<input type='hidden' name='no' value='${vo.no}'/>"
							tag += "<input type='hidden' name='cno' value='"+o.cno+"'/>"
							tag += "<div class='cno'>"+num+"</div>";
							tag += "<div class='cPwd cId'> 비밀번호 : <input class='cPwd' type='password' name='userpwd' value='"+o.userpwd+"' maxlength='10'><span id='editPwdcheck'>0/10</span></div>";
							tag += "<div class='cId' > 작성자 : <input class='cId' type='text' name='userid' value='"+o.userid+"' maxlength='5'><span id='editidcheck'>0/5</span></div>";
							tag += "<div class='"+o.cno+"'><button class='finish'>완료</button><button class='cancel' type='button'>취소</button></div>";
							tag += "<div><textarea class='cContent' name='content' maxlength='250' wrap='hard'>"+o.content+"</textarea><br><span class='editContentWord'>0/250</span></div>";
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
	commentList();	

	//댓글쓰기
	$(document).on('click', '#commentBtn', function(){
	console.log("comment write in!!!!!!")
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
					commentList();
				},error:function(){
					console.log("url->",url);
					console.log("params->",params);
					console.log("댓글 등록 에러 발생");
				} 
			});//ajax end
		}//if  end
		return false;
	}//submitCheck function end
	return false;
	});//btn end

		//댓삭
		$(document).on('click','.delete', function(){
			if(confirm("선택한 댓글을 삭제하겠습니까?")){
				var cno = $(this).parent().attr("class");
				var url = "/myapp/commentCheck";
				var data = "cno="+cno+"&userpwd=";
				var delUrl = "no=${vo.no}&cno="+cno;
				var obj = $(this);
				
				commentCheck(url, data, 'delete', delUrl, obj);
			}
		});

		//수정
		$(document).on('click','.edit', function(){
			var cno = $(this).parent().attr("class");
			var url = "/webapp/commentCheck";
			var data = "cno="+cno+"&userpwd=";
			var delUrl = "no=${vo.no}&cno="+cno;
			var obj = $(this);
			
			commentCheck(url, data, 'edit', editUrl, obj);
		});

	//댓글 삭제
	function commentDelete(location){
		$.ajax({
			url : "/myapp/commentDelete",
			data : location,
			success : function(result){
				if(result>0){//성공
					replyList();
				}else{ //실패
					alert("댓글 삭제가 실패했습니다.");
				}
			}, error : function(result){
				console.log("[ 댓삭 실패 ]");
			}
		});
	};
	
	//댓글 수정
	//댓글 수정창 보이기
	function commentEdit(obj){
		$(obj).parent().parent().css('display', 'none');
		$(obj).parent().parent().next().css('display', 'block');
		var pwdCount = $(obj).parent().parent().next().children().children().eq(3).children().val().length;
		var idcount = $(obj).parent().parent().next().children().children().eq(4).children().val().length;
		var contentcount = $(obj).parent().parent().next().children().children().eq(6).children().val().length;
		console.log(contentcount);
		$(obj).parent().parent().next().children().children().eq(3).children().next().text(pwdCount+"/10");
		$(obj).parent().parent().next().children().children().eq(4).children().next().text(idcount+"/5");
		$(obj).parent().parent().next().children().children().eq(6).children().next().text(contentcount+"/250");
	}
	//수정 확인
	
	//댓글 비밀번호 확인
	function commentCheck(url, data, state, location, obj){
		var pwd = prompt("해당 댓글의 비밀번호를 입력하세요.")
		
		if(pwd != null){
			$.ajax({
				url : url,
				data : data+pwd,
				success : function(result){
					if(result>0){
						if(state == 'delete'){
							commentDel(location);
						}else if(state == 'edit'){
							commentEdit(obj);
						}
					}else{
						alert("비밀번호를 다시 확인해주세요.")
						commentCheck(url, data, state, location, obj);
					}
				}, error : function(result){
					
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
		//비밀번호 
		//var check = userpwd.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
		var check = userpwd.value.match(/[0-9]/);
		var pw = $("#userpwd").val();
		
		if($("#userpwd").val().trim()==""){
			alert("비밀번호는 숫자 4자리를 입력해주세요.");
			$("#userpwd").focus();
			return false;
		}
		if($("#userpwd").val().length < 4){
			alert("비밀번호는 숫자 4자리를 입력해주세요.");
			$("#userpwd").focus();
			return false;
		}
		if($("#userpwd").val().length > 4 && !check){
			alert("비밀번호는 숫자 4자리를 입력해주세요.");
			$("#userpwd").focus();
			return false;
	    }
		if(pw.search(/\s/) != -1){
			alert("공백으로 비밀번호를 설정할 수 없습니다. \n 비밀번호는 4자리 숫자를 입력해주세요.")
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
	//-------- 수정 ------------
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
	$(document).on('input', '.cText', function(){
		var obj = $(this);
		var wordcheck = $(this).next().next();
		checkblank(obj, '댓글의 본문')
		subjectWordCount(obj, wordcheck);
	});
	
	//키보드 입력	
	//작성자 글자수
	userid.oninput = function(){
		var obj = $("#userid");
		var wordcheck = $("#useridLength");
		checkblank(obj, '작성자')
		subjectWordCount(obj, wordcheck);
	}
	//비밀번호 글자수 
	userpwd.oninput = function(e){
		var obj = $("#userpwd");
		var wordcheck = $("#userpwdLength");
		var pwdAlert = $("#pwdMsg");
		
		checkblank(obj, '비밀번호')
		subjectWordCount(obj, wordcheck);
	}
	
	//댓글 본문 글자수
	content.oninput = function(){
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
				alert(obj.attr("maxlength")+"글자까지 입력 가능합니다.")		
			}, 100);
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
	
}); //function end

</script>
</head>
<body>
<div class="container">
	<h2>게시판</h2>
	<input type="hidden" name="no" value="${vo.no}"/>
		<ul>
			<!-- 작성자 -->
			<li class="menuLine">
				<span class="menu">작성자</span>  <span><c:out value="${vo.userid}"  escapeXml="true"></c:out></span>
			<li>
			<li class="menuLine"><span class="menu">등록일</span> ${vo.writedate}</li>
			<%-- <li class="menuLine"><span class="menu">조회수</span> ${vo.hit}</li> --%>
			<!-- 제목 -->
			<%-- <li class="menuLine" id="sub" >${vo.subject}</li> --%>
			<%-- <li> <input id="sub" type="text" value="<c:out value="${vo.subject}"></c:out>"  readonly></li> --%>
			<li> <textarea id="sub" readonly><c:out value="${vo.subject}" escapeXml="true"></c:out></textarea></li>
			<!-- 내용 -->
			<%-- <li>< id="content"><c:out value="${vo.content}" escapeXml="true"></c:out></li> --%>
			<%-- 	<li><textarea id="content" readonly>${vo.content}</textarea></li>  --%>
			<li><textarea id="summernote"  id="content" readonly><c:out value="${vo.content}" escapeXml="true"></c:out></textarea></li> 
		</ul>
		<div id="btnLine">
			<%-- <button class="btn"><a href="boardEdit?no=${vo.no}" >수정하기</a></button> --%>
			<button class="btn" onClick="boardEdit()"><a href="" id="boardEdit" >수정하기</a></button>
			<button class="btn" onClick="boardDelete()"><a href="" id="boardDel">삭제하기</a></button>	
		
			<button class="btn" onClick="location.href='<%=request.getContextPath()%>/replyWrite?no=${vo.no}'">답글쓰기</button>	
				<input type="button" value="목록" class="btn" onClick="location.href='<%=request.getContextPath()%>/boardList'"/>
		</div>
		<br/>
		<hr/>
		
		<!------------------- 댓글 ----------------------->
		<h4>comment</h4>
		<div id="commentContainer">
		<form method="post" id="commentForm" >
		<div style="margin-bottom:7px;">
			<input type="hidden" name="no" value="${vo.no}">
			&nbsp; 	<label>작성자</label>&nbsp;&nbsp;&nbsp;<input type="text" name="userid" id="userid" maxlength="10"> <span id="useridLength"></span><!-- /<span id="max_count">10</span> -->
			 &nbsp; &nbsp;<label>비밀번호</label><input type="number" name="userpwd" id="userpwd" inputmode="numeric" class="input-number-password"  maxlength="4"> <span id="userpwdLength"></span><!-- /<span id="max_count">4</span> -->
			 <input type ="submit" value="댓글등록" id="commentBtn" class="btn" style="float:right;"><br/>
		</div>
			<textarea name="content" id="content" id="sub" maxlength="150" style="margin-bottom:0px;"></textarea>	<span id="commentLength"></span><!-- /<span id="max_count">150</span> -->
				
		</form>
		</div>
		<br/>
		<!-- 댓글 목록 -->
	<%-- 	<span>[전체 댓글 수 : ${list.size} ] </span> --%>
		<div id="commentList"> <!-- webSpring01 -->
		</div>
</div>
</body>
</html>