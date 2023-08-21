package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.ContactsRemark;
import per.zpp.workbench.mapper.ContactsRemarkMapper;
import per.zpp.workbench.service.ContactsRemarkService;

import java.util.List;

@Service
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Override
    public int saveRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insertContactRemark(contactsRemark);
    }

    @Override
    public List<ContactsRemark> queryRemarkById(String id) {
        return contactsRemarkMapper.selectRemarkById(id);
    }

    @Override
    public int updateRemarkByRemarkId(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.updateRemarkById(contactsRemark);
    }

    @Override
    public int deleteRemarkById(String id) {
        return contactsRemarkMapper.deleteRemarkById(id);
    }
}
