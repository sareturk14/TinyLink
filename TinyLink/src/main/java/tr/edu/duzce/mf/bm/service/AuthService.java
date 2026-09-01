package tr.edu.duzce.mf.bm.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tr.edu.duzce.mf.bm.dao.LogDao;
import tr.edu.duzce.mf.bm.dao.UserDao;
import tr.edu.duzce.mf.bm.dao.VerificationTokenDao;
import tr.edu.duzce.mf.bm.entity.Log;
import tr.edu.duzce.mf.bm.entity.Role;
import tr.edu.duzce.mf.bm.entity.User;
import tr.edu.duzce.mf.bm.entity.VerificationToken;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

/**
 * Kayıt ve e-posta doğrulama akışlarını @Transactional sınırları içinde yürüten servis.
 * Şifre BCrypt ile hash'lenir; kayıt sonrası UUID token üretilip e-posta ile gönderilir.
 */
@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    /** Doğrulama linkinin geçerli kalacağı süre (saat). */
    private static final int TOKEN_VALIDITY_HOURS = 24;

    /** Mailde geçecek uygulama URL'i; ortam değişkeniyle değiştirilebilir. */
    private static final String APP_BASE_URL =
            System.getenv().getOrDefault("APP_BASE_URL", "http://localhost:8080/bm470");

    @Autowired
    private UserDao userDao;

    @Autowired
    private LogDao logDao;

    @Autowired
    private VerificationTokenDao verificationTokenDao;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private EmailService emailService;

    private static final java.util.regex.Pattern PASSWORD_POLICY =
            java.util.regex.Pattern.compile("^(?=.*[A-Z]).{6,}$");

    @Transactional
    public void register(String username, String email, String rawPassword) {
        if (userDao.existsByUsername(username)) {
            throw new IllegalArgumentException("Bu kullanıcı adı zaten kayıtlı.");
        }
        if (userDao.existsByEmail(email)) {
            throw new IllegalArgumentException("Bu e-posta adresi zaten kayıtlı.");
        }
        if (!PASSWORD_POLICY.matcher(rawPassword).matches()) {
            throw new IllegalArgumentException("weak_password");
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(rawPassword));
        user.setRole(Role.USER);
        user.setVerified(false);

        userDao.save(user);
        logDao.save(new Log(null, user, "USER_REGISTER",
                "username=" + user.getUsername(), null));

        VerificationToken token = new VerificationToken(
                UUID.randomUUID().toString(),
                user,
                LocalDateTime.now().plusHours(TOKEN_VALIDITY_HOURS)
        );
        verificationTokenDao.save(token);

        sendVerificationEmail(user, token.getToken());

    }

    /**
     * Token'ı doğrular: bulamazsa veya süresi dolmuşsa false döner.
     * Geçerliyse kullanıcının isVerified=true yapılır ve token silinir.
     */
    @Transactional
    public boolean verifyToken(String tokenStr) {
        Optional<VerificationToken> opt = verificationTokenDao.findByToken(tokenStr);
        if (opt.isEmpty()) {
            return false;
        }

        VerificationToken token = opt.get();
        if (token.isExpired()) {
            verificationTokenDao.delete(token);
            return false;
        }

        User user = token.getUser();
        user.setVerified(true);
        userDao.update(user);

        verificationTokenDao.delete(token);
        logDao.save(new Log(null, user, "USER_VERIFIED",
                "username=" + user.getUsername(), null));
        return true;
    }

    /**
     * Doğrulama maili tekrar gönderir.
     * Kullanıcı bulunamazsa veya zaten doğrulanmışsa IllegalArgumentException fırlatır.
     * Varsa eski token silinip yeni token oluşturulur; mail @Async ile arka planda gönderilir.
     */
    @Transactional
    public void resendVerification(String email) {
        User user = userDao.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("NOT_FOUND"));

        if (user.isVerified()) {
            throw new IllegalArgumentException("ALREADY_VERIFIED");
        }

        verificationTokenDao.findByUser(user).ifPresent(verificationTokenDao::delete);

        VerificationToken token = new VerificationToken(
                UUID.randomUUID().toString(),
                user,
                LocalDateTime.now().plusHours(TOKEN_VALIDITY_HOURS)
        );
        verificationTokenDao.save(token);

        sendVerificationEmail(user, token.getToken());
    }

    private void sendVerificationEmail(User user, String tokenStr) {
        String verifyLink = APP_BASE_URL + "/verify?token=" + tokenStr;
        String subject = "Hesabınızı doğrulayın";
        String body = "Merhaba " + user.getUsername() + ",\n\n"
                + "Hesabınızı doğrulamak için tıklayın: " + verifyLink + "\n\n"
                + "Bu link " + TOKEN_VALIDITY_HOURS + " saat boyunca geçerlidir.\n\n"
                + "Eğer bu kayıt isteği size ait değilse bu maili dikkate almayın.";

        try {
            emailService.send(user.getEmail(), subject, body);
        } catch (Exception e) {
            // Mail hatası kaydı geri almasın — kullanıcı oluşmuş olsun, doğrulama tekrar tetiklenebilir
            log.warn("Doğrulama maili gönderilemedi (kullanıcı oluşturuldu): username={}, error={}",
                    user.getUsername(), e.getMessage());
        }
    }
}
