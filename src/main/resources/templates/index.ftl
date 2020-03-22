<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<script src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
<#--<script src="https://cdn.bootcss.com/twitter-bootstrap/4.4.1/js/bootstrap.min.js"></script>-->
<script src="https://cdn.bootcss.com/twitter-bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
<link href="https://cdn.bootcss.com/twitter-bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.bootcss.com/material-design-icons/3.0.1/iconfont/material-icons.min.css" rel="stylesheet">
<script src="https://cdn.bootcss.com/echarts/4.6.0/echarts.min.js"></script>
<#--<script src="https://cdn.bootcss.com/twitter-bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>-->
<script src="myJS/charts.js"></script>
<style>
    .btn {
        margin: 5px;
    }
</style>
<script>
    const positions = ["D1","D2","D3","D4","H1","H2","T1","T2"];
    // noinspection JSAnnotator
    const nameMap = ${nameMapJson};
    let data;//后台List<Player>
    let tempPlayer;//临时角色
    let tempMistake;//临时失误表
    let timerStartPoint;//计时开始点
    let timerEndPoint;//计时结束点
    let timerLogs = [];//[{being,end}]
    let totalTimeMill =${totalTimeMill};//总开荒时间
    let todayTimeMill =${todayTimeMill};//今天开荒时间
    let todayTimeInterval;//更新今天开荒时间的定时器

    function Player() {//参考后台的Player
        this.id = undefined;
        this.name = undefined;
        this.position = undefined;
        this.active = true;
        this.mistake = [];
        this.getTotalPoint = function () {
            let ret = 0;
            $.each(this.mistake, function (i, m) {
                ret += m.p1 + m.p2 + m.p3 + m.p4;
            });
            return ret;
        }
    }

    function Mistake() {//参考后台的Mistake
        this.id = undefined;
        this.playerId = undefined;
        this.p1 = 0;
        this.p2 = 0;
        this.p3 = 0;
        this.p4 = 0;
        this.logTime = "";
        this.remark = "";
        this.valid = true;
        this.getTotalPoint = function () {
            return this.p1 + this.p2 + this.p3 + this.p4;
        };
        this.addPointByPhase = function (phase) {
            switch (phase) {
                case 1:
                    this.p1 += 1;
                    break;
                case 2:
                    this.p2 += 1;
                    break;
                case 3:
                    this.p3 += 1;
                    break;
                case 4:
                    this.p4 += 1;
                    break;
            }
        };
        this.subPointByPhase = function (phase) {
            switch (phase) {
                case 1:
                    this.p1 -= this.p1 > 0 ? 1 : 0;
                    break;
                case 2:
                    this.p2 -= this.p2 > 0 ? 1 : 0;
                    break;
                case 3:
                    this.p3 -= this.p3 > 0 ? 1 : 0;
                    break;
                case 4:
                    this.p4 -= this.p4 > 0 ? 1 : 0;
                    break;
            }
        }
    }

    $(function () {
        $("#timeCost").text(calTimeString(totalTimeMill));
        $("#todayTime").text(calTimeString(todayTimeMill));

        initNoteData();

        //模态框关闭时清空暂存玩家和暂存点数
        $('#pointModal').on('hidden.bs.modal', function (e) {
            tempPlayer = undefined;
            tempMistake = undefined;
            $("[id^='pointShow']").text("0");
        });
    });


    //(查服务器)设置浏览器副本的总本数据
    function initNoteData() {
        $.ajax({
            type: "GET",
            url: "ajaxGetNote",
            data: {},
            dataType: "json",
            success: function (resp) {
                console.log(resp);
                //获取数据
                data = resp;
                //echart设置数据
                initCharts();
            }
        });
    }

    //加点至临时表
    function addPoint(phase) {
        if (tempMistake === undefined) {
            tempMistake = new Mistake();
            tempMistake.playerId = tempPlayer.id;
            tempMistake.logTime = new Date().toJSON();
            console.log("init Mistake: " + JSON.stringify(tempMistake));
        }
        tempMistake.addPointByPhase(phase);
        console.log("current total point: " + tempMistake.getTotalPoint());
        $("#pointShow_" + phase).text(tempMistake["p" + phase]);
    }

    function subPoint(phase) {
        if (tempMistake === undefined) {
            return;
        }
        tempMistake.subPointByPhase(phase);
        console.log("current total point: " + tempMistake.getTotalPoint());
        $("#pointShow_" + phase).text(tempMistake["p" + phase]);
        if (tempMistake.getTotalPoint() <= 0) {
            tempMistake = undefined;
            console.log("deleted.");
        }
    }

    //当打开模态框时更新当前选中玩家数据
    function setTempPlayer(pos) {
        // let newPlayer=new Player();
        let currPlayer = getPlayerByPos(pos);
        tempPlayer = currPlayer;
        $("#remark").val("");
        $("#pointModalTitle").text(currPlayer.name);
        listPlayMis();
    }

    function getPlayerByPos(pos) {
        let ret = undefined;
        $.each(data, function (i, p) {
            if (p.position === pos) {
                ret = p;
            }
        });
        console.log(data);
        console.log(ret);
        return ret;
    }

    //获取该玩家的所有点数
    function getTotalPoint(player) {
        let ret = 0;
        $.each(player.mistake, function (i, v) {
            ret += v.p1 + v.p2 + v.p3 + v.p4;
        });
        return ret;
    }

    function saveNote() {
        if (tempMistake === undefined) {
            console.log("empty mistake,return");
            return;
        }
        let remark = $("#remark");
        tempMistake.remark = remark.val();
        $.ajax({
            type: "POST",
            url: "ajaxSetMis",
            data: {mis: JSON.stringify(tempMistake)},
            dataType: "json",
            success: function (resp) {
                tempMistake = undefined;
                tempPlayer = undefined;
                initNoteData();
            }
        });
    }

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

    function listPlayMis() {
        let card = `
<div class="row detailCardMark">
    <div class="col-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">[[title]]</h5>
                <h6 class="card-subtitle mb-2 text-muted">[[subtitle]]</h6>
                <p class="card-text">[[text]]</p>
                <a href="javascript:void(0)" onclick="ajaxDeleteMis('[[id]]')" class="card-link">删除这条记录</a>
            </div>
        </div>
    </div>
</div>`;
        let modalBody = $("#modalBody");
        $.ajax({
            type: "POST",
            url: "ajaxGetPlayerMis",
            data: {playerJson: JSON.stringify(tempPlayer)},
            dataType: "json",
            success: function (resp) {
                //通过标记移除
                $(".detailCardMark").remove();
                $.each(resp, function (i, v) {
                    let miss = v.p1 + " " + v.p2 + " " + v.p3 + " " + v.p4;
                    modalBody.append(card.replace("[[title]]", miss).replace("[[subtitle]]", new Date(v.logTime).toString()).replace("[[text]]", v.remark).replace("[[id]]", v.id));
                });
            }
        });
    }

    function ajaxDeleteMis(id) {
        $.ajax({
            type: "POST",
            url: "ajaxDeleteMis",
            data: {id: id},
            dataType: "json",
            success: function (resp) {
                listPlayMis();
                initNoteData();
            }
        });
    }

    function ajaxUpdatePlayerName() {
        let data=[];
        let names=$("[id^='PlayerName_']");
        $.each(names,function (i,v) {
            data.push({pos:$(v).attr("id").split("_")[1],name:$(v).val()});
        });
        $.ajax({
            type: "POST",
            url: "ajaxUpdateName",
            data: {data:JSON.stringify(data)},
            dataType: "json",
            success: function (resp) {
                if(resp){
                    location.reload();
                }
            }
        });
    }

    function ajaxReset(type) {
        if (confirm("确定清空吗?")){
            $.ajax({
                type: "GET",
                url: "ajaxReset",
                data: {type:type},
                dataType: "json",
                success: function (resp) {
                    if(resp){
                        location.reload();
                    }
                }
            });
        }
    }
