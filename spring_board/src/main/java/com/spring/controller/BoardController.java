package com.spring.controller;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.domain.PageDTO;
import com.spring.service.BoardService;

@Controller
@RequestMapping("/board/*")
public class BoardController {
	private static final Logger logger = 
			LoggerFactory.getLogger(BoardController.class);

	@Inject
	private BoardService service;
	
	//전체 게시물 가져오기
	@GetMapping("/list")
	public void list(Model model,@ModelAttribute("cri")Criteria cri) {
		logger.info("전체 게시물 요청......");
		try {
			//List<BoardVO> list=service.listAll();
			List<BoardVO> list=service.listCriteria(cri);
			//전체 게시물 수를 구한 후 PageDTO에 담기
			int totalRows=service.totalCount(cri);
			PageDTO dto=new PageDTO();
			dto.setCri(cri);
			dto.setTotalCount(totalRows);			
			
			model.addAttribute("list", list);
			model.addAttribute("dto", dto);
		} catch (Exception e) {			
			e.printStackTrace();
		}
	}
	
	//http://localhost:8080/board/register 요청에 응답하는 컨트롤러 작성
	//views/register.jsp 보여주기
	@GetMapping("/register")
	public void registerGet() {
		logger.info("register.jsp 보여주기....");
	}
	
	//register.jsp에서 작성한 값 가져오기
	@PostMapping("/register")
	public String registerPost(BoardVO vo,RedirectAttributes rttr) {
		logger.info("register.jsp 정보 가져오기....");	
		
		
		if(vo.getAttachList()!=null) {
			vo.getAttachList().forEach(attach->logger.info(""+attach));
		}		
		
		//service메소드 호출해서 db삽입하기
		try {
			service.create(vo);	
			rttr.addFlashAttribute("result", service.lastSelectBno());
		} catch (Exception e) {			
			e.printStackTrace();
		}
		
		//삽입이 끝난 후 리스트로 이동
		//return "redirect:list";
		return "redirect:/board/list";
	}
	
	//board/hitupdate 요청 처리하는 컨트롤러 작성
	//bno가져오기, 조회수 업데이트
	@GetMapping("/hitupdate")
	public String hitUpdate(int bno,Criteria cri,RedirectAttributes rttr) {
		logger.info("조회수 업데이트....");
		try {
			service.cntupdate(bno);
		} catch (Exception e) {			
			e.printStackTrace();
		}
		
		rttr.addAttribute("bno", bno);
		rttr.addAttribute("page", cri.getPage());
		rttr.addAttribute("perPageNum", cri.getPerPageNum());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/read";   //내용가져오기 컨트롤러 호출
	}
	
	// /board/read요청 처리하는 컨트롤러
	// bno 가져오기, bno에 해당하는 내용 읽어오기
	// 내용을 가지고 read.jsp로 이동
	@GetMapping(value= {"/read","/modify"})
	public void read(int bno,Model model,@ModelAttribute("cri")Criteria cri) {
		logger.info("내용 읽어오기");
		BoardVO vo=null;
		try {
			vo=service.read(bno);
		} catch (Exception e) {			
			e.printStackTrace();
		}
		if(vo!=null)
			model.addAttribute("vo", vo);		
	}
	
	
	//   /board/modify.jsp post로 넘어오는 요청 컨트롤러 만들기
	//modify.jsp에서 넘어오는 내용 가져와서
	//db수정 후 리스트로 이동
	@PostMapping("/modify")
	public String modify(BoardVO vo,@ModelAttribute("cri")Criteria cri,RedirectAttributes rttr) {
		logger.info("게시판 내용 수정....");
		
		
		
		try {
			service.update(vo);
		} catch (Exception e) {			
			e.printStackTrace();
		}
		rttr.addAttribute("page", cri.getPage());
		rttr.addAttribute("perPageNum", cri.getPerPageNum());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
				
		return "redirect:/board/list";
	}
	
	// /board/remove 컨트롤러 작성
	// bno가져와서 삭제 후 리스트로 이동
	@PostMapping("/remove")
	public String remove(int bno,Criteria cri,RedirectAttributes rttr) {
		logger.info("게시판 글 삭제...");
		try {
			//서버에서 첨부물 삭제를 위해 bno에 해당하는 목록 가져오기
			List<BoardAttachVO> attachList=service.getAttachList(bno);
			
			int result=service.delete(bno);
			
			if(result>0) {//서버 폴더에서 파일 삭제				
				deleteFile(attachList);
			}
		} catch (Exception e) {			
			e.printStackTrace();
		}
		
		rttr.addAttribute("page", cri.getPage());
		rttr.addAttribute("perPageNum", cri.getPerPageNum());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	//글번호에 해당하는 첨부목록 가져오기
	@ResponseBody
	@GetMapping(value="/getAttachList",
			produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<BoardAttachVO>> getAttachList(int bno){
		logger.info(bno+ " 첨부 목록 가져오기");
		List<BoardAttachVO> list=null;
		try {
			list = service.getAttachList(bno);
		} catch (Exception e) {			
			e.printStackTrace();
		}
		
		return new ResponseEntity<List<BoardAttachVO>>(list,HttpStatus.OK);
	}//
	
	private void deleteFile(List<BoardAttachVO> attachList){
		
		logger.info("파일 삭제....");
		
		if(attachList==null||attachList.size()<=0) {
			return;
		}		
		
		for(BoardAttachVO vo:attachList) {
			Path file=Paths.get(vo.getUploadPath()+"\\"+
						vo.getUuid()+"_"+vo.getFileName());
			
			try {
				//일반파일,이미지 파일 삭제
				Files.deleteIfExists(file);
				
				//썸네일 삭제
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail=Paths.get(vo.getUploadPath()+"\\s_"+
						vo.getUuid()+"_"+vo.getFileName());
					Files.deleteIfExists(thumbNail);
				}
			} catch (IOException e) {				
				e.printStackTrace();
			}			
		}
		
		
		
	}
}









