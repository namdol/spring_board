<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="/resources/css/upload.css"/>
<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Register</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>            
            <div class="row">
                <div class="col-lg-12">
                	<div class="panel panel-default">
                        <div class="panel-heading">
                           Board Register Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="" method="post" role="form">
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content"></textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer">                				
                				</div>  
                				<button type="submit" class="btn btn-default">Submit</button>              			
                				<button type="reset" class="btn btn-default">reset</button>              			
                			</form>
                		</div>
                	</div>
                </div>
            </div> 
           <!-- 파일 등록 부분 --> 
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">File Attach</div>
            			<div class="panel-body">
            				<div class="form-group uploadDiv">
            					<input type="file" name="uploadFile" multiple>
            				</div>
            				<div class='uploadResult'>
								<ul>
						
								</ul>
							</div>
            			</div><!-- end uploadResult -->
            		</div><!-- end panel-default -->
            	</div>
            </div> 
  <script>
  	//submit 버튼 이벤트 막기
  	$(function(){
  		//register 폼 가져오기
  		var formObj=$("form[role='form']");  		
  		
  		$("button[type='submit']").click(function(e){
  			e.preventDefault();  //이벤트 막기
  			
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
  			
  			formObj.append(str).submit();
  		});
  		
  		
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
		
		// x버튼 클릭시 첨부파일 삭제(목록,폴더)
		$(".uploadResult").on("click","button",function(){
			var targetFile = $(this).data("file");
			var type=$(this).data("type");
			var targetLi=$(this).closest("li");
			
			$.ajax({
				url:'/deleteFile',
				dataType:'text',
				data:{
					fileName:targetFile,
					type:type
				},
				type:'post',
				success:function(result){
					console.log(result);
					targetLi.remove();
				}
			});					
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
  	});
  
  </script>          
                      
<%@include file="../includes/footer.jsp" %> 




      