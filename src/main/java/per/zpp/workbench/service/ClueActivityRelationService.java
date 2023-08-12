package per.zpp.workbench.service;

import per.zpp.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    int saveCreateClueActivityRelationByList(List<ClueActivityRelation> list);

    int deleteClueActivityRelationByClueIdAndActivityId(ClueActivityRelation clueActivityRelation);
}
