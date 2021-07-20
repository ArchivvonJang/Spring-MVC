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
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/boardStyle.css">
<style>
	.menu{margin-right:10px; font-weight: bold;}
	#btnLine{margin:0 auto;width:1000px; text-algin:center;}
	ul{}
	.menuLine{margin: 10px 0 15px 0;}
	#sub{
		font-size:1em; border: 1px solid lightgray; 
		height:40px ; line-height:40px; padding-left:10px; 
		white-space:normal; word-break:break-all;  text-overflow:ellipsis;
		width: 1110px; overflow: auto;
		margin-bottom:15px;
	 }
	#content{
		 padding:10px; width: 1110px; height: 700px auto; border:1px solid lightgray; word-break:break-all; overflow: auto;
		margin-bottom:15px; 
	}
</style>
<script type="text/javascript">
	// $(function(){	}); 아래랑 같은기능을 하는 다른표기법
	$(()=>{
		$("#boardDel").click(()=>{
			if(confirm("삭제하시겠습니까?")){
				location.href="boardDelete?no=${vo.no}";
				//getUserpwd(window.location.href);
			};
		});
		$("#boardEdit").click(()=>{
			if(confirm("수정하시겠습니까?")){
				location.href="boardEdit?no=${vo.no}";
				//getUserpwd(window.location.href);
			};
		});
	
		function getUserpwd(locationUrl){
			var pwd = prompt("비밀번호를 입력하세요");
			
			if(pwd != null){
				checkUserpwd(pwd, window.location.href);
			}
			if(pwd != ''){
				checkUserpwd(pwd, window.location.href);
			}
			if(pwd == '' || pwd==null){
				alert("다시 입력해주세요");
				return false;
			}
		}
		function checkUserpwd(pwd, locationUrl){
			$.ajax({
				url : "/webapp/getUserpwd",
				data : "no=${vo.no}&userpwd="+pwd,
				success : function(result){
					if(result==0){
						alert("비밀번호를 다시 확인해주세요.");		
						getUserpwd(window.location.href);
						console.log('url : ',window.location.href)
					}else if(result==1){
						location.href = window.location.href;
					}
				}, error : function(){
					
				}
			});
		}
	
	});
</script>
</head>
<body>
<div class="container">
	<h2>게시판</h2>
	<input type="hidden" name="no" value="${vo.no}"/>
		<ul>
			<!-- 작성자 -->
			<li class="menuLine">
				<span class="menu">작성자</span>  <span><c:out value="${vo.userid}"></c:out></span>
			<li>
			<li class="menuLine"><span class="menu">등록일</span> ${vo.writedate}</li>
			<li class="menuLine"><span class="menu">조회수</span> ${vo.hit}</li>
			<!-- 제목 -->
			<%-- <li class="menuLine" id="sub" >${vo.subject}</li> --%>
			<li> <input id="sub" type="text" value="<c:out value="${vo.subject}"></c:out>"  readonly></li>
			<!-- 내용 -->
			 <li id="content">${vo.content}</li> 
			
		</ul>
		<div id="btnLine">
			<%-- <button class="btn"><a href="boardEdit?no=${vo.no}" >수정하기</a></button> --%>
			<button class="btn"><a href="#" id="boardEdit" >수정하기</a></button>
			<button class="btn"><a href="#" id="boardDel">삭제하기</a></button>
			<input type="button" value="목록" class="btn" onClick="location.href='<%=request.getContextPath()%>/boardList'"/>
		</div>
</div>
</body>
</html>