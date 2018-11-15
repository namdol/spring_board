package com.spring.domain;

public class PageDTO {
	private int totalCount;
	private int startPage;
	private int endPage;
	private boolean next;
	private boolean prev;
	
	//화면 하단의 보여줄 페이지
	private int displayPageNum=10;
	private Criteria cri;
	
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
		calcData();
	}
	private void calcData() {
		//totalcount 값에 따라 endPage, startPage 계산
		endPage=(int)(Math.ceil(cri.getPage()/(double)displayPageNum)*displayPageNum);
		startPage=(endPage-displayPageNum)+1;
		
		int tmpEndPage=(int)(Math.ceil(totalCount/(double)cri.getPerPageNum()));
		if(endPage>tmpEndPage)
			endPage=tmpEndPage;
		
		prev=(startPage==1)?false:true;
		next=endPage*cri.getPerPageNum() >=totalCount?false:true;
	}
	
	
	public int getStartPage() {
		return startPage;
	}
	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	public boolean isNext() {
		return next;
	}
	public void setNext(boolean next) {
		this.next = next;
	}
	public boolean isPrev() {
		return prev;
	}
	public void setPrev(boolean prev) {
		this.prev = prev;
	}
	public int getDisplayPageNum() {
		return displayPageNum;
	}
	public void setDisplayPageNum(int displayPageNum) {
		this.displayPageNum = displayPageNum;
	}
	public Criteria getCri() {
		return cri;
	}
	public void setCri(Criteria cri) {
		this.cri = cri;
	}
	
}
