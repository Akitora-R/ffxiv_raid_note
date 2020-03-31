let todayTimeInterval;//更新今天开荒时间的定时器
let timerStartPoint;//计时开始点
let timerEndPoint;//计时结束点
let timerLogs = [];//[{being,end}]

function timerStart() {
    switchBtn(true);
    timerStartPoint = new Date();
    todayTimeInterval = setInterval(updateTodayTime, 1000);
}

function timerPause() {
    switchBtn(false);
    timerEndPoint = new Date();
    timerLogs.push({begin: timerStartPoint.getTime(), end: timerEndPoint.getTime()});
    timerStartPoint = undefined;
    timerEndPoint = undefined;
    clearInterval(todayTimeInterval);
}

function timerReset() {
    switchBtn(false);
    timerLogs = [];
    timerStartPoint = undefined;
    timerEndPoint = undefined;
    clearInterval(todayTimeInterval);
    $("#todayTime").text(calTimeString(todayTimeMill));
}

function timerSave() {
    if (timerStartPoint !== undefined){
        timerEndPoint = new Date();
        timerLogs.push({begin: timerStartPoint.getTime(), end: timerEndPoint.getTime()});
        timerStartPoint = undefined;
        timerEndPoint = undefined;
        clearInterval(todayTimeInterval);
    }else if (timerLogs.length < 1){
        return
    }
    $.ajax({
        type: "POST",
        url: "ajaxSaveTimer",
        data: {timerLogs: JSON.stringify(timerLogs)},
        dataType: "json",
        success: function (resp) {
            totalTimeMill = resp.total;
            // noinspection JSUnresolvedVariable
            todayTimeMill = resp.today;
            timerLogs = [];
            timerReset();
        }
    });
}

function calTimeString(timeMill) {
    let baseSecond = 1000;
    let baseMinute = 1000 * 60;
    let baseHour = 1000 * 60 * 60;
    let h = parseInt(String(timeMill / baseHour));
    let m = parseInt(String(timeMill % baseHour / baseMinute));
    let s = (timeMill % baseMinute / baseSecond).toFixed(2);
    return h + " Hour " + m + " Min " + s + " Sec";
}

function refreshTodayTime(timeMill) {
    $("#todayTime").text(calTimeString(timeMill));
}

function updateTodayTime() {
    let tempMill = new Date() - timerStartPoint + todayTimeMill;
    $.each(timerLogs, function (i, v) {
        tempMill += v.end - v.begin;
    });
    refreshTodayTime(tempMill);
}

function switchBtn(state) {
    let startBtn = $("#timerStart");
    let pauseBtn = $("#timerPause");
    if (state){
        startBtn.addClass("disabled");
        startBtn.attr("disabled", "disabled");
        startBtn.html(
            '<span class="spinner-grow spinner-grow-sm" role="status" aria-hidden="true"></span>' +
            '计时中...');
        pauseBtn.removeAttr("disabled");
        pauseBtn.removeClass("disabled");
        pauseBtn.html("暂停");
    }else {
        startBtn.removeAttr("disabled");
        startBtn.removeClass("disabled");
        startBtn.html("开始");
        pauseBtn.addClass("disabled");
        pauseBtn.attr("disabled", "disabled");
        pauseBtn.html("未开始");
    }
}

function manualSetTime() {
    let hourIn=$("#hourIn");
    let minIn=$("#minIn");
    $.ajax({
        type: "POST",
        url: "ajaxManualSaveTimer",
        data: {hour: hourIn.val(),min:minIn.val()},
        dataType: "json",
        success: function (resp) {
            totalTimeMill = resp.total;
            // noinspection JSUnresolvedVariable
            todayTimeMill = resp.today;
            timerLogs = [];
            timerReset();
        }
    });
}