package tr.edu.duzce.mf.bm.config;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.orm.hibernate5.HibernateTransactionManager;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.beans.PropertyVetoException;
import java.util.Properties;

@Configuration
@EnableTransactionManagement
public class DatabaseConfig {

    // 1. c3p0 Bağlantı Havuzu
    @Bean
    public DataSource dataSource() {
        ComboPooledDataSource ds = new ComboPooledDataSource();
        try {
            ds.setDriverClass("com.mysql.cj.jdbc.Driver");

            String dbHost = System.getenv().getOrDefault("DB_HOST", "localhost");
            ds.setJdbcUrl("jdbc:mysql://" + dbHost + ":3306/url_shortener_db"
                    + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
            ds.setUser("admin");
            ds.setPassword("admin123");

            // Bağlantı havuzu sınırları
            ds.setMinPoolSize(5);
            ds.setMaxPoolSize(20);
            ds.setMaxIdleTime(3000);
        } catch (PropertyVetoException e) {
            throw new RuntimeException("Veritabanı sürücüsü yüklenemedi!", e);
        }
        return ds;
    }

    // 2. Hibernate SessionFactory
    @Bean
    public LocalSessionFactoryBean sessionFactory() {
        LocalSessionFactoryBean sf = new LocalSessionFactoryBean();
        sf.setDataSource(dataSource());

        // entity paketini otomatik tarar — yeni entity eklendikçe burayı değiştirmeye gerek yok
        sf.setPackagesToScan("tr.edu.duzce.mf.bm.entity");

        Properties props = new Properties();
        props.setProperty("hibernate.dialect",        "org.hibernate.dialect.MySQLDialect");
        props.setProperty("hibernate.show_sql",       "true");
        props.setProperty("hibernate.format_sql",     "false");
        // "update": tablo yoksa oluşturur, varsa sütun ekler — silme yapmaz
        props.setProperty("hibernate.hbm2ddl.auto",   "update");
        sf.setHibernateProperties(props);

        return sf;
    }

    // 3. Transaction Yöneticisi
    @Bean
    public HibernateTransactionManager transactionManager() {
        HibernateTransactionManager tm = new HibernateTransactionManager();
        tm.setSessionFactory(sessionFactory().getObject());
        return tm;
    }
}
