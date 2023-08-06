package per.zpp.workbench.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import per.zpp.settings.domain.User;
import per.zpp.settings.service.UserService;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/workbench/main")
public class MainController {


    @RequestMapping("/toMainIndex")
    public String toMainIndex(){

        return "/workbench/main/index";
    }
}
