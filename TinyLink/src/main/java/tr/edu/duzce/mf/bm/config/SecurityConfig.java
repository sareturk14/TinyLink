package tr.edu.duzce.mf.bm.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

/**
 * Spring Security yapılandırması — kimlik doğrulama ve yetkilendirme altyapısı.
 *
 * Bu sınıf şunları sağlar:
 *  - BCryptPasswordEncoder: şifrelerin tek yönlü, salt'lı hash'lenmesi
 *  - AuthenticationManager: AuthController'da inject edilebilir
 *  - SecurityFilterChain: hangi URL'lerin korumalı olduğunu belirler
 *  - RoleBasedAuthenticationSuccessHandler: giriş sonrası rol bazlı yönlendirme
 *
 * CSRF varsayılan olarak aktif — tüm POST formları _csrf token göndermek zorunda.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public AuthenticationSuccessHandler roleBasedSuccessHandler() {
        return new RoleBasedAuthenticationSuccessHandler();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   AuthenticationSuccessHandler successHandler) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                // Admin paneli yalnızca ADMIN rolü için
                .requestMatchers("/admin/**").hasRole("ADMIN")
                // Kimlik doğrulama akışı + statik kaynaklar — herkese açık
                .requestMatchers("/login", "/register", "/verify", "/auth/resend-verification", "/assets/**").permitAll()
                // Kullanıcı dashboard işlemleri — yalnızca giriş yapmış kullanıcılar
                .requestMatchers("/", "/shorten", "/trash", "/urls/**").authenticated()
                // Geri kalan tek-segmentli yollar (/{shortCode}) — herkese açık
                .anyRequest().permitAll()
            )

            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .usernameParameter("email")
                .passwordParameter("password")
                // Rol bazlı yönlendirme: ADMIN -> /admin, USER -> /
                .successHandler(successHandler)
                .failureHandler((req, res, ex) -> {
                    String target = (ex instanceof org.springframework.security.authentication.LockedException)
                            ? "/login?error=locked" : "/login?error";
                    res.sendRedirect(req.getContextPath() + target);
                })
                .permitAll()
            )

            .logout(logout -> logout
                .logoutUrl("/logout")
                // Çıkıştan sonra login sayfasında "Çıkış yaptın" mesajı görünsün
                .logoutSuccessUrl("/login?logout")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            );

        return http.build();
    }
}
