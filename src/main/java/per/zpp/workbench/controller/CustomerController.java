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
import per.zpp.workbench.domain.Contacts;
import per.zpp.workbench.domain.Customer;
import per.zpp.workbench.domain.CustomerRemark;
import per.zpp.workbench.domain.Tran;
import per.zpp.workbench.service.ContactsService;
import per.zpp.workbench.service.CustomerRemarkService;
import per.zpp.workbench.service.CustomerService;
import per.zpp.workbench.service.TranService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.ResourceBundle;

@Controller
@RequestMapping("/workbench/customer")
public class CustomerController {
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private TranService tranService;

    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("/toCusIndex")
    public String toCusIndex(HttpServletRequest request) {
        //查询所有user
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList", userList);
        return "workbench/customer/index";
    }

    @RequestMapping("/queryCustomerByConditionForPage")
    @ResponseBody
    public Object queryCustomerByConditionForPage(String name, String owner, String phone, String website,
                                                  int pageNo, int pageSize) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("phone", phone);
        map.put("website", website);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        List<Customer> customerList = customerService.queryCustomerByConditionForPage(map);
        int totalCount = customerService.queryCountOfCustomerByConditionForPage(map);
        HashMap<String, Object> retMap = new HashMap<>();
        retMap.put("customerList", customerList);
        retMap.put("totalCount", totalCount);
        return retMap;
    }

    @RequestMapping("/saveCustomer")
    @ResponseBody
    public Object saveCustomer(Customer customer, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setCreateBy(user.getId());
        ReturnObject returnObject = new ReturnObject();
        int key = customerService.saveCustomer(customer);
        if (key > 0) {
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } else {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，请稍后重试~");
        }
        return returnObject;
    }

    @RequestMapping("/deleteCusByIds")
    @ResponseBody
    public Object deleteCusByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            customerService.deleteCusByIds(id); // 通过联系人id数组删除所有对应的线索以及该线索的所有信息
            returnObject.setCode(SystemConstant.SUCCESS_CODE);
        } catch (Exception e) { // 发生了某些异常，捕获后返回信息
            e.printStackTrace();
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/queryCustomerById")
    @ResponseBody
    public Object queryCustomerById(String id) {
        Customer customer = customerService.queryCustomerById(id);
        return customer;
    }

    @RequestMapping("/editCustomer")
    @ResponseBody
    public Object editCustomer(Customer customer, HttpSession session) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtils.formatDateTime(new Date()));
        int key = customerService.editCustomer(customer);
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
        Customer customer = customerService.selectCustomerDetailById(id);
        List<User> userList = userService.queryAllUsers();
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryAllCustomerRemarkById(id);
        List<Tran> tranList = tranService.selectTranByContactsId(id);
        List<Contacts> contactsList = contactsService.queryContactsById(id);
        List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        for (int i = 0; i < tranList.size(); i++) {
            //解析配置文件、
            ResourceBundle possibility = ResourceBundle.getBundle("possibility");
            String possibilityString = possibility.getString(tranList.get(i).getStage());
            tranList.get(i).setPossibility(possibilityString);
        }
        request.setAttribute("customer", customer);
        request.setAttribute("customerRemarkList", customerRemarkList);
        request.setAttribute("userList", userList);
        request.setAttribute("tranList", tranList);
        request.setAttribute("contactsList", contactsList);
        request.setAttribute("appellation", appellation);
        request.setAttribute("sourceList", sourceList);
        return "/workbench/customer/detail";
    }

}
