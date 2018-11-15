package com.spring.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyVO;
import com.spring.persistence.BoardDAO;
import com.spring.persistence.ReplyDAO;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Inject
	private ReplyDAO rdao;
	@Inject
	private BoardDAO bdao;
	
	@Transactional
	@Override
	public int addReply(ReplyVO vo) throws Exception {		
		//댓글이 등록되면서 spring_board의 replycnt 컬럼 값을 하나
		//추가 해야 함
		int result=rdao.create(vo);
		bdao.updateReplyCnt(vo.getBno(), 1);
		return result;
	}
	@Override
	public int modifyReply(ReplyVO vo) throws Exception {			
		return rdao.update(vo);
	}
	@Transactional
	@Override
	public int removeReply(int rno) throws Exception {		
		int bno=rdao.getBno(rno);
		bdao.updateReplyCnt(bno, -1);
		return rdao.delete(rno);
	}
	@Override
	public ReplyVO getReply(int rno) throws Exception {		
		return rdao.get(rno);
	}
	/*@Override
	public List<ReplyVO> list(int bno) throws Exception {		
		return rdao.list(bno);
	}*/
	@Override
	public List<ReplyVO> listPage(int bno, Criteria cri) throws Exception {
		return rdao.listPage(bno, cri);
	}
	@Override
	public int count(int bno) throws Exception {		
		return rdao.count(bno);
	}
	@Override
	public int getBno(int rno) throws Exception {
		//댓글의 삭제시 원본글의 글번호 가져오기
		return rdao.getBno(rno);
	}

}
