package per.zpp.workbench.service;

import per.zpp.workbench.domain.Clue;
import per.zpp.workbench.domain.FunnelVO;

import java.util.List;
import java.util.Map;

public interface ClueService {

    int saveClue(Clue clue);

    List<Clue> queryClueByConditionForPage(Map<String, Object> map);

    int queryClueCountByCondition(Map<String, Object> map);

    void deleteClueByIds(String id[]);

    Clue queryClueById(String id);

    int updateClueById(Clue clue);

    Clue selectDetailById(String id);

    void saveConvert(Map<String, Object> map);


    List<String> queryClueStageOfClueGroupByClueStage();

    List<Integer> queryCountOfClueGroupByClueStage();
}
