package per.zpp.workbench.service;

import per.zpp.workbench.domain.FunnelVO;
import per.zpp.workbench.domain.Tran;
import per.zpp.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

public interface TranService {

    List<Tran> queryTranByConditionForPage(Map<String,Object> map);

    int queryTranCountForPage(Map<String,Object> map);

    void saveCreateTran(Tran tran);

    Tran selectTranById(String id);

    Tran selectTransactionById(String id);

    List<FunnelVO> queryCountOfTranGroupByStage();

    List<Tran> selectTranByContactsId(String id);


    void deleteByTranIds(String [] id);

    void editTran(Tran tran);

    Tran selectEditTranById(String id);
}
