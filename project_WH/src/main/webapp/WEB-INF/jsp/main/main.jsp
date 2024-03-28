<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>브이월드 오픈API</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"  href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">

<!-- SweetAlert -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/sweetalert2.min.css">
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

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
          //alert("! " + fileName);
			
          swal({
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
                     swal({
                         title: "파일 업로드 중...",
                         text: "진행 중: " + perc + "%",
                         closeOnClickOutside: false,
                         closeOnEsc: false,
                         buttons: false
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
    
 // swal이나 alert창이 아닌 메인 화면에서 호출해줄 함수인데, 사용하지 않는다.
    function progressBar(per){
        if(per > 55){
            $(".progressPer").css("color", "#000");
        }
        per = per.toFixed(1);
        $(".progressPer").text(per+" %");
        $(".progressNow").css("width", "calc(" + per + "% - 20px)");
    }
/////////////////////////////////// 파일 업로드 end
	
////////////////////////////////////// vworld 맵생성하는 부분 start
    let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
        target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
        layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
          new ol.layer.Tile({
            source: new ol.source.OSM({
           url: 'http://api.vworld.kr/req/wmts/1.0.0/5FC26C17-DD7E-3483-AD1C-D77561A51358/Base/{z}/{y}/{x}.png' 
                    // vworld의 지도를 가져온다.
            })
          }) ],
        view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
          center: ol.proj.fromLonLat([128.4, 35.7]),
          zoom: 7
        })
    });
