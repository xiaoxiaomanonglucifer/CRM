package per.zpp.settings.service.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.settings.mapper.DicValueMapper;
import per.zpp.settings.service.DicValueService;
import per.zpp.settings.domain.DicValue;

import java.util.List;
@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }

    @Override
    public DicValue queryDicValueByStageId(String id) {
        return dicValueMapper.selectDicValueByStageId(id);
    }

    @Override
    public String queryStageNoByStageName(String stage) {
        return dicValueMapper.selectStageNoByStageName(stage);
    }
}
