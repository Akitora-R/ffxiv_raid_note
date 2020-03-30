package kagetora.note.service;

import kagetora.note.dao.TimerMapper;
import kagetora.note.entity.Timer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
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

    public void deleteTodayTimer(){
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(new Date());
        gc.set(Calendar.HOUR_OF_DAY,0);
        gc.set(Calendar.MINUTE,0);
        gc.set(Calendar.SECOND,0);
        gc.set(Calendar.MILLISECOND,0);
        Date begin = gc.getTime();
        gc.add(Calendar.DAY_OF_YEAR,1);
        Date end = gc.getTime();
        timerMapper.deleteTimerByTime(begin,end);
    }

    @Autowired
    public TimerService(TimerMapper timerMapper) {
        this.timerMapper = timerMapper;
    }
}
