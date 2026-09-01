package tr.edu.duzce.mf.bm.dao;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import tr.edu.duzce.mf.bm.entity.UrlLink;
import tr.edu.duzce.mf.bm.entity.User;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository // Spring'e bu sınıfın bir veritabanı erişim sınıfı olduğunu söyleriz
public class UrlLinkDaoImpl implements UrlLinkDao {

    @Autowired
    private SessionFactory sessionFactory; // HibernateConfig'de oluşturduğumuz havuz

    // O anki aktif veritabanı oturumunu getirir
    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void save(UrlLink urlLink) {
        getCurrentSession().persist(urlLink); // Veritabanına INSERT yapar
    }

    @Override
    public UrlLink findByShortCode(String shortCode) {
        // Kısa koda göre veritabanından sorgulama (SELECT) yapar
        Query<UrlLink> query = getCurrentSession().createQuery("FROM UrlLink WHERE shortCode = :code", UrlLink.class);
        query.setParameter("code", shortCode);
        return query.uniqueResult();
    }

    @Override
    public void update(UrlLink urlLink) {
        getCurrentSession().merge(urlLink); // Veritabanında UPDATE yapar
    }

    @Override
    public void delete(UrlLink urlLink) {
        Session session = getCurrentSession();
        // Detached olabilir; önce attach et sonra sil
        UrlLink managed = session.contains(urlLink) ? urlLink : session.merge(urlLink);
        session.remove(managed);
    }

    @Override
    public Optional<UrlLink> findById(Long id) {
        return Optional.ofNullable(getCurrentSession().get(UrlLink.class, id));
    }

    @Override
    public List<UrlLink> findAll() {
        return getCurrentSession().createQuery("FROM UrlLink ORDER BY createdAt DESC", UrlLink.class).getResultList();
    }

    @Override
    public long count() {
        return getCurrentSession()
                .createQuery("SELECT COUNT(u) FROM UrlLink u", Long.class)
                .getSingleResult();
    }

    @Override
    public long totalClickCount() {
        Long sum = getCurrentSession()
                .createQuery("SELECT COALESCE(SUM(u.clickCount), 0) FROM UrlLink u", Long.class)
                .getSingleResult();
        return sum != null ? sum : 0L;
    }

    @Override
    public List<UrlLink> findActiveByUser(User user) {
        Query<UrlLink> q = getCurrentSession().createQuery(
                "FROM UrlLink u WHERE u.user = :user AND u.deleted = false ORDER BY u.createdAt DESC",
                UrlLink.class);
        q.setParameter("user", user);
        return q.getResultList();
    }

    @Override
    public List<UrlLink> findTrashedByUser(User user) {
        Query<UrlLink> q = getCurrentSession().createQuery(
                "FROM UrlLink u WHERE u.user = :user AND u.deleted = true ORDER BY u.deletedAt DESC",
                UrlLink.class);
        q.setParameter("user", user);
        return q.getResultList();
    }

    @Override
    public List<UrlLink> findTrashedBefore(LocalDateTime cutoff) {
        Query<UrlLink> q = getCurrentSession().createQuery(
                "FROM UrlLink u WHERE u.deleted = true AND u.deletedAt IS NOT NULL AND u.deletedAt < :cutoff",
                UrlLink.class);
        q.setParameter("cutoff", cutoff);
        return q.getResultList();
    }

    @Override
    public Map<String, Long> countByCategory() {
        List<Object[]> rows = getCurrentSession()
                .createQuery(
                        "SELECT COALESCE(u.aiCategory, 'Kategorisiz'), COUNT(u) FROM UrlLink u " +
                        "GROUP BY COALESCE(u.aiCategory, 'Kategorisiz') ORDER BY COUNT(u) DESC",
                        Object[].class)
                .getResultList();
        Map<String, Long> result = new LinkedHashMap<>();
        for (Object[] row : rows) {
            result.put((String) row[0], (Long) row[1]);
        }
        return result;
    }
}
