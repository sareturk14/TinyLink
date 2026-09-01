package tr.edu.duzce.mf.bm.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

public class RequestLoggingInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(RequestLoggingInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        // İstek (Request) işlenmeden hemen önce çalışır
        String uri = request.getRequestURI();
        String method = request.getMethod();

        StringBuilder params = new StringBuilder();
        Map<String, String[]> parameterMap = request.getParameterMap();

        if (!parameterMap.isEmpty()) {
            params.append(" | Parametreler: ");
            parameterMap.forEach((key, values) ->
                    params.append(key).append("=").append(String.join(",", values)).append(" ")
            );
        }

        logger.info("GELEN İSTEK -> URI: {}, Metot: {}{}", uri, method, params);
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) {
        // İstek bittikten ve View'a (Görüntüye) dönmeden hemen önce çalışır
        if (modelAndView != null) {
            logger.info("GELEN CEVAP -> Görüntü (View) Adı: {}, Taşınan Veriler: {}",
                    modelAndView.getViewName(), modelAndView.getModel());
        }
    }
}
