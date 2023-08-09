package per.zpp.workbench.service;

import per.zpp.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String id);

    int saveCreateActivityRemark(ActivityRemark activityRemark);

    int deleteActivityRemark(String id);

    int updateActivityRemarkById(ActivityRemark remark);
}
