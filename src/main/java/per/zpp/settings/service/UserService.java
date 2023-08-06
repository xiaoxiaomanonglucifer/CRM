package per.zpp.settings.service;

import per.zpp.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {

    User selectUserByLoginActAndPwd(Map<String,Object> map);

    List<User> queryAllUsers();
}
