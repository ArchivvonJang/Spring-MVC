package com.myproject.myapp.vo;

public class BoardVO {
	private int no;
	private int rownum;
	private String subject;
	private String content;
	private String userid;
	private String userpwd;
	private int hit;
	private String writedate;
	
	private int ref; // 답글 그룹 (== 같은원글번호)
	private int step; // 답글 들여쓰기
	private int lvl; //답글 순서
	
	//파일업로드
	//private String filename;
	//private int downcount;
	
	private String filename[]; // 파일명 저장 배열
	private String delfile[]; // 삭제할 파일을 담을 변수
	private int downcount; //다운로드 횟수
	
	private int replyRecord;
	
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getUserpwd() {
		return userpwd;
	}
	public void setUserpwd(String userpwd) {
		this.userpwd = userpwd;
	}
	public int getHit() {
		return hit;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}
	public String getWritedate() {
		return writedate;
	}
	public void setWritedate(String writedate) {
		this.writedate = writedate;
	}
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	public int getRef() {
		return ref;
	}
	public void setRef(int ref) {
		this.ref = ref;
	}
	public int getStep() {
		return step;
	}
	public void setStep(int step) {
		this.step = step;
	}
	public int getLvl() {
		return lvl;
	}
	public void setLvl(int lvl) {
		this.lvl = lvl;
	}
	public int getReplyRecord() {
		return replyRecord;
	}
	public void setReplyRecord(int replyRecord) {
		this.replyRecord = replyRecord;
	}
	public String[] getFilename() {
		return filename;
	}
	public void setFilename(String[] filename) {
		this.filename = filename;
	}
	public String[] getDelfile() {
		return delfile;
	}
	public void setDelfile(String[] delfile) {
		this.delfile = delfile;
	}
	public int getDowncount() {
		return downcount;
	}
	public void setDowncount(int downcount) {
		this.downcount = downcount;
	}
	
	

	
}
