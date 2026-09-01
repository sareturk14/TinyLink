package tr.edu.duzce.mf.bm.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tr.edu.duzce.mf.bm.dao.UrlLinkDao;
import tr.edu.duzce.mf.bm.entity.UrlLink;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Çöp kutusundaki (isDeleted = true) URL kayıtlarını periyodik olarak hard delete eden servis.
 *
 * Kuralı: deletedAt değerinin üzerinden 7 gün geçmiş kayıtlar tamamen veritabanından silinir.
 * Cron: Her pazar gecesi 03:00 (Avrupa/İstanbul saatine göre uygulama saatiyle).
 *
 * @EnableScheduling AppConfig'de tanımlı; bu sınıf @Service olduğu için root context tarafından
 * yönetilir ve scheduler tarafından otomatik olarak tetiklenir.
 */
@Service
public class UrlCleanupService {

    private static final Logger log = LoggerFactory.getLogger(UrlCleanupService.class);

    /** Çöpe atılmış bir URL'nin kalıcı silinmeden önce bekleyeceği gün sayısı. */
    private static final int RETENTION_DAYS = 7;

    @Autowired
    private UrlLinkDao urlLinkDao;

    /**
     * Cron pattern: saniye dakika saat gün-ay ay gün-hafta
     * "0 0 3 ? * SUN"  -> Her pazar saat 03:00'te çalışır.
     */
    @Scheduled(cron = "0 0 3 ? * SUN")
    @Transactional
    public void purgeExpiredTrash() {
        LocalDateTime cutoff = LocalDateTime.now().minusDays(RETENTION_DAYS);
        List<UrlLink> stale = urlLinkDao.findTrashedBefore(cutoff);

        if (stale.isEmpty()) {
            log.info("Çöp kutusu temizlik görevi: silinecek eski kayıt yok.");
            return;
        }

        for (UrlLink link : stale) {
            urlLinkDao.delete(link);
        }
        log.info("Çöp kutusu temizlik görevi: {} adet URL kalıcı olarak silindi (cutoff: {}).",
                stale.size(), cutoff);
    }
}
