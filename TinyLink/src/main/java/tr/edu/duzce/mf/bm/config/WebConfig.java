package tr.edu.duzce.mf.bm.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import java.time.Duration;
import java.util.Locale;

/**
 * Web (Servlet) Context yapılandırması.
 * Yalnızca @Controller bileşenlerini tarar;
 * Service/DAO bean'leri kök context'teki AppConfig tarafından sağlanır.
 */
@Configuration
@EnableWebMvc
@EnableTransactionManagement
@ComponentScan(
    basePackages    = "tr.edu.duzce.mf.bm",
    useDefaultFilters = false,
    includeFilters  = @ComponentScan.Filter(
        type    = FilterType.ANNOTATION,
        classes = Controller.class
    )
)
public class WebConfig implements WebMvcConfigurer {

    // 1. Çoklu Dil Desteği
    @Bean
    public ResourceBundleMessageSource messageSource() {
        ResourceBundleMessageSource source = new ResourceBundleMessageSource();
        source.setBasename("messages");
        source.setDefaultEncoding("UTF-8");
        return source;
    }

    // 2. Dil tercihini cookie'de sakla, varsayılan Türkçe
    @Bean
    public CookieLocaleResolver localeResolver() {
        CookieLocaleResolver resolver = new CookieLocaleResolver("language-cookie");
        resolver.setDefaultLocale(new Locale("tr"));
        resolver.setCookieMaxAge(Duration.ofHours(1));
        return resolver;
    }

    // 3. JSP View Resolver
    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        return resolver;
    }

    // 4. Statik kaynaklar (CSS, JS, resimler)
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/**")
                .addResourceLocations("/assets/");
    }

    // 5. Interceptor'lar
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        LocaleChangeInterceptor localeInterceptor = new LocaleChangeInterceptor();
        localeInterceptor.setParamName("lang");
        registry.addInterceptor(localeInterceptor);

        registry.addInterceptor(new LoggingInterceptor());
    }
}