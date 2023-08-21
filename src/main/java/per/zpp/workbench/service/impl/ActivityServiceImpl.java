package per.zpp.workbench.service.impl;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.Activity;
import per.zpp.workbench.domain.FunnelVO;
import per.zpp.workbench.mapper.ActivityMapper;
import per.zpp.workbench.mapper.ActivityRemarkMapper;
import per.zpp.workbench.service.ActivityService;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

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
        //删除和市场活动相关评论
        activityRemarkMapper.deleteRemarkByIds(id);
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
    public List<Activity> selectActivityById(String[] ids) {
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

    @Override
    public List<Activity> queryActivityByClueId(String clueId) {
        return activityMapper.selectActivityDetailByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityForDetailByNameAndClueId(Map<String, Object> map) {
        return activityMapper.selectAllActivityForDetailByNameAndClueId(map);
    }

    @Override
    public List<Activity> queryActivityByActivityIds(String[] ids) {
        return activityMapper.selectActivityByActivityIds(ids);
    }

    @Override
    public List<Activity> queryActivityForConvertByNameAndClueId(HashMap<String, Object> map) {
        return activityMapper.selectActivityForConvertByNameAndClueId(map);
    }

    @Override
    public List<Activity> queryActivityByActivityName(String activityName) {
        return activityMapper.selectActivityByActivityName(activityName);
    }

    @Override
    public List<FunnelVO> queryCountOfActivityGroupByOwner() {
        return activityMapper.selectCountOfActivityGroupByOwner();
    }

    @Override
    public List<Activity> queryActivityByContactsId(String id) {
        return activityMapper.selectActivityDetailByContactsId(id);
    }

    @Override
    public List<Activity> queryActivityByActivityNameAndContactsId(HashMap<String, Object> map) {
        return activityMapper.selectActivityByActivityNameAndContactsId(map);
    }

    @Override
    public List<Activity> queryActivityByActivityNameAndTranId(HashMap<String, Object> map) {
        return activityMapper.selectActivityByActivityNameAndTranId(map);
    }

}
