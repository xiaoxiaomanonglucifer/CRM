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
import per.zpp.workbench.domain.ClueRemark;
import per.zpp.workbench.service.ClueRemarkService;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
@RequestMapping("/workbench/clue")
public class clueRemarkController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/saveClueRemark")
    @ResponseBody
    public Object saveClueRemark(ClueRemark clueRemark, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setEditFlag(SystemConstant.REMARK_FLAG_FALSE);
        try {
            int key = clueRemarkService.saveClueRemark(clueRemark);
            if (key > 0) {
                returnObject.setCode(SystemConstant.SUCCESS_CODE);
                returnObject.setRetData(clueRemark);
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
    @RequestMapping("/updateClueRemarkById")
    public Object updateClueRemarkById(ClueRemark clueRemark, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        clueRemark.setEditFlag(SystemConstant.REMARK_FLAG_TRUE);
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        int key = clueRemarkService.updateClueRemarkById(clueRemark);
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
            returnObject.setRetData(clueRemark);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙稍后重试~");
        }

        return returnObject;
    }
    @ResponseBody
    @RequestMapping("/deleteClueRemarkById")
    public Object deleteClueRemarkById(String id){
    int key=clueRemarkService.deleteClueRemarkById(id);
        ReturnObject returnObject = new ReturnObject();
        if(key>0){
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        }else{
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙~");
        }
        return returnObject;
    }

}
