package per.zpp.workbench.service;

import per.zpp.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkService {
    List<TranRemark> selectTranRemarkDetailById(String id);

    int updateTranRemarkByRemarkId(TranRemark tranRemark);

    int deleteTranRemarkByRemarkId(String id);

    int saveTranRemark(TranRemark tranRemark);
}
