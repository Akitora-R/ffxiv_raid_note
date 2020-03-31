package kagetora.note.service;

import kagetora.note.dao.ProgressMapper;
import kagetora.note.entity.Phase;
import kagetora.note.entity.Progress;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProgressService {
    private ProgressMapper progressMapper;

    public List<Phase> getAllPhases(){
        return progressMapper.selectAllPhases();
    }

    public void setProgress(Progress progress){
        progressMapper.insertProgress(progress);
    }

    @Autowired
    public ProgressService(ProgressMapper progressMapper) {
        this.progressMapper = progressMapper;
    }
}
