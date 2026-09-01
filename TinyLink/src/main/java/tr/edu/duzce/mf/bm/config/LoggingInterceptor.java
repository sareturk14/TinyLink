package tr.edu.duzce.mf.bm.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Tüm HTTP isteklerini ve yanıtlarını otomatik olarak loglayan interceptor.
 *
 * preHandle       → istek detayları (method, URI, IP, User-Agent, parametreler)
 * postHandle      → view adı ve model anahtarları (DEBUG — varsayılan INFO seviyesinde gözükmez)
 * afterCompletion → HTTP durum kodu, toplam süre, varsa hata
 */
public class LoggingInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(LoggingInterceptor.class);

    /** Başlangıç zamanını request attribute olarak saklarken kullanılan anahtar. */
    private static final String START_TIME_ATTR = "reqStartTime";

    /** Loglanmayacak hassas parametre adları (güvenlik). */
    private static final Set<String> SENSITIVE_PARAMS = Set.of("password", "password_confirm", "token", "secret");

    // -------------------------------------------------------------------------
    // preHandle: istek işlenmeden önce
    // -------------------------------------------------------------------------
    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) {

        request.setAttribute(START_TIME_ATTR, System.currentTimeMillis());

        String method     = request.getMethod();
        String uri        = request.getRequestURI();
        String remoteAddr = request.getRemoteAddr();
        String userAgent  = request.getHeader("User-Agent");
        String params     = buildParamString(request.getParameterMap());

        log.info(">>> REQUEST  [{} {}] | IP: {} | Params: {} | UA: {}",
                method, uri, remoteAddr, params, abbreviate(userAgent, 60));

        return true; // işlemeye devam et
    }

    // -------------------------------------------------------------------------
    // postHandle: controller bitti, view render edilmeden önce
    // -------------------------------------------------------------------------
    @Override
    public void postHandle(HttpServletRequest request,
                           HttpServletResponse response,
                           Object handler,
                           ModelAndView modelAndView) {

        if (modelAndView != null) {
            log.debug("    VIEW     [{}] | Model keys: {}",
                    modelAndView.getViewName(),
                    modelAndView.getModel().keySet());
        }
    }

    // -------------------------------------------------------------------------
    // afterCompletion: view render edildi (ya da redirect yapıldı), istek bitti
    // -------------------------------------------------------------------------
    @Override
    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response,
                                Object handler,
                                Exception ex) {

        long duration = elapsed(request);
        int  status   = response.getStatus();
        String label  = request.getMethod() + " " + request.getRequestURI();

        if (ex != null) {
            log.error("<<< RESPONSE [{}] | Status: {} | Time: {} ms | ERROR: {}",
                    label, status, duration, ex.getMessage());
        } else {
            log.info("<<< RESPONSE [{}] | Status: {} | Time: {} ms",
                    label, status, duration);
        }
    }

    // -------------------------------------------------------------------------
    // Yardımcı metodlar
    // -------------------------------------------------------------------------

    private String buildParamString(Map<String, String[]> paramMap) {
        if (paramMap == null || paramMap.isEmpty()) {
            return "-";
        }
        return paramMap.entrySet().stream()
                .map(e -> SENSITIVE_PARAMS.contains(e.getKey().toLowerCase())
                        ? e.getKey() + "=***"
                        : e.getKey() + "=" + String.join(",", e.getValue()))
                .collect(Collectors.joining(" | "));
    }

    private long elapsed(HttpServletRequest request) {
        Object start = request.getAttribute(START_TIME_ATTR);
        return (start instanceof Long) ? System.currentTimeMillis() - (Long) start : -1L;
    }

    private String abbreviate(String str, int maxLen) {
        if (str == null) return "-";
        return str.length() <= maxLen ? str : str.substring(0, maxLen) + "...";
    }
}
