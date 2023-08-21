package per.zpp.workbench.service;

import per.zpp.workbench.domain.Contacts;
import per.zpp.workbench.domain.FunnelVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> queryContactsByContactsName(String contactsName);

    List<FunnelVO> queryCountOfCustomerAndContactsGroupByCustomer();

    List<Contacts> queryContactsById(String id);

    int saveContacts(Contacts contacts);

    void deleteByIds(String[] id);

    Contacts queryById(String id);

    int updateContacts(Contacts contacts);

    List<Contacts> queryContactsForPage(Map<String,Object>map);

    int queryCountOfContactsByCondition(HashMap<String, Object> map);


    List<Contacts> queryContactsByContactsNameAndTranId(HashMap<String, Object> map);

    Contacts queryEditById(String id);
}
