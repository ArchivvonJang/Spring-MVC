package com.myproject.myapp.controller;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.poi.util.SystemOutLogger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import com.myproject.myapp.service.BoardService;
import com.myproject.myapp.vo.BoardVO;
import com.myproject.myapp.vo.CommentVO;
import com.myproject.myapp.vo.SearchAndPageVO;

@Controller
public class BoardController {
	@Autowired
	private DataSourceTransactionManager transactionManager; //트랜잭션
	
	@Inject
	BoardService boardService;

	
	
	//게시판 목록
	@RequestMapping("/boardList")
	public ModelAndView boardList(CommentVO cvo, SearchAndPageVO sapvo, HttpServletRequest req) {
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

		
		List<BoardVO> list = boardService.boardAllRecord(sapvo);
		
		//댓글
		//int no = Integer.parseInt(req.getParameter("no"));
		List<CommentVO> clist = boardService.commentAllList(cvo.getNo());
		
		//댓글 갯수
		List<Integer> cno = new ArrayList<Integer>(); 
		for(int i=0; i<list.size(); i++) {
			cno.add(boardService.getCno(list.get(i).getNo()));
		}
		
		
		//원글번호의 답글덩어리들 쪼개기
		int ref[] = new int[list.size()];
		for(int i=0; i<list.size(); i++) {
			ref[i] = list.get(i).getRef();
			System.out.println("답글SET ref["+i+"]   ----> "+ ref[i]);
		}
		
		//ref[i]가 같은 번호의 갯수를 구해서 1까지 for문을 돌려서 갯수를 구해준다?
		
		// 게시글 정렬
		int listSort = list.size()-1;
		List<Integer> lvl = new ArrayList<Integer>();
		for(int i = 0; i<list.size(); i++) {
			lvl.add(list.get(listSort).getLvl());
			listSort--;
		}
		
		//System.out.println("댓글이 씌여지는 board no ---> " + cvo.getNo());
		
		/*
		 * for(int i=0; i<list.size(); i++) { System.out.println("cno" +i+ "-> " +
		 * list.get(i).getNo()); }
		 */
		
		// return ModelAndView
		mav.addObject("totalRecord", sapvo.getTotalRecord()); //전체 글 갯수
		mav.addObject("cno", cno); //댓글 갯수
		mav.addObject("ref", ref); //답글 
		mav.addObject("list", list); //게시판 글 목록
		mav.addObject("clist", clist); //댓글 글 목록
		mav.addObject("sapvo",sapvo); //페이징	
		mav.setViewName("board/boardList"); //보내줄 view name 
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
	//	mav.addObject("cvo", boardService.commentAllList(no));
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
	@Transactional(rollbackFor = {Exception.class, RuntimeException.class})
	public ModelAndView boardDelete(int no) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(DefaultTransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);	
		System.out.println("delete no-->"+no);
		// 원글 삭제가 가능하고 답글이 있는경우답글까지 지운다. delete
		// 답글은 제목, 글내용을 삭제된 글입니다.로 바꾼다. update
		
		ModelAndView mav = new  ModelAndView();
		try {
			System.out.println("board delete transaction!!!try catch in!!!");
			//답글 확인
			int replyCnt = boardService.replyCnt(no);
			//삭제 하면 1 아니면 0
			//int result = boardService.boardDelete(no);
			//상태 변경
			int result = boardService.replyDeleteUpdate(no);
			
			//나중에 글 삭제할 때 해당 글의 댓글도 지워지도록 하기 --> JSP에서 안보이게 하기로 바꿈
			//int commentDel = boardService.boardCommentDelete(no);
			
			
			System.out.println("boardDelete rCount check ---> "+ replyCnt);
			System.out.println("board Delete rdeleteupdate (result) check ---> "+ result);
		//	System.out.println("comment delete check ---> "+ commentDel);
			//원글정보 - 원글인지 확인 step=0 or no = ref 인지 확인
			System.out.println("board delete no :" + no);
			//BoardVO orivo = boardService.getStep(no);
			//String userpwd = boardService.getUserpwd(no);
			
			//지워진 글 갯수를 담을 변수 result
	//		int result = 0; 
			
			//원글 - 원글은 step=0 userid가 userpwd가 같을때 삭제해야함
	//		if(orivo.getStep()==0 ) { //원글 - 원글은 step=0 userid가 session의userid와 같을때 삭제해야함
	//			result = boardService.boardDelete(no);// 몇개 지웠는지 결과를 구할 수 있다.
	//			
	//		}else if(orivo.getStep()>0){ //답글
	//			result = boardService.replyDeleteUpdate(no);
	//		}
			
			//삭제가 되었으면 리스트로 이동, 삭제 안되었으면 글내용보기로 이동 
			if(result>0) {
				//System.out.println("comment delete check ---> "+ commentDel);
				mav.setViewName("redirect:boardList");
				transactionManager.commit(status);
				 System.out.println("[ 글 삭제 성공 ]");
			}else {
				mav.addObject("no", no);//레코드번호를 보내줌
				mav.setViewName("redirect:boardView");
				System.out.println("[ delete - 글 삭제 실패 ]");
				transactionManager.rollback(status);
			}
		}catch(Exception e) {
			mav.addObject("no", no);
			mav.setViewName("redirect:boardView");
			 System.out.println("[ rollback - 글 삭제 에러 ]");
			e.printStackTrace();
		}
		return mav;
	}
	
