package com.myproject.myapp.dao;

import java.util.List;


import com.myproject.myapp.vo.BoardVO;
import com.myproject.myapp.vo.SearchAndPageVO;

public interface BoardDAO {
	public List<BoardVO> boardAllRecord(SearchAndPageVO sapvo);
	public int boardInsert(BoardVO vo);
	public BoardVO boardSelect(int no);
	public int boardEdit(BoardVO vo);
	public int boardUpdate(BoardVO vo); 
	public int boardDelete(int no); //vo 대신에 매개변수로 하기 
	//총 레코드 수 구하기
	public int totalRecord(SearchAndPageVO sapvo);
	public int hitCnt(int no);
}
