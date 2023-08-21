package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.commons.constants.SystemConstant;
import per.zpp.commons.utils.DateUtils;
import per.zpp.commons.utils.UUIDUtils;
import per.zpp.settings.domain.User;
import per.zpp.workbench.domain.*;
import per.zpp.workbench.mapper.*;
import per.zpp.workbench.service.ClueService;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service

public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public int saveClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.queryClueByConditionForPage(map);
    }

    @Override
    public int queryClueCountByCondition(Map<String, Object> map) {
        return clueMapper.queryCountOfClueByCondition(map);
    }

    @Override
    public void deleteClueByIds(String[] id) {
         clueMapper.deleteClueByIds(id);
         clueRemarkMapper.deleteRemarkByIds(id);
         clueActivityRelationMapper.deleteActivityRelationByIds(id);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.queryClueById(id);
    }

    @Override
    public int updateClueById(Clue clue) {
        return clueMapper.updateByPrimaryKeySelective(clue);
    }

    @Override
    public Clue selectDetailById(String id) {
        return clueMapper.selectClueDetailById(id);
    }

    @Override
    public void saveConvert(Map<String, Object> map) {
        //根据id先查线索信息
        String id = (String) map.get("clueId");
        String isCreateTran = (String) map.get("isCreateTran");
        User user = (User) map.get(SystemConstant.SESSION_USER);
        Clue clue = clueMapper.queryClueById(id);
        //把线索有关客户的实体类对象拿出
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setAddress(clue.getAddress());
        customer.setContactSummary(clue.getContactSummary());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setDescription(clue.getDescription());
        customer.setName(clue.getCompany());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setOwner(user.getId());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customerMapper.insertCustomer(customer);

        //封装联系人对象
        Contacts contacts = new Contacts();
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setCustomerId(customer.getId());
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setId(UUIDUtils.getUUID());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contactsMapper.insertContacts(contacts);

        //根据clueId查询所有备注信息
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectClueRemarkByClueId(id);
        List<CustomerRemark> cRList = new ArrayList<>();
        List<ContactsRemark> cTList = new ArrayList<>();
        if (clueRemarks != null && clueRemarks.size() > 0) {
            //遍历clueRemarks
            CustomerRemark cR = null;
            ContactsRemark cT = null;
            for (ClueRemark clueRemark : clueRemarks) {
                cR = new CustomerRemark();
                cT = new ContactsRemark();
                cR.setCreateBy(clueRemark.getCreateBy());
                cR.setCreateTime(clueRemark.getCreateTime());
                cR.setCustomerId(customer.getId());
                cR.setEditBy(clueRemark.getEditBy());
                cR.setEditTime(clueRemark.getEditTime());
                cR.setId(UUIDUtils.getUUID());
                cR.setNoteContent(clueRemark.getNoteContent());
                cR.setEditFlag(clueRemark.getEditFlag());

                cT.setContactsId(contacts.getId());
                cT.setCreateBy(clueRemark.getCreateBy());
                cT.setCreateTime(clueRemark.getCreateTime());
                cT.setEditBy(clueRemark.getEditBy());
                cT.setEditFlag(clueRemark.getEditFlag());
                cT.setEditTime(clueRemark.getEditTime());
                cT.setId(UUIDUtils.getUUID());
                cT.setNoteContent(clueRemark.getNoteContent());

                cRList.add(cR);
                cTList.add(cT);

            }
            customerRemarkMapper.insertCustomerRemarkByList(cRList);
            contactsRemarkMapper.insertContactsRemarkByList(cTList);
        }
        //根据ClueId查询该线索id和市场活动的关系
        List<ClueActivityRelation> clueActivityRelations = clueActivityRelationMapper.selectClueActivityRelationByClueId(id);
        ContactsActivityRelation ctAr = null;
        List<ContactsActivityRelation> ctArList = new ArrayList<>();
        if (clueActivityRelations != null && clueActivityRelations.size() > 0) {
            for (ClueActivityRelation car : clueActivityRelations) {
                ctAr = new ContactsActivityRelation();
                ctAr.setId(UUIDUtils.getUUID());
                ctAr.setActivityId(car.getActivityId());
                ctAr.setContactsId(contacts.getId());
                ctArList.add(ctAr);
            }
            contactsActivityRelationMapper.insertContactsActivityRelationByList(ctArList);
        }
        //判断是否需要创建交易
        if (isCreateTran.equals("true")) {
            Tran tran = new Tran();
            String activityId = (String) map.get("activityId");
            String money = (String) map.get("money");
            String name = (String) map.get("name");
            String expectedDate = (String) map.get("expectedDate");
            String stage = (String) map.get("stage");
            tran.setActivityId(activityId);
            tran.setMoney(money);
            tran.setExpectedDate(expectedDate);
            tran.setName(name);
            tran.setStage(stage);
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formatDateTime(new Date()));
            tran.setCustomerId(customer.getId());
            tran.setOwner(user.getId());
            tran.setId(UUIDUtils.getUUID());
            tranMapper.insertTran(tran);


            if (cRList != null && cRList.size() > 0) {
                TranRemark tR = null;
                List<TranRemark> tRList = new ArrayList<>();
                for (CustomerRemark cr : cRList) {
                    tR = new TranRemark();
                    tR.setTranId(tran.getId());
                    tR.setCreateBy(cr.getCreateBy());
                    tR.setCreateTime(cr.getCreateTime());
                    tR.setEditBy(cr.getEditBy());
                    tR.setEditFlag(cr.getEditFlag());
                    tR.setEditTime(cr.getEditTime());
                    tR.setId(UUIDUtils.getUUID());
                    tR.setNoteContent(cr.getNoteContent());
                    tRList.add(tR);
                }
                tranRemarkMapper.insertTranRemarkByList(tRList);
            }
        }
        clueRemarkMapper.deleteByPrimaryKey(id);
        clueActivityRelationMapper.deleteByPrimaryKey(id);
        clueMapper.deleteByPrimaryKey(id);
    }

    @Override
    public List<String> queryClueStageOfClueGroupByClueStage() {
        return clueMapper.selectClueStageOfClueGroupByClueStage();
    }

    @Override
    public List<Integer> queryCountOfClueGroupByClueStage() {
        return clueMapper.selectCountOfClueGroupByClueStage();
    }
}