</script>

<body>
<div class="container-fluid">


    <div class="row">
        <div class="col-md-12" style="margin-top: 5px;margin-bottom: 20px;">
            <h1>接好你的锅</h1>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <label for="currRaid">当前副本:</label>
            <h3 class="text-justify d-inline" id="currRaid">${currRaid}</h3>
        </div>
    </div>

    <div class="row" style="margin-bottom: 10px;">
        <div class="col-md-12">
            <div class="card-deck">
                <div class="card bg-info shadow" style="color: aliceblue;">
                    <div class="card-body">
                        <h3 id="timeCost"></h3>
                        <i class="material-icons">
                            timelapse
                        </i>
                        <small>历时</small>
                    </div>
                </div>

                <div class="card bg-success shadow" style="color: aliceblue;">
                    <div class="card-body">
                        <h3>20% (水雷)</h3>
                        <i class="material-icons">
                            golf_course
                        </i>
                        <small>进度</small>
                    </div>
                </div>

                <div class="card bg-warning shadow">
                    <div class="card-body">
                        <h3>${totalPoint} point</h3>
                        <i class="material-icons">
                            clear
                        </i>
                        <small>全队记点</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="card-deck">
                <div class="card">
                    <div class="card-header">
                        小本本
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <button onclick="setTempPlayer('T1')" class="btn btn-outline-primary btn-block"
                                        data-toggle="modal" data-target="#pointModal">${nameMap['T1']}</button>
                            </div>
                            <div class="col-md-3">
                                <button onclick="setTempPlayer('T2')" class="btn btn-outline-primary btn-block"
                                        data-toggle="modal" data-target="#pointModal">${nameMap['T2']}</button>
                            </div>
                            <div class="col-md-3">
                                <button onclick="setTempPlayer('H1')" class="btn btn-outline-success btn-block"
                                        data-toggle="modal" data-target="#pointModal">${nameMap['H1']}</button>
                            </div>
                            <div class="col-md-3">
                                <button onclick="setTempPlayer('H2')" class="btn btn-outline-success btn-block"
                                        data-toggle="modal" data-target="#pointModal">${nameMap['H2']}</button>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <button onclick="setTempPlayer('D1')" class="btn btn-outline-danger btn-block"
                                        data-toggle="modal" data-target="#pointModal">${nameMap['D1']}</button>
                            </div>
                            <div class="col-md-3">
                                <button onclick="setTempPlayer('D2')" class="btn btn-outline-danger btn-block"
                                        data-toggle="modal" data-target="#pointModal">${nameMap['D2']}</button>
                            </div>
                            <div class="col-md-3">
                                <button onclick="setTempPlayer('D3')" class="btn btn-outline-danger btn-block"
                                        data-toggle="modal" data-target="#pointModal">${nameMap['D3']}</button>
                            </div>
                            <div class="col-md-3">
                                <button onclick="setTempPlayer('D4')" class="btn btn-outline-danger btn-block"
                                        data-toggle="modal" data-target="#pointModal">${nameMap['D4']}</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <ul class="nav nav-tabs card-header-tabs" id="myTab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="manage-time-tab" data-toggle="pill" href="#manage-time" role="tab" aria-controls="manage-time" aria-selected="true">时间</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="manage-progress-tab" data-toggle="pill" href="#manage-progress"
                                   role="tab" aria-controls="manage-progress" aria-selected="false">进度</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="manage-player-tab" data-toggle="pill" href="#manage-player"
                                   role="tab" aria-controls="manage-player" aria-selected="false">玩家</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="manage-settings-tab" data-toggle="pill" href="#manage-settings"
                                   role="tab" aria-controls="manage-settings" aria-selected="false">设置</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body tab-content" id="myTabContent">
                        <div class="tab-pane fade show active" id="manage" role="tabpanel" aria-labelledby="manage-tab">
                            <div class="tab-content" id="pills-tabContent">
                                <div class="tab-pane fade show active" id="manage-time" role="tabpanel" aria-labelledby="manage-time-tab">
                                    <div class="row">
                                        <div class="col-12 text-center">
                                            <small>今日已累计开荒:</small>
                                            <h3 id="todayTime">123H</h3>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-3">
                                            <button id="timerStart" onclick="timerStart()"
                                                    class="btn btn-block btn-outline-success">开始
                                            </button>
                                        </div>
                                        <div class="col-sm-3">
                                            <button id="timerPause" onclick="timerPause()"
                                                    class="btn btn-block btn-outline-warning disabled" disabled>未开始
                                            </button>
                                        </div>
                                        <div class="col-sm-3">
                                            <button id="timerReset" onclick="timerReset()"
                                                    class="btn btn-block btn-outline-danger">重置
                                            </button>
                                        </div>
                                        <div class="col-sm-3">
                                            <button id="timerSave" onclick="timerSave()"
                                                    class="btn btn-block btn-outline-dark">保存
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="manage-progress" role="tabpanel"
                                     aria-labelledby="manage-progress-tab">

                                </div>
                                <div class="tab-pane fade" id="manage-player" role="tabpanel"
                                     aria-labelledby="manage-player-tab">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="row">
                                                <div class="col-6">
                                                    <div class="input-group mb-3 border border-primary rounded">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text">T1</span>
                                                        </div>
                                                        <input type="text" class="form-control"
                                                               placeholder="${nameMap['T1']}" id="PlayerName_T1"
                                                               aria-label="name">
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="input-group mb-3 border border-primary rounded">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text">T2</span>
                                                        </div>
                                                        <input type="text" class="form-control"
                                                               placeholder="${nameMap['T2']}" id="PlayerName_T2"
                                                               aria-label="name">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="row">
                                                <div class="col-6">
                                                    <div class="input-group mb-3 border border-success rounded">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text">H1</span>
                                                        </div>
                                                        <input type="text" class="form-control"
                                                               placeholder="${nameMap['H1']}" id="PlayerName_H1"
                                                               aria-label="name">
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="input-group mb-3 border border-success rounded">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text">H2</span>
                                                        </div>
                                                        <input type="text" class="form-control"
                                                               placeholder="${nameMap['H2']}" id="PlayerName_H2"
                                                               aria-label="name">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="row">
                                                <div class="col-6">
                                                    <div class="input-group mb-3 border border-danger rounded">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text">D1</span>
                                                        </div>
                                                        <input type="text" class="form-control"
                                                               placeholder="${nameMap['D1']}" id="PlayerName_D1"
                                                               aria-label="name">
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="input-group mb-3 border border-danger rounded">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text">D2</span>
                                                        </div>
                                                        <input type="text" class="form-control"
                                                               placeholder="${nameMap['D2']}" id="PlayerName_D2"
                                                               aria-label="name">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="row">
                                                <div class="col-6">
                                                    <div class="input-group mb-3 border border-danger rounded">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text">D3</span>
                                                        </div>
                                                        <input type="text" class="form-control"
                                                               placeholder="${nameMap['D3']}" id="PlayerName_D3"
                                                               aria-label="name">
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="input-group mb-3 border border-danger rounded">
                                                        <div class="input-group-prepend">
                                                            <span class="input-group-text">D4</span>
                                                        </div>
                                                        <input type="text" class="form-control"
                                                               placeholder="${nameMap['D4']}" id="PlayerName_D4"
                                                               aria-label="name">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12">
                                            <button onclick="ajaxUpdatePlayerName()" class="btn btn-info btn-block">保存</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="manage-settings" role="tabpanel"
                                     aria-labelledby="manage-settings-tab">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <button class="btn btn-block btn-outline-danger" onclick="ajaxReset('timer')">重置时间数据</button>
                                        </div>
                                        <div class="col-md-4">
                                            <button class="btn btn-block btn-outline-danger" onclick="ajaxReset('playerName')">重置玩家名称</button>
                                        </div>
                                        <div class="col-md-4">
                                            <button class="btn btn-block btn-outline-danger" onclick="ajaxReset('note')">重置小本本</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <ul class="nav nav-tabs card-header-tabs" id="pointTab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="total-tab" data-toggle="pill" href="#total" role="tab" aria-controls="total" aria-selected="true">玩家得点</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="today-tab" data-toggle="pill" href="#today" role="tab" aria-controls="today" aria-selected="false">今日玩家得点</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body tab-content" id="pointTabContent">
                    <div class="tab-pane fade show active" id="total" role="tabpanel" aria-labelledby="total-tab">
                        <div class="row">
                            <div class="col-12" id="TotalChart" style="height: 20rem">

                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="today" role="tabpanel" aria-labelledby="total-tab">
                        <div class="row">
                            <div class="col-12" id="TodayChart" style="height: 20rem">

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

