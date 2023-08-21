package per.zpp.workbench.service;

import per.zpp.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryService {
    List<TranHistory> selectTranHisDetailById(String id);
}
