package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.ActivityRemark;
import per.zpp.workbench.mapper.ActivityRemarkMapper;
import per.zpp.workbench.service.ActivityRemarkService;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String id) {
        return activityRemarkMapper.queryActivityRemarkForDetailByActivityId(id);
    }

    @Override
    public int saveCreateActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insert(activityRemark);
    }

    @Override
    public int deleteActivityRemark(String id) {
        return activityRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int updateActivityRemarkById(ActivityRemark remark) {
        return activityRemarkMapper.updateRemarkById(remark);
    }


}
