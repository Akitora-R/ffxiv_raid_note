package kagetora.note.service;

import kagetora.note.dao.PlayerMapper;
import kagetora.note.entity.Player;
import kagetora.note.entity.VO.MistakeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class PlayerService {
    PlayerMapper playerMapper;
    private final Set<String> positions = Set.of("T1", "T2", "H1", "H2", "D1", "D2", "D3", "D4");
    public List<Player> getAllPlayer(){
        return playerMapper.selectAllPlayer();
    }

    public Map<String,String> getPosNameMap(){
        List<Player> players = this.playerMapper.selectAllPlayer();
        HashMap<String, String> ret = new HashMap<>();
        for (Player p:players){
            ret.put(p.getPosition(),p.getName());
        }
        return ret;
    }
    public Integer getTotalPoint(){
        Integer totalPoint = playerMapper.getTotalPoint();
        return totalPoint==null?0:totalPoint;
    }

    public List<Map<String,Integer>> getTodayPlayerPoint(){
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(new Date());
        gc.set(Calendar.HOUR_OF_DAY,0);
        gc.set(Calendar.MINUTE,0);
        gc.set(Calendar.SECOND,0);
        gc.set(Calendar.MILLISECOND,0);
        Date begin = gc.getTime();
        gc.add(Calendar.DAY_OF_YEAR,1);
        Date end = gc.getTime();
        return playerMapper.selectPlayerToMisByDate(begin,end);
    }

    public void updatePlayerNameByPosition(String pos,String newName){
        if (positions.contains(pos)&& !newName.isBlank()){
            playerMapper.updatePlayerNameByPosition(pos,newName,true);
        }
    }

    public void resetPlayerName(){
        positions.forEach((var pos)-> playerMapper.updatePlayerNameByPosition(pos,pos,true));
    }

    public ArrayList<MistakeVO> getChartDataForDayStack(){
        List<Map<String, Object>> maps = playerMapper.selectChartDataForDayStack();
        ArrayList<MistakeVO> mistakeVOS = new ArrayList<>();
        maps.forEach(map -> {
            Date currDate = (Date) map.get("date");
            MistakeVO datum = getMistakeVOByDate(mistakeVOS, currDate);
            if (datum==null){
                datum = new MistakeVO(currDate,new HashMap<>());
                mistakeVOS.add(datum);
            }
            datum.getData().put((String) map.get("pos"), (Integer) map.get("point"));
        });
        mistakeVOS.forEach(mistakeVO -> positions.forEach(p-> mistakeVO.getData().putIfAbsent(p,0)));
        return mistakeVOS;
    }

    private MistakeVO getMistakeVOByDate(List<MistakeVO> list,Date date){
        for (MistakeVO vo : list) {
            if (vo.getDate().equals(date)){
                return vo;
            }
        }
        return null;
    }

    @Autowired
    public PlayerService(PlayerMapper playerMapper) {
        this.playerMapper = playerMapper;
    }

}
