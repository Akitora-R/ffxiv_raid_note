package kagetora.note.entity;

import java.util.Date;

public class Progress {
    Integer id;
    Integer progress;
    Date date;

    @Override
    public String toString() {
        return "Progress{" +
                "id=" + id +
                ", progress=" + progress +
                ", date=" + date +
                '}';
    }

    public Progress(Integer id, Integer progress, Date date) {
        this.id = id;
        this.progress = progress;
        this.date = date;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getProgress() {
        return progress;
    }

    public void setProgress(Integer progress) {
        this.progress = progress;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
