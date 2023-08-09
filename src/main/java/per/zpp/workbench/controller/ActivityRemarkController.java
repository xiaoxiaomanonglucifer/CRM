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
import per.zpp.workbench.domain.ActivityRemark;
import per.zpp.workbench.service.impl.ActivityRemarkServiceImpl;
import per.zpp.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkServiceImpl activityRemarkService;

    @ResponseBody
    @RequestMapping("/saveCreateActivityRemark")
    public Object saveCreateActivityRemark(ActivityRemark remark, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateTime(DateUtils.formatDateTime(new Date()));
        remark.setCreateBy(user.getId());
        remark.setEditFlag(SystemConstant.REMARK_FLAG_FALSE);
        try {
            int key = activityRemarkService.saveCreateActivityRemark(remark);
            if (key > 0) {
                returnObject.setCode(SystemConstant.SUCCESS_CODE);
                returnObject.setRetData(remark);
            } else {
                returnObject.setCode(SystemConstant.FAIL_CODE);
                returnObject.setMessage("系统忙稍后重试~");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙稍后重试~");
        }
        return returnObject;
    }

    @ResponseBody
    @RequestMapping("/deleteActivityRemark")
    public Object deleteActivityRemark(String id) {
        int key = activityRemarkService.deleteActivityRemark(id);
        ReturnObject returnObject = new ReturnObject();
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，稍后再试~");
        }

        return returnObject;
    }

    @ResponseBody
    @RequestMapping("/updateActivityRemarkById")
    public Object updateActivityRemarkById(ActivityRemark remark,HttpSession session) {
        User user=(User)session.getAttribute(SystemConstant.SESSION_USER);
        remark.setEditFlag(SystemConstant.REMARK_FLAG_TRUE);
        remark.setEditBy(user.getId());
        remark.setEditTime(DateUtils.formatDateTime(new Date()));
        int key = activityRemarkService.updateActivityRemarkById(remark);
        ReturnObject returnObject = new ReturnObject();
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
            returnObject.setRetData(remark);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，稍后再试~");
        }
        return returnObject;
    }
}
