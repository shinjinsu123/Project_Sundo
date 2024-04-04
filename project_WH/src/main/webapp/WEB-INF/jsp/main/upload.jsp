<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>파일 업로드</title>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

</head>

<script type="text/javascript" charset="UTF-8">
$(document).ready(function(){  //
	
/////////////////////////////////// 파일 업로드 start
    $("#fileBtn").on("click", function() {
       let fileName = $('#file').val();
       alert("!111 " + fileName);
       if(fileName == ""){
          alert("파일을 선택해주세요.");
          return false;
       }
       let dotName = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
       if(dotName == 'txt'){
          alert("! " + fileName);
			
          swal.fire({
            title: "파일 업로드 중...",
            text: "잠시만 기다려주세요.",
            closeOnClickOutside: false,
            closeOnEsc: false,
            buttons: false
        	});
          
          $.ajax({
             url : '/fileUp2.do',
             type : 'POST',
             dataType: 'json',
             data : new FormData($('#form')[0]),
             cache : false,
             contentType : false,
             processData : false,
             enctype: 'multipart/form-data',
             // 추가한부분
             xhr: function(){
                 var xhr = $.ajaxSettings.xhr();
                 // Set the onprogress event handler
                 xhr.upload.onprogress = function(event){
                     var perc = Math.round((event.loaded / event.total) * 100);
                     // 파일 업로드 진행 상황을 SweetAlert로 업데이트
                      swal.update({
                            title: "파일 업로드 중...",
                            text: "진행 중: " + perc + "%"
                        });
                     
                     // 업로드가 완료되면 SweetAlert 닫기
                     if (perc >= 100) {
                         swal.close();
                     }
                 };
                 return xhr;
          },
          success : function(result) {
              // 파일 업로드 성공 시 SweetAlert로 성공 메시지 보여줌
              swal("성공!", "파일이 성공적으로 업로드되었습니다.", "success");
              console.log("SUCCESS : ", result);
          },
          error : function(Data) {
              // 파일 업로드 실패 시 SweetAlert로 에러 메시지 보여줌
              swal("에러!", "파일 업로드 중 에러가 발생했습니다.", "error");
              console.log("ERROR : ", Data);
          } 
       });

       }else{
          alert("확장자가 안 맞으면 멈추기");   
       }
    });
/////////////////////////////////// 파일 업로드 end
}); 
</script>
<body>
    	<div>
          	<form id="form" enctype="multipart/form-data">
				<input type="file" id="file" name="file" accept="txt">
			</form>
				<button type="button" id="fileBtn">파일 전송</button><hr>
        </div>

</body>
</html>