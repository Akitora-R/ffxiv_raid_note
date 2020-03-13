package kagetora.note.service;

import kagetora.note.dao.MistakeMapper;
import kagetora.note.entity.Mistake;
import kagetora.note.entity.Player;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MistakeService {
    private MistakeMapper mistakeMapper;

    @Transactional
    public int insertMistake(Mistake mistake){
        return mistakeMapper.insertMistake(mistake);
    }

    public List<Mistake> selectMistakeByPlayer(Player player){
        return this.mistakeMapper.selectMistakeByPlayer(player);
    }

    @Transactional
    public int deleteById(int id){
        return this.mistakeMapper.deleteById(id);
    }

    @Transactional
    public int invalidateAllMis(){
        return 0;
    }

    @Autowired
    public MistakeService(MistakeMapper mistakeMapper) {
        this.mistakeMapper = mistakeMapper;
    }
}
