package per.zpp.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 对date类型数据进行处理的工具
 */
public class DateUtils {
    /**
     * 对指定的date进行格式化
     * @param date
     * @return
     */
    public static String formatDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String nowStr=sdf.format(date);
        return nowStr;
    }

}
