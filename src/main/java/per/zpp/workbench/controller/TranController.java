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
import per.zpp.workbench.domain.*;
import per.zpp.workbench.service.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.ResourceBundle;

@Controller
@RequestMapping("/workbench/transaction")
public class TranController {

    @Autowired
    private TranHistoryService tranHistoryService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;

    @Autowired
    private TranService tranService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TranRemarkService tranRemarkService;

    @RequestMapping("/toTranIndex")
    public String toTranIndex(HttpServletRequest request) {
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> transactionType = dicValueService.queryDicValueByTypeCode("transactionType");
        request.setAttribute("stageList", stage);
        request.setAttribute("sourceList", source);
        request.setAttribute("transactionTypeList", transactionType);
        return "/workbench/transaction/index";
    }

    @RequestMapping("/toSaveIndex")
    public String toSaveIndex(HttpServletRequest request) {
        //查询用户返回放到作用域中
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> transactionType = dicValueService.queryDicValueByTypeCode("transactionType");
        request.setAttribute("stageList", stage);
        request.setAttribute("sourceList", source);
        request.setAttribute("transactionType", transactionType);
        request.setAttribute("userList", userList);
        return "/workbench/transaction/save";
    }

    @RequestMapping("/queryTranByConditionForPage")
    @ResponseBody
    public Object queryTranByConditionForPage(String owner, String name, String customerId,
                                              String stage, String source, String contactsId,
                                              int pageNo, int pageSize) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("customerId", customerId);
        map.put("stage", stage);
        map.put("source", source);
        map.put("contactsId", contactsId);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        List<Tran> tranList = tranService.queryTranByConditionForPage(map);
        int totalCount = tranService.queryTranCountForPage(map);
        HashMap<String, Object> retMap = new HashMap<>();
        retMap.put("tranList", tranList);
        retMap.put("totalCount", totalCount);
        return retMap;
    }


    @RequestMapping("/queryAllActivityByActivityName")
    @ResponseBody
    public Object queryAllActivityByActivityName(String activityName) {
        List<Activity> activityList = activityService.queryActivityByActivityName(activityName);
        return activityList;
    }

    @RequestMapping("/queryContactsByContactsName")
    @ResponseBody
    public Object queryContactsByContactsName(String contactsName) {
        List<Contacts> contactsList = contactsService.queryContactsByContactsName(contactsName);
        return contactsList;
    }


    @RequestMapping("/getPossibilityByStage")
    @ResponseBody
    public Object getPossibilityByStage(String stage) {
        //解析配置文件、
        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        String possibilityString = possibility.getString(stage);
        return possibilityString;
    }

    @RequestMapping("/queryCustomerNameByFuzzyName")
    @ResponseBody
    public Object queryCustomerNameByFuzzyName(String customerName) {
        List<String> customerList = customerService.queryAllCustomerByCustomerName(customerName);
        return customerList;
    }


    @RequestMapping("/saveCreateTransaction")
    @ResponseBody
    public Object saveCreateTransaction(Tran tran, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        tran.setId(UUIDUtils.getUUID());
        tran.setCreateTime(DateUtils.formatDateTime(new Date()));
        tran.setCreateBy(user.getId());
        tranService.saveCreateTran(tran);
        returnObject.setCode(SystemConstant.SUCCESS_CODE);
        return returnObject;
    }

    @RequestMapping("/toDetailIndex")
    public String toDetailIndex(String id, HttpServletRequest request) {
        Tran tran = tranService.selectTranById(id);
        List<TranRemark> tranRemarkList = tranRemarkService.selectTranRemarkDetailById(id);
        List<TranHistory> tranHistoryList = tranHistoryService.selectTranHisDetailById(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        //查Tran的stage对应No的多少
        String stageOrderNo = dicValueService.queryDicValueByStageId(tranService.selectTransactionById(id).getStage()).getOrderNo();
        //解析配置文件、
        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        String possibilityString = possibility.getString(tran.getStage());
        request.setAttribute("tran", tran);
        request.setAttribute("possibility", possibilityString);
        request.setAttribute("tranRemarkList", tranRemarkList);
        request.setAttribute("tranHistoryList", tranHistoryList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("stageOrderNo", stageOrderNo);
        return "workbench/transaction/detail";
    }

    @ResponseBody
    @RequestMapping("/updateTranRemarkByRemarkId")
    public Object updateTranRemarkByRemarkId(TranRemark tranRemark, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        tranRemark.setEditFlag(SystemConstant.REMARK_FLAG_TRUE);
        tranRemark.setEditBy(user.getId());
        tranRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try {
            int key = tranRemarkService.updateTranRemarkByRemarkId(tranRemark);
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


    @RequestMapping("/toEditIndex")
    public String toEditIndex(String id, HttpServletRequest request) {
        List<User> userList = userService.queryAllUsers();
        Tran tran = tranService.selectTranById(id);
        Tran editTran=tranService.selectEditTranById(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        String possibilityString = possibility.getString(tran.getStage());
        tran.setPossibility(possibilityString);
        request.setAttribute("tran", tran);
        request.setAttribute("editTran", editTran);
        request.setAttribute("userList", userList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("typeList", typeList);
        request.setAttribute("sourceList", sourceList);

        return "workbench/transaction/edit";
    }

    @RequestMapping("/deleteTranByIds")
    @ResponseBody
    public Object deleteTranByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            tranService.deleteByTranIds(id); // 通过联系人id数组删除所有对应的交易以及交易的所有信息
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } catch (Exception e) { // 发生了某些异常，捕获后返回信息
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }


    @RequestMapping("/editTransaction")
    @ResponseBody
    public Object editTransaction(Tran tran, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        tran.setEditBy(user.getId());
        tran.setEditTime(DateUtils.formatDateTime(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try {
            tranService.editTran(tran); // 通过联系人id数组删除所有对应的交易以及交易的所有信息
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } catch (Exception e) { // 发生了某些异常，捕获后返回信息
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

}
