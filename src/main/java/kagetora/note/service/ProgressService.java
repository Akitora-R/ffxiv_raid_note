package kagetora.note.service;

import kagetora.note.dao.ProgressMapper;
import kagetora.note.entity.Phase;
import kagetora.note.entity.Progress;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@Service
public class ProgressService {
    private ProgressMapper progressMapper;

    public List<Phase> getAllPhases() {
        return progressMapper.selectAllPhases();
    }

    public void setProgress(Progress progress) {
        progressMapper.insertProgress(progress);
    }

    public BigDecimal getProgressPercentage() {
        return progressMapper.selectProgressPercentage();
    }

    public Phase getLatestPhase() {
        return progressMapper.selectLatestPhase();
    }

    public String getProgressStatement() {
        Phase phase = this.getLatestPhase();
        if (phase==null){
            return "从零开始的亚历山大";
        }
        return this.getProgressPercentage().multiply(new BigDecimal("100")).setScale(1, RoundingMode.HALF_EVEN) + "% (" + "P" + phase.getPhase() + phase.getDetail() + ")";
    }

    @Autowired
    public ProgressService(ProgressMapper progressMapper) {
        this.progressMapper = progressMapper;
    }
}
