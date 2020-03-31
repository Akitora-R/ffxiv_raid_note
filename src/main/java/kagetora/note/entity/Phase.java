package kagetora.note.entity;

public class Phase {
    Integer id;
    Integer phase;
    Integer point;
    String detail;

    @Override
    public String toString() {
        return "Phase{" +
                "id=" + id +
                ", phase=" + phase +
                ", point=" + point +
                ", detail='" + detail + '\'' +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPhase() {
        return phase;
    }

    public void setPhase(Integer phase) {
        this.phase = phase;
    }

    public Integer getPoint() {
        return point;
    }

    public void setPoint(Integer point) {
        this.point = point;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }
}
