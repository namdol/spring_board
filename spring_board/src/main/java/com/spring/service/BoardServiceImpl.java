package com.spring.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.persistence.BoardAttachDAO;
import com.spring.persistence.BoardDAO;

@Service  //자동으로 객체 생성
public class BoardServiceImpl implements BoardService{
	
	@Inject //@AutoWired
	private BoardDAO dao;
	@Inject
	private BoardAttachDAO adao; //첨부파일
	
	@Transactional
	@Override
	public int create(BoardVO vo) throws Exception {
		int result=dao.create(vo);
		//새글이 들어가면서 생성된 bno 가져오기
		int bno=dao.lastSelectBno();
		
		//첨부파일 작업하기
		if(vo.getAttachList()==null || vo.getAttachList().size()<=0) {
			return 0;
		}
		//uuid,filetype,uploadpath,fileName,bno
		
		vo.getAttachList().forEach(attach->{
			attach.setBno(bno);
			adao.attach_insert(attach);
		});
		
		return result;
	}
	@Transactional
	@Override
	public int update(BoardVO vo) throws Exception {		
		//첨부물이 추가되는 경우 처리하기
		//1. 테이블에 저장된 기존 첨부 목록 지우기
		adao.removeAttachList(vo.getBno());
		//2. 내용 수정
		int result = dao.update(vo);
		
		if(result==0 || vo.getAttachList()==null || vo.getAttachList().size()<=0) {
			return 0;
		}
		vo.getAttachList().forEach(attachList->{
			attachList.setBno(vo.getBno());
			adao.attach_insert(attachList);
		});
		
		return result;
	}
	@Transactional
	@Override
	public int delete(int bno) throws Exception {		
		
		//첨부물 삭제
		adao.removeAttachList(bno);
		//게시물 삭제
		int result=dao.delete(bno);
		
		return result;
	}

	@Override
	public BoardVO read(int bno) throws Exception {		
		return dao.read(bno);
	}

	@Override
	public List<BoardVO> listAll() throws Exception {		
		return dao.listAll();
	}

	@Override
	public int cntupdate(int bno) throws Exception {		
		return dao.cntupdate(bno);
	}

	@Override
	public int lastSelectBno() throws Exception {		
		return dao.lastSelectBno();
	}

	@Override
	public List<BoardVO> listCriteria(Criteria cri) throws Exception {
		return dao.listCriteria(cri);
	}

	@Override
	public int totalCount(Criteria cri) throws Exception {
		return dao.totalCount(cri);
	}

	@Override
	public void updateReplyCnt(int bno, int amount) throws Exception {
		dao.updateReplyCnt(bno, amount);		
	}

	@Override
	public List<BoardAttachVO> getAttachList(int bno) throws Exception {
		return adao.getAttachList(bno);
	}

}





