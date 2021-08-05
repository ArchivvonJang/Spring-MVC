package com.myproject.myapp.vo;

public class SearchAndPageVO {
	private String userid;
	
	//검색어와 검색키
	private String searchKey;
	private String searchWord;
	private String searchid;
	private String searchnum;
	//페이지
	// 총레코드수가 발생하면, 총페이지수를 구하기 가능 -> 총페이지수가 나오면 마지막페이지에 레코드가 몇개 남았는지 확인 -> 그럼 시작페이지알수있음
	// 초기값 설정 , 값 변동 x
	private int onePageNum=5;//한페이지당 페이지 갯수 1 2 3 4 5
	private int onePageRecord=10;//한페이지당 레코드수
	
	//초기값o,변동o
	private int pageNum=1;//현재페이지 					초기 세팅해줘야하는 값 3개	private int pageNum=1;//현재페이지 					초기 세팅해줘야하는 값 3개	private int pageNum=1;//현재페이지 					초기 세팅해줘야하는 값 3개
	private int startPageNum=1;//시작페이지 =3 이면 3페이지부터 시작
	private int lastPage=5; //한 페이지의 페이지 개수의 마지막 번호  
	//끝 페이지 : 시작 페이지 + 출력할 페이지 목록 수 - 1 (마지막 범위는 따로 처리)
	//초기값x, 변동d
	private int totalRecord;//총 레코드 수 	(검색어에 해당하는)	
	private int totalPage;//마지막페이지, 총 페이지 수 
	private int lastPageRecord;//마지막 페이지의 남은 레코드수
	// 현재페이지의 시작 게시글 번호 = (현재 페이지 번호 - 1)*페이지 당 출력할 게시글 갯수
	//이전글 다음글
	private int prevNo;//이전글번호
	private String prevSubject;//이전글제목
	private int nextNo;//다음글번호
	private String nextSubject;//다음글제목
	
	// 정렬 
	private String sortRecord;
	
	//댓글
	private int totalCommentRecord;
	
	//getter setter
	//검색
	public String getSearchKey() {
		return searchKey;
	}
	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}
	public String getSearchWord() {
		return searchWord;
	}
	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}
	
	//페이징
	public int getPageNum() {
		return pageNum;
	}
	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
		//미리 계산하기 -> 시점만 구해서 그 메소드 안에서 구하면됨
				//시작페이지 번호 계산
				startPageNum =  (pageNum-1)/onePageNum*onePageNum+1; //1, 11, 21 한페이지당 출력할 넘버수만큼 알아서 n페이지가 찍혀야함
	}
	public int getOnePageNum() {
		return onePageNum;
	}
	public void setOnePageNum(int onePageNum) {
		this.onePageNum = onePageNum;
	}
	public int getOnePageRecord() {
		return onePageRecord;
	}
	public void setOnePageRecord(int onePageRecord) {
		this.onePageRecord = onePageRecord;
	}
	public int getTotalRecord() {
		return totalRecord;
	}
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
		
		//미리 계산
			//총 레코드수를 이용하여 총 페이지수를 계산
			totalPage = (int)Math.ceil(totalRecord/(double)onePageRecord) ; //실수로 계산하고 그다음에 올림하고 정수로 바꿈
			
			//마지막페이지 레코드수  
			if(totalRecord % onePageRecord == 0) { //짜투리가 없는것 (남아있는 레코드가 없을 때 10의 배수)
				lastPageRecord = onePageRecord;
			}else { //짜투리가 있으면 
				lastPageRecord = totalRecord%onePageRecord; //마지막페이지의 남은 레코드 수 
			}
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getStartPageNum() {
		return startPageNum;
	}
	public void setStartPageNum(int startPageNum) {
		this.startPageNum = startPageNum;
	}
	public int getLastPageRecord() {
		return lastPageRecord;
	}
	public void setLastPageRecord(int lastPageRecord) {
		this.lastPageRecord = lastPageRecord;
	}
	
	//이전글 다음글
	
	
	public int getPrevNo() {
		return prevNo;
	}
	public void setPrevNo(int prevNo) {
		this.prevNo = prevNo;
	}
	public String getPrevSubject() {
		return prevSubject;
	}
	public void setPrevSubject(String prevSubject) {
		this.prevSubject = prevSubject;
	}
	public int getNextNo() {
		return nextNo;
	}
	public void setNextNo(int nextNo) {
		this.nextNo = nextNo;
	}
	public String getNextSubject() {
		return nextSubject;
	}
	public void setNextSubject(String nextSubject) {
		this.nextSubject = nextSubject;
	}
	//정렬
	public String getSortRecord() {
		return sortRecord;
	}
	public void setSortRecord(String sortRecord) {
		this.sortRecord = sortRecord;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getSearchid() {
		return searchid;
	}
	public void setSearchid(String searchid) {
		this.searchid = searchid;
	}
	public String getSearchnum() {
		return searchnum;
	}
	public void setSearchnum(String searchnum) {
		this.searchnum = searchnum;
	}
	public int getLastPage() {
		return lastPage;
	}
	public void setLastPage(int lastPage) {
		this.lastPage = lastPage;
	}
	public int getTotalCommentRecord() {
		return totalCommentRecord;
	}
	public void setTotalCommentRecord(int totalCommentRecord) {
		this.totalCommentRecord = totalCommentRecord;
	}

	
}
