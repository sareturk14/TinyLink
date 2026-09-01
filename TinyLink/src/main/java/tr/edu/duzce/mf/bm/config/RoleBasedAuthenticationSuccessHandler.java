package tr.edu.duzce.mf.bm.config;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;

import java.io.IOException;

/**
 * Giriş başarılı olduğunda role göre yönlendirme yapar:
 *  - ROLE_ADMIN  -> /admin
 *  - diğer       -> /  (kullanıcı dashboard'u)
 */
public class RoleBasedAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {

        String target = "/";
        for (GrantedAuthority authority : authentication.getAuthorities()) {
            if ("ROLE_ADMIN".equals(authority.getAuthority())) {
                target = "/admin";
                break;
            }
        }

        // DefaultRedirectStrategy contextPath'i otomatik prefix'ler;
        // burada manuel eklemek "/bm470/bm470/..." (çift dizin) hatasına yol açar.
        getRedirectStrategy().sendRedirect(request, response, target);
    }
}
