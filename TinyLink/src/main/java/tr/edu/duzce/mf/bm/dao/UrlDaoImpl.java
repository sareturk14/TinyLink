package tr.edu.duzce.mf.bm.dao;

import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import tr.edu.duzce.mf.bm.entity.UrlLink;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class UrlDaoImpl implements UrlDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(UrlLink urlLink) {
        sessionFactory.getCurrentSession().persist(urlLink);
    }

    @Override
    public void update(UrlLink urlLink) {
        sessionFactory.getCurrentSession().merge(urlLink);
    }

    @Override
    public void deleteById(Long id) {
        UrlLink urlLink = sessionFactory.getCurrentSession().get(UrlLink.class, id);
        if (urlLink != null) {
            sessionFactory.getCurrentSession().remove(urlLink);
        }
    }

    @Override
    public UrlLink findByShortCode(String shortCode) {
        Query<UrlLink> query = sessionFactory.getCurrentSession()
                .createQuery("FROM UrlLink u WHERE u.shortCode = :shortCode", UrlLink.class);
        query.setParameter("shortCode", shortCode);
        try {
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public Optional<UrlLink> findById(Long id) {
        return Optional.ofNullable(
                sessionFactory.getCurrentSession().get(UrlLink.class, id)
        );
    }

    @Override
    public List<UrlLink> findAll() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM UrlLink u ORDER BY u.createdAt DESC", UrlLink.class)
                .getResultList();
    }

    @Override
    public List<UrlLink> findByUserId(Long userId) {
        Query<UrlLink> query = sessionFactory.getCurrentSession()
                .createQuery(
                        "FROM UrlLink u WHERE u.user.id = :userId ORDER BY u.createdAt DESC",
                        UrlLink.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }

    @Override
    public List<UrlLink> findExpired() {
        Query<UrlLink> query = sessionFactory.getCurrentSession()
                .createQuery(
                        "FROM UrlLink u WHERE u.expiresAt IS NOT NULL AND u.expiresAt < :now",
                        UrlLink.class);
        query.setParameter("now", LocalDateTime.now());
        return query.getResultList();
    }

    @Override
    public boolean existsByShortCode(String shortCode) {
        Query<Long> query = sessionFactory.getCurrentSession()
                .createQuery(
                        "SELECT COUNT(u) FROM UrlLink u WHERE u.shortCode = :shortCode",
                        Long.class);
        query.setParameter("shortCode", shortCode);
        Long count = query.getSingleResult();
        return count != null && count > 0;
    }

    // ------------------------------------------------------------------
    // Soft Delete & Kategori implementasyonları
    // ------------------------------------------------------------------

    @Override
    public List<UrlLink> findActiveByUserId(Long userId) {
        Query<UrlLink> query = sessionFactory.getCurrentSession()
                .createQuery(
                        "FROM UrlLink u " +
                        "WHERE u.user.id = :userId " +
                        "  AND u.deleted = false " +
                        "  AND (u.expiresAt IS NULL OR u.expiresAt >= :now) " +
                        "ORDER BY u.createdAt DESC",
                        UrlLink.class);
        query.setParameter("userId", userId);
        query.setParameter("now", LocalDateTime.now());
        return query.getResultList();
    }

    @Override
    public List<UrlLink> findDeletedByUserId(Long userId) {
        Query<UrlLink> query = sessionFactory.getCurrentSession()
                .createQuery(
                        "FROM UrlLink u " +
                        "WHERE u.user.id = :userId " +
                        "  AND u.deleted = true " +
                        "ORDER BY u.createdAt DESC",
                        UrlLink.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }

    @Override
    public void softDeleteUrl(Long id) {
        UrlLink urlLink = sessionFactory.getCurrentSession().get(UrlLink.class, id);
        if (urlLink != null) {
            urlLink.setDeleted(true);
            // @Transactional sayesinde session kapanırken Hibernate dirty-check ile otomatik UPDATE gönderir
        }
    }

    @Override
    public void restoreUrl(Long id) {
        UrlLink urlLink = sessionFactory.getCurrentSession().get(UrlLink.class, id);
        if (urlLink != null) {
            urlLink.setDeleted(false);
        }
    }
}
