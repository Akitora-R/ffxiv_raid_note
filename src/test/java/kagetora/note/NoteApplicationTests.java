package kagetora.note;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import kagetora.note.dao.PlayerMapper;
import kagetora.note.entity.Player;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.util.*;

@SpringBootTest
class NoteApplicationTests {
    @Autowired
    PlayerMapper playerMapper;

    @Test
    void contextLoads() {
    }
    @Test
    void test1() {
        List<Player> players = playerMapper.selectAllPlayer();
        System.out.println(players);
    }

    @Test
    void test2(){
        Player player = playerMapper.selectPlayerById(1);
        System.out.println(player);
    }

    @Test
    void test3() throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        Player player = playerMapper.selectPlayerById(1);
        String p = mapper.writeValueAsString(player);
        System.out.println(mapper.readValue(p,Player.class));
    }
}
