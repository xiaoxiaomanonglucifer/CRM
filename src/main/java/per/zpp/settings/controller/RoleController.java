package per.zpp.settings.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class RoleController {

    @RequestMapping("/settings/qx/role/toRoleIndex")
    public String toRoleIndex() {
        return "settings/qx/role/index";
    }
}
