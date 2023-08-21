package per.zpp.workbench.domain;

public class ContactsRemark {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_contacts_remark.id
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_contacts_remark.note_content
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    private String noteContent;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_contacts_remark.create_by
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    private String createBy;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_contacts_remark.create_time
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    private String createTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_contacts_remark.edit_by
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    private String editBy;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_contacts_remark.edit_time
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    private String editTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_contacts_remark.edit_flag
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    private String editFlag;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_contacts_remark.contacts_id
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    private String contactsId;

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public ContactsRemark(String id, String noteContent, String createBy, String createTime, String editBy, String editTime, String editFlag, String contactsId) {
        this.id = id;
        this.noteContent = noteContent;
        this.createBy = createBy;
        this.createTime = createTime;
        this.editBy = editBy;
        this.editTime = editTime;
        this.editFlag = editFlag;
        this.contactsId = contactsId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public ContactsRemark() {
        super();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_contacts_remark.id
     *
     * @return the value of tbl_contacts_remark.id
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_contacts_remark.id
     *
     * @param id the value for tbl_contacts_remark.id
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_contacts_remark.note_content
     *
     * @return the value of tbl_contacts_remark.note_content
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public String getNoteContent() {
        return noteContent;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_contacts_remark.note_content
     *
     * @param noteContent the value for tbl_contacts_remark.note_content
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public void setNoteContent(String noteContent) {
        this.noteContent = noteContent == null ? null : noteContent.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_contacts_remark.create_by
     *
     * @return the value of tbl_contacts_remark.create_by
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public String getCreateBy() {
        return createBy;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_contacts_remark.create_by
     *
     * @param createBy the value for tbl_contacts_remark.create_by
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public void setCreateBy(String createBy) {
        this.createBy = createBy == null ? null : createBy.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_contacts_remark.create_time
     *
     * @return the value of tbl_contacts_remark.create_time
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public String getCreateTime() {
        return createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_contacts_remark.create_time
     *
     * @param createTime the value for tbl_contacts_remark.create_time
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public void setCreateTime(String createTime) {
        this.createTime = createTime == null ? null : createTime.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_contacts_remark.edit_by
     *
     * @return the value of tbl_contacts_remark.edit_by
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public String getEditBy() {
        return editBy;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_contacts_remark.edit_by
     *
     * @param editBy the value for tbl_contacts_remark.edit_by
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public void setEditBy(String editBy) {
        this.editBy = editBy == null ? null : editBy.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_contacts_remark.edit_time
     *
     * @return the value of tbl_contacts_remark.edit_time
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public String getEditTime() {
        return editTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_contacts_remark.edit_time
     *
     * @param editTime the value for tbl_contacts_remark.edit_time
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public void setEditTime(String editTime) {
        this.editTime = editTime == null ? null : editTime.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_contacts_remark.edit_flag
     *
     * @return the value of tbl_contacts_remark.edit_flag
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public String getEditFlag() {
        return editFlag;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_contacts_remark.edit_flag
     *
     * @param editFlag the value for tbl_contacts_remark.edit_flag
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public void setEditFlag(String editFlag) {
        this.editFlag = editFlag == null ? null : editFlag.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_contacts_remark.contacts_id
     *
     * @return the value of tbl_contacts_remark.contacts_id
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public String getContactsId() {
        return contactsId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_contacts_remark.contacts_id
     *
     * @param contactsId the value for tbl_contacts_remark.contacts_id
     *
     * @mbggenerated Mon Aug 14 08:07:40 CST 2023
     */
    public void setContactsId(String contactsId) {
        this.contactsId = contactsId == null ? null : contactsId.trim();
    }
}