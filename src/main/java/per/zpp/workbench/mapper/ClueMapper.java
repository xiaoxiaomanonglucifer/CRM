package per.zpp.workbench.mapper;

import per.zpp.workbench.domain.Clue;
import per.zpp.workbench.domain.FunnelVO;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Thu Aug 10 10:57:37 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Thu Aug 10 10:57:37 CST 2023
     */
    int insert(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Thu Aug 10 10:57:37 CST 2023
     */
    int insertSelective(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Thu Aug 10 10:57:37 CST 2023
     */
    Clue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Thu Aug 10 10:57:37 CST 2023
     */
    int updateByPrimaryKeySelective(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Thu Aug 10 10:57:37 CST 2023
     */
    int updateByPrimaryKey(Clue record);

    int insertClue(Clue clue);

    List<Clue> queryClueByConditionForPage(Map<String, Object> map);

    int queryCountOfClueByCondition(Map<String, Object> map);

    int deleteClueByIds(String id[]);

    Clue queryClueById(String id);

    Clue selectClueDetailById(String id);

    List<String> selectClueStageOfClueGroupByClueStage();

    List<Integer> selectCountOfClueGroupByClueStage();
//    int updateClueById(Clue clue);

//        Clue selectClueById(String id);


}