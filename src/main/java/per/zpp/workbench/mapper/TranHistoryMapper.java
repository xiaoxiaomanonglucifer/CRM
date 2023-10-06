package per.zpp.workbench.mapper;

import per.zpp.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Tue Aug 15 15:22:45 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Tue Aug 15 15:22:45 CST 2023
     */
    int insert(TranHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Tue Aug 15 15:22:45 CST 2023
     */
    int insertSelective(TranHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Tue Aug 15 15:22:45 CST 2023
     */
    TranHistory selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Tue Aug 15 15:22:45 CST 2023
     */
    int updateByPrimaryKeySelective(TranHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Tue Aug 15 15:22:45 CST 2023
     */
    int updateByPrimaryKey(TranHistory record);

    int insertTransactionHistory(TranHistory record);

    List<TranHistory> selectTranHisDetailById(String id);

    void deleteHistoryByIds(String[] ids);
}