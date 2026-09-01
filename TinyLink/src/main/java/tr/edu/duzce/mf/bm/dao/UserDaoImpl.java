package tr.edu.duzce.mf.bm.dao;

import jakarta.persistence.NoResultException;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import tr.edu.duzce.mf.bm.entity.User;

import java.util.List;
import java.util.Optional;

@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(User user) {
        sessionFactory.getCurrentSession().persist(user);
    }

    @Override
    public void update(User user) {
        sessionFactory.getCurrentSession().merge(user);
    }

    @Override
    public Optional<User> findById(Long id) {
        return Optional.ofNullable(
                sessionFactory.getCurrentSession().get(User.class, id)
        );
    }

    @Override
    public Optional<User> findByEmail(String email) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("FROM User u WHERE u.email = :email", User.class);
        query.setParameter("email", email);
        try {
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<User> findByUsername(String username) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("FROM User u WHERE u.username = :username", User.class);
        query.setParameter("username", username);
        try {
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    @Override
    public boolean existsByEmail(String email) {
        Query<Long> query = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class);
        query.setParameter("email", email);
        return query.getSingleResult() > 0;
    }

    @Override
    public boolean existsByUsername(String username) {
        Query<Long> query = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(u) FROM User u WHERE u.username = :username", Long.class);
        query.setParameter("username", username);
        return query.getSingleResult() > 0;
    }

    @Override
    public List<User> findAll() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM User u ORDER BY u.createdAt DESC", User.class)
                .getResultList();
    }

    @Override
    public long count() {
        return sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(u) FROM User u", Long.class)
                .getSingleResult();
    }
}
