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
import per.zpp.workbench.domain.CustomerRemark;
import per.zpp.workbench.service.CustomerRemarkService;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
@RequestMapping("/workbench/customer")
public class CustomerRemarkController {

    @Autowired
    private CustomerRemarkService customerRemarkService;

    @ResponseBody
    @RequestMapping("/saveCustomerRemark")
    public Object saveCustomerRemark(CustomerRemark customerRemark, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        customerRemark.setEditFlag(SystemConstant.REMARK_FLAG_FALSE);
        customerRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        customerRemark.setId(UUIDUtils.getUUID());
        customerRemark.setCreateBy(user.getId());
        int key = customerRemarkService.saveCustomerRemark(customerRemark);
        ReturnObject returnObject = new ReturnObject();
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
            returnObject.setRetData(customerRemark);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙～");
        }
        return returnObject;
    }

    @RequestMapping("/updateCusRemarkByRemarkId")
    @ResponseBody
    public Object updateCusRemarkByRemarkId(CustomerRemark customerRemark,HttpSession session){
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        customerRemark.setEditFlag(SystemConstant.REMARK_FLAG_TRUE);
        customerRemark.setEditBy(user.getId());
        customerRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        int key = customerRemarkService.updateCusRemarkByRemarkId(customerRemark);
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
            returnObject.setRetData(customerRemark);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙稍后重试~");
        }

        return returnObject;
    }

    @RequestMapping("/deleteCusRemarkByRemarkId")
    @ResponseBody
    public Object deleteCusRemarkByRemarkId(String id){
        int key=customerRemarkService.deleteCusRemarkByRemarkId(id);
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
