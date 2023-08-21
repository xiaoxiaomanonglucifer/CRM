package per.zpp.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.workbench.domain.ContactsActivityRelation;
import per.zpp.workbench.mapper.ContactsActivityRelationMapper;
import per.zpp.workbench.service.ContactsActivityRelationService;

import java.util.List;

@Service
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Override
    public int deleteActivityByContactsId(ContactsActivityRelation contactsActivityRelation) {
        return contactsActivityRelationMapper.deleteActivityByContactsId(contactsActivityRelation);
    }

    @Override
    public int saveCreateContactsActivityRelationByList(List<ContactsActivityRelation> carList) {
        return contactsActivityRelationMapper.insertContactsActivityRelationByList(carList);
    }
}
