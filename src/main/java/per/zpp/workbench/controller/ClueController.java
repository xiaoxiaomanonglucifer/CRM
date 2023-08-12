package per.zpp.workbench.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import per.zpp.commons.constants.SystemConstant;
import per.zpp.commons.domain.ReturnObject;
import per.zpp.commons.utils.DateUtils;
import per.zpp.commons.utils.UUIDUtils;
import per.zpp.settings.domain.DicValue;
import per.zpp.settings.domain.User;
import per.zpp.settings.service.DicValueService;
import per.zpp.settings.service.UserService;
import per.zpp.workbench.domain.Activity;
import per.zpp.workbench.domain.Clue;
import per.zpp.workbench.domain.ClueActivityRelation;
import per.zpp.workbench.domain.ClueRemark;
import per.zpp.workbench.service.ActivityService;
import per.zpp.workbench.service.ClueActivityRelationService;
import per.zpp.workbench.service.ClueRemarkService;
import per.zpp.workbench.service.ClueService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/toClueIndex")
    public String toClueIndex(HttpServletRequest request) {
        //查询用户返回放到作用域中
        List<User> userList = userService.queryAllUsers();
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        // 封装到request域中
        request.setAttribute("userList", userList);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("clueStateList", clueStateList);
        request.setAttribute("sourceList", sourceList);
        return "/workbench/clue/index";
    }

    @ResponseBody
    @RequestMapping("/saveClue")
    public Object saveClue(Clue clue, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        clue.setCreateBy(user.getId());
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));
        int key = clueService.saveClue(clue);
        ReturnObject returnObject = new ReturnObject();
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，请稍后重试~");
        }
        return returnObject;
    }

    @ResponseBody
    @RequestMapping("/queryClueByConditionForPage")
    public Object queryClueByConditionForPage(String fullname, String company,
                                              String phone, String source,
                                              String owner, String mphone, String state, int pageNo, int pageSize) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("fullname", fullname);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        List<Clue> clues = clueService.queryClueByConditionForPage(map);
        int totalCount = clueService.queryClueCountByCondition(map);
        HashMap<String, Object> retMap = new HashMap<>();
        retMap.put("clueList", clues);
        retMap.put("totalCount", totalCount);
        return retMap;
    }

    @RequestMapping("/deleteClueByIds")
    @ResponseBody
    public Object deleteClueByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        int key = clueService.deleteClueByIds(id);
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，稍后重试~");
        }
        return returnObject;
    }

    @RequestMapping("/queryClueById")
    @ResponseBody
    public Object queryClueById(String id) {
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    @RequestMapping("/updateClueById")
    @ResponseBody
    public Object updateClueById(Clue clue, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));
        int key = clueService.updateClueById(clue);
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，稍后重试~");
        }
        return returnObject;
    }

    @RequestMapping("/toDetailIndex")
    public String toDetailIndex(String id, HttpServletRequest request) {
        Clue clue = clueService.selectDetailById(id);
        List<ClueRemark> clueRemarks = clueRemarkService.selectClueRemarkDetailById(id);
        List<Activity> activities = activityService.queryActivityByClueId(id);
        request.setAttribute("clueRemarkList", clueRemarks);
        request.setAttribute("clue", clue);
        request.setAttribute("activityList", activities);
        return "/workbench/clue/detail";
    }

    @ResponseBody
    @RequestMapping("/queryActivityForDetailByNameAndClueId")
    public Object queryActivityForDetailByNameAndClueId(String activityName, String clueId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("clueId", clueId);
        List<Activity> activities = activityService.queryActivityForDetailByNameAndClueId(map);
        return activities;
    }

    @RequestMapping("/saveBound")
    @ResponseBody
    public Object saveBound(String[] activityId, String clueId) {
        ClueActivityRelation car = null;
        List<ClueActivityRelation> carList = new ArrayList<>();
        //封装参数
        for (String actId : activityId) {
            car = new ClueActivityRelation();
            car.setActivityId(actId);
            car.setClueId(clueId);
            car.setId(UUIDUtils.getUUID());
            carList.add(car);
        }
        ReturnObject returnObject = new ReturnObject();
        try {
            int key = clueActivityRelationService.saveCreateClueActivityRelationByList(carList);
            if (key > 0) {
                returnObject.setCode(SystemConstant.SUCCESS_CODE);
                List<Activity> activityList = activityService.selectActivityById(activityId);
                returnObject.setRetData(activityList);
            } else {
                returnObject.setCode(SystemConstant.FAIL_CODE);
                returnObject.setMessage("系统繁忙~");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙~");
        }

        return returnObject;
    }

    @ResponseBody
    @RequestMapping("/deleteBound")
    public Object deleteBound(ClueActivityRelation clueActivityRelation) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int res = clueActivityRelationService.deleteClueActivityRelationByClueIdAndActivityId(clueActivityRelation);
            if (res > 0) {
                returnObject.setCode(SystemConstant.SUCCESS_CODE);
            } else {
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
