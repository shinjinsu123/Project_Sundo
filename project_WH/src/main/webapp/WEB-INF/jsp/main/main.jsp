<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<script src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" charset="UTF-8">
var map;
   $(document).ready(function(){ //

                  ////////////////////////////////////// vworld 맵생성하는 부분 start
                  map = new ol.Map(
                        { // OpenLayer의 맵 객체를 생성한다.
                           target : 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
                           layers : [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
                           new ol.layer.Tile(
                                 {
                                    source : new ol.source.OSM(
                                          {
                                             url : 'http://api.vworld.kr/req/wmts/1.0.0/5FC26C17-DD7E-3483-AD1C-D77561A51358/Base/{z}/{y}/{x}.png'
                                          // vworld의 지도를 가져온다.
                                          })
                                 }) ],
                           view : new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
                              center : ol.proj.fromLonLat([ 128.4,
                                    35.7 ]),
                              zoom : 8
                           })
                        });
                  ////////////////////////////////// vworld 맵생성하는 부분 end
				  
                  //////////////// "탄소지도" 레이어 적용 탭 start
                  $("#layorMap").click(function(e) {
                     e.preventDefault(); // 기본 동작 방지(화면 이동 방지)

                     $.ajax({
                         type : 'get',
                         url : '/layorMap.do',
                         dataType : 'html',
                         success : function(response) {
                             $("#views").html(response);
                         },
                         error : function(xhr, status, error) {
                             // 서버로의 요청이 실패하거나 오류인 경우에만 메시지를 표시
                             if(xhr.status === 404) {
                                 alert("페이지를 찾을 수 없습니다.");
                             } else if(xhr.status === 500) {
                                 alert("서버 오류가 발생했습니다.");
                             } else {
                                 // 그 외의 오류는 무시
                                 console.error("AJAX 오류 발생: " + status + ", " + error);
                             }
                         }
                     });
                  });
                  //////////////// 레이어 적용 탭 end
                  
                  //////////////// "데이터 삽입" 파일업로드 탭 start
                  $("#upLoad").click(function(e) {
                     e.preventDefault(); // 기본 동작 방지(화면 이동 방지)

                     $.ajax({
                        type : 'get',
                        url : '/upLoad.do',
                        dataType : 'html',
                        success : function(response) {
                           $("#views").html(response);
                        },
                        error : function(error) {
                           alert("업로드 페이지 불러오기 오류");
                        }
                     });
                  });
                  ////////////////파일업로드 탭 end
                  
                  //////////////// "통계" 차트 적용 탭 start
                  $("#chart").click(function(e) {
                     e.preventDefault(); // 기본 동작 방지(화면 이동 방지)
					 alert("통계로 넘어간다");
					 google.charts.load('current', {'packages':['corechart']});
					 google.charts.setOnLoadCallback(function() {
                     $.ajax({
                        type : 'get',
                        url : '/chart.do',
                        dataType : 'html',
                        success : function(response) {
                           $("#views").html(response);
                        },
                        error : function(error) {
                           alert("업로드 페이지 불러오기 오류");
                        }
                     });
                  });
                  //////////////// 차트 적용 탭 end
               });
});
</script>

<style>
/* 전체 스타일 */
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
}

/* 헤더 스타일 */
.Topheader {
    background-color: #343a40;
    color: #fff;
    text-align: center;
    padding: 10px;
}

/* 메인 컨테이너 */
.container-fluid {
    display: flex;
    height: 100vh;
}

/* 좌측 패널 스타일 */
.side-panel {
    flex: 0 0 25%;
    background-color: #f8f9fa;
    border-right: 1px solid #dee2e6;
}

/* 메뉴 스타일 */
.nav-link {
    color: #000;
    padding: 10px 0;
    text-align: center;
    border-bottom: 1px solid #dee2e6;
    transition: all 0.3s ease;
}

.nav-link:hover {
    background-color: #e9ecef;
    color: #007bff;
}

.nav-link.active {
    background-color: #007bff;
    color: #fff;
}

/* 맵 스타일 */
#map {
    flex: 1;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    background-color: #f1f1f1;
}
</style>

</head>
<body>
<div class="Topheader">
	<h3>Header</h3>
</div>
   <div class="container-fluid d-flex flex-column m-3" style="height: 100%;">
       <div class="row flex-grow-1">
           <div class="col-md-4 d-flex flex-column">
               <div class="row">
                   <div class="col-md-12 border border-dark">
                   <div class="text-center p-1 bold fs-4" style="height: 50px; font-size: 2rem;">탄소 공간지도 시스템</div>
               </div>
            </div>
            <div class="row">
               <div class="col-md-3 border border-dark border-end-0 border-top-0">
                  <div class="nav">
                     <!-- 탄소지도 -->
                     <div class="nav-item justify-content-center">
                        <a id="layorMap" class="nav-link">탄소지도</a><br>
                     </div>
                     <!-- 데이터 삽입 -->
                     <div class="nav-item justify-content-center">
                        <a id="upLoad" class="nav-link">데이터 삽입</a><br>
                     </div>
                     <!-- 통계 -->
                     <div class="nav-item justify-content-center">
                        <a id="chart" class="nav-link">통계</a><br>
                     </div>
                  </div>
               </div>
               		 <!-- map.jsp / static.jsp / upload.jsp 불러오는 곳 -->
                     <div id="views"   class="col-md-9 p-3 border border-dark border-top-0" style="height: 915.5px;">메뉴를 선택해주세요</div>
	         </div>
	         </div>
         		<div id="map" style="height: 100vh; width: 65%; margin-left: auto;"></div>
         		
         	   <!-- 팝업을 나타내는 HTML 요소 -->
			   <!-- <div id="popup" class="popup">
			     <a href="#" id="popup-closer" class="popup-closer">&times;</a>
			     <div id="popup-content"></div>
			   </div> -->
		</div>
   </div>

</body>
</html>