package com.spring.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

@Repository   //객체 생성
public class BoardDAOImpl implements BoardDAO {
	
	@Inject  //@AutoWired
	private SqlSession sqlSession;
	
	private static String namespace="mapper.boardMapper";
	
	@Override
	public int create(BoardVO vo) throws Exception {		
		return sqlSession.insert(namespace+".create",vo);
	}

	@Override
	public int update(BoardVO vo) throws Exception {		
		return sqlSession.update(namespace+".update", vo);
	}
	@Override
	public int delete(int bno) throws Exception {		
		return sqlSession.delete(namespace+".delete", bno);
	}
	@Override
	public BoardVO read(int bno) throws Exception {		
		return sqlSession.selectOne(namespace+".read", bno);
	}
	@Override
	public List<BoardVO> listAll() throws Exception {		
		return sqlSession.selectList(namespace+".selectAll");
	}
	@Override
	public int cntupdate(int bno) throws Exception {		
		return sqlSession.update(namespace+".cntupdate", bno);
	}

	@Override
	public int lastSelectBno() throws Exception {		
		return sqlSession.selectOne(namespace+".lastSelectBno");
	}

	@Override
	public List<BoardVO> listCriteria(Criteria cri) throws Exception {		
		return sqlSession.selectList(namespace+".listSearch",cri);
	}

	@Override
	public int totalCount(Criteria cri) throws Exception {		
		return sqlSession.selectOne(namespace+".totalSearchCount", cri);
	}

	@Override
	public void updateReplyCnt(int bno, int amount) throws Exception {
		Map<String, Object> map=new HashMap<>();
		map.put("bno", bno);
		map.put("amount", amount);
		
		sqlSession.update(namespace+".updateReplyCnt", map);		
	}
}




