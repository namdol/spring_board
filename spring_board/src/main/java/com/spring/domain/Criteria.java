package com.spring.domain;

public class Criteria {
	private int page;  //현재페이지
	private int perPageNum; //페이지당 보여줄 게시물 수
	
	//검색처리 시 추가되는 부분
	private String keyword;
	private String type;
	
	public Criteria() {
		super();
		this.page=1;
		this.perPageNum=10;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		if(page<=0) {
			page=1;
			return;
		}
		this.page = page;
	}
	public int getPerPageNum() {
		return perPageNum;
	}
	public void setPerPageNum(int perPageNum) {
		if(perPageNum<=0 || perPageNum > 100) {
			this.perPageNum=10;
			return;
		}
		this.perPageNum = perPageNum;
	}
	
	//BoardMapper 용
	public int getPageStart() {
		return (this.page-1)*perPageNum;
	}
}








