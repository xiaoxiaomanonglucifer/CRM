package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.ClueRemark;
import per.zpp.workbench.mapper.ClueRemarkMapper;
import per.zpp.workbench.service.ClueRemarkService;
import per.zpp.workbench.service.ClueService;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public int saveClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insert(clueRemark);
    }

    @Override
    public List<ClueRemark> selectClueRemarkDetailById(String id) {
        return clueRemarkMapper.selectClueRemarkDetailById(id);
    }

    @Override
    public int updateClueRemarkById(ClueRemark clueRemark) {
        return clueRemarkMapper.updateClueRemarkById(clueRemark);
    }

    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteByPrimaryKey(id);
    }
}
