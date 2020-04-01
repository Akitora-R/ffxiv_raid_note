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
    @Results(id = "playerMap", value = {
            @Result(property = "id", column = "id"),
            @Result(property = "mistake", column = "id", many = @Many(select = "kagetora.note.dao.MistakeMapper.selectMistakeByPlayer"))
    })
    List<Player> selectAllPlayer();

    @Select("SELECT SUM(p1+p2+p3+p4) FROM mistake m LEFT JOIN player p ON m.player_id=p.id WHERE p.active = TRUE AND m.valid = TRUE")
    Integer getTotalPoint();

    @Select("SELECT p.position pos, p.name name, SUM(p1+p2+p3+p4) point FROM mistake m LEFT JOIN player p ON m.player_id=p.id WHERE active=true AND m.log_time>=#{begin} AND m.log_time < #{end} GROUP BY p.name,pos ORDER BY pos")
    List<Map<String, Integer>> selectPlayerToMisByDate(Date begin, Date end);

    @Update("UPDATE player SET name = #{newName} WHERE position = #{pos} AND active = #{active}")
    void updatePlayerNameByPosition(String pos, String newName, Boolean active);

    @Results(value = {
            @Result(property = "date", column = "date", javaType = Date.class),
            @Result(property = "point", column = "point", javaType = Integer.class)
    })
    @Select("SELECT DATE_FORMAT( log_time, '%Y-%m-%d' ) date,sum( p1 + p2 + p3 + p4 ) point,p.name name,p.position pos FROM mistake m LEFT JOIN player p ON p.id = m.player_id WHERE p.active = TRUE AND m.valid = TRUE GROUP BY date,name,pos ORDER BY date ASC")
    List<Map<String, Object>> selectChartDataForDayStack();
}
