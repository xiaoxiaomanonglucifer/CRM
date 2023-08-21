package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.TranRemark;
import per.zpp.workbench.mapper.TranRemarkMapper;
import per.zpp.workbench.service.TranRemarkService;

import java.util.List;

@Service
public class TranRemarkServiceImpl implements TranRemarkService {
    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public List<TranRemark> selectTranRemarkDetailById(String id) {
        return tranRemarkMapper.selectTranRemarkById(id);
    }

    @Override
    public int updateTranRemarkByRemarkId(TranRemark tranRemark) {
        return tranRemarkMapper.updateTranRemarkByRemarkId(tranRemark);
    }

    @Override
    public int deleteTranRemarkByRemarkId(String id) {
        return tranRemarkMapper.deleteTranRemarkByRemarkId(id);
    }

    @Override
    public int saveTranRemark(TranRemark tranRemark) {
        return tranRemarkMapper.insertRemark(tranRemark);
    }
}
