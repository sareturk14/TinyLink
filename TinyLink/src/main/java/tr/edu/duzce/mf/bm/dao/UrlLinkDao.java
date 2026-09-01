package tr.edu.duzce.mf.bm.dao;

import tr.edu.duzce.mf.bm.entity.UrlLink;
import tr.edu.duzce.mf.bm.entity.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface UrlLinkDao {
    void save(UrlLink urlLink);                  // Yeni link kaydet
    UrlLink findByShortCode(String shortCode);   // Kısa koda göre linki bul (Yönlendirme için)
    void update(UrlLink urlLink);                // Tıklanma sayısını veya AI özetini güncelle
    void delete(UrlLink urlLink);                // Hard delete (kalıcı)
    Optional<UrlLink> findById(Long id);         // ID ile getir (sahip kontrolü için)
    List<UrlLink> findAll();                     // Bütün linkleri getir (admin paneli için)
    long count();                                // Toplam URL sayısı (admin paneli)
    long totalClickCount();                      // Tüm URL'lerin toplam tıklanma sayısı

    /** Kullanıcının çöp kutusunda olmayan (aktif) URL'lerini en yenisinden eskisine getirir. */
    List<UrlLink> findActiveByUser(User user);

    /** Kullanıcının çöp kutusundaki URL'lerini en yenisinden eskisine getirir. */
    List<UrlLink> findTrashedByUser(User user);

    /** Belirli bir tarihten önce çöpe atılmış tüm URL'leri getirir (cron job için). */
    List<UrlLink> findTrashedBefore(LocalDateTime cutoff);

    /** AI kategorilerine göre URL sayısını döndürür (admin istatistik için). */
    Map<String, Long> countByCategory();
}
