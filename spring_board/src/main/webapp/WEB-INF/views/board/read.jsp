<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Read</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>            
            <div class="row">
                <div class="col-lg-12">
                	<div class="panel panel-default">
                        <div class="panel-heading">
                           Board Read Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="" role="form">
                				<div class="form-group">
                					<label>Bno</label>
                					<input class="form-control" name="bno" readonly="readonly" value="${vo.bno}">                				
                				</div> 
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title" readonly="readonly" value="${vo.title}">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content" readonly="readonly">${vo.content}</textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer" readonly="readonly" value="${vo.writer}">                				
                				</div>  
                				<button type="button" class="btn btn-default">Modify</button>              			
                				<button type="button" class="btn btn-info">List</button>              			
                			</form>
                		</div>
                	</div>
                </div>
            </div>
            <!-- 첨부물 영역 -->
            <div class='bigPictureWrapper'>
			  <div class='bigPicture'>
			  </div>
			</div>
            
            <link rel="stylesheet" href="/resources/css/upload.css"/>
            
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">Files</div>
            				<div class="panel-body">
            					<div class="uploadResult">
            						<ul></ul>
            					</div>
            				</div>
            		</div>
            	</div>            
            </div>
            <!-- 댓글 영역 -->
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">
	            			<i class="fa fa-comments fa-fw"></i>      				
	            			Reply
	            			<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
            			</div><!-- ./ end panel-heading  --> 
            			<div class="panel-body">
            				<ul class="chat">
            					<!--  start reply -->
            					<li class="left clearfix" data-rno='12'>
            						<div>
            							<div class="header">
	            							<strong class="primary-font">user00</strong>
	            							<small class="pull-right text-muted">2018-11-06 10:10</small>
            							</div>
            							<p>Good Job!!!</p>
            						</div>            						
            					</li>
            				</ul>            			
            			</div><!-- ./ end panel-body  --> 
            			<div class="panel-footer"><!-- 댓글의 페이지 나누기 영역 -->
            				
            			</div><!-- ./ end panel-footer  --> 
            		</div><!-- ./ end panel panel-default  -->            	
            	</div><!-- ./ end col-lg-12  -->            
            </div><!-- ./ end row  -->  
            <!-- 댓글 등록  버튼 누르면  Modal -->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title" id="myModalLabel">Reply Modal</h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                            	<label>Reply</label>
                            	<input class="form-control" name="replytext" value="New Reply">
                            </div>
                            <div class="form-group">
                            	<label>Replyer</label>
                            	<input class="form-control" name="replyer" value="replyer">
                            </div>
                            <div class="form-group">
                            	<label>Reply Date</label>
                            	<input class="form-control" name="replydate" value="">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-warning" id="modalModBtn">Modify</button>
                            <button type="button" class="btn btn-danger" id="modalRemoveBtn">Remove</button>
                            <button type="button" class="btn btn-primary" id="modalRegisterBtn">Register</button>
                            <button type="button" class="btn btn-default" id="modalCloseBtn">Close</button>                            
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal --> 
            
            
            <!-- modify나 페이지 처리를 위한 폼 개별 구성 -->
            <form id="operForm" action="/board/modify">
            	<input type="hidden" value="${vo.bno}" name="bno">
            	<input type="hidden" value="${cri.page}" name="page">
            	<input type="hidden" value="${cri.perPageNum}" name="perPageNum">
            	<input type="hidden" value="${cri.keyword}" name="keyword">
            	<input type="hidden" value="${cri.type}" name="type">
            </form>
     <script src="/resources/js/reply.js"></script>       
     <script>
     	$(function(){
     		//댓글을 등록할 글 번호 지정
     		var bno=${vo.bno};
     		//댓글을 달 영역 가져오기
     		var replyUL=$(".chat");
     		
     		//댓글 불러오기 호출
     		showList(1);     		
     		     		
     		function showList(page){     			
	     		replyService.getList(
	     			//  /{bno}/{page} => json 데이터를 가져와야 함		
	     			{bno:bno,page:page||1},function(dto,list){
	     				//console.log("read.jsp"+ dto);
	     				
	     				//가져올 댓글이 없는 경우
	     				if(dto==null||list==null||list.length==0){
	     					replyUL.html("");
	     					return;
	     				}
	     				//댓글이 있는 경우 - 10개 부분에 해당하는 댓글 보여주기
	     				var str="";
	     				for(var i=0,len=list.length||0;i<len;i++){
	     					str+="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
	     					str+="<div><div class='header'><strong class='primary-font'>["+list[i].rno+"] ";
	     					str+=list[i].replyer+"</strong>";
	     					str+="<small class='pull-right text-muted'>"+replyService.displayTime(list[i].regdate);
	     					str+="</small></div><p>"+list[i].replytext+"</p></div></li>";
	     				}
	     				replyUL.html(str);	
	     				
	     				//페이지 나누기 부분 추가
	     				showReplyPage(dto);
	     			}
	     		);//getList 종료
     		}
     		    		
     		
     		//addReplyBtn을 클릭하면 띄울 모달 부분
     		var modal=$("#myModal");
     		//모달창에 보이는 세개의 입력상자 가져오기
     		var modalInputReply = modal.find("input[name='replytext']");
     		var modalInputReplyer = modal.find("input[name='replyer']");
     		var modalInputDate = modal.find("input[name='replydate']");
     		//버튼 가져오기
     		var modalModBtn=$("#modalModBtn");
     		var modalRemoveBtn=$("#modalRemoveBtn");
     		var modalRegisterBtn=$("#modalRegisterBtn");
     		
     		
     		$("#addReplyBtn").click(function(){
     			//댓글 등록 버튼을 클릭하면 input 상자안 내용을 모두 지우고
     			modal.find("input").val("");
     			//date가 들어갈 input 태그 안보이게 함
     			modalInputDate.closest("div").hide();
     			//버튼들 중 register과 close 버튼만 보이게 함
     			modalModBtn.hide();
     			modalRemoveBtn.hide();
     			
     			modal.modal("show");
     		});
     		$("#modalRegisterBtn").click(function(){//댓글등록
     			var reply={
     				bno:bno,
     				replyer:modalInputReplyer.val(),
     				replytext:modalInputReply.val()
     			};
     			
     			replyService.add(reply,
	     			function(result){
	     				if(result==='success'){
	     					alert('삽입성공');
	     					modal.find("input").val("");
	     					modal.modal("hide");
	     					//댓글 갱신
	     					showList(1);
	     				}	
	     			});//add 종료
     		});//modalRegisterBtn종료
     		
     		$("#modalModBtn").click(function(){
     			var rno=modal.data("rno");
     			var replytext=modalInputReply.val();
     			
     			replyService.update({rno:rno,replytext:replytext},function(result){
     				//if(result==='success')
     				//	alert('수정 성공');
     				//모달창 닫기
     				modal.modal("hide");
     				//리스트 불러오기
     				//showList(1);
     				showList(pageNum);
     			});     		   		
     		});//modalModBtn종료
     		
     		$("#modalRemoveBtn").click(function(){
     			var rno=modal.data("rno");     			
     			replyService.remove(rno,function(result){
     			//if(result==='success')
     				//alert("삭제 성공");
     				modal.modal("hide");
     				//showList(1);
     				showList(pageNum);
     			});     			 		   		
     		});//modalRemovdBtn종료
     		
     		
     		$(".chat").on("click","li",function(){
     			//댓글 번호 가져오기
     			var rno=$(this).data("rno");
     			
     			replyService.get(rno,function(data){
         			//console.log(data);
     				modalInputReply.val(data.replytext);
     				modalInputReplyer.val(data.replyer).attr("readonly","readonly");
     				modalInputDate.val(replyService.displayTime(data.regdate)).attr("readonly","readonly");
     				//수정과 삭제를 위해서 rno 담아야 함
     				modal.data("rno",data.rno);
     				
     				//register버튼 안보이게 하기
     				modalRegisterBtn.hide();
     				modal.modal("show");
         		}); 
     		}); //chat 종료
     		
			//댓글 페이지 나누기 영역 가져오기            		
    		var replyPageFooter = $(".panel-footer");
    		
    		function showReplyPage(maker){            			    			
    			
    			var str="<ul class='pagination pull-right'>";
    			
    			if(maker.prev){
    				str+="<li class='page-item'><a class='page-link' href='"
    				+(maker.startPage-1)+"'>Previous</a></li>"
    			}
    			
    			for(var i=maker.startPage,len=maker.endPage;i<=len;i++){
    				var active = maker.cri.page == i ? "active" : "";
    				str+="<li class='page-item "+active+" '><a class='page-link' href='"
    				+i+"'>"+i+"</a></li>";
    			}            			
    			if(maker.next){
    				str+="<li class='page-item'><a class='page-link' href='"+
    				(maker.endPage+1)+"'>Next</a></li>";
    			}            			
    			str+="</ul></div>";
    			
    			replyPageFooter.html(str);
    		}//reply 페이지 처리
    		
    		
    		//댓글 리스트 페이지 클릭시 동작
    		var pageNum=1;
    		replyPageFooter.on("click","li a",function(e){
    			//이벤트 취소
    			e.preventDefault();
    			
    			pageNum=$(this).attr("href");
    			
    			showList(pageNum);
    		});
    		
    		//현재 글번호의 첨부물 가져오기
    		$.getJSON("/board/getAttachList",{bno:bno},function(arr){
    			console.log(arr);
    			var str="";
    			$(arr).each(function(i,attach){
    				if(attach.fileType){//image 파일이라면
    					var fileCallPath=encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
    				
						str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='";
						str += attach.fileName+"' data-type='"+attach.fileType+"'><div>";
						str += "<span>"+attach.fileName+"</span><br/>";
						str += "<img src='/display?fileName="+fileCallPath+"'></a>";
						str += "</div></li>";
    				}else{
    					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='";
						str += attach.fileName+"' data-type='"+attach.fileType+"'><div>";
						str += "<span>"+attach.fileName+"</span><br/>";
						str += "<a><img src='/resources/img/attach.png'></a></div></li>";								
    				}            			
    			});            			
    			$(".uploadResult ul").html(str);
    		});
     		$(".uploadResult").on("click","li",function(){
     			var liobj=$(this);
     			
     			var path=encodeURIComponent(liobj.data("path")+"/"+liobj.data("uuid")+"_"+liobj.data("filename"));
     			
     			if(liobj.data("type")){
     				showImage(path.replace(new RegExp(/\\/g),"/"));
     			}else{
     				location.href="/download?fileName="+path;
     			}
     		});//
     		$(".bigPictureWrapper").click(function(){
				//원본사진 닫기
				$(".bigPicture").animate({width:'0%',height:'0%'},1000);
				setTimeout(function(){
					$(".bigPictureWrapper").hide();
				},1000);
			});
     	});
     	function showImage(fileCallPath){
			//썸네일 이미지를 클릭하면 화면에 크게 보여주기
			$(".bigPictureWrapper").css("display","flex").show();
			
			$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>")
					.animate({width:'100%',height:'100%'},1000);
		}			
     </script>         
     <script>
     	$(function(){
     		var form=$("#operForm");
     		
     		$(".btn-default").click(function(){
     			//modify버튼을 클릭하면 operForm 보내기     			
     			form.submit();
     		});
     		$(".btn-info").click(function(){
     			//게시판 목록보기 이동
     			form.find("bno").remove(); //hidden bno 삭제
     			form.attr("action","/board/list");
     			form.attr("method","get");
     			form.submit();
     		});
     	});     
     </script>       
                     
<%@include file="../includes/footer.jsp" %>       