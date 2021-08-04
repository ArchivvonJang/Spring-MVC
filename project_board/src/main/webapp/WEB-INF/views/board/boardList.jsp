<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>list</title>
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
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/list.css">
<script>
	//검색어 확인
	$(function(){
		$("#searchForm").submit(function(){
			//searchWord있는지 없는지 찾기 , 있을때만 데이터 넘기기
			if($('#searchWord').val()=="" || $('#searchWord').val()==null){
				alert("검색어를 입력하세요.");
				return false;
			}
			return true;
		});
		if(${sapvo.totalRecord == 0}){
			alert("검색 결과가 없습니다.");		
			history.back();
		}
	});
</script>
</head>
<body>
	<div class="container">
		<h2>게시판</h2>
	
		<!-- 검색하기 -->
		<div id="search_container" style="height:30px;">		
		<form method="get" action="boardList" id="searchForm">
			<input type="text" id="searchWord" name="searchWord" placeholder="검색하기" <c:if test="${sapvo.searchWord != null || sapvo.searchWord != ''}">value="${sapvo.searchWord}"</c:if>><input type="submit" id="searchBtn" value="검색"/>			
		</form>	
		</div>
		<div id="totalList">
			[ total &nbsp; ${sapvo.totalRecord} ]  &nbsp;  &nbsp; 
			<a href="<%=request.getContextPath()%>/boardList">전체보기</a>
		</div>
		<!-- search_container end -->
		<ul id="boardList">
			<li class="menu">번호</li>
			<li class="menu" style="text-align:center">제목</li>
			<li class="menu">글쓴이</li>
			<li class="menu">조회수</li>
			<li class="menu">등록일</li>
		<!-- 변수 선언 -->
		<!-- 									총 레코드 수 - ((현재 페이지-1) * 한 페이지 레코드 ) -->
		<c:set var="recordNum" value="${totalRecord - ((sapvo.pageNum-1) * sapvo.onePageRecord)}"/>
		<c:forEach var="vo" items="${list}" >
			<!-- 번호 -->
			<li>${recordNum}<input type="hidden" name="no" value="${vo.no}"/></li>
			<!-- 답글 -->
			<c:if test="${vo.step>0}">
			<li class="wordCut">
			<c:forEach var="i" begin="1" end="${vo.step}">
			<!-- 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
			</c:forEach>
			<c:if test="${vo.step>0}">
					⤷
			</c:if>
			</li>
			</c:if>
			<!-- 제목 -->
			<li class="wordcut" id="sub"><a href="boardView?no=${vo.no}" style="white-space: pre"><c:out value="${vo.subject}" escapeXml="true"></c:out></a></li>
			<!-- 글쓴이 -->
			<li class="wordcut" id="sub"><c:out value="${vo.userid}"></c:out></li>
			<!-- 조회수 -->
			<li>${vo.hit }</li>
			<!-- 작성일 -->
			<li>${vo.writedate}</li>
			<c:set var="recordNum" value="${recordNum-1}"/>
		</c:forEach>
			
		</ul>
		<div id="btnLine">
			<button class="btn"><a href="<%=request.getContextPath()%>/boardWrite">글쓰기</a></button> 
		</div>
		
	</div>
		<!-------------- pagination------------------>
		<div class="page_wrap">
			<div class="page_nation">
			<!-- 1페이지 이상 레코드가 있어야지 화살표가 추가된다. -->
			<c:if test="${sapvo.pageNum>1}"><!-- 이전페이지가 있을때 -->
			  	<!--맨앞으로-->
  				<a class="arrow pprev" href="boardList?pageNum=1<c:if test="${sapvo.searchWord != null && sapvo.searchWord != ''}">&searchWord=${sapvo.searchWord}</c:if>">◀</a>
				<!--앞으로 1개 이상 존재하면,-->
				<c:if test="${sapvo.startPageNum > 1}"> 
        		<a class="arrow prev" href="boardList?pageNum=${sapvo.startPageNum-1}<c:if test="${sapvo.searchWord != null && sapvo.searchWord != ''}">&searchWord=${sapvo.searchWord}</c:if>">◁</a>
 				</c:if>
 			</c:if>
 				<!--레코드 갯수에 따른 페이지 갯수 표시 :  jstl c tag를 사용하여 startPageNum(시작페이지)부터 끝(마지막페이지 -> 시작페이지+한 페이지당 페이지수-1)까지 반복하여 값을 꺼낸다.--> 
         		<c:forEach var="p" begin="${sapvo.startPageNum}" end="${(sapvo.startPageNum + sapvo.onePageNum)-1}">
	         		<!--p가 총페이지수보다 작거나같을때  레코드가 있는 페이지까지만 표시 -->
	            	<c:if test="${p<=sapvo.totalPage}">  
						<!--현재페이지 :  현재보고있는 페이지 표시 -->
		               <c:if test="${p==sapvo.pageNum}">
		                  <a class="on" href="boardList?pageNum=${p}<c:if test="${sapvo.searchWord != null && sapvo.searchWord != ''}">&searchWord=${sapvo.searchWord}</c:if>">${p}</a>
		               </c:if>
		               <!-- 현재페이지가 아닐 때 -->
		               <c:if test="${p!=sapvo.pageNum}">
		                  <a href="boardList?pageNum=${p}<c:if test="${sapvo.searchWord != null && sapvo.searchWord != ''}">&searchWord=${sapvo.searchWord}</c:if>">${p}</a>
		               </c:if>
	            	</c:if>
        		</c:forEach>
        
        		<!-- 다음 페이지가 있을 때 ,총페이지수가 한 페이지세트 끝번호보다 크면 -->
        		<c:if test="${sapvo.pageNum <= sapvo.totalPage}">
				<!--뒤로-->            
	         	<a class="arrow next" href="boardList?pageNum=${sapvo.startPageNum + sapvo.onePageNum}<c:if test="${sapvo.searchWord != null && sapvo.searchWord != ''}">&searchWord=${sapvo.searchWord}</c:if>">▷</a>
				</c:if>
				<!--맨뒤로-->
				<c:if test="${sapvo.pageNum != sapvo.totalPage }">
	         	<a class="arrow nnext" href="boardList?pageNum=${sapvo.totalPage}<c:if test="${sapvo.searchWord != null && sapvo.searchWord != ''}">&searchWord=${sapvo.searchWord}</c:if>">▶</a>
			 	</c:if>
			
			</div>
		 </div> 
		 <!-------------- 페이징 끝 --------------->
	
</body>
</html>