	//답글 쓰기 폼 이동
	@RequestMapping("/replyWrite")
	public ModelAndView replyWriteForm(int no) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("no", no);
		mav.setViewName("board/replyWrite");
		return mav;
	}
	
	//답글 작성 - 트랜잭션
	@RequestMapping(value="/replyWriteOk", method=RequestMethod.POST)
	@Transactional(rollbackFor= {Exception.class, RuntimeException.class}) //예외가발생하면 롤백처리를해줘라
	public ModelAndView replyWriteOk(BoardVO vo, HttpServletRequest req) {
		//트렌잭션 
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();  //객체 생성을 위해 호출해옴
		def.setPropagationBehavior(DefaultTransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def); //트렌젝션을 하기 위해 객체생성 -트렌젝션 생성하기 위한 준비끝
		
		ModelAndView mav = new ModelAndView();
		
		System.out.println("replywriteOk controller 까지 왔습니다. try catch 들어가기 직전");
		
		try {
			//1. 원글의 ref, step, lvl를 가져온다. (원글의 레코드번호)를 넣으면 vo가 반환 [mapper-select]
			BoardVO orivo = boardService.oriInfo(vo.getNo());
			System.out.println("ori no -> " + orivo.getNo());
			System.out.println("subject check -> " + vo.getSubject());
			
			//2. 답글에 orivo 에서 가져온 값 추가 -> lvl 증가 : 원글 번호 가 같고 lvl이 원글 번호의 lvl보다 크면 1증가 [mapper-update]
			int lvlUpdate = boardService.lvlCount(orivo);
			System.out.println("boardController 레벨 업데이트 갯수 lvl update -> "+lvlUpdate);
			
			//3. 답글(레코드)추가 : 아래의 데이터를 위 orivo에 추가,db에서 읽어온 원래 ref를 불러옴, db의 step + 1, lvl + 1 업데이트가 이루어짐 insert
			//원글번호 가져오기
			vo.setRef(orivo.getRef());      System.out.println("orivo ref -->" + orivo.getRef());
			//들여쓰기
			vo.setStep(orivo.getStep()+1);  System.out.println("orivo step + 1 ---> "+orivo.getStep() + " +++1");
			//순서
			vo.setLvl(orivo.getLvl()+1);    System.out.println("orivo lvl + 1 ---> " + orivo.getLvl()+ " +++1");
			
			//4. 답글 등록 메소드 호출
			int cnt = boardService.replyDataInsert(vo); // orivo 넣기 금지
			System.out.println("insert 성공했나요 ???  cnt --> "+ cnt);
			//5. cnt rollback 처리
			// cnt = 0 이면, insert 불가능 -> rollback
			// 예외 발생시, exception으로 가서 알아서 rollback 처리 
			// 0 값이 들어온건 예외발생이 아님 그래서 rollback이 안되므로 rollback 처리해줘야 한다.
			mav.addObject("no", vo.getNo());
			
			if(cnt>0) { //등록 성공
				//transaction commit해주고 원글으로 이동
				mav.setViewName("redirect:boardList");
		
				transactionManager.commit(status);
			}else { //실패
				//insert가 안되었지만 cnt = 0 또는 에러 발생하지 않았을 때, 원글 글 번호와 함께 답글쓰기 폼으로 이동 
				mav.setViewName("redirect:replyWrite"); System.out.println("[ insert - 답글등록 실패 ]");
				transactionManager.rollback(status);
			}
			
			
		}catch(Exception e){
			mav.addObject("no", vo.getNo());
			mav.setViewName("redirect:replyWrite"); System.out.println("[ rollback - 답글등록 실패 ]");
		}
		
	
		return mav;
	}	
	
	//답글 삭제 ---> boardDelete 로 돌아가세요

