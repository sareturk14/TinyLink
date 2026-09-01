package tr.edu.duzce.mf.bm.dao;

import tr.edu.duzce.mf.bm.entity.UrlLink;

import java.util.List;
import java.util.Optional;

public interface UrlDao {

    void save(UrlLink urlLink);

    void update(UrlLink urlLink);

    void deleteById(Long id);

    /** Kısa koda göre URL getirir. Bulunamazsa null döner. */
    UrlLink findByShortCode(String shortCode);

    Optional<UrlLink> findById(Long id);

    List<UrlLink> findAll();

    /** Belirli bir kullanıcıya ait tüm URL'leri getirir. */
    List<UrlLink> findByUserId(Long userId);

    /**
     * Süresi dolmuş URL'leri getirir.
     * Kural: expires_at IS NOT NULL AND expires_at &lt; şu anki zaman
     */
    List<UrlLink> findExpired();

    boolean existsByShortCode(String shortCode);

    // ------------------------------------------------------------------
    // Soft Delete & Kategori metotları
    // ------------------------------------------------------------------

    /**
     * Kullanıcının aktif URL'lerini döner.
     * Kural: is_deleted=false VE (expires_at IS NULL VEYA expires_at >= şimdi)
     */
    List<UrlLink> findActiveByUserId(Long userId);

    /**
     * Kullanıcının çöp kutusundaki URL'lerini döner.
     * Kural: is_deleted=true
     */
    List<UrlLink> findDeletedByUserId(Long userId);

    /**
     * URL'yi fiziksel olarak silmek yerine is_deleted=true yapar.
     */
    void softDeleteUrl(Long id);

    /**
     * Çöp kutusundaki URL'yi geri alır: is_deleted=false yapar.
     */
    void restoreUrl(Long id);
}
