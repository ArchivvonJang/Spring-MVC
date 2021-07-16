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
	#content{overflow:scroll; border:1px solid lightgray; padding:10px;}
	#btnLine{margin-top:10px;}
	.menuLine{margin: 10px 0 15px 0;}
	#sub{font-size:1em; border: 1px solid lightgray; height:40px; line-height:40px; padding-left:10px;}
</style>
<script type="text/javascript">
	// $(function(){	}); 아래랑 같은기능을 하는 다른표기법
	$(()=>{
		$("#boardDel").click(()=>{
			if(confirm("삭제하시겠습니까?")){
				location.href="boardDelete?no=${vo.no}";
			};
		});
		
	});
</script>
</head>
<body>
<div class="container">
	<h2>게시판</h2>
	<input type="hidden" name="no" value="${vo.no}"/>
		<ul>
			<li class="menuLine"><span class="menu">작성자</span> ${vo.userid}</li>
			<li class="menuLine"><span class="menu">등록일</span> ${vo.writedate}</li>
			<li class="menuLine"><span class="menu">조회수</span> ${vo.hit}</li>
			<br/>
			<li class="menuLine" id="sub" class="wordcut" >${vo.subject}</li>
			<li id="content">${vo.content}</li>
		</ul>
		<div id="btnLine">
			<button class="btn"><a href="boardEdit?no=${vo.no}" >수정하기</a></button>
			<button class="btn"><a href="#" id="boardDel">삭제하기</a></button>
			<input type="button" value="목록" class="btn" onClick="location.href='<%=request.getContextPath()%>/boardList'"/>
		</div>
</div>
</body>
</html>