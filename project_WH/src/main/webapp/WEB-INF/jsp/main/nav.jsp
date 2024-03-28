<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<script type="text/javascript" charset="UTF-8">
$(document).ready(function() {		
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
				$.ajax({
					url : '/fileUp2.do',
					type : 'POST',
					dataType: 'json',
					data : new FormData($('#form')[0]),
					cache : false,
					contentType : false,
					processData : false,
					enctype: 'multipart/form-data',
					success : function(result) {
						alert(result);
					},
					error : function(Data) {
					}				
				});
	
			}else{
				alert("확장자가 안 맞으면 멈추기");	
			}
			
			
		});

	});
</script>

<nav class="navbar navbar-gray bg-dark" id="mainNav">
	<div class="d-flex align-items-center" style="text-align: center;">
		<div>
			<h3>탄소공간지도시스템</h3>
		</div>
		    <div class="container" id="menu" style="height: 100%; background-color: #f0f0f0; float: left;">
                <!-- 탄소지도 -->
                <div style="display: flex; align-items: center;">
                    <button type="button" onclick="showCarbonMap()">탄소지도</button>
                </div>
                <!-- 데이터 삽입 -->
                <div style="display: flex; align-items: center;">
                    <button type="button" onclick="insertData()">데이터 삽입</button>
                </div>
                <!-- 통계 -->
                <div style="display: flex; align-items: center;">
                    <button type="button" onclick="showChart()">통계</button>
                </div>
            </div>
            
            <div>
            	<form id="form" enctype="multipart/form-data">
					<input type="file" id="file" name="file" accept="txt">
				</form>
					<button type="button" id="fileBtn">파일 전송</button>
            </div>
            <!-- <tbody>
            <tr>
                 <th class="active" style="text-align:right"><label class="control-label" for="">파일 업로드</label></th>
                 <td><input type="file" name="file" id="file" accept=".txt"/></td>
            </tr>
            </tbody> -->
	</div>
</nav>