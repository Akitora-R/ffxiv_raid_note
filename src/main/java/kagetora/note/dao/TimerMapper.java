package kagetora.note.dao;

import kagetora.note.entity.Timer;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface TimerMapper {

    @Insert("INSERT INTO timer(begin,end) VALUES(#{begin},#{end})")
    int insertTimer(Timer timer);

    @Select("SELECT * FROM timer")
    List<Timer> selectAllTimer();

    @Select("SELECT * FROM timer WHERE begin>= CURDATE()")
    List<Timer> selectTodayTimer();

    @Delete("DELETE FROM timer")
    void deleteAllTimer();
}
