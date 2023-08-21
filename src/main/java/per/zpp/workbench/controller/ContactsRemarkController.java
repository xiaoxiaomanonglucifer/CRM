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
import per.zpp.workbench.domain.ContactsRemark;
import per.zpp.workbench.service.ContactsRemarkService;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
@RequestMapping("/workbench/contacts")
public class ContactsRemarkController {

    @Autowired
    private ContactsRemarkService contactsRemarkService;

    @RequestMapping("/saveRemark")
    @ResponseBody
    public Object saveRemark(ContactsRemark contactsRemark, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        contactsRemark.setId(UUIDUtils.getUUID());
        contactsRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        contactsRemark.setCreateBy(user.getId());
        contactsRemark.setEditFlag(SystemConstant.REMARK_FLAG_FALSE);
        int key = contactsRemarkService.saveRemark(contactsRemark);
        ReturnObject returnObject = new ReturnObject();
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
            returnObject.setRetData(contactsRemark);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙～");
        }
        return returnObject;
    }

    @RequestMapping("/updateRemark")
    @ResponseBody
    public Object updateRemark(ContactsRemark contactsRemark, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        contactsRemark.setEditFlag(SystemConstant.REMARK_FLAG_TRUE);
        contactsRemark.setEditBy(user.getId());
        contactsRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        int key = contactsRemarkService.updateRemarkByRemarkId(contactsRemark);
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
            returnObject.setRetData(contactsRemark);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙稍后重试~");
        }

        return returnObject;
    }

    @RequestMapping("/deleteRemarkById")
    @ResponseBody
    public Object deleteRemarkById(String id) {
        int key = contactsRemarkService.deleteRemarkById(id);
        ReturnObject returnObject = new ReturnObject();
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙稍后重试~");
        }
        return returnObject;
    }


}
