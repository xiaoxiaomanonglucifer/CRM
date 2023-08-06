package per.zpp.commons.utils;


import java.util.UUID;

public class UUIDUtils {

    /**
     * 获取随机id
     * @return
     */
        public static String getUUID(){
            return UUID.randomUUID().toString().replaceAll("-","");
        }
}
