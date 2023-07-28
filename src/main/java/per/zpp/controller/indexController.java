package per.zpp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller//mvc配置文件扫描包
public class indexController {
    /*
    按理说给controller分配url应该写 http://127.0.0.1:8080/crm/
    为了简便 ://ip:port/应用名称必须省去
     */
        @RequestMapping("/")
    public String index(){
            //请求转发地址不会变 前缀不会变，不能用重定向
//        return "/WEB-INF/pages/index.jsp"; 完整路径写法
            return "/index";//配置了视图解析器之后的写法(加了前缀和后缀)
    }

}
