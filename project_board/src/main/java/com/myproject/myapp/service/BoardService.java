package com.myproject.myapp.service;

import java.util.List;

import com.myproject.myapp.vo.BoardVO;
import com.myproject.myapp.vo.SearchAndPageVO;

public interface BoardService {
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
	public int claseDataInsert(BoardVO vo);
	//답변형 글 (레코드)수정
	public int claseUpdate(BoardVO vo);
	//원글번호 확인 - step과 userid 가져오기
	public BoardVO getStep(int no);
	//원글(레코드) 삭제
	public int claseDelete(int no);
	//답글들 삭제된글로 표시
	public int claseDeleteUpdate(int no, String userpwd);
}
