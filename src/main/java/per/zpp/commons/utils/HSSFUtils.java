package per.zpp.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import per.zpp.workbench.domain.Activity;

import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.util.List;


public class HSSFUtils {
    /**
     * 创建市场活动Excel文件
     * @param activityList 市场活动集合
     * @param fileName 导出文件名
     * @param response 响应
     * @throws Exception 输出流异常
     */
        public static void createExcelFileByActivity(List<Activity> activityList, HttpServletResponse response,String fileName)throws Exception{
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet("市场活动列表");
            HSSFRow row = sheet.createRow(0);//第一行
            HSSFCell cell = row.createCell(0);//从第一行的第一列开始
            cell.setCellValue("ID");
            cell = row.createCell(1);
            cell.setCellValue("所有者");
            cell = row.createCell(2);
            cell.setCellValue("名称");
            cell = row.createCell(3);
            cell.setCellValue("开始日期");
            cell = row.createCell(4);
            cell.setCellValue("结束日期");
            cell = row.createCell(5);
            cell.setCellValue("成本");
            cell = row.createCell(6);
            cell.setCellValue("描述");
            cell = row.createCell(7);
            cell.setCellValue("创建时间");
            cell = row.createCell(8);
            cell.setCellValue("创建者");
            cell = row.createCell(9);
            cell.setCellValue("修改时间");
            cell = row.createCell(10);
            cell.setCellValue("修改者");

            if (activityList != null && activityList.size() > 0) {
                Activity activity = null;
                for (int i = 0; i < activityList.size(); i++) {
                    activity = activityList.get(i);
                    row = sheet.createRow(i + 1);
                    cell = row.createCell(0);
                    cell.setCellValue(activity.getId());
                    cell = row.createCell(1);
                    cell.setCellValue(activity.getOwner());
                    cell = row.createCell(2);
                    cell.setCellValue(activity.getName());
                    cell = row.createCell(3);
                    cell.setCellValue(activity.getStartDate());
                    cell = row.createCell(4);
                    cell.setCellValue(activity.getEndDate());
                    cell = row.createCell(5);
                    cell.setCellValue(activity.getCost());
                    cell = row.createCell(6);
                    cell.setCellValue(activity.getDescription());
                    cell = row.createCell(7);
                    cell.setCellValue(activity.getCreateTime());
                    cell = row.createCell(8);
                    cell.setCellValue(activity.getCreateBy());
                    cell = row.createCell(9);
                    cell.setCellValue(activity.getEndDate());
                    cell = row.createCell(10);
                    cell.setCellValue(activity.getEditBy());
                }
            }
            //根据wb对象生成excel文件到服务端
//        FileOutputStream fos = new FileOutputStream("D:\\code\\javacodee\\CRM\\serviceDir\\activityList.xls");
//        wb.write(fos);
//        fos.close();
//        wb.close();
            //把excel文件从服务器下载到客户端
            response.setContentType("application/octet-stream;charset=UTF-8");
            response.addHeader("Content-Disposition","attachment;filename="+fileName);
            OutputStream out = response.getOutputStream();//得到客户端即浏览器的输出流
            //边读边下载
//        FileInputStream fis = new FileInputStream("D:\\code\\javacodee\\CRM\\serviceDir\\activityList.xsl");
//        byte[] bytes = new byte[255];
//        int len=0;
//        while((len=fis.read(bytes))!=-1){
//            out.write(bytes,0,len);
//        }
//        fis.close();
            wb.write(out);
            wb.close();
            out.flush();
        }

        public static String getCellValueType(HSSFCell cell){
            String ret="";
            if(cell.getCellType()== HSSFCell.CELL_TYPE_BOOLEAN){
                ret=cell.getBooleanCellValue()+"";
            }else if(cell.getCellType()==HSSFCell.CELL_TYPE_STRING){
                ret=cell.getStringCellValue();
            }else if(cell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC){
                ret=cell.getNumericCellValue()+"";
            }else if(cell.getCellType()==HSSFCell.CELL_TYPE_FORMULA){
                ret=cell.getCellFormula()+"";
            }else{
                ret="";
            }
            return ret;
        }

}
