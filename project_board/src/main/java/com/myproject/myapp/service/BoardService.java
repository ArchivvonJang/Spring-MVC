package com.myproject.myapp.service;

import java.util.List;

import com.myproject.myapp.vo.BoardVO;
import com.myproject.myapp.vo.SearchAndPageVO;

public interface BoardService {
	public List<BoardVO> boardAllRecord(SearchAndPageVO sapvo);
	public int boardInsert(BoardVO vo);
	public BoardVO boardSelect(int no);
	public int boardEdit(BoardVO vo);
	public int boardUpdate(BoardVO vo); 
	public int boardDelete(int no); 
	public int totalRecord(SearchAndPageVO sapvo);
	public int hitCnt(int no);
}
