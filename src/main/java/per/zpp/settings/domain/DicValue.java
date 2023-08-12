package per.zpp.settings.domain;

public class DicValue {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.id
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.value
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    private String value;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.text
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    private String text;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.order_no
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    private String orderNo;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.type_code
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    private String typeCode;

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public DicValue(String id, String value, String text, String orderNo, String typeCode) {
        this.id = id;
        this.value = value;
        this.text = text;
        this.orderNo = orderNo;
        this.typeCode = typeCode;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public DicValue() {
        super();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_dic_value.id
     *
     * @return the value of tbl_dic_value.id
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_dic_value.id
     *
     * @param id the value for tbl_dic_value.id
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_dic_value.value
     *
     * @return the value of tbl_dic_value.value
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public String getValue() {
        return value;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_dic_value.value
     *
     * @param value the value for tbl_dic_value.value
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public void setValue(String value) {
        this.value = value == null ? null : value.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_dic_value.text
     *
     * @return the value of tbl_dic_value.text
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public String getText() {
        return text;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_dic_value.text
     *
     * @param text the value for tbl_dic_value.text
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public void setText(String text) {
        this.text = text == null ? null : text.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_dic_value.order_no
     *
     * @return the value of tbl_dic_value.order_no
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public String getOrderNo() {
        return orderNo;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_dic_value.order_no
     *
     * @param orderNo the value for tbl_dic_value.order_no
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo == null ? null : orderNo.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_dic_value.type_code
     *
     * @return the value of tbl_dic_value.type_code
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public String getTypeCode() {
        return typeCode;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_dic_value.type_code
     *
     * @param typeCode the value for tbl_dic_value.type_code
     *
     * @mbggenerated Thu Aug 10 19:28:10 CST 2023
     */
    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode == null ? null : typeCode.trim();
    }
}