package per.zpp.workbench.mapper;

import per.zpp.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Mon Aug 14 08:29:13 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Mon Aug 14 08:29:13 CST 2023
     */
    int insert(ContactsActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Mon Aug 14 08:29:13 CST 2023
     */
    int insertSelective(ContactsActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Mon Aug 14 08:29:13 CST 2023
     */
    ContactsActivityRelation selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Mon Aug 14 08:29:13 CST 2023
     */
    int updateByPrimaryKeySelective(ContactsActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Mon Aug 14 08:29:13 CST 2023
     */
    int updateByPrimaryKey(ContactsActivityRelation record);

    int insertContactsActivityRelationByList(List<ContactsActivityRelation> list);

    int deleteActivityByContactsId(ContactsActivityRelation contactsActivityRelation);

    void deleteContactsActivityRelationByContactsIds(String[] ids);
}