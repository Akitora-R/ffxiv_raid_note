package kagetora.note.service;

import kagetora.note.dao.PlayerMapper;
import kagetora.note.entity.Player;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.*;

@Service
public class PlayerService {
    PlayerMapper playerMapper;
    private final List<String> positions = List.of("T1", "T2", "H1", "H2", "D1", "D2", "D3", "D4");
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

    public void updatePlayerNameByPosition(String pos,String newName){
        if (positions.contains(pos)&& !newName.isBlank()){
            playerMapper.updatePlayerNameByPosition(pos,newName,true);
        }
    }

    public void resetPlayerName(){
        positions.forEach((var pos)-> playerMapper.updatePlayerNameByPosition(pos,pos,true));
    }

    @Autowired
    public PlayerService(PlayerMapper playerMapper) {
        this.playerMapper = playerMapper;
    }

}
