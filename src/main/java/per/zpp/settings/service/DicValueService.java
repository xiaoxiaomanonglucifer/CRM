package per.zpp.settings.service;

import per.zpp.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {

    List<DicValue> queryDicValueByTypeCode(String typeCode);

    DicValue queryDicValueByStageId(String id);

    String queryStageNoByStageName(String stage);
}
