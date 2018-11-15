package com.spring.persistence;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyVO;

@Repository
public class ReplyDAOImpl implements ReplyDAO {

	@Inject
	private SqlSession session;
	private static String namespace="mapper.replyMapper";
	
	
	@Override
	public int create(ReplyVO vo) throws Exception {		
		return session.insert(namespace+".create",vo);
	}
	@Override
	public int update(ReplyVO vo) throws Exception {		
		return session.update(namespace+".update", vo);
	}
	@Override
	public int delete(int rno) throws Exception {		
		return session.delete(namespace+".delete", rno);
	}
	@Override
	public ReplyVO get(int rno) throws Exception {		
		return session.selectOne(namespace+".get", rno);
	}
	/*@Override
	public List<ReplyVO> list(int bno) throws Exception {		
		return session.selectList(namespace+".list", bno);
	}*/
	@Override
	public List<ReplyVO> listPage(int bno, Criteria cri) throws Exception {
		HashMap<String, Object> map=new HashMap<>();
		map.put("bno", bno);
		map.put("cri", cri);
		return session.selectList(namespace+".listPage", map);
	}
	@Override
	public int count(int bno) throws Exception {		
		return session.selectOne(namespace+".count",bno);
	}
	@Override
	public int getBno(int rno) throws Exception {		
		return session.selectOne(namespace+".getBno",rno);
	}
}
