package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.Customer;
import per.zpp.workbench.mapper.CustomerMapper;
import per.zpp.workbench.mapper.CustomerRemarkMapper;
import per.zpp.workbench.service.CustomerService;

import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Override
    public List<String> queryAllCustomerByCustomerName(String customerName) {
        return customerMapper.selectCustomerNameByFuzzyName(customerName);
    }

    @Override
    public List<Customer> queryCustomerByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerByConditionForPage(map);
    }

    @Override
    public int queryCountOfCustomerByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomerByCondition(map);
    }

    @Override
    public int saveCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public void deleteCusByIds(String[] ids) {
        // 删除客户备注
        customerRemarkMapper.deleteCustomerRemarkByCustomerIds(ids);
        // 删除客户关联交易
        // 删除客户关联联系人
        // 删除客户信息
        customerMapper.deleteCusByIds(ids);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int editCustomer(Customer customer) {
        return customerMapper.updateCustomer(customer);
    }

    @Override
    public Customer selectCustomerDetailById(String id) {
        return customerMapper.selectCustomerDetailById(id);
    }
}
