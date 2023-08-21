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
import java.util.*;

@Controller
@RequestMapping("/workbench/contacts")
public class ContactsController {
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;

    @Autowired
    private TranService tranService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;

    @RequestMapping("/toConIndex")
    public String toConIndex(HttpServletRequest request) {
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<User> userList = userService.queryAllUsers();
        List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("userList", userList);
        request.setAttribute("appellation", appellation);
        return "workbench/contacts/index";
    }


    @RequestMapping("/saveContacts")
    @ResponseBody
    public Object saveContacts(Contacts contacts, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setId(UUIDUtils.getUUID());
        int key = contactsService.saveContacts(contacts);
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
            returnObject.setRetData(contacts);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙~");
        }
        return returnObject;
    }

    @RequestMapping("/deleteContactByIds")
    @ResponseBody
    public Object deleteContactByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            contactsService.deleteByIds(id); // 通过联系人id数组删除所有对应的线索以及该线索的所有信息
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } catch (Exception e) { // 发生了某些异常，捕获后返回信息
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/toConDetailIndex")
    public String toConDetailIndex(String id, HttpServletRequest request) {
        List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<User> userList = userService.queryAllUsers();
        Contacts contacts = contactsService.queryById(id);
        List<ContactsRemark> contactsRemarks = contactsRemarkService.queryRemarkById(id);
        List<Tran> tranList = tranService.selectTranByContactsId(id);
        List<Activity> activityList = activityService.queryActivityByContactsId(id);
        for (int i = 0; i < tranList.size(); i++) {
            //解析配置文件、
            ResourceBundle possibility = ResourceBundle.getBundle("possibility");
            String possibilityString = possibility.getString(tranList.get(i).getStage());
            tranList.get(i).setPossibility(possibilityString);
        }
        request.setAttribute("contacts", contacts);
        request.setAttribute("contactsRemarks", contactsRemarks);
        request.setAttribute("tranList", tranList);
        request.setAttribute("activityList", activityList);
        request.setAttribute("appellation", appellation);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("userList", userList);
        return "workbench/contacts/detail";
    }

    @RequestMapping("/deleteBound")
    @ResponseBody
    public Object deleteBound(ContactsActivityRelation contactsActivityRelation) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int res = contactsActivityRelationService.deleteActivityByContactsId(contactsActivityRelation);
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

    @RequestMapping("/saveBound")
    @ResponseBody
    public Object saveBound(String[] activityId, String contactsId) {
        ContactsActivityRelation car = null;
        List<ContactsActivityRelation> carList = new ArrayList<>();
        //封装参数
        for (String actId : activityId) {
            car = new ContactsActivityRelation();
            car.setActivityId(actId);
            car.setContactsId(contactsId);
            car.setId(UUIDUtils.getUUID());
            carList.add(car);
        }
        ReturnObject returnObject = new ReturnObject();
        try {
            int key = contactsActivityRelationService.saveCreateContactsActivityRelationByList(carList);
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


    @RequestMapping("/updateContacts")
    @ResponseBody
    public Object updateContacts(Contacts contacts, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        contacts.setEditBy(user.getId());
        contacts.setEditTime(DateUtils.formatDateTime(new Date()));
        int key = contactsService.updateContacts(contacts);
        ReturnObject returnObject = new ReturnObject();
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统忙~");
        }
        return returnObject;
    }

    @RequestMapping("/queryContactsForPage")
    @ResponseBody
    public Object queryContactsForPage(String owner, String name, String customerId,
                                       String source, String address, int pageNo, int pageSize) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("customerId", customerId);
        map.put("source", source);
        map.put("address", address);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        List<Contacts> contactsList = contactsService.queryContactsForPage(map);
        int totalCount = contactsService.queryCountOfContactsByCondition(map);
        // 封装查询参数，传给前端操作
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("contactsList", contactsList);
        resultMap.put("totalCount", totalCount);
        return resultMap;
    }

    @RequestMapping("/queryContactsById")
    @ResponseBody
    public Object queryContactsById(String id) {
        Contacts contacts = contactsService.queryEditById(id);
        return contacts;
    }

    @RequestMapping("/queryContactsByContactsNameAndTranId")
    @ResponseBody
    public Object queryContactsByContactsNameAndTranId(String contactsName, String tranId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("contactsName", contactsName);
        map.put("tranId", tranId);
        List<Contacts> contactsList = contactsService.queryContactsByContactsNameAndTranId(map);
        return contactsList;
    }
}
