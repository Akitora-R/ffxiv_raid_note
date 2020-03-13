package kagetora.note.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import kagetora.note.entity.Mistake;
import kagetora.note.entity.Player;
import kagetora.note.entity.Timer;
import kagetora.note.service.MistakeService;
import kagetora.note.service.PlayerService;
import kagetora.note.service.TimerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class IndexCtl {
    private Logger logger = LoggerFactory.getLogger(IndexCtl.class);
    private ObjectMapper mapper = new ObjectMapper();
    private PlayerService playerService;
    private MistakeService mistakeService;
    private TimerService timerService;

    @RequestMapping("/")
    public String index(Model model) {
        model.addAttribute("nameMap", playerService.getPosNameMap());
        model.addAttribute("totalPoint", playerService.getTotalPoint());
        model.addAttribute("totalTimeMill", timerService.getTotalMillisecond().toString());
        model.addAttribute("todayTimeMill", timerService.getTodayMillisecond().toString());
        model.addAttribute("currRaid", "绝亚历山大");
        return "index";
    }

    @ResponseBody
    @RequestMapping("/ajaxGetNote")
    public Object ajaxGetNote() {
        return playerService.getAllPlayer();
    }

    @ResponseBody
    @RequestMapping("/ajaxSetMis")
    public Object ajaxSetMis(String mis) {
        Mistake mistake = null;
        try {
            mistake = mapper.readValue(mis, Mistake.class);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        assert mistake != null;
        logger.info(mistake.toString());
        mistakeService.insertMistake(mistake);
        return true;
    }

    @ResponseBody
    @RequestMapping("ajaxGetPlayerMis")
    public Object ajaxGetPlayerMis(String playerJson) {
        Player player = null;
        try {
            player = mapper.readValue(playerJson, Player.class);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        assert player != null;
        return this.mistakeService.selectMistakeByPlayer(player);
    }

    @ResponseBody
    @RequestMapping("/ajaxSaveTimer")
    public Object ajaxSaveTimer(String timerLogs) {
        if (StringUtils.isEmpty(timerLogs)) {
            return false;
        }
        Timer[] timers = null;
        try {
            timers = mapper.readValue(timerLogs, Timer[].class);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        assert timers != null;
        timerService.insertAllTimers(timers);
        HashMap<String, Object> ret = new HashMap<>();
        ret.put("today", timerService.getTodayMillisecond());
        ret.put("total", timerService.getTotalMillisecond());
        return ret;
    }

    @ResponseBody
    @RequestMapping("/ajaxDeleteMis")
    public Object ajaxDeleteMis(int id) {
        mistakeService.deleteById(id);
        return true;
    }

    @ResponseBody
    @RequestMapping("/ajaxUpdateName")
    public Object ajaxUpdateName(String data) {
        logger.info(data);
        List<Map<String, String>> value = null;
        try {
            value = mapper.readValue(data, new TypeReference<>() {
            });
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        assert value != null;
        value.forEach((var i) -> playerService.updatePlayerNameByPosition(i.get("pos"), i.get("name")));
        return true;
    }

    @ResponseBody
    @RequestMapping("/ajaxReset")
    public Object ajaxReset(String type) {
        switch (type) {
            case "playerName":
                playerService.resetPlayerName();
                break;
            case "timer":
                timerService.deleteAllTimer();
                break;
            case "note":
                mistakeService.invalidateAllMis();
                break;
        }
        return true;
    }

    @Autowired
    public IndexCtl(PlayerService playerService, MistakeService mistakeService, TimerService timerService) {
        this.playerService = playerService;
        this.mistakeService = mistakeService;
        this.timerService = timerService;
    }
}
