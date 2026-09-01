package tr.edu.duzce.mf.bm.dao;

import tr.edu.duzce.mf.bm.entity.User;

import java.util.List;
import java.util.Optional;

public interface UserDao {

    void save(User user);

    void update(User user);

    Optional<User> findById(Long id);

    Optional<User> findByEmail(String email);

    Optional<User> findByUsername(String username);

    boolean existsByEmail(String email);

    boolean existsByUsername(String username);

    List<User> findAll();

    long count();
}
