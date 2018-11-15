package com.spring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.domain.Criteria;
import com.spring.domain.PageDTO;
import com.spring.domain.ReplyVO;
import com.spring.service.ReplyService;

@RestController
@RequestMapping("/replies")
public class ReplyController {
	private static final Logger logger
					= LoggerFactory.getLogger(ReplyController.class);
	
	@Inject
	private ReplyService service;
	
	@PostMapping("/new")	
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		logger.info("댓글 등록");
		int result=0;
		try {
			result=service.addReply(vo);
		} catch (Exception e) {			
			e.printStackTrace();
		}
		return result==1?
			new ResponseEntity<>("success",HttpStatus.OK):
			new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping("/{bno}/{page}")
	public ResponseEntity<Map<String, Object>> list(@PathVariable("bno")int bno
			,@PathVariable("page")int page){
		logger.info("댓글 리스트 가져오기");
		
		ResponseEntity<Map<String, Object>> entity=null;
		try {
			
			//댓글 계산하기
			Criteria cri=new Criteria();
			cri.setPage(page);
			
			PageDTO dto=new PageDTO();
			dto.setCri(cri);						
			List<ReplyVO> list = service.listPage(bno,cri);			
			Map<String, Object> map=new HashMap<>();
			map.put("list", list);			
			int replycount=service.count(bno);
			dto.setTotalCount(replycount);			
			
			map.put("dto", dto);
			
			if(map.isEmpty()) {
				entity=new ResponseEntity<>(HttpStatus.NO_CONTENT);
			}else {
				entity=new ResponseEntity<>(map,HttpStatus.OK);
			}
		} catch (Exception e) {			
			e.printStackTrace();
		}
		return entity;		
	}
	
	//댓글 업데이트
	//put : 전체 수정에 가까움, patch : 일부분 수정에 가까움
	@RequestMapping(path="/{rno}",method= {RequestMethod.PATCH,RequestMethod.PUT})
	public ResponseEntity<String> update(@PathVariable("rno")int rno,@RequestBody ReplyVO vo){
		logger.info("댓글 수정");
		int result=0;
		try {
			vo.setRno(rno);
			result=service.modifyReply(vo);
		} catch (Exception e) {			
			e.printStackTrace();
		}
		return result==1?
			new ResponseEntity<>("success",HttpStatus.OK):
			new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	//댓글 삭제
	@DeleteMapping("/{rno}")
	public ResponseEntity<String> remove(@PathVariable("rno")int rno){
		logger.info("댓글 삭제");
		int result=0;
		try {			
			result=service.removeReply(rno);
		} catch (Exception e) {			
			e.printStackTrace();
		}		
		return result==1?
			new ResponseEntity<>("success",HttpStatus.OK):
			new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	@GetMapping("/{rno}")
	public ResponseEntity<ReplyVO> get(@PathVariable("rno")int rno){
		logger.info("댓글 하나 가져오기");
		ReplyVO vo=null;
		try {			
			vo=service.getReply(rno);
		} catch (Exception e) {			
			e.printStackTrace();
		}		
		return vo!=null?
			new ResponseEntity<>(vo,HttpStatus.OK):
			new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	
}