</html>
<!-- Modal -->
<div class="modal fade" id="pointModal" tabindex="-1" role="dialog" aria-labelledby="pointModalTitle"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="pointModalTitle">Modal title</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="modalBody">
                <div class="row">
                    <label class="col-3 col-form-label col-form-label-lg">P1</label>
                    <div class="col-9">
                        <div class="btn-group d-flex" role="group">
                            <button class="btn btn-outline-primary w-100" onclick="addPoint(1)">
                                喜加一
                                <span class="badge badge-dark" id="pointShow_1">0</span>
                            </button>
                            <button class="btn btn-outline-secondary w-50" onclick="subPoint(1)">手滑了</button>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <label class="col-3 col-form-label col-form-label-lg">P2</label>
                    <div class="col-9">
                        <div class="btn-group d-flex" role="group">
                            <button class="btn btn-outline-primary w-100" onclick="addPoint(2)">
                                喜加一
                                <span class="badge badge-dark" id="pointShow_2">0</span>
                            </button>
                            <button class="btn btn-outline-secondary w-50" onclick="subPoint(2)">手滑了</button>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <label class="col-3 col-form-label col-form-label-lg">P3</label>
                    <div class="col-9">
                        <div class="btn-group d-flex" role="group">
                            <button class="btn btn-outline-primary w-100" onclick="addPoint(3)">
                                喜加一
                                <span class="badge badge-dark" id="pointShow_3">0</span>
                            </button>
                            <button class="btn btn-outline-secondary w-50" onclick="subPoint(3)">手滑了</button>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <label class="col-3 col-form-label col-form-label-lg">P4</label>
                    <div class="col-9">
                        <div class="btn-group d-flex" role="group">
                            <button class="btn btn-outline-primary w-100" onclick="addPoint(4)">
                                喜加一
                                <span class="badge badge-dark" id="pointShow_4">0</span>
                            </button>
                            <button class="btn btn-outline-secondary w-50" onclick="subPoint(4)">手滑了</button>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">备注</span>
                            </div>
                            <textarea class="form-control" aria-label="remark" id="remark" placeholder="看看你都干了些啥好事"></textarea>
                        </div>
                    </div>
                </div>
<#--                <div class="row">-->
<#--                    <div class="col-12">-->
<#--                        <div class="card">-->
<#--                            <div class="card-body">-->
<#--                                <h5 class="card-title">[[title]]</h5>-->
<#--                                <h6 class="card-subtitle mb-2 text-muted">[[subtitle]]</h6>-->
<#--                                <p class="card-text">[[text]]</p>-->
<#--                                <a href="#" class="card-link">[[link]]</a>-->
<#--                            </div>-->
<#--                        </div>-->
<#--                    </div>-->
<#--                </div>-->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="saveNote()">保存</button>
            </div>
        </div>
    </div>
</div>