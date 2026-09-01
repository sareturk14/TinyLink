package tr.edu.duzce.mf.bm.dao;

import jakarta.persistence.NoResultException;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import tr.edu.duzce.mf.bm.entity.User;
import tr.edu.duzce.mf.bm.entity.VerificationToken;

import java.util.Optional;

@Repository
public class VerificationTokenDaoImpl implements VerificationTokenDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(VerificationToken token) {
        sessionFactory.getCurrentSession().persist(token);
    }

    @Override
    public Optional<VerificationToken> findByToken(String token) {
        Query<VerificationToken> query = sessionFactory.getCurrentSession()
                .createQuery("FROM VerificationToken vt WHERE vt.token = :token", VerificationToken.class);
        query.setParameter("token", token);
        try {
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<VerificationToken> findByUser(User user) {
        Query<VerificationToken> query = sessionFactory.getCurrentSession()
                .createQuery("FROM VerificationToken vt WHERE vt.user = :user", VerificationToken.class);
        query.setParameter("user", user);
        try {
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    @Override
    public void delete(VerificationToken token) {
        sessionFactory.getCurrentSession().remove(token);
    }
}
