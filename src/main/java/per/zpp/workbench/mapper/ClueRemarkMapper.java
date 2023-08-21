package per.zpp.workbench.mapper;

import per.zpp.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Aug 11 10:58:26 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Aug 11 10:58:26 CST 2023
     */
    int insert(ClueRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Aug 11 10:58:26 CST 2023
     */
    int insertSelective(ClueRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Aug 11 10:58:26 CST 2023
     */
    ClueRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Aug 11 10:58:26 CST 2023
     */
    int updateByPrimaryKeySelective(ClueRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Aug 11 10:58:26 CST 2023
     */
    int updateByPrimaryKey(ClueRemark record);

    //需要联表查询名字
    List<ClueRemark> selectClueRemarkDetailById(String id);

    //不用联表查询查名字
    List<ClueRemark> selectClueRemarkByClueId(String clueId);
    int updateClueRemarkById(ClueRemark clueRemark);

    void deleteRemarkByIds(String[] ids);
}