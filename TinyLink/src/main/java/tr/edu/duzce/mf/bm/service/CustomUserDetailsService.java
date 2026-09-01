package tr.edu.duzce.mf.bm.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tr.edu.duzce.mf.bm.dao.UserDao;
import tr.edu.duzce.mf.bm.entity.User;

import java.util.List;

/**
 * Spring Security'nin kimlik doğrulama akışında çağırdığı servis.
 *
 * isVerified=false ise UserDetails enabled=false olarak kurulur; bu durumda
 * Spring Security otomatik olarak DisabledException fırlatır ve girişe izin vermez.
 */
@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserDao userDao;

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userDao.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException(
                        "Bu e-posta adresine sahip kullanıcı bulunamadı: " + email));

        // Role.USER -> "ROLE_USER", Role.ADMIN -> "ROLE_ADMIN"
        String authority = "ROLE_" + user.getRole().name();

        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                user.isVerified(),    // enabled — false ise DisabledException atılır
                true,                 // accountNonExpired
                true,                 // credentialsNonExpired
                !user.isBanned(),     // accountNonLocked — false ise LockedException atılır
                List.of(new SimpleGrantedAuthority(authority))
        );
    }
}
