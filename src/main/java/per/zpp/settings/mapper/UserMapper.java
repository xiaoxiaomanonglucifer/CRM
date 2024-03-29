package per.zpp.settings.mapper;

import per.zpp.settings.domain.User;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface UserMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sun Jul 30 09:55:55 CST 2023
     */
//    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sun Jul 30 09:55:55 CST 2023
     */
    int insert(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sun Jul 30 09:55:55 CST 2023
     */
    int insertSelective(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sun Jul 30 09:55:55 CST 2023
     */
    User selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sun Jul 30 09:55:55 CST 2023
     */
    int updateByPrimaryKeySelective(User record);



    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sun Jul 30 09:55:55 CST 2023
     */
    int updateByPrimaryKey(User record);

    /**
     * 根据账号密码查询用户
     * @param map
     * @return
     */
    User selectUserByLoginActAndPwd(Map<String,Object> map);

    List<User> selectAllUsers();
/*
zhushi
 */
    List<User> selectUserForPage(Map<String,Object>map);
}