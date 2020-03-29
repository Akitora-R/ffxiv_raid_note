function timerStart() {
    let startBtn = $("#timerStart");
    let pauseBtn = $("#timerPause");
    timerStartPoint = new Date();
    startBtn.addClass("disabled");
    startBtn.attr("disabled", "disabled");
    startBtn.html(
        '<span class="spinner-grow spinner-grow-sm" role="status" aria-hidden="true"></span>' +
        '计时中...');
    pauseBtn.removeAttr("disabled");
    pauseBtn.removeClass("disabled");
    pauseBtn.html("暂停");
    todayTimeInterval = setInterval(updateTodayTime, 1000);
}

function timerPause() {
    let startBtn = $("#timerStart");
    let pauseBtn = $("#timerPause");
    startBtn.removeAttr("disabled");
    startBtn.removeClass("disabled");
    startBtn.html("开始");
    pauseBtn.addClass("disabled");
    pauseBtn.attr("disabled", "disabled");
    pauseBtn.html("未开始");
    timerEndPoint = new Date();
    timerLogs.push({begin: timerStartPoint.getTime(), end: timerEndPoint.getTime()});
    timerStartPoint = undefined;
    timerEndPoint = undefined;
    clearInterval(todayTimeInterval);
}

function timerReset() {
    let startBtn = $("#timerStart");
    let pauseBtn = $("#timerPause");
    startBtn.removeAttr("disabled");
    startBtn.removeClass("disabled");
    startBtn.html("开始");
    pauseBtn.addClass("disabled");
    pauseBtn.attr("disabled", "disabled");
    pauseBtn.html("未开始");
    timerLogs = [];
    timerStartPoint = undefined;
    timerEndPoint = undefined;
    clearInterval(todayTimeInterval);
}

function timerSave() {
    if (timerLogs.length === 0) {
        return
    }
    $.ajax({
        type: "POST",
        url: "ajaxSaveTimer",
        data: {timerLogs: JSON.stringify(timerLogs)},
        dataType: "json",
        success: function (resp) {
            clearInterval(todayTimeInterval);
            totalTimeMill = resp.total;
            todayTimeMill = resp.today;
            timerLogs = [];
        }
    });
}

function calTimeString(timeMill) {
    let baseSecond = 1000;
    let baseMinute = 1000 * 60;
    let baseHour = 1000 * 60 * 60;
    let h = parseInt(String(timeMill / baseHour));
    let m = parseInt(String(timeMill % baseHour / baseMinute));
    let s = String(timeMill % baseMinute / baseSecond);
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
