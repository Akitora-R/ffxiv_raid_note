package kagetora.note.dao;

import kagetora.note.entity.Phase;
import kagetora.note.entity.Progress;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
@Mapper
@Repository
public interface ProgressMapper {
    @Select("SELECT * FROM phase ORDER BY id")
    List<Phase> selectAllPhases();

    @Select("SELECT (SELECT p.progress FROM progress p ORDER BY p.date DESC LIMIT 1)/(SELECT count(*) FROM phase)")
    BigDecimal selectProgressPercentage();

    @Select("SELECT id,phase,point,detail FROM phase WHERE id=(SELECT p.progress FROM progress p ORDER BY p.date DESC LIMIT 1)")
    Phase selectLatestPhase();

    @Insert("INSERT INTO progress(progress,date) VALUES(#{progress},#{date})")
    void insertProgress(Progress progress);
}
