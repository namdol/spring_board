<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board List</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board List Page
                            <button id='regBtn' type='button' class='btn btn-xs pull-right'>Register New Board</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <table class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>번 호</th>
                                        <th>제 목</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                        <th>조회수</th>
                                    </tr>                                    
                                </thead> 
                                <c:forEach var="vo" items="${list}">
                                	<tr>
                                		<td>${vo.bno}</td>
                                		<td><a href="/board/hitupdate?bno=${vo.bno}&page=${cri.page}&perPageNum=${cri.perPageNum}&type=${cri.type}&keyword=${cri.keyword}">${vo.title} <strong>[${vo.replycnt}]</strong></a></td>
                                		<td>${vo.writer}</td>
                                		<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${vo.regdate}"/></td>
                                		<td>${vo.cnt}</td>
                                	</tr>
                                </c:forEach>                               
                            </table>
							<div class="row"> <!-- start search -->
                            	<div class="col-md-12">
                            	  <div class="col-md-8">
                            		<form id="searchForm" action="" method="get">
                            			<select name="type">
                            				<option value="" <c:out value="${empty cri.type?'selected':''}"/>>-----</option>	
                            				<option value="T" <c:out value="${cri.type eq 'T'?'selected':''}"/>>제목</option>	
                            				<option value="C" <c:out value="${cri.type eq 'C'?'selected':''}"/>>내용</option>	
                            				<option value="W" <c:out value="${cri.type eq 'W'?'selected':''}"/>>작성자</option>	
                            				<option value="TC" <c:out value="${cri.type eq 'TC'?'selected':''}"/>>제목  or 내용</option>	
                            				<option value="TW" <c:out value="${cri.type eq 'TW'?'selected':''}"/>>제목  or 작성자</option>          			
                            				<option value="TCW" <c:out value="${cri.type eq 'TCW'?'selected':''}"/>>제목  or 내용  or 작성자</option>          			
                            			</select>
                            			<input type="text" name="keyword" value="${cri.keyword}">
                            			<input type="hidden" name="page" value="${cri.page}">
                            			<input type="hidden" name="perPageNum" value="${cri.perPageNum}">
                            			<button class="btn btn-default">Search</button>
                            	   	</form>
                            	   </div>
                            	   <div class="col-md-2 col-md-offset-2">
                            	   	<select class="form-control" id="perPageNum">						
										<option value="10" <c:out value="${cri.perPageNum eq 10?'selected':''}"/>>10</option>				
										<option value="20" <c:out value="${cri.perPageNum eq 20?'selected':''}"/>>20
										<option value="30" <c:out value="${cri.perPageNum eq 30?'selected':''}"/>>30</option>
										<option value="40" <c:out value="${cri.perPageNum eq 40?'selected':''}"/>>40</option>
								  	</select>	
								  </div>
                             	 </div>                             	 
                      		 </div><!-- end search -->
                            <!-- start Pagination -->
                            <div class="text-center">
                            	<ul class="pagination">
                            		<c:if test="${dto.prev}">
                            		<li class="paginate_button previous"><a href="list?page=${dto.startPage-1}&perPageNum=${cri.perPageNum}&type=${cri.type}&keyword=${cri.keyword}">Previous</a>
                            		</c:if>
                            		<c:forEach var="idx" begin="${dto.startPage}" end="${dto.endPage}">
                            		<li <c:out value="${cri.page==idx?'class=active':''}"/>><a href="list?page=${idx}&perPageNum=${cri.perPageNum}&type=${cri.type}&keyword=${cri.keyword}">${idx}</a>
                            		</c:forEach>
                            		<c:if test="${dto.next && dto.endPage>0}">
                            		<li class="paginate_button next"><a href="list?page=${dto.endPage+1}&perPageNum=${cri.perPageNum}&type=${cri.type}&keyword=${cri.keyword}">Next</a>                            		
                            		</c:if>
                            	</ul>
                            </div>
                            <!-- end Pagination -->   
                            </div>
                            <!-- end panel-body -->
                        </div>
                        <!-- end panel -->
                    </div>                   
                </div>               
            <!-- /.row -->
    <!-- 게시글 등록 여부를 알려주는 모달 -->        
    <div class="modal" tabindex="-1" role="dialog" id="myModal">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">게시글 등록</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <p>처리가 완료되었습니다.</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>	        
	      </div>
	    </div>
	  </div>
	</div>   
	<!-- 목록 갯수 변환시 보낼 폼 -->
	<form id="perPageForm">
		<input type="hidden" name="page" value="${cri.page}">
		<input type="hidden" name="perPageNum" value="${cri.perPageNum}">	
		<input type="hidden" name="keyword" value="${cri.keyword}">	
		<input type="hidden" name="type" value="${cri.type}">	
	</form>
	
	     
    <script>
    	//모달 창과 관련있는 스크립트
    	$(function(){
    		var result='${result}';
    		checkModal(result);    		
    		
    		history.replaceState({},null,null);
    		
    		function checkModal(result){
    			if(result===''|| history.state){
    				return;
    			}else if(parseInt(result)>0){
    				//lastSelectBno 값을 이용해서 0보다 큰 값이 넘어올 때 사용
    				$(".modal-body").html("게시글 "+parseInt(result)+" 번이 등록되었습니다.");
    			}
    			$("#myModal").modal("show");
    		}
    	});
    </script>    
            
    <script>
    	$(function(){
    		$("#regBtn").click(function(){
    			location.href="/board/register";
    		});
    		
    		//목록 갯수 변화
    		$(".form-control").change(function(){
    			//사용자가 선택한 페이지당 개수 가져오기
    			var perPageNum = $(this).val();
    			//보낼 폼 가져오기
    			var perPageForm = $("#perPageForm");
    			//가져온 폼에 페이지당 개수 값 세팅
    			perPageForm.find("[name='perPageNum']").val(perPageNum);
    			//폼 보내기
    			perPageForm.submit();
    		});
    		
    		//검색버튼 처리
    		$(".btn-default").click(function(){
    			var searchForm=$("#searchForm");
    			//검색어와 검색종류가 선택되지 않으면 폼을 이동 안 시키기
    			if(!searchForm.find("option:selected").val()){
    				alert("검색 종류를 선택하세요");
    				return false;
    			}
    			if(!searchForm.find("input[name='keyword']").val()){
    				alert("검색어를 선택하세요");
    				searchForm.find("input[name='keyword']").focus();
    				return false;
    			}
    			//조건을 만족하면 page는 무조건 1로 세팅
    			searchForm.find("input[name='page']").val("1");
    			//폼 보내기
    			searchForm.submit();
    		});
    		
    	});
    </script>        
<%@include file="../includes/footer.jsp" %>  






     