package per.zpp.workbench.mapper;

import per.zpp.workbench.domain.Activity;
import per.zpp.workbench.domain.FunnelVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Thu Aug 03 15:25:59 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Thu Aug 03 15:25:59 CST 2023
     */
//    int insert(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Thu Aug 03 15:25:59 CST 2023
     */
    int insertSelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Thu Aug 03 15:25:59 CST 2023
     */
    Activity selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Thu Aug 03 15:25:59 CST 2023
     */
    int updateByPrimaryKeySelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Thu Aug 03 15:25:59 CST 2023
     */
    int updateByPrimaryKey(Activity record);

    /**
     * 保存创建市场活动
     *
     * @param record
     * @return
     */
    int insertActivity(Activity record);

    List<Activity> selectActivityByConditionForPage(Map<String, Object> map);

    int selectCountOfActivityByCondition(Map<String, Object> map);

    int deleteActivityByIds(String[] ids);

    int editActivity(Activity activity);

    Activity queryActivityById(String id);

    List<Activity> selectAllActivity();

    List<Activity> selectActivityById(String[] ids);

    int insertActivityByList(List<Activity> activityList);

    Activity selectActivityForDetailById(String id);

    List<Activity> selectActivityDetailByClueId(String clueId);

    List<Activity> selectActivityDetailByContactsId(String contactsId);

    List<Activity> selectAllActivityForDetailByNameAndClueId(Map<String,Object> map);

    /**
     * 根据ids查询市场活动的明细信息
     * @param ids
     * @return
     */
    List<Activity> selectActivityByActivityIds(String []ids);

    List<Activity> selectActivityForConvertByNameAndClueId(HashMap<String, Object> map);


    List<Activity> selectActivityByActivityName(String activityName);


    List<FunnelVO> selectCountOfActivityGroupByOwner();

    List<Activity> selectActivityByActivityNameAndContactsId(HashMap<String, Object> map);

    List<Activity> selectActivityByActivityNameAndTranId(HashMap<String, Object> map);



}