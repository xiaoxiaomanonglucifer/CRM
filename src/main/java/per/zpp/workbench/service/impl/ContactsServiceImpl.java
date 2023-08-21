package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.commons.utils.DateUtils;
import per.zpp.commons.utils.UUIDUtils;
import per.zpp.workbench.domain.Contacts;
import per.zpp.workbench.domain.Customer;
import per.zpp.workbench.domain.FunnelVO;
import per.zpp.workbench.mapper.ContactsActivityRelationMapper;
import per.zpp.workbench.mapper.ContactsMapper;
import per.zpp.workbench.mapper.ContactsRemarkMapper;
import per.zpp.workbench.mapper.CustomerMapper;
import per.zpp.workbench.service.ContactsRemarkService;
import per.zpp.workbench.service.ContactsService;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Override
    public List<Contacts> queryContactsByContactsName(String contactsName) {
        return contactsMapper.selectContactsByFuzzyName(contactsName);
    }

    @Override
    public List<FunnelVO> queryCountOfCustomerAndContactsGroupByCustomer() {
        return contactsMapper.queryCountOfCustomerAndContactsGroupByCustomer();
    }

    @Override
    public List<Contacts> queryContactsById(String id) {
        return contactsMapper.selectContactById(id);
    }

    @Override
    public int saveContacts(Contacts contacts) {
        //根据前台传递的模糊name查询此客户id是否存在
        String customerId = customerMapper.selectCustomerIdByName(contacts.getCustomerId());
        if (customerId != null) {
            contacts.setCustomerId(customerId);
        } else {
            Customer customer = new Customer();
            customer.setOwner(contacts.getCreateBy());
            customer.setName(contacts.getCustomerId());
            customer.setId(UUIDUtils.getUUID());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customer.setCreateBy(contacts.getCreateBy());
            customerMapper.insertCustomer(customer); // 新增用户
            contacts.setCustomerId(customer.getId()); // 修改联系人的用户为该用户id
        }
        return contactsMapper.insertCon(contacts);
    }

    @Override
    public void deleteByIds(String[] id) {
        contactsRemarkMapper.deleteContactsRemarkByContactsId(id);
        // 删除关联关系
        contactsActivityRelationMapper.deleteContactsActivityRelationByContactsIds(id);
        // 删除联系人
         contactsMapper.deleteByIds(id);
    }

    @Override
    public Contacts queryById(String id) {
        return contactsMapper.selectById(id);
    }

    @Override
    public int updateContacts(Contacts contacts) {
        String customerId = customerMapper.selectCustomerIdByName(contacts.getCustomerId());
        if (customerId != null) {
            contacts.setCustomerId(customerId);
        } else {
            Customer customer = new Customer();
            customer.setCreateBy(contacts.getCreateBy());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customer.setId(UUIDUtils.getUUID());
            customer.setName(contacts.getCustomerId());
            customer.setOwner(contacts.getOwner());
            customerMapper.insertCustomer(customer);
            contacts.setCustomerId(customer.getId());
        }
        return contactsMapper.updateContactsByContacts(contacts);
    }

    @Override
    public List<Contacts> queryContactsForPage(Map<String, Object> map) {
        return contactsMapper.selectContactsForPage(map);
    }

    @Override
    public int queryCountOfContactsByCondition(HashMap<String, Object> map) {
        return contactsMapper.selectCountOfContactsByCondition(map);
    }

    @Override
    public List<Contacts> queryContactsByContactsNameAndTranId(HashMap<String, Object> map) {
        return contactsMapper.selectContactsByContactsNameAndTranId(map);
    }

    @Override
    public Contacts queryEditById(String id) {
        return contactsMapper.selectByEditContactsById(id);
    }


}
