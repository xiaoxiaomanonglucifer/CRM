package per.zpp.settings.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import per.zpp.commons.constants.SystemConstant;
import per.zpp.commons.domain.ReturnObject;
import per.zpp.commons.utils.DateUtils;
import per.zpp.settings.domain.User;
import per.zpp.settings.service.UserService;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
//和方法的RequestMapping结合形成一个在浏览器地址上显示的路径
public class UserController {
    @Autowired
    private UserService userService;

    /*
    url要和controller方法处理完请求之后响应信息返回的页面的资源目录保持一致
     */
//    @RequestMapping("/WEB-INF/pages/settings/qx/user/toLoginIn.do")
    @RequestMapping("/settings/qx/user/toLogin")
    public String toLogin() {
        return "settings/qx/user/login";//结合springmvc里面的配置文件视图解析器返回一个url：
        //(WEB-INF/pages/)settings/qx/user/login(.jsp)
        //括号里到的都是视图解析器默认添加的内容
    }

    /**
     * 登录方法
     * 错误一：没有开启mybatis的驼峰命名 导致数据库字段名和 实体类名称不同，查询结果为null
     * 解决方法在mybatis的配置文件中加入 <setting name="mapUnderscoreToCamelCase" value="true"/> 开启驼峰命名 将_去掉并将_下一个变成大写
     *
     * @param loginAct
     * @param loginPwd
     * @param isRemPwd
     * @param request
     * @return
     */
    @RequestMapping("/settings/qx/user/login")
    public @ResponseBody
    Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpSession session, HttpServletResponse response) {
//        System.out.println(request.getScheme());
//        System.out.println(request.getServerName());
//        System.out.println(request.getServerPort());
//        System.out.println(request.getContextPath());

        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);//""里面的要和mapper.xml里面的{}里面的名称一致
        map.put("loginPwd", loginPwd);
        User user = userService.selectUserByLoginActAndPwd(map);
        ReturnObject returnObject = new ReturnObject();
        //根据查询结果 ，生成响应信息
        if (user == null) {
            returnObject.setCode(SystemConstant.FAIL_CODE);
            returnObject.setMessage("用户名或者密码错误~");
        } else {//进一步判断账号是否合法 ip、以及是否被锁定 、是否过期(expire)
            //用字符串的形式判断时间的大小来判断用户是否过期
            String nowStr = DateUtils.formatDateTime(new Date());
//            System.out.println("nowStr="+nowStr);
//            System.out.println("expireTime="+user.getExpireTime());
//            System.out.println("user="+user);
            if (nowStr.compareTo(user.getExpireTime()) > 0) {//现在的时间比较大 则说明过期
                returnObject.setCode(SystemConstant.FAIL_CODE);
                returnObject.setMessage("账号已过期~~");
            } else if ("0".equals(user.getLockState()))//被锁定
            {
                returnObject.setCode(SystemConstant.FAIL_CODE);
                returnObject.setMessage("状态被锁定~");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {//ip失败
                returnObject.setCode(SystemConstant.FAIL_CODE);
                returnObject.setMessage("ip受限，不能在该区域登录~");
            } else {
                returnObject.setCode(SystemConstant.SUCCESS_CODE);
                session.setAttribute(SystemConstant.SESSION_USER, user);
                Cookie c1;
                Cookie c2;
                if ("true".equals(isRemPwd)) {
                    c1 = new Cookie("loginAct", user.getLoginAct());
                    c2 = new Cookie("loginPwd", user.getLoginPwd());
                    c1.setMaxAge(60 * 60 * 24 * 10);
                    c2.setMaxAge(60 * 60 * 24 * 10);
                } else {
//把没过期的cookie删除
                    c1 = new Cookie("loginAct", "1");
                    c2 = new Cookie("loginPwd", "1");
                    c1.setMaxAge(0);
                    c2.setMaxAge(0);
                }
                response.addCookie(c1);
                response.addCookie(c2);
            }
        }
        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout")
    public String logout(HttpServletResponse response, HttpSession session) {
        //清空cookie
        Cookie c1 = new Cookie("loginAct", "1");
        Cookie c2 = new Cookie("loginPwd", "1");
        c1.setMaxAge(0);
        c2.setMaxAge(0);
        response.addCookie(c1);
        response.addCookie(c2);
        //销毁session
        session.invalidate();
        return "redirect:/";
    }
//    http://localhost:8080/CRM/settings/qx/user/toLogin
//    http://localhost:8080/settings/qx/user/logout

    @RequestMapping("/settings/qx/toIndex")
    public String toIndex(HttpSession session, HttpServletRequest request) {
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        request.setAttribute("user", user);
        return "settings/qx/index";
    }

    @RequestMapping("/settings/qx/user/toUserIndex")
    public String toUserIndex() {
        return "settings/qx/user/index";
    }


}
