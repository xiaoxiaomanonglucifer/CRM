package per.zpp.workbench.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import per.zpp.workbench.domain.FunnelVO;
import per.zpp.workbench.service.ActivityService;
import per.zpp.workbench.service.ClueService;
import per.zpp.workbench.service.ContactsService;
import per.zpp.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/chart")
public class CharController {
    @Autowired
    private TranService tranService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueService clueService;

    @Autowired
    private ContactsService contactsService;
    @RequestMapping("/transaction/toTranIndex")
    public String toTranIndex(){
        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/transaction/queryCountOfTranGroupByStage")
    @ResponseBody
    public Object queryCountOfTranGroupByStage(){
        List<FunnelVO> funnelVOList = tranService.queryCountOfTranGroupByStage();
        // 根据查询结果，返回响应信息
        return funnelVOList;
    }

    @RequestMapping("/activity/toActivityIndex")
    public String toActivityIndex(){
        return "workbench/chart/activity/index";
    }
    @RequestMapping("/activity/queryCountOfActivityGroupByOwner")
    @ResponseBody
    public Object queryCountOfActivityGroupByOwner(){
        List<FunnelVO> funnelVOList = activityService.queryCountOfActivityGroupByOwner();
        // 根据查询结果，返回响应信息
        return funnelVOList;
    }


    @RequestMapping("/clue/toClueIndex")
    public String toClueIndex(){
        return "workbench/chart/clue/index";
    }
    @RequestMapping("/clue/queryCountOfClueGroupByStage")
    @ResponseBody
    public Object queryCountOfClueGroupByStage(){
        List<String> clueStage = clueService.queryClueStageOfClueGroupByClueStage();
        List<Integer> counts = clueService.queryCountOfClueGroupByClueStage();
        Map<String, Object> map = new HashMap<>();
        map.put("clueStage", clueStage);
        map.put("counts", counts);
        // 根据查询结果，返回响应信息
        return map;
    }

    @RequestMapping("/customerAndContacts/toConAndCusIndex")
    public String toConAndCusIndex(){
        return "workbench/chart/customerAndContacts/index";
    }

    @RequestMapping("/customerAndContacts/queryCountOfCustomerAndContactsGroupByCustomer")
    @ResponseBody
    public Object queryCountOfCustomerAndContactsGroupByCustomer(){
        List<FunnelVO> funnelVOList = contactsService.queryCountOfCustomerAndContactsGroupByCustomer();
        // 根据查询结果，返回响应信息
        return funnelVOList;
    }
}
