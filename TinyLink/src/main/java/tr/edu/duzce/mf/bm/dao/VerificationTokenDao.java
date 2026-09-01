package tr.edu.duzce.mf.bm.dao;

import tr.edu.duzce.mf.bm.entity.User;
import tr.edu.duzce.mf.bm.entity.VerificationToken;

import java.util.Optional;

public interface VerificationTokenDao {

    void save(VerificationToken token);

    Optional<VerificationToken> findByToken(String token);

    Optional<VerificationToken> findByUser(User user);

    void delete(VerificationToken token);
}
