package com.myproject.myapp.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import com.myproject.myapp.service.BoardService;
import com.myproject.myapp.vo.BoardVO;
import com.myproject.myapp.vo.SearchAndPageVO;

@Controller
public class BoardController {
	@Inject
	BoardService boardService;
	
	@RequestMapping("/boardList")
	public ModelAndView boardList(SearchAndPageVO sapvo, HttpServletRequest req) {
		ModelAndView mav = new ModelAndView();
		//페이징 처리
		String reqPageNum = req.getParameter("pageNum");// pageNum = 1로 sapvo에 이미 기본값 세팅이 되어 있음
		if (reqPageNum != null) { // 리퀘스트했을 때, 페이지번호가 있으면 세팅/ 없으면 기본 값=1
			sapvo.setPageNum(Integer.parseInt(reqPageNum));
		}
		System.out.println("getPageNum-->"+sapvo.getPageNum());
		System.out.println("onePageRecord-->"+sapvo.getOnePageRecord());
		System.out.println("reqPageNum --> "+reqPageNum);
		
		// 검색어와 검색키
		sapvo.setSearchWord(sapvo.getSearchWord());
		sapvo.setSearchKey(sapvo.getSearchKey()); 
		System.out.println("searchword->" + sapvo.getSearchWord());
		
		//총 레코드 수 구하기 
		sapvo.setTotalRecord(boardService.totalRecord(sapvo));
		
		
		//modelandview
		mav.addObject("totalRecord", sapvo.getTotalRecord());
		mav.addObject("list", boardService.boardAllRecord(sapvo));
		mav.addObject("sapvo",sapvo);	
		mav.setViewName("board/boardList");
		return mav;
	}
	//글쓰기 폼으로 이동
	@RequestMapping("/boardWrite")
	public String boardWrite() {
		return "board/boardWrite";
	}
	//글쓰기 완료 후 리스트로 이동
	@RequestMapping(value="/boardWriteOk", method=RequestMethod.POST)
	public ModelAndView boardWriteOk(BoardVO vo) {
		ModelAndView mav = new ModelAndView();
		  if(boardService.boardInsert(vo)>0) {
		        mav.setViewName("redirect:boardList");
		    }else {
		        mav.setViewName("redirect:boardWrite");
		    }
		return mav;
	}
	@RequestMapping("/boardView")
	public ModelAndView boardView(int no) {
		ModelAndView mav = new ModelAndView();
		mav.addObject(boardService.hitCnt(no));
		mav.addObject("vo", boardService.boardSelect(no));
		mav.setViewName("board/boardView");
		return mav;
	}
	//비밀번호 체킹
	@RequestMapping("/getUserpwd")
	@ResponseBody
	public int getUserpwd(int no, String userpwd) {
		int result = 0;
		String oriUserpwd = boardService.getUserpwd(no);
		if(oriUserpwd.equals(userpwd)) {
			result=1;
		}
		return result;
	}
	//글쓰기 수정 폼으로 이동
	@RequestMapping("/boardEdit")
	public String boardEdit(int no, Model model) {
		model.addAttribute("vo", boardService.boardSelect(no));
		return "board/boardEdit";
	}
	//글쓰기 수정 완료 
	@RequestMapping(value="/boardEditOk", method=RequestMethod.POST)  //수정할 글(레코드) 수정
	public ModelAndView boardEditOk(BoardVO vo) {
		
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("no", vo.getNo()); //글번호

		if(boardService.boardUpdate(vo)>0) {
			mav.setViewName("redirect:/boardList");
			System.out.println("controller : 수정성공");
		}else {
			mav.setViewName("redirect:boardEdit");
			System.out.println("controller :  수정실패");
		}
		return mav;
	}
	//삭제
	@RequestMapping("/boardDelete")
	public ModelAndView boardDelete(int no, HttpSession session) {
		ModelAndView mav = new  ModelAndView();
		BoardVO vo = (BoardVO)session.getAttribute("bvo");
		//boardService.boardDelete(no, vo.getUserid()); //int가 반환
		if(boardService.boardDelete(no)>0) {
			mav.setViewName("redirect:boardList");
		}else {
			mav.addObject("no", no);//레코드번호를 보내줌
			mav.setViewName("redirect:boardView");
		}
		return mav;
	}
	
	
}
