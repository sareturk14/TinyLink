package tr.edu.duzce.mf.bm.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.stereotype.Controller;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.EnableAsync;

/**
 * Kök uygulama yapılandırması (Root Application Context).
 * Controller dışındaki tüm Spring bileşenlerini (Service, Repository, DAO)
 * otomatik olarak tarar ve yönetir.
 */
@Configuration
@EnableScheduling
@EnableAsync
@ComponentScan(
    basePackages = "tr.edu.duzce.mf.bm",
    excludeFilters = @ComponentScan.Filter(
        type  = FilterType.ANNOTATION,
        classes = Controller.class
    )
)
public class AppConfig {
    // Tüm bean tanımları @Component, @Service, @Repository
    // anotasyonlarıyla ilgili sınıflarda yapılır.
}
