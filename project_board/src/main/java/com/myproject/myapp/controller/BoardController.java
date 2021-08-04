package com.myproject.myapp.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import com.myproject.myapp.service.BoardService;
import com.myproject.myapp.vo.BoardVO;
import com.myproject.myapp.vo.SearchAndPageVO;

@Controller
public class BoardController {
	@Autowired
	private DataSourceTransactionManager transactionManager; //트랜잭션
	@Inject
	BoardService boardService;
	

	
	
	//게시판 목록
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
	//비밀번호 확인
	@GetMapping("/getUserpwd")
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
	public ModelAndView boardEdit(int no) {
		ModelAndView mav = new ModelAndView();
		// model 을 사용할 경우, model.addAttribute("vo", boardService.boardSelect(no));
		mav.addObject("vo",  boardService.boardSelect(no));
		mav.setViewName("board/boardEdit");
		return mav;
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
	public ModelAndView boardDelete(int no,HttpSession session) {
		
		ModelAndView mav = new  ModelAndView();
		
		BoardVO vo = (BoardVO)session.getAttribute("bvo");
		//boardService.boardDelete(no, vo.getUserid()); //int가 반환
		
		//답글
		
		//원글정보 - 원글인지 확인 step=0 or no = ref 인지 확인
		BoardVO orivo = boardService.getStep(no);
		String userpwd = boardService.getUserpwd(no);
		
		//지워진 글 갯수를 담을 변수 result
		int result = 0; 
		
		//원글 - 원글은 step=0 userid가 userpwd가 같을때 삭제해야함
		if(orivo.getStep()==0 && orivo.getUserpwd().equals(userpwd)) { //원글 - 원글은 step=0 userid가 session의userid와 같을때 삭제해야함
			result = boardService.boardDelete(no);// 몇개 지웠는지 결과를 구할 수 있다.
			
		}else if(orivo.getStep()>0 && orivo.getUserpwd().equals(userpwd)){ //답글
			result = boardService.claseDeleteUpdate(no, userpwd);
		}
		
		//삭제가 되었으면 리스트로 이동, 삭제 안되었으면 글내용보기로 이동 
//		if(boardService.boardDelete(no)>0) {
//			mav.setViewName("redirect:boardList");
//		}else {
//			mav.addObject("no", no);//레코드번호를 보내줌
//			mav.setViewName("redirect:boardView");
//		}
		
		if(result>0) {
			mav.setViewName("redirect:boardList");
		}else {
			mav.addObject("no", no);//레코드번호를 보내줌
			mav.setViewName("redirect:boardView");
		}

		return mav;
	}
	
	//답글 쓰기 폼 이동
	@RequestMapping("/claseWrite")
	public ModelAndView claseWriteForm(int no) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("no", no);
		mav.setViewName("/claseWrite");
		return mav;
	}
	
	//트랜젝션 처리
	@RequestMapping(value="/claseWriteOk", method=RequestMethod.POST)
	@Transactional(rollbackFor= {Exception.class, RuntimeException.class}) //예외가발생하면 롤백처리를해줘라
	public ModelAndView claseWriteOk(BoardVO vo, HttpSession session,HttpServletRequest req) {
		//트렌잭션 
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();  //객체 생성을 위해 호출해옴
		def.setPropagationBehavior(DefaultTransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def); //트렌젝션을 하기 위해 객체생성 -트렌젝션 생성하기 위한 준비끝
		ModelAndView mav = new ModelAndView();
		
		try {
			//1. 원글의 ref, step, lvl을 선택한다. (원글의 레코드번호)를 넣으면 vo가 반환 [mapper-select]
			BoardVO orivo = boardService.oriInfo(vo.getNo());
			//2. lvl 증가 : 원글 번호 가 같고 lvl이 원글 번호의 lvl보다 크면 1증가 [mapper-update]
			int lvlUpdate = boardService.lvlCount(orivo);
			System.out.println("boardController 레벨 업데이트 갯수 lvlCnt -> "+lvlUpdate);
			//3. 답글(레코드)추가 : 아래의 데이터를 위 orivo에 추가,db에서 읽어온 원래 ref를 불러옴, db의 step + 1, lvl + 1 업데이트가 이루어짐 insert
			vo.setRef(orivo.getRef());
			vo.setStep(orivo.getStep()+1);
			vo.setLvl(orivo.getLvl()+1);
			//4. 메소드 호출
			int cnt = boardService.claseDataInsert(vo); // orivo 넣기 금지
			//5. cnt rollback 처리
			// cnt = 0 이면, insert 불가능 -> rollback
			// 예외 발생시, exception으로 가서 알아서 rollback 처리 
			// 0 값이 들어온건 예외발생이 아님 그래서 rollback이 안되므로 rollback 처리해줘야 한다.
			mav.addObject("no", vo.getNo());
			
			if(cnt>0) {
				//transaction commit해주고 원글으로 이동
				mav.setViewName("redirect:boardView");
				transactionManager.commit(status);
			}else {
				//insert가 안되었지만 cnt = 0 또는 에러 발생하지 않았을 때, 원글 글 번호와 함께 답글쓰기 폼으로 이동 
				mav.setViewName("redirect:claseWrite");
				transactionManager.rollback(status);
			}
			
			
		}catch(Exception e){
			mav.addObject("no", vo.getNo());
			mav.setViewName("redirect:claseWrite");
		}
		
	
		return mav;
	}	
	
	//답글 삭제 
}
