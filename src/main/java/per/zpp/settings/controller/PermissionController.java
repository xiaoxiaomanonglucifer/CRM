package per.zpp.settings.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class PermissionController {

    @RequestMapping("/settings/qx/permission/toPerIndex")
    public String toPerIndex() {
        return "settings/qx/permission/index";
    }
}
