package kagetora.note.dao;

import kagetora.note.entity.Player;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Mapper
@Repository
public interface PlayerMapper {

    @Select("SELECT * FROM player WHERE id = #{id}")
    @ResultMap("playerMap")
    Player selectPlayerById(int id);

    @Select("SELECT * FROM player WHERE active = 1")
    @Results(id = "playerMap",value = {
            @Result(property = "id",column = "id"),
            @Result(property = "mistake",column = "id",many = @Many(select = "kagetora.note.dao.MistakeMapper.selectMistakeByPlayer"))
    })
    List<Player> selectAllPlayer();

    @Select("SELECT SUM(p1+p2+p3+p4) FROM mistake LEFT JOIN player ON mistake.player_id=player.id WHERE active=true")
    Integer getTotalPoint();

    @Select("SELECT p.name name, SUM(p1+p2+p3+p4) point FROM mistake m LEFT JOIN player p ON m.player_id=p.id WHERE active=true AND m.log_time>=#{begin} AND m.log_time < #{end} GROUP BY p.name")
    List<Map<String,Integer>> selectPlayerToMisByDate(Date begin,Date end);

    @Update("UPDATE player SET name = #{newName} WHERE position = #{pos} AND active = #{isActive}")
    void updatePlayerNameByPosition(String pos, String newName,Boolean isActive);
}
