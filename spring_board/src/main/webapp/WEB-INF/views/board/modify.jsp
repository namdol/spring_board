<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Modify</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>            
            <div class="row">
                <div class="col-lg-12">
                	<div class="panel panel-default">
                        <div class="panel-heading">
                           Board Modify Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="" method="post" role="form">
                				<div class="form-group">
                					<label>Bno</label>
                					<input class="form-control" name="bno" readonly="readonly" value="${vo.bno}">                				
                				</div> 
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title" value="${vo.title}">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content">${vo.content}</textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer" readonly="readonly" value="${vo.writer}">                				
                				</div>  
                				<button type="button" data-oper='modify' class="btn btn-default">Modify</button>              			
                				<button type="button" data-oper='remove' class="btn btn-danger">Remove</button>              			
                				<button type="button" data-oper='list' class="btn btn-info">List</button>              			
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
            					<div class="form-group uploadDiv">
            						<input type="file" name="uploadFile" multiple>
            					</div>
            					<div class="uploadResult">
            						<ul></ul>
            					</div>
            				</div>
            		</div>
            	</div>            
            </div>
            
       <!-- list버튼, remove버튼에서 사용할 폼 -->     
       <form name="form1" method="post">
       	  <input type="hidden" value="${vo.bno}" name="bno">
       	  <input type="hidden" value="${cri.page}" name="page">
          <input type="hidden" value="${cri.perPageNum}" name="perPageNum">
       </form>
       <script>
     	//첨부물을 가져올 글 번호 지정
		var bno=${vo.bno};
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
		}); //
		$("input[type='file']").change(function(){
			//Upload 버튼을 클릭하면 사용자가 선택한 파일들을
			//Ajax 기술을 사용하여 서버에 업로드 시키기
			console.log("업로드 호출");
			//form안에 들어있는 데이터 담을 변수 선언
			var formData=new FormData();
			
			//현재 첨부된 파일명들 배열로 가져오기
			var inputFile=$("input[name='uploadFile']");
			var files = inputFile[0].files;	
			console.log(files);
			//사용자가 첨부한 파일들 중에서 확장자 체크와
			//파일 사이즈 체크
			for(var i=0;i<files.length;i++){
				if(!checkExtension(files[i].name,files[i].size)){
					return false;
				}
				formData.append("uploadFile",files[i]);
			}
			
			//ajax 사용하여 서버로 데이터 보내기
			$.ajax({
				url : '/uploadAjax',
				data : formData,
				processData : false,
				contentType : false,
				type : 'post',
				dataType : 'json',
				success:function(result){
					console.log(result);
					showUploadedResult(result);
					
				}
			});
		});//change 종료
		
  		function showUploadedResult(uploadResultArr){
			//첨부된 파일 보여주기
			var str="";
			var uploadResult=$(".uploadResult ul");
			
			$(uploadResultArr).each(function(i,obj){
				if(obj.fileType){//image파일인경우
					var fileCallPath=encodeURIComponent(obj.uploadPath+"/s_"
							+obj.uuid+"_"+obj.fileName);
					//BoardAttachVO에 담긴 데이터들을 가져오기							
					str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
					str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
					str+="<div><span>"+obj.fileName+"</span>";
					str+="<button type='button' data-file='"+fileCallPath+"'";
					str+=" data-type='image' class='btn btn-warning btn-circle'>";
					str+="<i class='fa fa-times'></i></button><br>"					
					str+="<img src='/display?fileName="+fileCallPath+"'>";	
					str+="</div></li>";
						
				}else{//image 파일이 아닌 경우
					var fileCallPath=encodeURIComponent(obj.uploadPath+"/"
							+obj.uuid+"_"+obj.fileName);
					str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
					str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
					str+="<div><span>"+obj.fileName+"</span>";
					str+="<button type='button' data-file='"+fileCallPath+"'";
					str+=" data-type='file' class='btn btn-warning btn-circle'>";
					str+="<i class='fa fa-times'></i></button><br>"
					str+="<img src='/resources/img/attach.png'>";				
					str+="</div></li>";
				}//else 종료
			});//each 종료
			console.log(str);
			uploadResult.append(str);					
		}//showUploadedResult 종료
		
		// x버튼 클릭시 첨부파일 삭제(목록에서만 삭제)
		$(".uploadResult").on("click","button",function(){
			if(confirm("파일을 삭제하시겠습니까?")){
				var targetLi=$(this).closest("li");
				targetLi.remove();
			}
							
		});//uploadResult 종료
		
		
  		function checkExtension(fileName,fileSize){
			//자바스크립트 정규식 표현을 사용하여 
			//파일 업로드가 가능한 파일인지 확인
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5242880; //5MB
			if(fileSize>maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			return true;
		}//	checkExtension 종료
 
       </script>       
       <script>
       	$(function(){
       		//폼 가져오기
       		var form=$("form[name='form1']");
       		
       		//각각의 버튼이 클릭되면 action만 다르게 지정하기
       		$("button").click(function(){
       			//button의 oper 값 가져오기
       			var oper=$(this).data("oper");
       			
       			if(oper==='remove'){
       				form.attr("action","/board/remove");
       			}else if(oper==='list'){
       				form.attr("action","/board/list");
       				form.attr("method","get");
       			}else if(oper==='modify'){
       				//수정 폼 그대로 보내기
       				//cri객체 값을 hidden으로 보내지 않아도 됨
       				form=$("form[role='form']");
       				//수정된 첨부파일 목록 보내기
       				//form안의 내용과 첨부파일 내역을 같이 보내야 함
		  			var str="";
		  			$(".uploadResult ul li").each(function(i,obj){
		  				var data=$(obj);
		  				
		  				str+="<input type='hidden' name='attachList["+i+"].fileName'";
		  				str+=" value='"+data.data('filename')+"'>";
		  				str+="<input type='hidden' name='attachList["+i+"].uuid'";
		  				str+=" value='"+data.data('uuid')+"'>";
		  				str+="<input type='hidden' name='attachList["+i+"].uploadPath'";
		  				str+=" value='"+data.data('path')+"'>";
		  				str+="<input type='hidden' name='attachList["+i+"].fileType'";
		  				str+=" value='"+data.data('type')+"'>";
		  			});
		  			
		  			form.append(str).submit();
       				
       			}
       			form.submit();
       		});
       	});
       
       </script>           
<%@include file="../includes/footer.jsp" %> 







      