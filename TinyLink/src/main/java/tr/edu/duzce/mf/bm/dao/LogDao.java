package tr.edu.duzce.mf.bm.dao;

import tr.edu.duzce.mf.bm.entity.Log;

import java.util.List;

public interface LogDao {

    void save(Log log);

    List<Log> findAll();

    /** Belirli bir kullanıcıya ait logları getirir. */
    List<Log> findByUserId(Long userId);

    /** Belirli eylem tipine göre logları filtreler (örn: "URL_CREATED"). */
    List<Log> findByActionType(String actionType);
}
