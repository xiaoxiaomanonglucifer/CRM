package per.zpp.workbench.service;

import per.zpp.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {


    int saveClueRemark(ClueRemark clueRemark);

    List<ClueRemark> selectClueRemarkDetailById(String id);

    int updateClueRemarkById(ClueRemark clueRemark);

    int deleteClueRemarkById(String id);
}
