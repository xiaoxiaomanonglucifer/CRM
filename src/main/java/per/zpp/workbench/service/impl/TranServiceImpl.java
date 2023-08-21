package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.commons.utils.DateUtils;
import per.zpp.commons.utils.UUIDUtils;
import per.zpp.workbench.domain.Customer;
import per.zpp.workbench.domain.FunnelVO;
import per.zpp.workbench.domain.Tran;
import per.zpp.workbench.domain.TranHistory;
import per.zpp.workbench.mapper.CustomerMapper;
import per.zpp.workbench.mapper.TranHistoryMapper;
import per.zpp.workbench.mapper.TranMapper;
import per.zpp.workbench.mapper.TranRemarkMapper;
import per.zpp.workbench.service.TranService;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public List<Tran> queryTranByConditionForPage(Map<String, Object> map) {
        return tranMapper.queryTranByConditionForPage(map);
    }

    @Override
    public int queryTranCountForPage(Map<String, Object> map) {
        return tranMapper.selectTranCountForPage(map);
    }

    @Override
    public void saveCreateTran(Tran tran) {
        // 获取前端传来的用户对应的id（前端传来的是用户名称：tran.getCustomerId()，而数据库需要存放该用户的id）
        String customerId = customerMapper.selectCustomerIdByName(tran.getCustomerId());
        // 如果存在该用户，则将tran中的用户名改为对应的用户id
        if (customerId != null) {
            tran.setCustomerId(customerId);
        } else {
            // 不存在该用户，则新创建用户，并将tran中的用户名改为新创建的用户id
            Customer customer = new Customer();
            customer.setOwner(tran.getCreateBy());
            customer.setName(tran.getCustomerId());
            customer.setId(UUIDUtils.getUUID());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customer.setCreateBy(tran.getCreateBy());
            customerMapper.insertCustomer(customer); // 新增用户
            tran.setCustomerId(customer.getId()); // 修改联系人的用户为该用户id
        }
        // 新增线索
        tranMapper.insertTran(tran);
        TranHistory tranHistory = new TranHistory();
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setTranId(tran.getId());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setId(UUIDUtils.getUUID());
        // 新增历史记录
        tranHistoryMapper.insertTransactionHistory(tranHistory);
    }

    @Override
    public Tran selectTranById(String id) {
        return tranMapper.selectTranById(id);
    }

    @Override
    public Tran selectTransactionById(String id) {
        return tranMapper.selectTransactionById(id);
    }

    @Override
    public List<FunnelVO> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }

    @Override
    public List<Tran> selectTranByContactsId(String id) {
        return tranMapper.selectTranByContactsId(id);
    }

    @Override
    public void deleteByTranIds(String[] id) {
        //删除和交易有关的评论
        tranRemarkMapper.deleteRemarkByIds(id);
        //删除交易历史
        tranHistoryMapper.deleteHistoryByIds(id);
        tranMapper.deleteTranByIds(id);
    }

    @Override
    public void editTran(Tran tran) {
        // 获取前端传来的用户对应的id（前端传来的是用户名称：tran.getCustomerId()，而数据库需要存放该用户的id）
        String customerId = customerMapper.selectCustomerIdByName(tran.getCustomerId());
        if (customerId != null) {
            tran.setCustomerId(customerId);
        } else {
            // 不存在该用户，则新创建用户，并将tran中的用户名改为新创建的用户id
            Customer customer = new Customer();
            customer.setOwner(tran.getCreateBy());
            customer.setName(tran.getCustomerId());
            customer.setId(UUIDUtils.getUUID());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customer.setCreateBy(tran.getCreateBy());
            customerMapper.insertCustomer(customer); // 新增用户
            tran.setCustomerId(customer.getId()); // 修改联系人的用户为该用户id
        }
        // 更新交易
        tranMapper.updateTranByTran(tran);
        // 新增更新线索历史记录
        TranHistory tranHistory = new TranHistory();
        tranHistory.setCreateBy(tran.getEditBy());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setTranId(tran.getId());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setId(UUIDUtils.getUUID());
        // 新增历史记录
        tranHistoryMapper.insertTransactionHistory(tranHistory);
    }

    @Override
    public Tran selectEditTranById(String id) {
        return tranMapper.selectEditTranById(id);
    }


}

