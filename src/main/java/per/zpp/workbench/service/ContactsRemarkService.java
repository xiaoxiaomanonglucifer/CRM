package per.zpp.workbench.service;

import org.springframework.beans.factory.annotation.Autowired;
import per.zpp.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {

    int saveRemark(ContactsRemark contactsRemark);

    List<ContactsRemark>queryRemarkById(String id);

    int updateRemarkByRemarkId(ContactsRemark contactsRemark);

    int deleteRemarkById(String id);
}
