package kagetora.note.entity;

import java.util.Date;

public class Timer {
    private int id;
    private Date begin;
    private Date end;

    @Override
    public String toString() {
        return "Timer{" +
                "id=" + id +
                ", begin=" + begin +
                ", end=" + end +
                '}';
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getBegin() {
        return begin;
    }

    public void setBegin(Date begin) {
        this.begin = begin;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }
}
