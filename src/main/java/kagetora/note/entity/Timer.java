package kagetora.note.entity;

import java.util.Date;

public class Timer {
    private Integer id;
    private Date begin;
    private Date end;

    public Timer(Integer id, Date begin, Date end) {
        this.id = id;
        this.begin = begin;
        this.end = end;
    }

    public Timer() {
    }

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
