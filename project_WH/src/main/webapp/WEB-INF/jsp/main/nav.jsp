<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>MENU</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>2DMap</title>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
        <!-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *-->
        <!-- * *                               SB Forms JS                               * *-->
        <!-- * * Activate your form at https://startbootstrap.com/solution/contact-forms * *-->
        <!-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *-->
        <script src="https://cdn.startbootstrap.com/sb-forms-latest.js"></script>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top bg-dark" id="mainNav">
	<div class="d-flex align-items-center" style="text-align: center;">
		<div>
			<h3>탄소공간지도시스템</h3>
		</div>
		    <div id="menu" style="height: 100%; background-color: #f0f0f0; float: left;">
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
            	<form action="/fileUp" method="post" enctype="multipart/form-data">
					<input type="file" name="fileUp">
					<button type="submit">txt 파일 업로드</button>
				</form>
            </div>
		<div>
			asd
		</div>
	</div>
</nav>