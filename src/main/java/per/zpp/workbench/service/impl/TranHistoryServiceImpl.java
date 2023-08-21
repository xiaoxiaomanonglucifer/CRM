package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.TranHistory;
import per.zpp.workbench.mapper.TranHistoryMapper;
import per.zpp.workbench.service.TranHistoryService;

import java.util.List;

@Service
public class TranHistoryServiceImpl implements TranHistoryService {

    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    @Override
    public List<TranHistory> selectTranHisDetailById(String id) {
        return tranHistoryMapper.selectTranHisDetailById(id);
    }
}
