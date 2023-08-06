package per.zpp.workbench.service;

import per.zpp.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    int queryCountOfActivityByCondition(Map<String,Object> map);

    void deleteActivityByIds(String[] id);

    Activity queryActivityById(String id);

    int editActivity(Activity activity);
}
