<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>view</title>
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
		 padding:10px; width: 100%;height:500px auto; border:1px solid lightgray; word-break:break-all; overflow:auto;
		margin-bottom:15px; 
	}
	.note-editor.note-airframe .note-editing-area .note-editable[contenteditable=false], .note-editor.note-frame .note-editing-area .note-editable[contenteditable=false] {
    background-color: white; height: 500px auto;
	}
	#reviewContainer{margin-top:20px;}
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
			var loc = "/myapp/boardDelete?no=${vo.no}";//location url
			var data = "no=${vo.no}&userpwd=";	
			getUserpwd(data, loc);
			console.log("delete data : ", data, " loc :", loc);
		};

		function boardEdit(){
			var loc = "/myapp/boardEdit?no=${vo.no}";
			var data = "no=${vo.no}&userpwd=";
			getUserpwd(data, loc);
			console.log("edit data : ", data, " loc :", loc);
		};
	
		function getUserpwd(data, loc){
			console.log("getuserpwd in !!")
			var pwd = prompt("비밀번호를 입력하세요");
			var param = data + pwd;
			console.log("data : ", data, " / loc :", loc , " / param : ", param);
			if(pwd != null || pwd != " "){
				console.log("pwd check ! go to checkuserpwd")
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
		function checkUserpwd(param, loc){
			console.log("checkUserpwd ajax");
			console.log("checkUserpwd param : " , param,"/ loc : ",loc);
			$.ajax({
				url : "/myapp/getUserpwd",
				data : param,
				success : function(result){
					if(result==0){
						//alert("비밀번호를 확인해주세요.");		
						//getUserpwd(data,loc);
						console.log("ajax check loc : ", loc);
						
					}else if(result==1){
						location.href = loc;
					}
				}, error : function(){
			
					console.log("!!checkUserpwd ajax function error!!")
				}
			});
		}
	
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
$(function(){
	//댓글목록
	function reviewList(){
		var url = "/reviewList";
		var params = "no=${vo.no}";
		console.log(url);
		console.log(params);
		$.ajax({
			url:url,
			data:params,
			success:function(result){
				//변수이름이 $result
				var $result=$(reviewList);
				var tag="<ul>"
				//반복
					$result.each(function(i, o){
						tag+="<li><div>"+o.userid+"("+o.replydate+") ";
					
						tag+="<br/>"+o.content+"</div>";
					
						tag+="</li>";
					});//each end
					tag+="</ul>";
					$("#reviewList").html(tag);				
				
				
			}, error:function(){
				console.log("댓글 데이터 가져오기 에러 발생")
			}// success, error function end
		}); //ajax end
		
	} //reviewList end
	//댓글쓰기
	$('#reviewBtn').on('click',function(){
		if($("#content").val()!=''){
			var url ="/reviewWriteOk"; 
			var params=$("#reviewForm").serialize(); 
	
			$.ajax({
				url:url,
				data:params,
				success:function(result){ //돌려받은 값을 아래에 적기
					console.log("댓글 달기 성공 ");
					reviewList();
					$("#content").val("");
				},error:function(){
					console.log("url->",url);
					console.log("params->",params);
					console.log("댓글 등록 에러 발생");
				} 
			});//ajax end
		}else{
			alert("댓글을 입력하세요.");
		}//if else end
	});
	

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
			<input type="button" value="목록" class="btn" onClick="location.href='<%=request.getContextPath()%>/boardList'"/>
			<button class="btn"><a href="<%=request.getContextPath()%>/claseWrite?no=${vo.no}">답글달기</a></button>	
		</div>
		
		<!------------------- 댓글 ----------------------->
		<div id="reviewContainer">
		<form method="post" action=" " id="reviewForm">
			<input type="hidden" name="no" value="">
				<textarea name="content" id="content" id="sub"></textarea>
				<label>작성자</label><input type="text" name="userid" id="userid" maxlength="10">
				<label>비밀번호</label><input type="number" name="userpwd" id="userpwd" maxlength="4">
				<input type ="button" value="댓글등록" id="reviewBtn" class="btn">
		</form>
		</div>
		<!-- 댓글 목록 -->
		<span>[전체 댓글 수 : ${reviewRecord} ] </span>
		<div id="reviewList"> <!-- webSpring01 -->
		</div>
</div>
</body>
</html>