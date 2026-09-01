package tr.edu.duzce.mf.bm.service;

import tr.edu.duzce.mf.bm.entity.UrlLink;
import tr.edu.duzce.mf.bm.entity.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface UrlService {

    /**
     * Uzun URL'yi kısaltır. user null ise anonim, expiresAt null ise süresizdir.
     *
     * @param originalUrl kısaltılacak uzun URL
     * @param owner       link sahibi (giriş yapmış kullanıcı) — null olabilir
     * @param expiresAt   geçerlilik bitiş anı — null olabilir (kalıcı)
     * @return oluşturulan UrlLink nesnesi
     */
    UrlLink createShortUrl(String originalUrl, User owner, LocalDateTime expiresAt);

    /**
     * Eski API ile uyumluluk: anonim, süresiz link oluşturur.
     */
    UrlLink createShortUrl(String originalUrl);

    /**
     * Kısa kod ile URL arar ve tıklama sayısını artırır.
     */
    String getOriginalUrl(String shortCode);

    /**
     * Aktif (silinmemiş ve süresi dolmamış) URL'yi kısa koda göre getirir.
     */
    Optional<UrlLink> findActiveByShortCode(String shortCode);

    /**
     * Süresi dolmuş bir kısa kodla eşleşen kayıt var mı? — Yönlendirme akışında
     * "süresi doldu" sayfası göstermek için kullanılır.
     */
    boolean isExpired(String shortCode);

    /** Verilen URL kaydı için tıklanma sayısını 1 artırır. */
    void registerClick(UrlLink link);

    /** Tüm URL'ler (admin paneli için). */
    List<UrlLink> getAllUrls();

    /** Kullanıcının çöp kutusunda olmayan aktif URL'leri. */
    List<UrlLink> getActiveUrlsForUser(User owner);

    /** Kullanıcının çöp kutusundaki URL'leri. */
    List<UrlLink> getTrashedUrlsForUser(User owner);

    /**
     * URL'yi çöp kutusuna atar (soft delete). Sahip kontrolü yapar; sahip değilse
     * IllegalStateException atar.
     */
    void softDelete(Long id, User owner);

    /** Çöp kutusundaki URL'yi geri yükler. */
    void restore(Long id, User owner);

    /** Çöp kutusundaki URL'yi kalıcı olarak siler. */
    void permanentlyDelete(Long id, User owner);
}
