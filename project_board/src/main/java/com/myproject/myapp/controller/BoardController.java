package com.myproject.myapp.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor.HSSFColorPredefined;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
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

	/*
	 * @InitBinder public void initBinder(WebDataBinder binder) throws Exception {
	 * binder.registerCustomEditor(MultipartFile.class, new PropertyEditorSupport()
	 * {
	 * 
	 * @Override public void setAsText(String text) {
	 * Logger.debug("initBinder MultipartFile.class: {}; set null;", text);
	 * setValue(null); }
	 * 
	 * }); }
	 * 
	 */
	
	//게시판 목록
	@RequestMapping("/boardList")
	public ModelAndView boardList(BoardVO vo, CommentVO cvo, SearchAndPageVO sapvo, HttpServletRequest req) {
		ModelAndView mav = new ModelAndView();
		
		//페이징 처리
		String reqPageNum = req.getParameter("pageNum");// pageNum = 1로 sapvo에 이미 기본값 세팅이 되어 있음
		if (reqPageNum != null) { // 리퀘스트했을 때, 페이지번호가 있으면 세팅/ 없으면 기본 값=1
			sapvo.setPageNum(Integer.parseInt(reqPageNum));
		}
		//System.out.println("getPageNum-->"+sapvo.getPageNum());
		//System.out.println("onePageRecord-->"+sapvo.getOnePageRecord());
		//System.out.println("reqPageNum --> "+reqPageNum);
		
		// 검색어와 검색키
		sapvo.setSearchWord(sapvo.getSearchWord());
		sapvo.setSearchKey(sapvo.getSearchKey()); 
		//System.out.println("searchword->" + sapvo.getSearchWord());
		
		//총 레코드 수 구하기 
		sapvo.setTotalRecord(boardService.totalRecord(sapvo));
		
		//게시판목록
		List<BoardVO> list = boardService.boardAllRecord(sapvo);
		
		//답글
		List<BoardVO> rlist = boardService.replySelect(vo.getRef());
		
		//댓글
		//int no = Integer.parseInt(req.getParameter("no"));
		List<CommentVO> clist = boardService.commentAllList(cvo.getNo());
		
		//댓글 갯수
		List<Integer> cno = new ArrayList<Integer>(); 
		for(int i=0; i<list.size(); i++) {
			cno.add(boardService.getCno(list.get(i).getNo()));
		}
		
		int listSort = list.size()-1;
		
		//답글갯수
		List<Integer> rcnt = new ArrayList<Integer>();
		
		for(int i=0; i<list.size(); i++) {
			//총 답글 수 구하기
			rcnt.add(boardService.replyCnt(list.get(i).getRef()));
		//	System.out.println(i+"의 rcnt add :" +list.get(i).getNo());
		//	System.out.println(rcnt);
		}
		
	
		//원글번호의 답글덩어리들 쪼개기
		int ref[] = new int[list.size()];
		int lvl[] = new int[list.size()];
		int refLength = ref.length;
		int rc=0;
		for(int i=1; i<list.size(); i++) {
			//답글 덩어리 쪼개기
			ref[i] = list.get(i).getRef();
		//	System.out.println("답글SET ref["+i+"]   ----> "+ ref[i]);
		
			//	rcnt.add(list.get(listSort).getLvl());
		//	listSort--;
		//	System.out.println("1 -> " + list.get(i).getNo());
		//	System.out.println("2 -> "+list.get(listSort).getLvl());
			
			rc = boardService.replyCnt(ref[i]);
		//System.out.println("list controller ref "+i+":"+ref[i]+" rc : " + rc);
			
			rlist = boardService.replySelect(ref[i]);
			//System.out.println("list reply list ~~~~~~~~~~> "+rlist);
		}
		//총 레코드 수 구하기 
		//rcnt.add(rc);
		
		/*
		 * System.out.println("list controller -> cno : " + cno);
		 * System.out.println("list controller -> rc : " + rc);
		 * System.out.println("list controller -> replyCnt : " + rcnt);
		 * System.out.println("list controller -> lvl : " + vo.getLvl());
		 * System.out.println("list controller -> list.size : " + list.size() );
		 * System.out.println("list controller -> reflength : " + refLength);
		 */
		//ref[i]가 같은 번호의 갯수를 구해서 1까지 for문을 돌려서 갯수를 구해준다?
		
	
		//System.out.println("댓글이 씌여지는 board no ---> " + cvo.getNo());
		
		/*
		 * for(int i=0; i<list.size(); i++) { System.out.println("cno" +i+ "-> " +
		 * list.get(i).getNo()); }
		 */
		
		// return ModelAndView
		mav.addObject("totalRecord", sapvo.getTotalRecord()); //전체 글 갯수
		mav.addObject("cno", cno); //댓글 갯수
		mav.addObject("rcnt", rcnt); //답글 
		mav.addObject("rlist", rlist); //답글 
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
	public ModelAndView boardWriteOk(BoardVO vo, SearchAndPageVO sapvo, HttpServletRequest req) {
		ModelAndView mav = new ModelAndView();
		//---------- 파일 업로드 -------------
		//파일 업로드 - mutlpartrequest
		//new MultipartRequest(req 리퀘스트객체, path 어디에 업로드할지, 0 maxsize업로드하는 파일크기에 제한, path 한글인코딩을 뭐로할건지, filerenamepolicy null 객체만 만들어서 넣으면 알아서 리네임)
	System.out.println("controller boardWriteOk in!");
				String path = req.getSession().getServletContext().getRealPath("/upload");
				//System.out.println("path ->" +path);
				//파일 업로드를 위해서 multiparthttp객체로 변
				MultipartHttpServletRequest mr = (MultipartHttpServletRequest) req;
			
				
				//MultipartHttpServletRequest에서 업로드할 파일 목록을 구하기
				List<MultipartFile> files = mr.getFiles("file");
				
				//올라간 파일 이름을 담을 DB 리스트
				List<String> uploadDB = new ArrayList<String>(); // 중복파일 담기
				List<String> orifilename = new ArrayList<String>(); // 원본파일 이름 담기
				
				// 처음 업로드한 파일 담아놓을 배열
				String firstFile[] = req.getParameterValues("firstFile");
				
				//처음 업로드한 값이 존재하면,
			//	if(firstFile != null) {
			//		for(int j=0; j<firstFile.length; j++) {
			//			uploadDB.add(firstFile[j]);
			//		}
			//	}// if firstFile end
				
				//첨부 파일이 존재하면 실행!
				if(!files.isEmpty()) {
					System.out.println("controller boardWriteOk   file is not empty function  in!");
					//파일 수 만큼 반복 실행
					for(MultipartFile mf : files) { 
						//파일 이름을 담을 변수
						String originalFilename = mf.getOriginalFilename(); 
						//파일이름이 공백이 아니면  업로드
						if(!originalFilename.equals("")) { 
							//파일을 저장할 위치, 파일이름을 File 객체로 변환해서 담는다.
							File f = new File(path, originalFilename); 
							int i = 1;
							// 중복 검사 
							while(f.exists()) {
								int point = originalFilename.lastIndexOf(".");
								String name = originalFilename.substring(0, point); //파일명
								String extName = originalFilename.substring(point+1); //확장자 : 중복파일이면, 숫자 붙여주기
								//업로드 된 파일명 얻어오기(새로운 파일명), getOriginalFileName()은 원래 이름 구하는것, 이건 새로운 이름 구하기
								//mr.getOriginalFileName(nameAttr); //파일명 (원래 파일명) 기존네임->중복->리네임
								f = new File(path, name+"("+ i+")."+extName);
								//System.out.println("write file uplaod f : "+ f);
							}//while end
							
							//가져온 파일 업로드
							try {
								System.out.println("<<파일 업로드 성공>>");
								mf.transferTo(f); 
							}catch(Exception e) {
								System.out.println("<<파일 업로드 실패>>");
								e.printStackTrace();
							}
							//파일 이름 (원본 또는 중복+1 한 파일명 담기 )
							uploadDB.add(f.getName());//파일의 이름 담기
							orifilename.add(originalFilename); //원본 파일 이름 담기
					
						}// if equals end
					}//for mf end 
				}//if isEmpty end
				
				
				//DB에 이름 추가
				//여러개의 파일명을 하나의 String 으로 만들기 예: 이름 / 이름 /
				String filename = "";
				String orifile = ""; //원본파일
				for(int i=0; i<uploadDB.size(); i++) {
					filename = filename + uploadDB.get(i)+"/";
					orifile = orifile + orifilename.get(i)+"/";
				}
				vo.setFilename(filename);
				vo.setOrifilename(orifile);
				
				System.out.println("boardWrite get filename --> "+vo.getFilename() + ", orifile 이 있다면, orifilename  ---> " + vo.getOrifilename());				
				
		//-----------글 등록 --------
		  if(boardService.boardInsert(vo)>0) {
			  System.out.println("controller boardWriteOk result over zero! in!");
			  //글쓰다가 삭제한 파일
				String delFile[] = req.getParameterValues("delFile");
				if(delFile != null) {
					for(String dFile : delFile) {
						try {
							System.out.println("<< 글쓰기 파일 삭제 성공 >>" );
							File dFileObj = new File(path, dFile);
							dFileObj.delete();
						}catch(Exception e) {
							System.out.println("<< 글쓰기 파일 삭제 실패 >>" );
							e.printStackTrace();
						}
					}
				}// if delfile null end
			  
			  
			  mav.addObject("sapvo", sapvo);
		      mav.setViewName("redirect:boardList");
		    }else {
		        mav.setViewName("redirect:boardWrite");
		    }
		return mav;
	}
	@RequestMapping("/boardView")
	public ModelAndView boardView(int no, SearchAndPageVO sapvo, HttpServletRequest req) {
		ModelAndView mav = new ModelAndView();

		// 첨부파일
		BoardVO vo = boardService.boardSelect(no);
		//System.out.println("view filename : " + vo.getFilename());
		try {
			
			if(vo.getFilename()!=null  ) { 	 
				// String으로 파일명 / 파일명 /파일명.. 이렇게 들어간 데이터를 쪼갠다! 
				StringTokenizer tok = new StringTokenizer(vo.getFilename(),"/");
				
				if(vo.getOrifilename()!=null) {
					StringTokenizer oritok = new StringTokenizer(vo.getOrifilename(),"/"); 
					 mav.addObject("orifile", oritok);
					 System.out.println("boardview getFilename with orifile oritok : " + oritok);
				}
				
				String path = req.getSession().getServletContext().getRealPath("/upload");
				//System.out.println("boardview path : "+ path);
				//System.out.println("boardview getFilename with tok : " + tok);
				//System.out.println("board view file name from vo  : " + vo.getFilename());
				 mav.addObject("file", tok);
			 }
			
			//if end
		}catch(Exception e) {
			e.printStackTrace();
			System.out.println("filename found error");
		}
		//페이징
		mav.addObject("sapvo", sapvo);
		
		//조회수
		mav.addObject(boardService.hitCnt(no));
		//mav.addObject("cvo", boardService.commentAllList(no));
		
		//선택한 게시판 글의 내용
		mav.addObject("vo", boardService.boardSelect(no));
		
		//보낼 페이지 이름 
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
	public ModelAndView boardEdit(int no,  SearchAndPageVO sapvo) {
		ModelAndView mav = new ModelAndView();
		// model 을 사용할 경우, model.addAttribute("vo", boardService.boardSelect(no));
		
		BoardVO vo = boardService.boardSelect(no);
	
		//파일 이름 추가
		if(vo.getFilename() != null) {
			// 파일명/ 파일명/ 파일명 으로 된 filename String 쪼개기
			StringTokenizer tok = new StringTokenizer(vo.getFilename(), "/");
			mav.addObject("file", tok);
		}
		
		//선택한 게시판 글 
		mav.addObject("vo",  vo);
		mav.addObject("sapvo", sapvo);
		mav.setViewName("board/boardEdit");
		return mav;
	}
	//글쓰기 수정 완료 
	@RequestMapping(value="/boardEditOk", method=RequestMethod.POST)  //수정할 글(레코드) 수정
	public ModelAndView boardEditOk(BoardVO vo, SearchAndPageVO sapvo,HttpServletRequest req ) {
		//@RequestParam(value="file", required = false, defaultValue=" ") String file
		ModelAndView mav = new ModelAndView();

	try {	
		//파일 업로드 수정
		String path = req.getSession().getServletContext().getRealPath("/upload");
		MultipartHttpServletRequest mr = (MultipartHttpServletRequest)req;
		
		//System.out.println("boardEditOk path  : " + path);
		
		// 처음 글쓰기할 때 업로드한 파일 담아놓을 배열
		String initialFile[] = req.getParameterValues("initialFile");
		
		//수정하면서 새로 추가하거나 수정되는 파일
		List<MultipartFile> fileList = mr.getFiles("file");
		List<String> newUpload = new ArrayList<String>();
		
		//수정 시 첨부파일이 없으면 에러가 나므로 null을 setting
		if(vo.getFilename() == null || vo.getFilename() == "" || fileList.size()==0 || newUpload.isEmpty()) {
			vo.setFilename("");
		}
		
		// 값이 존재하면,
		if(initialFile != null) {
			for(int i=0; i<initialFile.length; i++) {
				newUpload.add(initialFile[i]);
			}
		}
		
		if(fileList != null && fileList.size()>0) {
			for(MultipartFile mf : fileList) {
				if(mf != null) {
					String oriFilename = mf.getOriginalFilename();
					if(oriFilename != null && !oriFilename.equals("")) {
						File ff = new File(path, oriFilename);
						int i = 0;
						while(ff.exists()) {
							int point = oriFilename.lastIndexOf(".");
							String filename = oriFilename.substring(0, point);
							String extName = oriFilename.substring(point+1);
							
							ff = new File(path, filename+"("+ i +")." + extName);
						}//while
						
						try {
							System.out.println(("<< boardEdit 파일업로드 성공 >>"));
							mf.transferTo(ff);			
						}catch(Exception e) {
							System.out.println(("<< boardEdit 파일업로드 실패 >>"));
							e.printStackTrace();
						}
						newUpload.add(ff.getName());
						//System.out.println("수정하면서 새로 추가되는 파일 길이 :" + newUpload.size());
					}//if oriname end
				}// if mf end
			}// for mf end
		}// if fileList null end
		
		//기존에 남아있는 파일(초기 글쓰기에 첨부된 파일)들과 새로운 추가된 파일들
		if(!newUpload.isEmpty()) {
			String filename = "";
			for(int i=0; i<newUpload.size(); i++) {
				filename = filename + newUpload.get(i)+"/";
			}
			vo.setFilename(filename);
		}
	
		//System.out.println("edit filename -> " + vo.getFilename());
		//System.out.println("edit subject -> " + vo.getSubject());
		//전체적인 Edit 삭제 성공 실패 여부 
		int result = boardService.boardUpdate(vo);
		//System.out.println("EditOk --> update result : " + result);
		if(result>0) {
		
			//수정하면서 삭제된 파일들
			String delFile[] = req.getParameterValues("delFile");
			if(delFile != null) {
				for(String dFile : delFile) {
					try {
						System.out.println("<< boardEdit 파일 삭제 성공 >>" );
						File dFileObj = new File(path, dFile);
						dFileObj.delete();
					}catch(Exception e) {
						System.out.println("<< boardEdit 파일 삭제 실패 >>" );
						e.printStackTrace();
					}
				}
			}// if delfile null end
			//수정 시 첨부파일이 없으면 에러가 나므로 null을 setting
		
			mav.setViewName("redirect:/boardView");
			System.out.println("controller : 수정성공");
			
		}else {
			
			// 글 수정 실패 --> 새로 업로드한 파일 reset
			if(newUpload.size()>0) {
				for(String newFile : newUpload) {
					try {
						System.out.println("<< boardEdit 새로운파일 업로드 성공 >>" );
						File dFileObj = new File(path, newFile);
						dFileObj.delete();
					}catch(Exception e) {
						System.out.println("<< boardEdit 새로운파일 업로드 실패 지우기! >>" );
						e.printStackTrace();
					}//try catch end
				}// if string new file end
			}// if newuplaod end
			
			mav.addObject("no",vo.getNo());
			mav.setViewName("redirect:boardEdit");
			System.out.println("controller :  수정실패");
		}//if else end
	}catch(Exception e) {
		e.printStackTrace();
		System.out.println("edit ok 전체적인 에러 발생!");
	}
		// 페이징 - 수정 후 다시 return 하는 목록이 해당 게시글이 있는 페이지로 넘어가야함 PageNum을 보내기 위해 추가!
		mav.addObject("sapvo", sapvo);
		
		//글번호
		mav.addObject("no", vo.getNo()); 
		
		
		return mav;
	}
	
	//삭제
	@RequestMapping("/boardDelete")
	@Transactional(rollbackFor = {Exception.class, RuntimeException.class})
	public ModelAndView boardDelete(int no) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(DefaultTransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);	
		
		//System.out.println("delete no-->"+no);
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
		//	System.out.println("board delete no :" + no);
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
				//mav.setViewName("redirect:boardList");
				mav.setViewName("redirect:boardView");
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
//----------------------------------------!!! 답글 !!!------------------------------------------------------	
	//답글 쓰기 폼 이동
	@RequestMapping("/replyWrite")
	public ModelAndView replyWriteForm(int no, SearchAndPageVO sapvo) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("no", no);
		mav.addObject("sapvo", sapvo);
		mav.setViewName("board/replyWrite");
		return mav;
	}
	
	//답글 작성 - 트랜잭션
	@RequestMapping(value="/replyWriteOk", method=RequestMethod.POST)
	@Transactional(rollbackFor= {Exception.class, RuntimeException.class}) //예외가발생하면 롤백처리를해줘라
	public ModelAndView replyWriteOk(BoardVO vo, HttpServletRequest req, SearchAndPageVO sapvo) {
		//트렌잭션 
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();  //객체 생성을 위해 호출해옴
		def.setPropagationBehavior(DefaultTransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def); //트렌젝션을 하기 위해 객체생성 -트렌젝션 생성하기 위한 준비끝
		
		ModelAndView mav = new ModelAndView();
		
		//System.out.println("replywriteOk controller in !!! try catch 들어가기 직전!!!");
		
		try {
			//수정 시 첨부파일이 없으면 에러가 나므로 null을 setting
			if(vo.getFilename() == null || vo.getFilename() == "" ) {
				vo.setFilename("");
			}
			//---------------0. 답글에 파일 업로드 --------------------------
			String path = req.getSession().getServletContext().getRealPath("/upload");
			System.out.println("reply write path ->" +path);
			
			MultipartHttpServletRequest mr = (MultipartHttpServletRequest) req;
			//MultipartHttpServletRequest에서 업로드할 파일 목록을 구하기
			List<MultipartFile> files = mr.getFiles("file");
			//올라간 파일 이름을 담을 DB 리스트
			 // 중복파일 담기
			List<String> uploadDB = new ArrayList<String>();
			// 원본파일 이름 담기
			List<String> orifilename = new ArrayList<String>();
			
			if(!files.isEmpty()) {
				//파일 수 만큼 반복 실행
				for(MultipartFile mf : files) {
					//파일 이름을 담을 변수
					String originalFilename = mf.getOriginalFilename();
					//파일이름이 공백이 아니면  업로드
					if(!originalFilename.equals("")) {
						//파일을 저장할 위치, 파일이름을 File 객체로 변환해서 담는다.
						File f = new File(path, originalFilename); 
						int i = 1;
						// 중복 검사 
						while(f.exists()) {
							int point = originalFilename.lastIndexOf(".");
							String name = originalFilename.substring(0, point); //파일명
							String extName = originalFilename.substring(point+1); //확장자 : 중복파일이면, 숫자 붙여주기
							//업로드 된 파일명 얻어오기(새로운 파일명), getOriginalFileName()은 원래 이름 구하는것, 이건 새로운 이름 구하기
							//mr.getOriginalFileName(nameAttr); //파일명 (원래 파일명) 기존네임->중복->리네임
							f = new File(path, name + "(" + i + ")." + extName);
							//System.out.println("write file uplaod f : " + f);
						}//while end
						
						//업로드 시키기
						try {
							System.out.println("<< replyWrite 답글 파일 업로드 성공 >>");
							mf.transferTo(f);
						}catch(Exception e) {
							System.out.println("<< replyWrite 답글 파일 업로드 실패 >>");
							e.printStackTrace();
						}
						//파일 이름 담기
						uploadDB.add(f.getName());//파일의 이름 담기
						orifilename.add(originalFilename); //원본 파일 이름 담기
					}// if equals end
				}//for mf end 
			}//if isEmpty end
			
			//DB에 이름 추가
			//여러개의 파일명을 하나의 String 으로 만들기 예: 이름 / 이름 /
			String filename = "";
			String orifile = ""; //원본파일
			for(int i=0; i<uploadDB.size(); i++) {
				filename = filename + uploadDB.get(i)+"/";
				orifile = orifile + orifilename.get(i)+"/";
			}
			
			vo.setFilename(filename);
			vo.setOrifilename(orifile);
			
			System.out.println("reply Write get filename --> "+vo.getFilename() + ", orifile 이 있다면, orifilename  ---> " + vo.getOrifilename());				
			
			// ------------------------ 1. 답글 작성 ----------------------------------			
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
			

			
			// 답글 등록 결과  확인
			if(cnt>0) { //등록 성공
				//transaction commit해주고 원글으로 이동
				mav.setViewName("redirect:boardList");
		
				transactionManager.commit(status);
			}else { //실패
				//insert가 안되었지만 cnt = 0 또는 에러 발생하지 않았을 때, 원글 글 번호와 함께 답글쓰기 폼으로 이동 
				mav.setViewName("redirect:replyWrite"); System.out.println("[ insert - 답글등록 실패 ]");
				transactionManager.rollback(status);
			} //if else end
			
			
		}catch(Exception e){
			e.printStackTrace();
			mav.addObject("no", vo.getNo());
			mav.setViewName("redirect:replyWrite"); 
			System.out.println("[ rollback - 답글등록 실패 ]");
		}//try catch end
		
	
		return mav; //갑자기 여기서 오류남 210813
	}	
	
	//답글 삭제 ---> boardDelete 로 돌아가세요

	@RequestMapping("/replyNumList")
	@ResponseBody
	public List<BoardVO> replyNumList(int ref) {
		List<BoardVO> rlist = boardService.replySelect(ref);
		
	//	System.out.println("댓글이 씌여지는 board no ---> " + ref );
	
		for(int i=0; i<rlist.size(); i++) {
			System.out.println("reply num list ref" +i+ "-> " + rlist.get(i).getRef());
		}
		
		return rlist;
		
	}
//------------------------------------!!!!  댓글  !!!!------------------------------------------------------
	//댓글 목록
	
	@RequestMapping("/commentList")
	@ResponseBody
	public List<CommentVO> commentList(int no) {
		List<CommentVO> list = boardService.commentAllList(no);
		
		//System.out.println("댓글이 씌여지는 board no ---> " + no );
		//댓글 페이징 처리s
		//String reqPageNum = req.getParameter("pageNum");// pageNum = 1로 sapvo에 이미 기본값 세팅이 되어 있음
		//if (reqPageNum != null) { // 리퀘스트했을 때, 페이지번호가 있으면 세팅/ 없으면 기본 값=1
		//	sapvo.setPageNum(Integer.parseInt(reqPageNum));
		//}
		
		for(int i=0; i<list.size(); i++) {
		//	System.out.println("cno" +i+ "-> " + list.get(i).getCno());
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
		//System.out.println("controller comment write ok in!!!");
		int result = boardService.commentInsert(cvo);
		return result;
	}
	//댓글 상태변경시 확인
	@RequestMapping("/commentCheck")
	@ResponseBody
	public Integer commentCheck(int cno, String userpwd) {
		//System.out.println("controller check comment no ->" + cno);
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
	
//------------------------------------ 엑셀 --------------------------------------	
	//엑셀 파일 다운 업로드 
	@RequestMapping(value="/excelDownload", method=RequestMethod.POST)
	@ResponseBody
	public void excelDownload(String fileName, HttpServletResponse res, Model model, SearchAndPageVO sapvo, String searchWord, String searchKey) throws Exception {
	//public void excelDownlad(String fileName, HttpServletResponse res, Model model, SearchAndPageVO sapvo, String searchWord, String searchKey) throws Exception {
		HSSFWorkbook workBook = new HSSFWorkbook(); // 엑셀 워크북 생성
		HSSFSheet sheet = null; //시트
		HSSFRow row = null; //행
		HSSFCell cell = null; //열 
		int rno = 0; //헤더 생성을 위한 열 번호
		 
		//엑셀에 답글 넣기 위해서 추가
		List<BoardVO> list = boardService.boardAllRecord(sapvo);
		
		for (int i = 0; i < list.size(); i++) {
		
		}
		
		System.out.println("excelDownlad controller in !!");
		
		try {
		List<BoardVO> excelList = boardService.excelList(searchKey, searchWord);
		List<Integer> cnoArr = new ArrayList<Integer>(); 
		
		for(int i = 0; i<excelList.size(); i++) {
			cnoArr.add(boardService.getCno(excelList.get(i).getNo() ));
		}
		
		//제목 폰트
		HSSFFont font = workBook.createFont();
		font.setFontHeightInPoints((short)15);
		font.setFontName("맑은고딕");
		
		//제목 스타일에 대한 폰트 적용, 정렬
		CellStyle headerStyle = workBook.createCellStyle(); // 제목 스타일
		headerStyle.setFont(font); //폰트 적용
		//headerStyle.setFillBackgroundColor(HSSFColorPredefined.LEMON_CHIFFON.getIndex());
		headerStyle.setFillForegroundColor(HSSFColorPredefined.YELLOW.getIndex());
		headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		
		//headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		headerStyle.setAlignment(HorizontalAlignment.CENTER);
		headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		headerStyle.setBorderTop(BorderStyle.THIN);
		headerStyle.setBorderLeft(BorderStyle.THIN);
		headerStyle.setBorderRight(BorderStyle.THIN);
		headerStyle.setBorderBottom(BorderStyle.THIN);
		
		//표 목록 스타일
		CellStyle bodyStyle = workBook.createCellStyle(); //제목 제외 스타일
		bodyStyle.setFont(font); //폰트 적용
		bodyStyle.setBorderTop(BorderStyle.THIN);
		bodyStyle.setBorderLeft(BorderStyle.THIN);
		bodyStyle.setBorderRight(BorderStyle.THIN);
		bodyStyle.setBorderBottom(BorderStyle.THIN);
		bodyStyle.setAlignment(HorizontalAlignment.CENTER);
		bodyStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		bodyStyle.setFillBackgroundColor(HSSFColorPredefined.GREY_25_PERCENT.getIndex());
		
		sheet = workBook.createSheet("게시판"); //워크시트 생성
		
		
		// 1행 (컬럼명)
		row = sheet.createRow(0);
		row.setHeight((short)0x150);
		
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(headerStyle);
		
		cell = row.createCell(1);
		cell.setCellValue("제목");
		cell.setCellStyle(headerStyle);				
			
		cell = row.createCell(2);
		cell.setCellValue("댓글");
		cell.setCellStyle(headerStyle);
		
		cell = row.createCell(3);
		cell.setCellValue("작성자");
		cell.setCellStyle(headerStyle);
	
		cell = row.createCell(4);
		cell.setCellValue("첨부파일");
		cell.setCellStyle(headerStyle);
		
		cell = row.createCell(5);
		cell.setCellValue("조회수");
		cell.setCellStyle(headerStyle);
		
		cell = row.createCell(6);
		cell.setCellValue("등록일");
		cell.setCellStyle(headerStyle);
		
		String[] headerArr = {"번호","제목","댓글", "작성자", "첨부파일", "조회수", "등록일"};
		//1행 (컬렴명)
		row = sheet.createRow(rno++);
		for(int i=0; i<headerArr.length; i++) {
			cell = row.createCell(i);
			cell.setCellValue(headerArr[i]);
			cell.setCellStyle(headerStyle);
		}
		
		// 2행 (목록)
		int esize = excelList.size();
		for (int i = 0; i < excelList.size(); i++) {
			
			row = sheet.createRow(rno+i);
			//번호
			cell = row.createCell(0); //0열부터 
			cell.setCellStyle(bodyStyle); //스타일 적용
			cell.setCellValue(esize--); //전체 사이즈 == 전체 목록 갯수 최신순일수록 높은 번호로 나오도록
			rno = 1;
			
			//제목
			cell = row.createCell(1); 
			cell.setCellStyle(bodyStyle);
			if(excelList.get(i).getLvl() > 0) {	
				for(int j = 0; j < excelList.get(i).getStep() ; j++) {
					cell.setCellValue( "RE: "); 
				}
				cell.setCellValue( "("+excelList.get(i).getLvl()+") "+excelList.get(i).getStep()+"번째 답글 : " + excelList.get(i).getSubject()); 
			}else {
				cell.setCellValue(excelList.get(i).getSubject()); 
			}
			rno = 1;
			
			
			//댓글
			cell = row.createCell(2); 
			cell.setCellStyle(bodyStyle);
			cell.setCellValue(cnoArr.get(i)); 
			rno = 1;
			
			//작성자
			cell = row.createCell(3); 
			cell.setCellStyle(bodyStyle);
			cell.setCellValue(excelList.get(i).getUserid());
			rno = 1;
			//첨부파일
			cell = row.createCell(4); 
			cell.setCellStyle(bodyStyle);
			cell.setCellValue(excelList.get(i).getFilename());
			rno = 1;
			//조회수
			cell = row.createCell(5); 
			cell.setCellStyle(bodyStyle);
			cell.setCellValue(excelList.get(i).getHit());
			rno = 1;
			//등록일
			cell = row.createCell(6);
			cell.setCellStyle(bodyStyle);
			cell.setCellValue(excelList.get(i).getWritedate()); 
			rno = 1;
		}
		
		//파일명
		res.setContentType("ms-vnd/excel");
		res.setHeader("Content-Disposition", "attachment; filename="+ java.net.URLEncoder.encode("boardlist.xls", "UTF8"));
		//엑셀 출력
		workBook.write(res.getOutputStream());
		workBook.close();
		System.out.println("엑셀 다운로드 성공");
		}catch(Exception e) {
			e.printStackTrace();
			System.out.println("엑셀 다운로드 실패");
		}
		
	}
	//파일 업로드하는 메소드 (사용은안하지만, 추가해놓음)
	@RequestMapping(value="/fileUpload", method=RequestMethod.POST)
	@ResponseBody
	 public String fileUpload(HttpServletRequest req, HttpServletResponse res, MultipartFile multipartFile) throws ServletException, IOException {
		 	//FileItem이라는 객체를 구하기
			//저장할 위치에 대한 경로
			String path = req.getSession().getServletContext().getRealPath("/upload");
			//파일 업로드를 위해서 multiparthttp객체로 변환해준다
			MultipartHttpServletRequest mr = (MultipartHttpServletRequest) req;
			try {
				//1. factory 객체 생성
				DiskFileItemFactory dfif = new DiskFileItemFactory();
				//2.팩토리에 업로드 위치(path ->파일로변환 java07-io 참조)세팅
				File f = new File(path);
				dfif.setRepository(f); //저장하는 공간이 어디냐
				//3. ServletFileUpload 객체 생성
				ServletFileUpload fileUpload = new ServletFileUpload(dfif); //dfif를 매개변수로 넣어줌
				//4. 폼의 필드수만큼 FileItem을 얻어온다.
				List<FileItem> items = fileUpload.parseRequest(req); //req를 넣으면 폼에 있는 필드수만큼 컬렉션이 들어옴
				
				BoardVO vo = new BoardVO();
				
				//items의 갯수
				//System.out.println("items.size()-> "+items.size());
				for(FileItem item :items) {
					//텍스트 필드인지 아니면 첨부파일인지 
					if(item.isFormField()) { //텍스트 입력할 수 있는 필드냐?라고 묻기
						//필드명 알아내기
						String fieldName = item.getFieldName();//필드명
						String value = item.getString("UTF-8"); //값,    데이터 (인코딩)
						
						if(fieldName.equals("subject")) {
							vo.setSubject(value); 
						}
						if(fieldName.equals("content")) {
							vo.setContent(value);
						}
					}else { //필드가 아닐땐 파일일때
							//파일
							//파일명 리네임
							//파일의 크기를 구하여 0보다 크면 업로드 구현	
							if(item.getSize()>0 ) {		//getSize() - 파일의 크기			
								String oriFilename = item.getName();//원래 파일명  aaa.gif -> aaa_1.gif  -> aaa_2.gif -> aaa_3.gif 이렇게 이름 중복되지 않도록 새 번호 부여해주기
								
								//파일명과 확장자를 분리 ( +중복 파일이름이 있는지 없는지 확인
								int dot=oriFilename.lastIndexOf(".");//.의 위치
								String filename = oriFilename.substring(0, dot);
								String ext=oriFilename.substring(dot+1);
								
								File file = new File(path, oriFilename);
								int idx=1;
								while(file.exists()) { // 있으면 true, 없으면 false
									//없는 이름 false가 나올때까지,,계속돌아
									file = new File(path, filename + "_" + idx++ + "." + ext);
								}//while end
								
								//업로드 실행
								item.write(file);  // Fileitem items가 반복되다가 여기 실림
								
							}//if end
						}//ifend
				
				}//for
				//---> FileItem 가 구해짐
			}catch(Exception e) {
				e.printStackTrace();
			}
				return "/myapp/boardView.jsp";
			
	 }
	//파일 다운로드
	@RequestMapping("/fileDownload")
	public ModelAndView fileDownload(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		//절대경로
		//파일 업로드된 경로
		//서버에 실제 저장된 파일명
		//실제 내보낼 파일명
		//파일 읽어 스트림에 담기
		// 파일 다운로드 헤더 지정
		
		
		return mav;
	}
}
