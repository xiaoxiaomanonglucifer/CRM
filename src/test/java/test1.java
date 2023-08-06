import org.junit.Test;
import per.zpp.commons.constants.SystemConstant;
import per.zpp.commons.utils.DateUtils;

import java.util.Date;

public class test1 {



    @Test
    public void test01(){
        String nowStr = DateUtils.formatDateTime(new Date());
        if (nowStr.compareTo("2025-11-27 21:50:05") > 0) {//现在的时间比较大 则说明过期
            System.out.println("失败");
        }
        System.out.println("成功");
    }
}
