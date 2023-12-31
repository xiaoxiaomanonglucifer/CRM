package per.zpp.workbench.mapper;

import per.zpp.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    int insert(ContactsRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    int insertSelective(ContactsRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    ContactsRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    int updateByPrimaryKeySelective(ContactsRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    int updateByPrimaryKey(ContactsRemark record);

    int insertContactsRemarkByList(List<ContactsRemark> list);

    int insertContactRemark(ContactsRemark contactsRemark);

    List<ContactsRemark> selectRemarkById(String id);

    int updateRemarkById(ContactsRemark contactsRemark);

    int deleteRemarkById(String id);

    void deleteContactsRemarkByContactsId(String[] ids);
}