package tr.edu.duzce.mf.bm.config;

import org.springframework.security.web.context.AbstractSecurityWebApplicationInitializer;

/**
 * Spring Security'nin servlet filter zincirini (springSecurityFilterChain)
 * Tomcat'in filter chain'ine kaydeder.
 *
 * SecurityConfig zaten AppInitializer üzerinden root context'e yüklendiği için
 * burada yapılandırma sınıfı parametresi vermeye gerek yok.
 */
public class SecurityWebInitializer extends AbstractSecurityWebApplicationInitializer {
}
