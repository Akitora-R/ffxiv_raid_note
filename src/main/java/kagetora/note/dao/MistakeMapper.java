package kagetora.note.dao;

import kagetora.note.entity.Mistake;
import kagetora.note.entity.Player;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;
@Mapper
@Repository
public interface MistakeMapper {
    @Select("SELECT * FROM mistake WHERE id = #{id}")
    Mistake selectMistakeById(int id);

    @Select("SELECT * FROM mistake WHERE player_id = #{id}")
    List<Mistake> selectMistakeByPlayer(Player player);

    @Insert("INSERT INTO mistake(player_id,p1,p2,p3,p4,log_time,remark) VALUES(#{playerId},#{p1},#{p2},#{p3},#{p4},#{logTime},#{remark})")
    @Options(useGeneratedKeys = true,keyProperty="id")
    int insertMistake(Mistake mistake);
}
