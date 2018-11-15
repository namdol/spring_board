package com.spring.persistence;

import java.util.List;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyVO;

public interface ReplyDAO {
	public int create(ReplyVO vo) throws Exception;
	public int update(ReplyVO vo) throws Exception;
	public int delete(int rno) throws Exception;
	public ReplyVO get(int rno) throws Exception;
	//public List<ReplyVO> list(int bno) throws Exception;	
	//댓글의 페이지 처리
	public List<ReplyVO> listPage(int bno,Criteria cri) throws Exception;
	public int count(int bno) throws Exception;
	//댓글
	public int getBno(int rno) throws Exception;
}
