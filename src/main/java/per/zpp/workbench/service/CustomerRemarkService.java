package per.zpp.workbench.service;

import per.zpp.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {

    List<CustomerRemark> queryAllCustomerRemarkById(String id);

    int saveCustomerRemark(CustomerRemark customerRemark);

    int updateCusRemarkByRemarkId(CustomerRemark customerRemark);

    int deleteCusRemarkByRemarkId(String id);
}
