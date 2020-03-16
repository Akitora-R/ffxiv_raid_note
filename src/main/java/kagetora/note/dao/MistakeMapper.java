package kagetora.note.dao;

import kagetora.note.entity.Mistake;
import kagetora.note.entity.Player;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;
@Mapper
@Repository
public interface MistakeMapper {
    @Select("SELECT * FROM mistake WHERE id = #{id}")
    Mistake selectMistakeById(int id);

    @Select("SELECT * FROM mistake WHERE player_id = #{id}")
    List<Mistake> selectMistakeByPlayer(Player player);

    @Insert("INSERT INTO mistake(player_id,p1,p2,p3,p4,log_time,remark,valid) VALUES(#{playerId},#{p1},#{p2},#{p3},#{p4},#{logTime},#{remark},#{valid})")
    @Options(useGeneratedKeys = true,keyProperty="id")
    int insertMistake(Mistake mistake);

    @Delete("DELETE FROM mistake WHERE id = #{id}")
    int deleteById(int id);
}