////////////////////////////////// vworld 맵생성하는 부분 end

	var sdLayer;
	var sggLayer;
	var bjdLayer;
	   
	// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< sd
	   $('#sidoSelect').change(function(){
    		var selectSiValue = $(this).val().split(',')[0];
    		var selectSiText = $(this).find('option:selected').text();
    		alert(selectSiValue);
    		
    	    // loc 값이 있을 경우에만 CQL 필터 생성
    	    if (selectSiValue && selectSiValue.length > 0) {
    	        var cqlFilterSd = "sd_cd='" + selectSiValue + "'";
    	    } else {
    	        var cqlFilterSd = ""; // loc 값이 없는 경우, 빈 문자열로 설정
    	    }
    	    
    	    if(sdLayer || sggLayer || bjdLayer) {
                map.removeLayer(sdLayer);
                map.removeLayer(sggLayer);
                map.removeLayer(bjdLayer);
            }
    	    
    	    /////////////////---------------------///////////////// 좌표 이동 및 줌 기능 start
    	    ///////////////////// 선택된 시/도의 geom값을 가져와서 지도에 표시
            var datas = $(this).val(); // value 값 가져오기
            var values = datas.split(",");
            var sidocd = values[0]; // sido 코드
            
            var geom = values[1]; // x 좌표
            //alert("sido 좌표값" + sido);
            var regex = /POINT\(([-+]?\d+\.\d+) ([-+]?\d+\.\d+)\)/;
	        var matches = regex.exec(geom);
	        var xCoordinate, yCoordinate;
	     
	        if (matches) {
	            xCoordinate = parseFloat(matches[1]); // x 좌표
	            yCoordinate = parseFloat(matches[2]); // y 좌표
	        } else {
	          alert("GEOM값 가져오기 실패!");
	        }

            var sidoCenter = ol.proj.fromLonLat([xCoordinate, yCoordinate]);
            map.getView().setCenter(sidoCenter); // 중심좌표 기준으로 보기
            map.getView().setZoom(10); // 중심좌표 기준으로 줌 설정
			/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 end
            
    	  // 레이어 추가하기
  	      var sdLayer = new ol.layer.Tile({
  	         source : new ol.source.TileWMS({
  	            url : 'http://localhost/geoserver/wms?service=WMS', // 1. 레이어 URL
  	            params : {
  	               'VERSION' : '1.1.0', // 2. 버전
  	               'LAYERS' : 'cite:tl_sd', // 3. 작업공간:레이어 명
  	               'CQL_FILTER': cqlFilterSd,  
  	               'BBOX' : '1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997',
  	               'SRS' : 'EPSG:3857', // SRID
  	               'FORMAT' : 'image/png' // 포맷
  	            },
  	            serverType : 'geoserver',
  	         })
  	      });
    	      
    	  map.addLayer(sdLayer); // 맵 객체에 레이어를 추가함
    		
	 	 // AJAX 요청 보내기
	     $.ajax({
		   type: 'POST', // 또는 "GET", 요청 방식 선택
	          url: '/sidoSelect.do', // 컨트롤러의 URL 입력
	          data: { 'sido': selectSiValue }, // 선택된 값 전송
	          dataType: 'json',
	        success: function(response) {
	             // 성공 시 수행할 작업
                 
	             var sggSelect = $("#sggSelect");
	             sggSelect.html("<option>--시/군/구를 선택하세요--</option>");
			     alert(response);
			     alert(response.length);
	             //var lists = JSON.parse(response);
	             for(var i = 0; i < response.length; i++) {
	                 var item = response[i];
	                 sggSelect.append("<option value='" + item.sgg_cd + "," + item.geom + "'>" + item.sgg_nm + "</option>");
	             }
	       	   },
	       	   error: function(xhr, status, error) {
	                 // 에러 발생 시 수행할 작업
	             	   alert('ajax 실패');
	                 // console.error("AJAX 요청 실패:", error);
	             }
	     	});
	     });
	   
		// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< sgg
	   
	   $('#sggSelect').change(function(){
		   var selectSggValue = $(this).val().split(',')[0];
	   		//alert(selectSggValue);
	   		
	   	    // loc 값이 있을 경우에만 CQL 필터 생성
   	        var cqlFilterSgg = "sgg_cd='" + selectSggValue + "'";
	   	    
   	     if(sggLayer || bjdLayer) {
             map.removeLayer(sggLayer);
             map.removeLayer(bjdLayer);
         }
   	     
		/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 start
 	    ///////////////////// 선택된 시/군/구의 geom값을 가져와서 지도에 표시
         var datas = $(this).val(); // value 값 가져오기
         var values = datas.split(",");
         var sidocd = values[0]; // sido 코드
         
         var geom = values[1]; // x 좌표
         //alert("sido 좌표값" + sido); 얜 가져옴
         var regex = /POINT\(([-+]?\d+\.\d+) ([-+]?\d+\.\d+)\)/;
	        var matches = regex.exec(geom);
	        var xCoordinate, yCoordinate;
	     	alert(matches);
	        
	        if (matches) {
	            xCoordinate = parseFloat(matches[1]); // x 좌표
	            yCoordinate = parseFloat(matches[2]); // y 좌표
	            alert("@@@@@@@@@@@@@@@@@@@@");
	        } else {
	          alert("GEOM값 가져오기 실패!");
	        }
	        alert("@@@@@@@@@@@@@@@@@@@@11111");
         var sidoCenter = ol.proj.fromLonLat([xCoordinate, yCoordinate]);
         map.getView().setCenter(sidoCenter); // 중심좌표 기준으로 보기
         map.getView().setZoom(10); // 중심좌표 기준으로 줌 설정
		/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 end

   	 // 레이어 추가하기
   	 alert(cqlFilterSgg);
   	      var sggLayer = new ol.layer.Tile({
   	         source : new ol.source.TileWMS({
   	            url : 'http://localhost/geoserver/wms?service=WMS', // 1. 레이어 URL
   	            params : {
   	               'VERSION' : '1.1.0', // 2. 버전
   	               'LAYERS' : 'cite:tl_sgg', // 3. 작업공간:레이어 명
   	               'CQL_FILTER': cqlFilterSgg,
   	               'BBOX' : '1.386872E7, 3906626.5, 1.4428071E7, 4670269.5',
   	               'SRS' : 'EPSG:3857', // SRID
   	               'FORMAT' : 'image/png' // 포맷
   	            },
   	            serverType : 'geoserver',
   	         })
   	      });
   	      map.addLayer(sggLayer); // 맵 객체에 레이어를 추가함
   	   alert(selectSggValue);
   	      //alert("돼냐?");
   		// AJAX 요청 보내기
   		$.ajax({
			   type: 'POST', // 또는 "GET", 요청 방식 선택
	           url: '/bjgSelect.do', // 컨트롤러의 URL 입력
	           data: { 'sgg': selectSggValue },  //선택된 값 전송
	           dataType: 'json',
	         success: function(response) {
	              // 성공 시 수행할 작업
	              var bjdSelect = $("#bjdSelect");
	              bjdSelect.html("<option>--동/읍/면을 선택하세요--</option>");
				  alert(response);
				  alert(response.length);
	              for(var i = 0; i < response.length; i++) {
	                  var item = response[i];
	                  bjdSelect.append("<option value='" + item.bjd_cd + "," + item.geom + "'>" + item.bjd_nm + "</option>");
	              	}
	        	   },
	        	   error: function(xhr, status, error) {
	                  // 에러 발생 시 수행할 작업
	              	   alert('ajax 실패');
	                  // console.error("AJAX 요청 실패:", error);
	              }
		     	});
   		alert("@@@@@@@@@@@@@@@@@@@@3333");
		     }); // changefunction end
   			// AJAX끝
	   
	   // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<bjd
	   $('#bjdSelect').change(function(){
		   var selectBjdValue = $(this).val().split(',')[0];
	   		alert(selectBjdValue);
	   		
	   	    // loc 값이 있을 경우에만 CQL 필터 생성
	   	    if (selectBjdValue && selectBjdValue.length > 0) {
	   	        var cqlFilterBjd = "bjd_cd='" + selectBjdValue + "'";
	   	    } else {
	   	        var cqlFilterBjd = ""; // loc 값이 없는 경우, 빈 문자열로 설정
	   	    }
	   	    alert(cqlFilterBjd);
		   	    
		   	 if(bjdLayer) {
	             map.removeLayer(bjdLayer);
	         }
		   	 
			/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 start
	 	    ///////////////////// 선택된 시/군/구의 geom값을 가져와서 지도에 표시
	         var datas = $(this).val(); // value 값 가져오기
	         var values = datas.split(",");
	         var sidocd = values[0]; // sido 코드
	         
	         var geom = values[1]; // x 좌표
	         //alert("sido 좌표값" + sido); 얜 가져옴
	         var regex = /POINT\(([-+]?\d+\.\d+) ([-+]?\d+\.\d+)\)/;
		        var matches = regex.exec(geom);
		        var xCoordinate, yCoordinate;
		     
		        if (matches) {
		            xCoordinate = parseFloat(matches[1]); // x 좌표
		            yCoordinate = parseFloat(matches[2]); // y 좌표
		        } else {
		          alert("GEOM값 가져오기 실패!");
		        }

	         var sidoCenter = ol.proj.fromLonLat([xCoordinate, yCoordinate]);
	         map.getView().setCenter(sidoCenter); // 중심좌표 기준으로 보기
	         map.getView().setZoom(10); // 중심좌표 기준으로 줌 설정
			/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 end

	   	 // 레이어 추가하기
	   	 alert(cqlFilterBjd);
	   	      var bjdLayer = new ol.layer.Tile({
	   	         source : new ol.source.TileWMS({
	   	            url : 'http://localhost/geoserver/wms?service=WMS', // 1. 레이어 URL
	   	            params : {
	   	               'VERSION' : '1.1.0', // 2. 버전
	   	               'LAYERS' : 'cite:tl_bjd', // 3. 작업공간:레이어 명
	   	               'CQL_FILTER': cqlFilterBjd,  
	   	               'BBOX' : '1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5',
	   	               'SRS' : 'EPSG:3857', // SRID
	   	               'FORMAT' : 'image/png' // 포맷
	   	            },
	   	            serverType : 'geoserver',
	   	         })
	   	      });
	   	      
	   	      map.addLayer(bjdLayer); // 맵 객체에 레이어를 추가함
	   		
	   });
	   	      
	   /* function updateAddress(sido, sgg, bjd) {
           // 각 select 요소에서 선택된 값 가져오기
             var sidoValue = sido || $('#sidoSelect').find('option:selected').text() || '';
             var sggValue = sgg || $('#sggSelect').find('option:selected').text() || ''; // 선택된 값이 없으면 빈 문자열 나열
             var bjdValue = bjd || $('#bjdSelect').find('option:selected').text() || '';

             // 주소 업데이트
             $('#address').html('<h1>' + sidoValue + ' ' + sggValue + ' ' + bjdValue + '</h1>');
        } */
	  
				$("#writeBtn").click(function(){
				    $("#write").modal('show');
				});
}); //

