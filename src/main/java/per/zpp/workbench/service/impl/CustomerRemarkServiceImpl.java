package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.CustomerRemark;
import per.zpp.workbench.mapper.CustomerRemarkMapper;
import per.zpp.workbench.service.CustomerRemarkService;

import java.util.List;

@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Override
    public List<CustomerRemark> queryAllCustomerRemarkById(String id) {
        return customerRemarkMapper.selectRemarkById(id);
    }

    @Override
    public int saveCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertCusRemark(customerRemark);
    }

    @Override
    public int updateCusRemarkByRemarkId(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateCusRemarkByRemarkId(customerRemark);
    }

    @Override
    public int deleteCusRemarkByRemarkId(String id) {
        return customerRemarkMapper.deleteCusRemarkByRemarkId(id);
    }
}
