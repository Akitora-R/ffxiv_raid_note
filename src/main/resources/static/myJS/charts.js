function Chart(obj,setting){
    this.chartObj=obj;
    //图表配置对象
    this.chartSetting={
        title: {
            text: 'title'
        },
        tooltip: {},
        legend: {
            data: ['point']
        },
        xAxis: {
            data: []
        },
        yAxis: {},
        series: [{
            name: 'name',
            type: 'bar',
            data: []
        }]
    };
}

let pointChartOption = {//得点图配置对象
    title: {
        text: '总好人榜'
    },
    tooltip: {},
    legend: {
        data: ['好人值']
    },
    xAxis: {
        data: []
    },
    yAxis: {},
    series: [{
        name: '好人值',
        type: 'bar',
        data: []
    }]
};
let pointChartOption_today = {
    title: {
        text: '今日好人榜'
    },
    tooltip: {},
    legend: {
        data: ['好人值']
    },
    xAxis: {
        data: []
    },
    yAxis: {},
    series: [{
        name: '好人值',
        type: 'bar',
        data: []
    }]
};

let charts=new Map();
/*
* totalPointChart
* todayPointChart
* */

$(function () {
    //解决tab切换图表不显示
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        charts.forEach(function (v,k) {
            v.chartObj.resize();
        });
    });
    $(window).resize(function () {
        charts.forEach(function (v,k) {
            v.chartObj.resize();
        });
    });
});

function initCharts() {
    setTotalChartData();
    setTodayChartData();
}

function setTotalChartData() {
    charts.set("totalPointChart",new Chart(echarts.init($("#TotalChart")[0],"light")));
    let totalPointChart=charts.get("totalPointChart");
    totalPointChart.chartSetting.title.text="总好人榜";
    totalPointChart.chartSetting.series[0].name="好人值";
    totalPointChart.chartSetting.xAxis.data =[];
    totalPointChart.chartSetting.series[0].data=[];
    $.each(data, function (i, p) {
        totalPointChart.chartSetting.xAxis.data.push(p.name);
        totalPointChart.chartSetting.series[0].data.push(getTotalPoint(p));
    });
    totalPointChart.chartObj.setOption(totalPointChart.chartSetting);
}

function setTodayChartData() {
    charts.set("todayPointChart",new Chart(echarts.init($("#TodayChart")[0],"light")));
    $.ajax({
        type: "POST",
        url: "ajaxGetTodayMis",
        data: {},
        dataType: "json",
        success: function (resp) {
            console.log(resp);
        }
    });
    //TODO
}