package kagetora.note.entity.VO;

import java.util.Date;
import java.util.Map;

public class MistakeVO {
    private Date date;
    private Map<String,Integer> data;

    @Override
    public String toString() {
        return "MistakeVO{" +
                "date=" + date +
                ", data=" + data +
                '}';
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Map<String, Integer> getData() {
        return data;
    }

    public void setData(Map<String, Integer> data) {
        this.data = data;
    }
}
