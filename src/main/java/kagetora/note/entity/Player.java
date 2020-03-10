package kagetora.note.entity;

import java.util.List;

public class Player {
    private Integer id;
    private String name;
    private String position;
    private Boolean isActive;
    private List<Mistake> mistake;

    @Override
    public String toString() {
        return "Player{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", position='" + position + '\'' +
                ", isActive=" + isActive +
                ", mistake=" + mistake +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public Boolean getActive() {
        return isActive;
    }

    public void setActive(Boolean active) {
        isActive = active;
    }

    public List<Mistake> getMistake() {
        return mistake;
    }

    public void setMistake(List<Mistake> mistake) {
        this.mistake = mistake;
    }
}
