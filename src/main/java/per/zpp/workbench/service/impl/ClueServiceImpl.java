package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.Clue;
import per.zpp.workbench.mapper.ClueMapper;
import per.zpp.workbench.service.ClueService;

import java.util.List;
import java.util.Map;

@Service

public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;


    @Override
    public int saveClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.queryClueByConditionForPage(map);
    }

    @Override
    public int queryClueCountByCondition(Map<String, Object> map) {
        return clueMapper.queryCountOfClueByCondition(map);
    }

    @Override
    public int deleteClueByIds(String[] id) {
        return clueMapper.deleteClueByIds(id);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.queryClueById(id);
    }

    @Override
    public int updateClueById(Clue clue) {
        return clueMapper.updateByPrimaryKeySelective(clue);
    }

    @Override
    public Clue selectDetailById(String id) {
        return clueMapper.selectClueDetailById(id);
    }
}
