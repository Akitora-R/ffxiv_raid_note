package kagetora.note.service;

import kagetora.note.dao.PlayerMapper;
import kagetora.note.entity.Player;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PlayerService {
    PlayerMapper playerMapper;

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
        List<String> positions = Arrays.asList("T1", "T2", "H1", "H2", "D1", "D2", "D3", "D4");
        if (positions.contains(pos)&& !newName.isBlank()){
            playerMapper.updatePlayerNameByPosition(pos,newName);
        }
    }

    @Autowired
    public PlayerService(PlayerMapper playerMapper) {
        this.playerMapper = playerMapper;
    }

}
