package per.zpp.workbench.service.impl;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.Activity;
import per.zpp.workbench.mapper.ActivityMapper;
import per.zpp.workbench.service.ActivityService;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public void deleteActivityByIds(String[] id) {
        activityMapper.deleteActivityByIds(id);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.queryActivityById(id);
    }

    @Override
    public int editActivity(Activity activity) {
        return activityMapper.editActivity(activity);
    }

    @Override
    public List<Activity> selectAllActivity() {
        return activityMapper.selectAllActivity();
    }

    @Override
    public List<Activity> selectActivityById(String []ids) {
        return activityMapper.selectActivityById(ids);
    }

    @Override
    public int saveActivityByList(List<Activity> activityList) {
        return activityMapper.insertActivityByList(activityList);
    }

    @Override
    public Activity selectActivityDetailById(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

}
