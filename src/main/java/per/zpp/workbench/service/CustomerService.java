package per.zpp.workbench.service;

import per.zpp.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    List<String> queryAllCustomerByCustomerName(String customerName);

    List<Customer> queryCustomerByConditionForPage(Map<String,Object>map);

    int queryCountOfCustomerByConditionForPage(Map<String,Object>map);

    int saveCustomer(Customer customer);

    void deleteCusByIds(String []id);

    Customer queryCustomerById(String id);

    int editCustomer(Customer customer);

    Customer selectCustomerDetailById(String id);


}
