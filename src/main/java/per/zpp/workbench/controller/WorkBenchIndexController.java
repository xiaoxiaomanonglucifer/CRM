package per.zpp.workbench.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import per.zpp.commons.constants.SystemConstant;
import per.zpp.settings.domain.User;
import per.zpp.settings.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/workbench")
public class WorkBenchIndexController {


    @RequestMapping("/toIndex")
    public String toIndex(HttpSession session,HttpServletRequest request) {
        User user=(User) session.getAttribute(SystemConstant.SESSION_USER);
        request.setAttribute("user",user);
        return "workbench/index";
    }
}
