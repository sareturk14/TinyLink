package tr.edu.duzce.mf.bm.dao;

import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import tr.edu.duzce.mf.bm.entity.Log;

import java.util.List;

@Repository
public class LogDaoImpl implements LogDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(Log log) {
        sessionFactory.getCurrentSession().persist(log);
    }

    @Override
    public List<Log> findAll() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Log l ORDER BY l.createdAt DESC", Log.class)
                .getResultList();
    }

    @Override
    public List<Log> findByUserId(Long userId) {
        Query<Log> query = sessionFactory.getCurrentSession()
                .createQuery(
                        "FROM Log l WHERE l.user.id = :userId ORDER BY l.createdAt DESC",
                        Log.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }

    @Override
    public List<Log> findByActionType(String actionType) {
        Query<Log> query = sessionFactory.getCurrentSession()
                .createQuery(
                        "FROM Log l WHERE l.actionType = :actionType ORDER BY l.createdAt DESC",
                        Log.class);
        query.setParameter("actionType", actionType);
        return query.getResultList();
    }
}
