class Chart{
    chartObj;
    //图表配置对象
    chartSetting={
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
    constructor(obj,setting) {
        this.chartObj=obj;
        if (setting!==undefined&&setting!==null){
            this.chartSetting=setting;
        }
    }
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
    $('a[data-toggle="pill"]').on('shown.bs.tab', function (e) {
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
    setDayStackChartData();
}

function setTotalChartData() {
    let chart=new Chart(echarts.init($("#TotalChart")[0],"light"));
    charts.set("totalPointChart",chart);
    chart.chartSetting.title.text="总好人榜";
    chart.chartSetting.series[0].name="好人值";
    chart.chartSetting.xAxis.data =[];
    chart.chartSetting.series[0].data=[];
    $.each(data, function (i, p) {
        chart.chartSetting.xAxis.data.push(p.name);
        chart.chartSetting.series[0].data.push(getTotalPoint(p));
    });
    chart.chartObj.setOption(chart.chartSetting);
}

function setTodayChartData() {
    $.ajax({
        type: "POST",
        url: "ajaxGetTodayMis",
        data: {},
        dataType: "json",
        success: function (resp) {
            console.log(resp);
            let chart=new Chart(echarts.init($("#TodayChart")[0],"light"));
            charts.set("todayPointChart",chart);
            chart.chartSetting.title.text="今日好人榜";
            chart.chartSetting.series[0].name="好人值";
            chart.chartSetting.xAxis.data =[];
            chart.chartSetting.series[0].data=[];
            $.each(resp,function (i,m) {
                chart.chartSetting.xAxis.data.push(m.name);
                chart.chartSetting.series[0].data.push(m.point);
            });
            chart.chartObj.setOption(chart.chartSetting);
        }
    });
}

function setDayStackChartData() {
    $.ajax({
        type: "POST",
        url: "ajaxGetDayStackChartData",
        data: {},
        dataType: "json",
        success: function (resp) {
            console.log(resp);
        }
    });
}
