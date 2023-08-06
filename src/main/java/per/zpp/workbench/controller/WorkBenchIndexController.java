package per.zpp.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workbench")
public class WorkBenchIndexController {
    @RequestMapping("/toIndex")
        public String toIndex(){
            return "workbench/index";
        }
}
