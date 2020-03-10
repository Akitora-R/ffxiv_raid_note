package kagetora.note.dao;

import kagetora.note.entity.Player;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface PlayerMapper {

    @Select("SELECT * FROM player WHERE id = #{id}")
    @ResultMap("playerMap")
    Player selectPlayerById(int id);

    @Select("SELECT * FROM player")
    @Results(id = "playerMap",value = {
            @Result(property = "id",column = "id"),
            @Result(property = "mistake",column = "id",many = @Many(select = "kagetora.note.dao.MistakeMapper.selectMistakeByPlayer"))
    })
    List<Player> selectAllPlayer();

    @Select("SELECT SUM(p1+p2+p3+p4) FROM mistake LEFT JOIN player ON mistake.player_id=player.id WHERE is_active=true")
    Integer getTotalPoint();
}
