package com.spring.persistence;

import java.util.List;

import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

public interface BoardDAO {
	//게시글 등록
	public int create(BoardVO vo) throws Exception;
	//게시글 수정
	public int update(BoardVO vo) throws Exception;
	//게시글 삭제
	public int delete(int bno) throws Exception;
	//게시글 조회
	public BoardVO read(int bno) throws Exception;
	//게시글 전체조회
	public List<BoardVO> listAll() throws Exception;
	//조회수 업데이트
	public int cntupdate(int bno) throws Exception;
	//마지막 글 번호 조회
	public int lastSelectBno() throws Exception;
	
	//페이지 처리후 리스트 가져오기
	public List<BoardVO> listCriteria(Criteria cri) throws Exception;
	//전체 게시물 수
	public int totalCount(Criteria cri) throws Exception;
	
	//댓글등록
	public void updateReplyCnt(int bno,int amount) throws Exception;
	
	
	
}








