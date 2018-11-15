package com.spring.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.domain.BoardAttachVO;

@Repository
public class BoardAttachDAOImpl implements BoardAttachDAO {

	private static String attach="mapper.attachMapper";
	@Inject
	private SqlSession session;
	
	@Override
	public void attach_insert(BoardAttachVO vo) {		
		session.insert(attach+".insert",vo);
	}

	@Override
	public void attach_delete(String uuid) {
		session.delete(attach+".delete",uuid);
	}

	@Override
	public List<BoardAttachVO> getAttachList(int bno) {		
		return session.selectList(attach+".getAttachList",bno);
	}

	@Override
	public void removeAttachList(int bno) {
		session.delete(attach+".deleteAll", bno);
		
	}
}
