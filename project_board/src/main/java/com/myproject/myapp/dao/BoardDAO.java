package com.myproject.myapp.dao;

import java.util.List;


import com.myproject.myapp.vo.BoardVO;
import com.myproject.myapp.vo.CommentVO;
import com.myproject.myapp.vo.SearchAndPageVO;

public interface BoardDAO {
	//게시판
	
	//전체 레코드
	public List<BoardVO> boardAllRecord(SearchAndPageVO sapvo);
	// 게시글 작성
	public int boardInsert(BoardVO vo);
	// 게시글 선택, 답변형 글 수정에서도 사용
	public BoardVO boardSelect(int no);
	// 수정
	public int boardEdit(BoardVO vo);
 
	public int boardUpdate(BoardVO vo); 
	// 삭제
	public int boardDelete(int no); //vo 대신에 매개변수로 하기 
	// 비밀번호 확인
	public String getUserpwd(int no);
	//총 레코드 수 구하기
	public int totalRecord(SearchAndPageVO sapvo);
	//조회수
	public int hitCnt(int no);
	
	//답글
	
	//원글의 ref, step, lvl를 선택하는 메소드
	public BoardVO oriInfo(int no);
	// lvl증가
	public int lvlCount(BoardVO vo);
	// insert ref, step, lvl
	public int replyDataInsert(BoardVO vo);
	//답변형 글 (레코드)수정
	public int replyUpdate(BoardVO vo);
	//원글번호 확인 - step과 userid 가져오기
	public BoardVO getStep(int no);
	//원글(레코드) 삭제
	public int replyDelete(int no);
	//답글들 삭제된글로 표시
	public int replyDeleteUpdate(int no);
	// 답글 갯수 세기
	public int replyCnt(int no);
	
	//댓글
	
	//원글 번호의 댓글 가져오기
	public int getCno(int no);
	//댓글등록
	 public int commentInsert(CommentVO cvo);
	 //댓수정
	 public int commentUpdate(CommentVO cvo);
	 //댓 상태변경을 위한 확인
	 public int commentCheck(int cno, String userpwd);
	 //댓삭제
	 public int commentDelete(int cno);
	 //댓목록
	 public List<CommentVO> commentAllList(int no, SearchAndPageVO sapvo);
	 //댓 총 레코드
	 public int totalCommentRecord(int no);
}

