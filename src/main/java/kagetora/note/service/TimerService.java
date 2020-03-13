package kagetora.note.service;

import kagetora.note.dao.TimerMapper;
import kagetora.note.entity.Timer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TimerService {
    private TimerMapper timerMapper;

    @Transactional
    public int insertTimer(Timer timer){
        return timerMapper.insertTimer(timer);
    }

    @Transactional
    public void insertAllTimers(Timer[] timers){
        for (Timer t:timers){
            this.insertTimer(t);
        }
    }

    public Long getTotalMillisecond(){
        long ret=0L;
        List<Timer> timers = timerMapper.selectAllTimer();
        for (Timer t:timers){
            ret+=t.getEnd().getTime()-t.getBegin().getTime();
        }
        return ret;
    }

    public Long getTodayMillisecond(){
        long ret=0L;
        List<Timer> timers = timerMapper.selectTodayTimer();
        for (Timer t:timers){
            ret+=t.getEnd().getTime()-t.getBegin().getTime();
        }
        return ret;
    }

    public void deleteAllTimer(){
        timerMapper.deleteAllTimer();
    }

    @Autowired
    public TimerService(TimerMapper timerMapper) {
        this.timerMapper = timerMapper;
    }
}
