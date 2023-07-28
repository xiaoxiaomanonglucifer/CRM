package per.zpp.settings.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/settings/qx/user")//和方法的RequestMapping结合形成一个在浏览器地址上显示的路径
public class UserController {

    /*
    url要和controller方法处理完请求之后响应信息返回的页面的资源目录保持一致
     */
//    @RequestMapping("/WEB-INF/pages/settings/qx/user/toLoginIn.do")
    @RequestMapping("/toLogin")
        public String toLogin(){
            return "settings/qx/user/login";//结合springmvc里面的配置文件视图解析器返回一个url：
                                                               ///(WEB-INF/pages/)settings/qx/user/login(.jsp)
                                                            //括号里到的都是视图解析器默认添加的内容
        }

}
