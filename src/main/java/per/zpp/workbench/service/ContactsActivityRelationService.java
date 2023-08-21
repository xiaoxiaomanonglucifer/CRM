package per.zpp.workbench.service;

import per.zpp.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationService {

    int deleteActivityByContactsId(ContactsActivityRelation contactsActivityRelation);

    int saveCreateContactsActivityRelationByList(List<ContactsActivityRelation> carList);
}
