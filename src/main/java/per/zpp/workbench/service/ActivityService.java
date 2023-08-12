package per.zpp.workbench.service;

import per.zpp.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String, Object> map);

    int queryCountOfActivityByCondition(Map<String, Object> map);

    void deleteActivityByIds(String[] id);

    Activity queryActivityById(String id);

    int editActivity(Activity activity);

    List<Activity> selectAllActivity();

    List<Activity> selectActivityById(String[] ids);

    int saveActivityByList(List<Activity> activityList);

    Activity selectActivityDetailById(String id);

    List<Activity> queryActivityByClueId(String clueId);

    List<Activity> queryActivityForDetailByNameAndClueId(Map<String,Object> map);

    List<Activity> queryActivityByActivityIds(String ids[]);
}