//------------------------------------!!!!  댓글  !!!!------------------------------------------------------
	//댓글 목록
	
	@RequestMapping("/commentList")
	@ResponseBody
	public List<CommentVO> commentList(int no) {
		List<CommentVO> list = boardService.commentAllList(no);
		
		System.out.println("댓글이 씌여지는 board no ---> " + no );
		//댓글 페이징 처리s
		//String reqPageNum = req.getParameter("pageNum");// pageNum = 1로 sapvo에 이미 기본값 세팅이 되어 있음
		//if (reqPageNum != null) { // 리퀘스트했을 때, 페이지번호가 있으면 세팅/ 없으면 기본 값=1
		//	sapvo.setPageNum(Integer.parseInt(reqPageNum));
		//}
		
		for(int i=0; i<list.size(); i++) {
			System.out.println("cno" +i+ "-> " + list.get(i).getCno());
		}
		
		return list;
		
	}
	//댓글 작성
	/*
	 * @RequestMapping(value="/CommentWriteOk", method=RequestMethod.POST)
	 * 
	 * @ResponseBody public ModelAndView CommentWriteOk(CommentVO cvo) {
	 * ModelAndView mav = new ModelAndView(); if(boardService.commentInsert(cvo)>0)
	 * { mav.setViewName("redirect:boardView");
	 * System.out.println("controller :  댓글 작성 성공"); }else {
	 * mav.setViewName("redirect:boardView");
	 * System.out.println("controller :  댓글 작성 실패"); } return mav; }
	 */
	
	@RequestMapping(value="/commentWriteOk", method=RequestMethod.GET)
	@ResponseBody
	public int commentWriteOk(CommentVO cvo) {
		System.out.println("controller comment write ok in!!!");
		int result = boardService.commentInsert(cvo);
		return result;
	}
	//댓글 상태변경시 확인
	@RequestMapping("/commentCheck")
	@ResponseBody
	public Integer commentCheck(int cno, String userpwd) {
		System.out.println("controller check comment no ->" + cno);
		System.out.println("controller check comment userpwd -> " + userpwd);
		return boardService.commentCheck(cno, userpwd);
	}

	//댓글 수정
	@RequestMapping("/commentEditOk")
	@ResponseBody
	//public int commentEditOk(CommentVO cvo) {
	public int commentEditOk(int no, int cno, String content) {
		System.out.println("controller comment Edit Edit  in!!!");
		//return boardService.commentUpdate(cvo);
		return boardService.commentUpdate(no, cno, content);
	}
	
	//댓글 삭제
	@RequestMapping("/commentDelete")
	@ResponseBody
	public int commentDelete(int no, int cno) {
		System.out.println("controller comment delete in!!!");
		return boardService.commentDelete(cno); // !! 문제 해결: param 값으로 cno를 입력받으면서 no를 넣고 있었음!!!!! 
	}
}
