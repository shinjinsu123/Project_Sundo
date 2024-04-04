<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>브이월드 오픈API</title>
<script src="https://www.gstatic.com/charts/loader.js"></script>
<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- bootstrap -->
<script type="text/javascript">
    google.charts.load('current', {'packages':['bar']});   // Google Charts 로드
    google.charts.setOnLoadCallback(drawChart);  // 로드 완료 후 drawChart 함수 호출

        $(function() {
            $('#showStatus').click(function(){
                var sdCd1 = $('#loc').val();
                var allSelected = $('#loc option:selected').attr('id') === 'all';
                
                console.log(sdCd1);
                console.log(allSelected);
                
                if(allSelected){
                    $.ajax({
                        type     : 'POST',
                        url      : 'allSelec.do',
                        dataType : 'json',
                        success: function(response){
                            drawChart(response);
                            drawTable(response);
                        },
                        error: function(xhr, status, error) {
                            console.error(error);
                        }
                    });
                }
            });
        });

    function drawChart(response) {
        if (!response || response.length < 1) {
            alert('시/도를 선택해 주세요.');
            return;
        }

        var data = [['Category','전기 사용량']];
        response.forEach(function(item) {
            data.push([item.sd_nm, item.sitotalusage]);
        });

        var chartData = google.visualization.arrayToDataTable(data);

        var options = {
            chart: {
                title: '시도 사용량',
                subtitle: 'Sales, Expenses, and Profit: 2014-2017',
            },
            tooltip: {trigger: 'both', isHtml: true },
            bar: {groupWidth: '50%'},
            animation: {
                startup: true,
                duration: 1000,
                easing: 'linear'
            },
            hAxis: {
                textStyle: { fontSize: 10 }, 
            },
            vAxis: {
                textStyle: { fontSize: 12, fontWeight: 'bold'}
            },
            chartArea: { 
                width: '75%',
                height: '93%'
            },
            bars: 'horizontal',
            focusTarget: 'category'
        };

        var chart = new google.visualization.BarChart(document.getElementById('charts'));
        chart.draw(chartData, options);
    }

    function drawTable(response) {
        var tableHtml = '<table class="table"><thead style="position: sticky; top: 0; background-color: white; z-index: 1;"><tr><th>지역 이름</th><th>전기 사용량(kWh)</th></tr></thead><tbody>';
        
        response.forEach(function(item) {
            tableHtml += '<tr><td>' + item.sd_nm + '</td><td>' + item.sitotalusage + '</td></tr>';
        });

        tableHtml += '</tbody></table>';
        $('#table').html(tableHtml).css({
            'max-height': '350px',
            'overflow-y': 'auto',
            'background-color': 'white'
        });
    }
</script>
<style>
#table thead th {
    border: 1px solid black; /* 제목에 테두리 추가 */
}

#table tbody td {
    border: 1px solid black; /* 내용에 테두리 추가 */
}
</style>
</head>
<body>
<div>
   <div>
        <select id="loc" name="loc">
            <option>시/도 선택</option>
            <option id="all" value="${sitotalusage}">전체 선택</option>
            <c:forEach items="${chartList}" var="row2">
                <option id="sd" value="${row2.sd_cd}">${row2.sd_nm}</option>
            </c:forEach>
        </select>
   </div><br>
   <button class="btn btn-secondary" id="showStatus">통계 보기</button>
   <div>
        <div id="charts"></div>
        <div id="table"></div>
   </div>
</div>
</body>
</html>