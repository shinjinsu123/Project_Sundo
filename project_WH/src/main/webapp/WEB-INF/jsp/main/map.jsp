<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>브이월드 오픈API</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">

<script type="text/javascript" charset="UTF-8">
$(document).ready(function(){  //
	
	/////////////////////////////////////////////////////////////////////////////
	///////////////////             전역변수 설정           ////////////////////
	///////////////////////////////////////////////////////////////////////////
	
	var sdLayer;
	var sggLayer;
	var bjdLayer;
	var sggmvLayer;
	var bjdmvLayer;
	var sggSelect;
	var bjdSelect;
	let cqlFilterSd;
	let cqlFilterSgg;
	let cqlFilterBjd;
	let cqlFilterSGGMV;
	let cqlFilterBJDMV;
	let sidocd;
	let sggcd;
	let bjdcd;
	
	let	selectSggValue;
	let selectBjdValue;
	
	//범례 이미지 테이블
	var legendContainer;
	var legendUrl;
	var legendImg;
	
	/////////////////////////////////////////////////////////////////////////////
    ///////////////////             버튼 클릭 시             ///////////////////
    ///////////////////////////////////////////////////////////////////////////
	
    $("#searchBtn").click(function() {
	
        if (sidocd) {
            if(!sggcd && !bjdcd){
            	map.removeLayer(sggmvLayer); // 시를 계속 바꿀때 기존거 삭제하기
            	//map.removeLayer(sdLayer); // 시를 계속 바꿀때 기존거 삭제하기
                //addSggMVLayer();
            	addSidoLayer();
            }else if(sggcd && !bjdcd) {
            	map.removeLayer(sggLayer);
            	map.removeLayer(bjdLayer);
            	map.removeLayer(bjdmvLayer); // 구를 계속 바꿀때 기존거 삭제하기
            	addSidoLayer();
                addSggLayer();
                addBjdMVLayer();
            }else if(sggcd && bjdcd) {
           		map.removeLayer(sggLayer);
       		    map.removeLayer(sggmvLayer);
       		    map.removeLayer(bjdmvLayer);
                addBjdLayer();
            }
         }
    });
	
	/////////////////////////////////////////////////////////////////////////////
    ///////////////////             리셋 버튼 시             ///////////////////
    ///////////////////////////////////////////////////////////////////////////
	
    $("#resetBtn").click(function() {
    	location.reload();
    	
    });
	
	
    
    /////////////////////////////////////////////////////////////////////////////
    ///////////////             레 이 어 함 수 호 출             ///////////////
    ///////////////////////////////////////////////////////////////////////////
    
    function addSidoLayer() {
       
	   	// 레이어 추가하기
	      sdLayer = new ol.layer.Tile({
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
		map.addLayer(sdLayer);
    }
    function addSggMVLayer() {
    	
	  	   // 레이어 추가하기
		   //alert(cqlFilterSGGMV);
		   	sggmvLayer = new ol.layer.Tile({
		   	         source : new ol.source.TileWMS({
		   	            url : 'http://localhost/geoserver/wms?service=WMS', // 1. 레이어 URL
		   	            params : {
		   	               'VERSION' : '1.1.0', // 2. 버전
		   	               'LAYERS' : 'cite:sggmv', // 3. 작업공간:레이어 명
		   	               'CQL_FILTER': cqlFilterSGGMV,
		   	               'BBOX' : '1.386872E7, 3906626.5, 1.4428071E7, 4670269.5',
		   	               'SRS' : 'EPSG:3857', // SRID
		   	               'FORMAT' : 'image/png' // 포맷
		   	            },
		   	            serverType : 'geoserver',
		   	         })
		   	     });
		   	     map.addLayer(sggmvLayer); // 맵 객체에 레이어를 추가함
		   	     
				/////////////////////////////////////////////////////////////////////////////
		   	    /////////////////             범례 테이블 적용             /////////////////
		   	    ///////////////////////////////////////////////////////////////////////////
		   	    
		   	    // 범례 이미지 <div> 생성
				legendContainer = document.createElement('div');
				legendContainer.className = 'legend-container';
				
				// 맵에 범례 테이블을 추가.
				map.getTargetElement().appendChild(legendContainer);
				
				// 범례 테이블에 들어갈 정보 받아올 URL (정보)
				legendUrl = 'http://localhost/geoserver/cite/wms?' +
				    'service=WMS' +
				    '&VERSION=1.0.0' +
				    '&REQUEST=GetLegendGraphic' +
				    '&LAYER=cite:sggmv' +
				    '&FORMAT=image/png' +
				    '&WIDTH=80' +
				    '&HEIGHT=20';
				
				// 범례 이미지를 추가할 HTML 생성.
				legendImg = document.createElement('img');
				legendImg.src = legendUrl;
				
				// 범례 이미지를 범례 컨테이너에 추가.
				legendContainer.appendChild(legendImg);
				
				/////////////////////////////////////////////////////////////////////////////
				/////////////////////             팝 업 창            //////////////////////
				///////////////////////////////////////////////////////////////////////////
				
				//팝업 오버레이 생성
				var overlaysgg = new ol.Overlay({
				element: document.getElementById('popup'), // 팝업의 HTML 요소
				positioning: 'bottom-center' // 팝업을 마커 아래 중앙에 위치시킴
				//offset: [0, -20], // 팝업을 마커 아래로 조정
				//autoPan: true // 팝업이 지도 영역을 벗어날 경우 자동으로 팝업 위치를 조정하여 보여줌
				});
				map.addOverlay(overlaysgg);
				
				//팝업 닫기 버튼 요소 가져오기
				var popupCloser = document.getElementById('popup-closer');
				
				// 팝업 닫기 버튼에 이벤트 리스너 추가
				popupCloser.onclick = function() {
					overlaysgg.setPosition(undefined); // 팝업을 지도에서 제거
				  return false; // 이벤트 전파 방지
				};
				
				//클릭 이벤트 리스너 설정
				map.on('singleclick', function(evt) {

				// 클릭한 지점의 좌표를 가져옴
				var coordinate = evt.coordinate;
				
				  // 해당 좌표에서의 지리적 정보를 가져오는 것을 서버에 요청
				  var featureRequest = new ol.format.WFS().writeGetFeature({
					    srsName: 'EPSG:3857',
					    featureNS: 'http://localhost/geoserver/cite',
					    featurePrefix: 'cite',
					    featureTypes: ['sggmv'],
					    outputFormat: 'application/json',
					    geometryName: 'geom',
					    filter: new ol.format.filter.Intersects('geom', new ol.geom.Point(coordinate))
					});
				
				// 서버에 요청 보내기
				fetch('http://localhost/geoserver/cite/wms', {
				method: 'POST',
				body: new XMLSerializer().serializeToString(featureRequest)
				})
				.then(function(response) {
				return response.json();
				})
				.then(function(json) {
				// 가져온 정보에서 단계 구분 값을 추출하여 팝업에 표시
				if (json.features.length > 0) {
				  var properties = json.features[0].properties;
				  var sgg_pu = properties['usage']; // 예시: 구분 값의 키가 'sgg_cd'라 가정
				  var sgg_cd = properties['adm_sect_c']; 
				  var sgg_nm = properties['sgg_nm'];
				  
				  // 팝업 내용을 구성
				  var popupContent;
				    popupContent = 
				       '<p>' + sgg_nm + '</p>'
				       + '<p>전력 사용량 : ' + sgg_pu.toLocaleString() + ' kWh' + '</p>';
				       
				     // 팝업 내용 설정
				     document.getElementById('popup-content').innerHTML = popupContent;
				     
				     // 팝업 위치 설정 및 보이기
				     overlaysgg.setPosition(coordinate);
				     document.getElementById('popup').style.display = 'block'; // 팝업 창을 보이도록 설정
				} else {
				  alert('클릭한 지점에 대한 정보를 찾을 수 없습니다.');
				}
				});
			});
	    }

    function addSggLayer() {
  	   	  // 레이어 추가하기
   	      sggLayer = new ol.layer.Tile({
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
   	     map.addLayer(sggLayer); // 맵 객체에 레이어를 추가.
    }
    
    function addBjdMVLayer() {
    	map.removeLayer(sggmvLayer);
        // 레이어 추가하기
        bjdmvLayer = new ol.layer.Tile({
            source : new ol.source.TileWMS({
                url : 'http://localhost/geoserver/wms?service=WMS', // 1. 레이어 URL
                params : {
                    'VERSION' : '1.1.0', // 2. 버전
                    'LAYERS' : 'cite:shinjinviewbjd', // 3. 작업공간:레이어 명
                    'CQL_FILTER': cqlFilterBJDMV,
                    'BBOX' : '1.386872E7, 3906626.5, 1.4428071E7, 4670269.5',
                    'SRS' : 'EPSG:3857', // SRID
                    'FORMAT' : 'image/png' // 포맷
                },
                serverType : 'geoserver',
            })
        });
        map.addLayer(bjdmvLayer); // 맵 객체에 레이어를 추가함
        map.removeLayer(sggmvLayer);
        
        // 범례 이미지 생성
        legendContainer = document.createElement('div');
        legendContainer.className = 'legend-container'; // CSS 클래스 추가
        
        // 맵 요소의 상대적인 위치에 범례 컨테이너를 추가합니다.
        map.getTargetElement().appendChild(legendContainer);
        
        // 범례 이미지 요청을 위한 URL 생성
        legendUrl = 'http://localhost/geoserver/cite/wms?' +
            'service=WMS' +
            '&VERSION=1.0.0' +
            '&REQUEST=GetLegendGraphic' +
            '&LAYER=cite:shinjinviewbjd' +
            '&FORMAT=image/png' +
            '&WIDTH=80' +
            '&HEIGHT=20';
        
        // 범례 이미지를 추가할 HTML <img> 엘리먼트를 생성.
        legendImg = document.createElement('img');
        legendImg.src = legendUrl;
        
        // 범례 이미지를 범례 컨테이너에 추가.
        legendContainer.appendChild(legendImg);
        
		/////////////////////////////////////////////////////////////////////////////
		/////////////////////             팝 업 창            //////////////////////
		///////////////////////////////////////////////////////////////////////////
		
		//팝업 오버레이 생성
		var overlaybjd = new ol.Overlay({
		element: document.getElementById('popup'), // 팝업의 HTML 요소
		positioning: 'bottom-center' // 팝업을 마커 아래 중앙에 위치시킴
		//offset: [0, -20], // 팝업을 마커 아래로 조정
		//autoPan: true // 팝업이 지도 영역을 벗어날 경우 자동으로 팝업 위치를 조정하여 보여줌
		});
		map.addOverlay(overlaybjd);
		
		//팝업 닫기 버튼 요소 가져오기
		var popupCloser = document.getElementById('popup-closer');
		
		// 팝업 닫기 버튼에 이벤트 리스너 추가
		popupCloser.onclick = function() {
			overlaybjd.setPosition(undefined); // 팝업을 지도에서 제거
		  return false; // 이벤트 전파 방지
		};
		
		//클릭 이벤트 리스너 설정
		map.on('singleclick', function(evt) {
		// 클릭한 지점의 좌표를 가져옴
		//alert("팝업 클릭했다.");
		var coordinate = evt.coordinate;
		
		  // 해당 좌표에서의 지리적 정보를 가져오는 요청을 서버에 보냄
		  var featureRequest = new ol.format.WFS().writeGetFeature({
			    srsName: 'EPSG:3857',
			    featureNS: 'http://localhost/geoserver/cite',
			    featurePrefix: 'cite',
			    featureTypes: ['shinjinviewbjd'],
			    outputFormat: 'application/json',
			    geometryName: 'geom',
			    filter: new ol.format.filter.Intersects('geom', new ol.geom.Point(coordinate))
			});
		
			// 서버에 요청 보내기
			fetch('http://localhost/geoserver/cite/wms', {
			method: 'POST',
			body: new XMLSerializer().serializeToString(featureRequest)
			})
			.then(function(response) {
			return response.json();
			})
			.then(function(json) {
			// 가져온 정보에서 단계 구분 값을 추출하여 팝업에 표시
			if (json.features.length > 0) {
			  var properties = json.features[0].properties;
			  var bjd_pu = properties['totalusage']; // 예시: 구분 값의 키가 'sgg_cd'라 가정
			  var sgg_cd = properties['adm_sect_c']; 
			  var bjd_nm = properties['bjd_nm'];
			  //alert(bjd_nm);
			  //alert(bjd_pu);
			  // 팝업 내용을 구성
			  var popupContentbjd;
			    popupContentbjd = 
			       '<p>' + bjd_nm + '</p>'
			       + '<p>전력 사용량 : ' + bjd_pu.toLocaleString() + ' kWh' + '</p>';
			       
			     // 팝업 내용 설정
			     document.getElementById('popup-content').innerHTML = popupContentbjd;
			     
			     // 팝업 위치 설정 및 보이기
			     overlaybjd.setPosition(coordinate);
			     document.getElementById('popup').style.display = 'block'; // 팝업 창을 보이도록 설정
			} else {
			  alert('클릭한 지점에 대한 정보를 찾을 수 없습니다.');
			}
		});
	});
}

    function addBjdLayer() {
    	
        // 레이어 추가하기
        bjdLayer = new ol.layer.Tile({
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
    }

    function removeLegend2() {
        // 범례 이미지 삭제
        legendContainer = document.querySelector('.legend-container'); // 범례 이미지를 감싸는 요소 선택
        if (legendContainer) { // 요소가 존재하는지 확인
            legendContainer.parentNode.removeChild(legendContainer); // 요소 제거
        }
    }
	
	/////////////////////////////////////////////////////////////////////////////
    ///////////////////             에 이 작 스             ////////////////////
    ///////////////////////////////////////////////////////////////////////////
	
	// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< sd
	   $('#sidoSelect').change(function(){
		   selectSggValue ="";
		   selectBjdValue ="";
		   
    		var selectSiValue = $(this).val().split(',')[0];
    		var selectSiText = $(this).find('option:selected').text();
    		//alert(selectSiValue);
    		
    	    // loc 값이 있을 경우에만 CQL 필터 생성
    	    if (selectSiValue && selectSiValue.length > 0) {
    	        cqlFilterSd = "sd_cd='" + selectSiValue + "'";
    	        cqlFilterSGGMV = "sd_nm='" + selectSiText + "'";
    	    } else {
    	        cqlFilterSd = ""; // loc 값이 없는 경우, 빈 문자열로 설정
    	    }
    	    
    	    if(sdLayer || sggLayer || bjdLayer) {
                map.removeLayer(sdLayer);
                map.removeLayer(sggLayer);
                map.removeLayer(bjdLayer);
            }
    	    
    	    //alert(cqlFilterSd);
    	    
    	    /////////////////---------------------///////////////// 좌표 이동 및 줌 기능 start
    	    ///////////////////// 선택된 시/도의 geom값을 가져와서 지도에 표시
            var datas = $(this).val(); // value 값 가져오기
            var values = datas.split(",");
            sidocd = values[0]; // sido 코드
            
            var geom = values[1]; // x 좌표
            //alert("sido 좌표값" + sido);
            
            // 문자열에서 POINT(x y) 형식의 좌표를 추출
            var regex = /POINT\(([-+]?\d+\.\d+) ([-+]?\d+\.\d+)\)/;
	        var matches = regex.exec(geom);
	        var xCoordinate, yCoordinate;
	     
	        if (matches) {
	            xCoordinate = parseFloat(matches[1]); // x 좌표
	            yCoordinate = parseFloat(matches[2]); // y 좌표
	        } else {
	          alert("GEOM값 가져오기 실패!");
	        }
			
	        //alert(matches);
	        
            var sidoCenter = ol.proj.fromLonLat([xCoordinate, yCoordinate]);
            map.getView().setCenter(sidoCenter); // 중심좌표 기준으로 보기
            map.getView().setZoom(10); // 중심좌표 기준으로 줌 설정
			/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 end
    		
	 	 // AJAX 요청 보내기
	     $.ajax({
		   type: 'POST', // 또는 "GET", 요청 방식 선택
	          url: '/sidoSelect.do', // 컨트롤러의 URL 입력
	          data: { 'sido': selectSiValue }, // 선택된 값 전송
	          dataType: 'json',
	          success: function(response) {
	             // 성공 시 수행할 작업
                 
	             sggSelect = $("#sggSelect");
	             sggSelect.html("<option>--시/군/구를 선택하세요--</option>");
	             bjdSelect = $("#bjdSelect");
	             bjdSelect.html("<option>--동/읍/면을 선택하세요--</option>");
			     //alert(response);
			     console.log(response);
			     //alert(response.length);
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
		   var selectSggText = $(this).find('option:selected').text();
	   		//alert(selectSggValue);
	   		
	   	    // loc 값이 있을 경우에만 CQL 필터 생성
   	        cqlFilterSgg = "sgg_cd='" + selectSggValue + "'";
   	     	cqlFilterBJDMV = "sgg_cd='" + selectSggValue + "'";
	   	    
	   	    if(sggLayer || bjdLayer) {
	            map.removeLayer(sggLayer);
	            map.removeLayer(bjdLayer);
	        }
   	     
		/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 start
 	    ///////////////////// 선택된 시/군/구의 geom값을 가져와서 지도에 표시
         var datas = $(this).val(); // value 값 가져오기
         var values = datas.split(",");
         sggcd = values[0]; // sido 코드
         
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
         map.getView().setZoom(11); // 중심좌표 기준으로 줌 설정
		/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 end
	
   		// AJAX 요청 보내기
   		$.ajax({
			   type: 'POST', // 또는 "GET", 요청 방식 선택
	           url: '/bjgSelect.do', // 컨트롤러의 URL 입력
	           data: { 'sgg': selectSggValue },  //선택된 값 전송
	           dataType: 'json',
	           contentType : 'application/json; charset=UTF-8',
	         success: function(response) {
	              // 성공 시 수행할 작업
	              bjdSelect = $("#bjdSelect");
	              bjdSelect.html("<option>--동/읍/면을 선택하세요--</option>");
				  //alert(response);
				  //alert(response.length);
	              for(var i = 0; i < response.length; i++) {
	                  var item = response[i];
	                  bjdSelect.append("<option value='" + item.bjd_cd + "," + item.geom + "'>" + item.bjd_nm + "</option>");
	              	}
	        	   },
	        	   error: function(xhr, status, error) {
	                  // 에러 발생 시 수행할 작업
	                  console.error("AJAX 요청 실패:", error);
	              }
		     	});
		     }); //
   			// AJAX끝
	   
	   // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<bjd
	   $('#bjdSelect').change(function(){
		   var selectBjdValue = $(this).val().split(',')[0];
	   		
	   	    // loc 값이 있을 경우에만 CQL 필터 생성
	   	    if (selectBjdValue && selectBjdValue.length > 0) {
	   	        cqlFilterBjd = "bjd_cd='" + selectBjdValue + "'";
	   	    } else {
	   	        cqlFilterBjd = ""; // loc 값이 없는 경우, 빈 문자열로 설정
	   	    }
		   	    
		   	 if(bjdLayer) {
	             map.removeLayer(bjdLayer);
	         }
		   	 
			/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 start
	 	    ///////////////////// 선택된 시/군/구의 geom값을 가져와서 지도에 표시
	         var datas = $(this).val(); // value 값 가져오기
	         var values = datas.split(",");
	         bjdcd = values[0]; // sido 코드
	         
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
	         map.getView().setZoom(13); // 중심좌표 기준으로 줌 설정
			/////////////////---------------------///////////////// 좌표 이동 및 줌 기능 end
	   });
});
</script>

<style type="text/css">
/* 범례 이미지를 가운데 정렬 */
#legendImg {
    display: block;
    margin: auto;
    border: 1px solid #ccc;
    padding: 5px;
    position: absolute;
    top: 10px;
    left: 10px;
    z-index: 1000; /* 맵 제일 앞에 표시됩니다 */
}

.legend-container {
    position: absolute;
    top: 100px;
    left: 700px;
    z-index: 1000;
}

 /* 폰트 스타일 */
  body {
    font-family: 'Arial', sans-serif;
  }
  
  /* 팝업 스타일 */
  .popup {
    display: none; /* 처음에는 숨김 */
    position: relative;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.3);
    padding: 20px;
    width: 250px;
    font-size: 16px;
    color: #333;
    line-height: 1.5;
    font-weight: bold;
  }

  /* 팝업 닫기 버튼 스타일 */
  .popup-closer {
    position: absolute;
    top: 5px;
    right: 5px;
    font-size: 20px;
    color: #888;
    text-decoration: none;
    transition: color 0.3s ease;
    font-weight: bold;
    line-height: 1; /*
  }

  .popup-closer:hover {
    color: #555;
  }
</style>

</head>
<body>
	   <div>
	         <button type="button" onclick="removeLayer()" name="rpg_1">레이어삭제하기</button>
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
	   
	   <div>
	   		<button id="searchBtn" name="searchBtn" type="button">레이어 띄우기</button>
	   </div>
	   
	   <div>
	   		<button id="resetBtn" name="resetBtn" type="button">레이어 초기화</button>
	   </div>
	   
	   <!-- 팝업을 나타내는 HTML 요소 -->
	   <div id="popup" class="popup">
	     <a href="#" id="popup-closer" class="popup-closer">&times;</a>
	     <div id="popup-content"></div>
	   </div>

</body>
</html>