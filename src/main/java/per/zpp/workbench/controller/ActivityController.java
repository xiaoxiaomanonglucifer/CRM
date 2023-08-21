package per.zpp.workbench.controller;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import per.zpp.commons.constants.SystemConstant;
import per.zpp.commons.domain.ReturnObject;
import per.zpp.commons.utils.DateUtils;
import per.zpp.commons.utils.HSSFUtils;
import per.zpp.commons.utils.UUIDUtils;
import per.zpp.settings.domain.User;
import per.zpp.settings.service.UserService;
import per.zpp.workbench.domain.Activity;
import per.zpp.workbench.domain.ActivityRemark;
import per.zpp.workbench.service.ActivityRemarkService;
import per.zpp.workbench.service.ActivityService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.InputStream;
import java.util.*;

@RequestMapping("/workbench/activity")
@Controller
public class ActivityController {

    @Autowired
    private ActivityService activityService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/toActivityIndex")
    public String toActivityIndex(HttpServletRequest request) {
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList", userList);
        return "/workbench/activity/index";
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
        return activityService.queryActivityById(id);
    }

    @RequestMapping("/editActivity")
    @ResponseBody
    public Object editActivity(Activity oldActivity, String id, HttpSession session) {
        Activity activity = activityService.queryActivityById(id);
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


    @RequestMapping("/exportAllActivities")
    public void exportAllActivities(HttpServletResponse response) throws Exception {
        List<Activity> activityList = activityService.selectAllActivity();
        HSSFUtils.createExcelFileByActivity(activityList, response, SystemConstant.FILE_NAME);

    }

    /**
     * @param id       名称要和前端传过来的参数一致
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportActivityByIds")
    public void exportActivityByIds(String[] id, HttpServletResponse response) throws Exception {
        List<Activity> activityList = activityService.selectActivityById(id);
        HSSFUtils.createExcelFileByActivity(activityList, response, SystemConstant.FILE_NAME);
    }

    @ResponseBody
    @RequestMapping("/importActivity")
    public Object importActivity(MultipartFile activityFile, HttpSession session) throws Exception {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        try {
            InputStream is = activityFile.getInputStream();
            HSSFWorkbook wb = new HSSFWorkbook(is);
            // 根据wb获取HSSFSheet对象，封装了一页的所有信息
            HSSFSheet sheet = wb.getSheetAt(0); // 页的下标，下标从0开始，依次增加
            // 根据sheet获取HSSFRow对象，封装了一行的所有信息

            HSSFRow row = null;
            HSSFCell cell = null;
            Activity activity = null;
            List<Activity> activityList = new ArrayList<>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++) { // row.getLastCellNum():最后一列的下标+1
                row = sheet.getRow(i);
                activity = new Activity();
                // 补充部分参数
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());//市场活动 拥有者是导入的人，导入的人就是当前登录的人
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));
                activity.setCreateBy(user.getId());//市场活动创建者是导入的人
                for (int j = 0; j < row.getLastCellNum(); j++) { // row.getLastCellNum():最后一列的下标+1
                    // 根据row获取HSSFCell对象，封装了一列的所有信息
                    cell = row.getCell(j);
                    String cellValue = HSSFUtils.getCellValueType(cell);
                    //第一行是活动名字0  第二行是开始时间1  第二列是结束时间2
                    if (j == 0) {
                        activity.setName(cellValue);
                    } else if (j == 1) {
                        activity.setStartDate(cellValue);
                    } else if (j == 2) {
                        activity.setEndDate(cellValue);
                    } else if (j == 3) {
                        activity.setCost(cellValue);
                    } else if (j == 4) {
                        activity.setDescription(cellValue);
                    }
                }
                activityList.add(activity);
            }
            int res = activityService.saveActivityByList(activityList);
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
            returnObject.setRetData(res);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/toDetailIndex")
    public String toDetailIndex(String id, HttpServletRequest request) {
        //根据id查询对应的市场活动的详细信息
        Activity activity = activityService.selectActivityDetailById(id);
        // 对应id的市场活动所有的备注
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        // 存入请求域中
        request.setAttribute("activity", activity);
        request.setAttribute("activityRemarkList", activityRemarkList);
        return "/workbench/activity/detail";
    }

    @RequestMapping("/queryActivityByActivityNameAndContactsId")
    @ResponseBody
    public Object queryActivityByActivityNameAndContactsId(String activityName, String contactsId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("contactsId", contactsId);
        List<Activity> activityList = activityService.queryActivityByActivityNameAndContactsId(map);
        return activityList;


    }

    @RequestMapping("/queryActivityByActivityNameAndTranId")
    @ResponseBody
    public Object queryActivityByActivityNameAndTranId(String activityName, String tranId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("tranId", tranId);
        List<Activity> activityList = activityService.queryActivityByActivityNameAndTranId(map);
        return activityList;


    }
}