</script>

<style>


/* .mainmain {
    display: flex; /* Flexbox 사용 */
    flex-direction: column; /* 세로 방향으로 요소들을 배치 */
    height: 100%; /* 화면 전체 높이를 차지하도록 설정 */
} */

.Topheader{
	display: flex;
    justify-content: center; /* 수평 가운데 정렬 */
    align-items: center; /* 수직 가운데 정렬 */
    height: 100px; /* 원하는 높이 설정 */
}

.mapPart{
	width: 100%;
}

.map {
	height: 600px;
	width: 100%;
}
   
.olControlAttribution {
    right: 20px;
}

.olControlLayerSwitcher {
    right: 20px;
    top: 20px;
}

.container {
	display: flex;
}

*{margin:0;padding:0}
	.progressContainer{position:relative;width: 450px;padding:20px 10px;border: 1px solid #eee;margin-top: 15px;background:#000;height:20px;}
	.progress{position:absolute;width: calc(100% - 20px);height: 20px;}
	.progressTotal{background: #5D5D5D;border-radius: 10px;}
	.progressNow{width: calc(0% - 20px);background: #FFF;border-radius: 10px;}
	.progressPer{background: transparent; text-align:center;color:#A6A6A6;}
</style>

</head>
<body>
<div class="mainmain">
   <div class="Topheader">
         <h3>Header</h3>
   </div>
   
   
   <div class="mapPart">  <!-- 중간3개 nav랑 지도 -->
      <div style="width: 20%;">
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
								<button type="button" id="fileBtn">파일 전송</button><hr>
		                	
		                </div>
		                
		                <!-- 로딩 바 & snack bar & bootstrap 토스트  -->
		                <!-- 구현하지 않음 -> swal창으로 대체 -->
		                <!-- <div style="width: 100%;padding: 25px;">
		                	<div class="progressContainer">
								<div class="progress progressTotal"></div>
								<div class="progress progressNow"></div>
								<div class="progress progressPer">0 %</div>
							</div>
		                </div> -->
		                
			</div>
      </div>
      
      <div id="map" style="height: 80vh; width:80%; margin-left: auto;">
      </div>
      
   </div>
   
   <div class="bottom">
	   <div>
	         <button type="button" onclick="javascript:deleteLayerByName('VHYBRID');" name="rpg_1">레이어삭제하기</button>
	   </div>
	   	   
	   <div>
		 	<select id="sidoSelect" name="loc">
		 		<option>--시/도를 선택하세요--</option>
				<c:forEach items="${list }" var="row">
					<option value="${row.sd_cd}, ${row.geom }" <c:if test="${row.sd_nm eq loc}">selected="selected"</c:if>>${row.sd_nm}</option>
				</c:forEach>
		 	</select>
	   </div>
	   
	   <div>
		 	<select id="sggSelect" name="sggSelect">
				<option>--시/군/구를 선택하세요--</option>
		 	</select>
	   </div>
	   
	   <div>
	   		<select id="bjdSelect" name="bjdSelect">
	   			<option>--동/읍/면을 선택하세요--</option>
	   		</select>
	   </div>
	   
	   <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#write">글쓰기</button>
	   
	   <!-- 부트스트랩 진행바 -->
	   <div class="progress">
		  <div class="progress progressPer progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 30%"></div>
	   </div>
	   	   
		<!-- 글쓰기 모달 만들기 -->
	    <div class="modal" id="write">
	    	<h1>모달입니다.</h1>
	    </div>
	</div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>