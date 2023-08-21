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
import per.zpp.workbench.domain.TranRemark;
import per.zpp.workbench.service.TranRemarkService;
import per.zpp.workbench.service.TranService;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
@RequestMapping("/workbench/transaction")
public class TranRemarkController {
    @Autowired
    private TranRemarkService tranRemarkService;

    @RequestMapping("/saveTranRemark")
    @ResponseBody
    public Object saveTranRemark(TranRemark tranRemark, HttpSession session) {
        User user=(User)session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        tranRemark.setId(UUIDUtils.getUUID());
        tranRemark.setCreateBy(user.getId());
        tranRemark.setEditFlag(SystemConstant.REMARK_FLAG_FALSE);
        tranRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        try {
            int key = tranRemarkService.saveTranRemark(tranRemark);
            if (key > 0) {
                returnObject.setCode(SystemConstant.SUCCESS_CODE);
                returnObject.setRetData(tranRemark);
            } else {
                returnObject.setCode(SystemConstant.FAIL_CODE);
                returnObject.setMessage("系统忙~");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙~");
        }
        return returnObject;
    }

    @RequestMapping("/deleteTranRemarkByRemarkId")
    @ResponseBody
    public Object deleteTranRemarkByRemarkId(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int key = tranRemarkService.deleteTranRemarkByRemarkId(id);
            if (key > 0) {
                returnObject.setCode(SystemConstant.SUCCESS_CODE);
            } else {
                returnObject.setCode(SystemConstant.FAIL_CODE);
                returnObject.setMessage("系统忙~");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙~");
        }
        return returnObject;
    }
}
