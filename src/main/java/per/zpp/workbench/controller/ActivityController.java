package per.zpp.workbench.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import per.zpp.commons.constants.SystemConstant;
import per.zpp.commons.domain.ReturnObject;
import per.zpp.commons.utils.DateUtils;
import per.zpp.commons.utils.UUIDUtils;
import per.zpp.settings.domain.User;
import per.zpp.settings.service.UserService;
import per.zpp.workbench.domain.Activity;
import per.zpp.workbench.mapper.ActivityMapper;
import per.zpp.workbench.service.ActivityService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequestMapping("/workbench/activity")
@Controller
public class ActivityController {

    @Autowired
    private ActivityService activityService;
    @Autowired
    private UserService userService;

    @RequestMapping("/toActivityIndex")
    public String toActivityIndex(HttpServletRequest request) {
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList", userList);
        return "workbench/activity/index";
    }

    @RequestMapping("/saveCreateActivity")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session) {
        //封装参数
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        activity.setCreateBy(user.getId());//可能有重名的，所以使用唯一主键进行区分
        try {
            int key = activityService.saveCreateActivity(activity);
            if (key > 0) {
                returnObject.setCode(SystemConstant.SUCCESS_CODE);

            } else {
                returnObject.setCode(SystemConstant.FAIL_CODE);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return returnObject;
    }

    @ResponseBody
    @RequestMapping("/queryActivityByConditionForPage")
    public Object queryActivityByConditionForPage(String name, String owner, String startDate,
                                                  String endDate, int pageNo, int pageSize) {
        System.out.println("name=" + name);
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);//key的值和mapper里面的#{}值一致
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        List<Activity> activities = activityService.queryActivityByConditionForPage(map);
        int totalCount = activityService.queryCountOfActivityByCondition(map);
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("activityList", activities);
        retMap.put("totalCount", totalCount);
        return retMap;
    }

    @RequestMapping("/deleteActivityByIds")
    @ResponseBody//把返回去的东西写成JSON数据回去
    public Object deleteActivityByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            activityService.deleteActivityByIds(id);
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙请重试");
        }
        return returnObject;
    }


    @RequestMapping("/queryActivityById")
    @ResponseBody
    public Object queryActivityById(String id) {
//        System.out.println("哈哈哈哈哈"+activityService.queryActivityById(id));
        System.out.println("act+hahahahhahahhahah  ="+activityService.queryActivityById(id));
        return activityService.queryActivityById(id);
    }
    @RequestMapping("/editActivity")
    @ResponseBody
    public Object editActivity(Activity oldActivity,String id,HttpSession session){
        Activity activity=activityService.queryActivityById(id);
        oldActivity.setCreateTime(activity.getCreateTime());
        oldActivity.setCreateBy(activity.getCreateBy());
        // 获取当前用户的session对象
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        // 封装参数
        oldActivity.setEditTime(DateUtils.formatDateTime(new Date()));
        oldActivity.setEditBy(user.getId()); // 修改用户的id
        ReturnObject returnObject = new ReturnObject();
        try {
            // 保存更新的对应id的市场活动
            int res = activityService.editActivity(oldActivity);
            if (res > 0) { // 更新成功
                returnObject.setCode(SystemConstant.SUCCESS_CODE);
            } else { // 更新失败，服务器端出了问题，为了不影响顾客体验，最好不要直接说出问题
                returnObject.setCode(SystemConstant.FAIL_CODE);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) { // 发生了某些异常，捕获后返回信息
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

}
