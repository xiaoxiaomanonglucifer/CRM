package per.zpp.settings.service.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import per.zpp.settings.domain.User;
import per.zpp.settings.mapper.UserMapper;
import per.zpp.settings.service.UserService;

import java.util.List;
import java.util.Map;

@Service()
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User selectById(String id) {
      return   userMapper.selectByPrimaryKey(id);
    }

    @Override
    public User selectUserByLoginActAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByLoginActAndPwd(map);
    }

    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }
}
