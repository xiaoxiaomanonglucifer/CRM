package per.zpp.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workbench/main")
public class MainController {


    @RequestMapping("/toMainIndex")
    public String toMainIndex(){

        return "/workbench/main/index";
    }
}
