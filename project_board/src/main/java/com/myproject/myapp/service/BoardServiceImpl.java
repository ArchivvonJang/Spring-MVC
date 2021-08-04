package com.myproject.myapp.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.myproject.myapp.dao.BoardDAO;
import com.myproject.myapp.vo.BoardVO;
import com.myproject.myapp.vo.SearchAndPageVO;

@Service
public class BoardServiceImpl implements BoardService{
	
	@Inject
	BoardDAO boardDAO;
	
	@Override
	public List<BoardVO> boardAllRecord(SearchAndPageVO sapvo) {
		return boardDAO.boardAllRecord(sapvo); 
	}

	@Override
	public int boardInsert(BoardVO vo) {
		return boardDAO.boardInsert(vo);
	}

	@Override
	public BoardVO boardSelect(int no) {
		return boardDAO.boardSelect(no);
	}

	@Override
	public int boardEdit(BoardVO vo) {
		return boardDAO.boardEdit(vo);
	}

	@Override
	public int boardUpdate(BoardVO vo) {
		return boardDAO.boardUpdate(vo);
	}

	@Override
	public int boardDelete(int no) {
		return boardDAO.boardDelete(no);
	}

	@Override
	public int totalRecord(SearchAndPageVO sapvo) {
		return boardDAO.totalRecord(sapvo);
	}

	@Override
	public int hitCnt(int no) {
		return boardDAO.hitCnt(no);
	}

	@Override
	public String getUserpwd(int no) {
		return boardDAO.getUserpwd(no);
	}

	@Override
	public BoardVO oriInfo(int no) {
		return boardDAO.oriInfo(no);
	}

	@Override
	public int lvlCount(BoardVO vo) {
		return boardDAO.lvlCount(vo);
	}

	@Override
	public int claseDataInsert(BoardVO vo) {
		return boardDAO.claseDataInsert(vo);
	}

	@Override
	public int claseUpdate(BoardVO vo) {
		return boardDAO.claseUpdate(vo);
	}

	@Override
	public BoardVO getStep(int no) {
		return boardDAO.getStep(no);
	}

	@Override
	public int claseDelete(int no) {
		return boardDAO.claseDelete(no);
	}

	@Override
	public int claseDeleteUpdate(int no,String userpwd) {
		return boardDAO.claseDeleteUpdate(no, userpwd);
	}
	

}
