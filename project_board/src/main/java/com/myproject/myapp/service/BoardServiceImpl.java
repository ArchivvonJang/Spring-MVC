package com.myproject.myapp.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.myproject.myapp.dao.BoardDAO;
import com.myproject.myapp.dao.CommentDAO;
import com.myproject.myapp.vo.BoardVO;
import com.myproject.myapp.vo.CommentVO;
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
	public int replyDataInsert(BoardVO vo) {
		return boardDAO.replyDataInsert(vo);
	}

	@Override
	public int replyUpdate(BoardVO vo) {
		return boardDAO.replyUpdate(vo);
	}

	@Override
	public BoardVO getStep(int no) {
		return boardDAO.getStep(no);
	}

	@Override
	public int replyDelete(int no) {
		return boardDAO.replyDelete(no);
	}

	@Override
	public int replyDeleteUpdate(int no,String userpwd) {
		return boardDAO.replyDeleteUpdate(no, userpwd);
	}
	


	@Override
	public int commentInsert(CommentVO cvo) {
		return boardDAO.commentInsert(cvo);
	}

	@Override
	public int commentUpdate(CommentVO cvo) {
		return boardDAO.commentUpdate(cvo);
	}

	@Override
	public int commentDelete(int num, String userpwd) {
		return boardDAO.commentDelete(num, userpwd);
	}

	@Override
	public List<CommentVO> commentAllList(SearchAndPageVO sapvo) {
		return boardDAO.commentAllList(sapvo);
	}
;
	@Override
	public int totalCommentRecord(SearchAndPageVO sapvo) {
		return boardDAO.totalCommentRecord(sapvo);
	}

}
