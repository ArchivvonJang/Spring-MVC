package com.myproject.myapp.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.myproject.myapp.dao.BoardDAO;
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
	public int replyDeleteUpdate(int no) {
		return boardDAO.replyDeleteUpdate(no);
	}

	@Override
	public int replyCnt(int ref) {
		return boardDAO.replyCnt(ref);
	}

	@Override
	public int getCno(int no) {
		return boardDAO.getCno(no);
	}

	@Override
	public int commentInsert(CommentVO cvo) {
		return boardDAO.commentInsert(cvo);
	}


	@Override
	public int commentCheck(int cno, String userpwd) {
		return boardDAO.commentCheck(cno, userpwd);
	}

	@Override
	public int commentDelete(int cno) {
		return boardDAO.commentDelete(cno);
	}

	@Override
	public List<CommentVO> commentAllList(int no) {
		return boardDAO.commentAllList(no);
	}

	@Override
	public int totalCommentRecord(int no) {
		return boardDAO.totalCommentRecord(no);
	}

	@Override
	public int boardCommentDelete(int no) {
		return boardDAO.boardCommentDelete(no);
	}

	@Override
	public int commentUpdate(int no, int cno, String content) {
		// TODO Auto-generated method stub
		return boardDAO.commentUpdate(no, cno, content);
	}

	@Override
	public List<BoardVO> excelList(String searchKey, String searchWord) {
		return boardDAO.excelList(searchKey, searchWord);
	}



	

}
