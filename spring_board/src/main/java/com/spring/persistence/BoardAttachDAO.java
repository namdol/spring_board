package com.spring.persistence;

import java.util.List;

import com.spring.domain.BoardAttachVO;

public interface BoardAttachDAO {
	public void attach_insert(BoardAttachVO vo);
	public void attach_delete(String uuid);
	public List<BoardAttachVO> getAttachList(int bno);
	public void removeAttachList(int bno);
}
