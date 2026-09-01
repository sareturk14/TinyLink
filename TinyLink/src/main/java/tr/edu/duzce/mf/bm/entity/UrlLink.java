package tr.edu.duzce.mf.bm.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "urls")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UrlLink {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "original_url", nullable = false, length = 2048)
    private String originalUrl;

    @Column(name = "short_code", nullable = false, unique = true, length = 20)
    private String shortCode;

    // Null = kalıcı link (süresi yok)
    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "ai_summary", columnDefinition = "TEXT")
    private String aiSummary;

    @Column(name = "ai_category", length = 50)
    private String aiCategory;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "click_count", nullable = false)
    private int clickCount;

    // Soft delete: true ise URL çöp kutusundadır, fiziksel olarak silinmez
    @Column(name = "is_deleted", nullable = false)
    private boolean deleted;

    // Soft delete'in yapıldığı an — UrlCleanupService, 7 gün geçmiş kayıtları
    // hard delete eder. Aktif URL'lerde null'dur.
    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    // Null = kategorisiz; kullanıcı kendi URL'lerini gruplayabilir
    @Column(name = "category_name", length = 50)
    private String categoryName;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.clickCount = 0;
        this.deleted = false;
    }

    // =========================================================================
    // Uyumluluk metotları: Mevcut kodun setSummary()/getSummary() çağrıları
    // aiSummary alanına yönlendirilir, böylece eski kod kırılmaz.
    // =========================================================================

    /**
     * Uyumluluk metodu — eski kodun summary alanına erişimi için.
     * Aslında aiSummary alanını döndürür.
     */
    public String getSummary() {
        return this.aiSummary;
    }

    /**
     * Uyumluluk metodu — eski kodun summary alanına yazması için.
     * Aslında aiSummary alanına yazar.
     */
    public void setSummary(String summary) {
        this.aiSummary = summary;
    }
}