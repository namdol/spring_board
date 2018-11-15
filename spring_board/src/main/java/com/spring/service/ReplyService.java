package com.spring.service;

import java.util.List;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyVO;

public interface ReplyService {
	public int addReply(ReplyVO vo) throws Exception;
	public int modifyReply(ReplyVO vo) throws Exception;
	public int removeReply(int rno) throws Exception;
	public ReplyVO getReply(int rno) throws Exception;
	//public List<ReplyVO> list(int bno) throws Exception;	
	//댓글의 페이지 처리
	public List<ReplyVO> listPage(int bno,Criteria cri) throws Exception;
	public int count(int bno) throws Exception;
	//댓글
	public int getBno(int rno) throws Exception;
}
