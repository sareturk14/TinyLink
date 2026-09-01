package tr.edu.duzce.mf.bm.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import tr.edu.duzce.mf.bm.dao.LogDao;
import tr.edu.duzce.mf.bm.dao.UrlLinkDao;
import tr.edu.duzce.mf.bm.entity.UrlLink;
import tr.edu.duzce.mf.bm.entity.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * UrlServiceImpl birim testleri.
 * Tüm bağımlılıklar (UrlLinkDao, AiService, Base62Util) Mockito ile izole edilmiştir.
 */
@ExtendWith(MockitoExtension.class)
class UrlServiceTest {

    @Mock private UrlLinkDao urlLinkDao;
    @Mock private LogDao logDao;
    @Mock private Base62Util base62Util;
    @Mock private AiService aiService;

    @InjectMocks
    private UrlServiceImpl urlService;

    // =========================================================================
    // TEST 1: createShortUrl — başarılı senaryo
    // =========================================================================

    @Test
    @DisplayName("Geçerli URL verildiğinde kısa link kaydedilmeli, AI kategori ve özeti atanmalı")
    void createShortUrl_shouldSaveLinkWithAiData() {
        when(aiService.analyzeAndGetSummary(anyString())).thenReturn("Teknoloji | GitHub kod platformu");
        when(base62Util.generateRandomCode(6)).thenReturn("xK3mPq");
        when(urlLinkDao.findByShortCode("xK3mPq")).thenReturn(null);

        UrlLink result = urlService.createShortUrl("https://github.com", null, null);

        assertEquals("xK3mPq",              result.getShortCode(),   "Kısa kod doğru atanmalı");
        assertEquals("Teknoloji",            result.getAiCategory(),  "AI kategorisi '|' ile ayrılıp atanmalı");
        assertEquals("GitHub kod platformu", result.getAiSummary(),   "AI özeti '|' ile ayrılıp atanmalı");
        verify(urlLinkDao, times(1)).save(result);
    }

    // =========================================================================
    // TEST 2: createShortUrl — shortCode çakışması → yeniden deneme
    // =========================================================================

    @Test
    @DisplayName("ShortCode çakışması olduğunda çakışmayan yeni kod üretilmeli")
    void createShortUrl_shouldRetryOnShortCodeCollision() {
        UrlLink existing = new UrlLink();
        when(aiService.analyzeAndGetSummary(anyString())).thenReturn("Diğer | Test bağlantısı");
        when(base62Util.generateRandomCode(6))
                .thenReturn("aaaaaa")   // 1. deneme: çakışıyor
                .thenReturn("bbbbbb");  // 2. deneme: boş, kabul edilir
        when(urlLinkDao.findByShortCode("aaaaaa")).thenReturn(existing);
        when(urlLinkDao.findByShortCode("bbbbbb")).thenReturn(null);

        UrlLink result = urlService.createShortUrl("https://example.com");

        assertEquals("bbbbbb", result.getShortCode(), "Çakışmayan ikinci kod kullanılmalı");
        verify(base62Util, times(2)).generateRandomCode(6);
    }

    // =========================================================================
    // TEST 3: softDelete — sahibi olan kullanıcı silebilmeli
    // =========================================================================

    @Test
    @DisplayName("Sahip kullanıcı URL'yi soft-delete ile çöp kutusuna taşıyabilmeli")
    void softDelete_shouldMarkLinkAsDeleted() {
        User owner = new User(); owner.setId(1L);
        UrlLink link = new UrlLink();
        link.setId(10L);
        link.setUser(owner);
        link.setDeleted(false);

        when(urlLinkDao.findById(10L)).thenReturn(Optional.of(link));

        urlService.softDelete(10L, owner);

        assertTrue(link.isDeleted(),             "deleted bayrağı true olmalı");
        assertNotNull(link.getDeletedAt(),        "deletedAt alanı doldurulmalı");
        verify(urlLinkDao, times(1)).update(link);
    }

    // =========================================================================
    // TEST 4: softDelete — yetkisiz kullanıcı hata almalı
    // =========================================================================

    @Test
    @DisplayName("Başka kullanıcının URL'sine softDelete uygulanırsa IllegalStateException fırlatılmalı")
    void softDelete_shouldThrow_whenNotOwner() {
        User owner = new User(); owner.setId(1L);
        User other = new User(); other.setId(2L);
        UrlLink link = new UrlLink();
        link.setId(10L);
        link.setUser(owner);

        when(urlLinkDao.findById(10L)).thenReturn(Optional.of(link));

        assertThrows(IllegalStateException.class,
                () -> urlService.softDelete(10L, other),
                "Yetkisiz erişimde IllegalStateException bekleniyor");
        verify(urlLinkDao, never()).update(any());
    }

    // =========================================================================
    // TEST 5: isExpired — süresi geçmiş link
    // =========================================================================

    @Test
    @DisplayName("expiresAt geçmişte olan link için isExpired true dönmeli")
    void isExpired_shouldReturnTrue_whenExpired() {
        UrlLink link = new UrlLink();
        link.setDeleted(false);
        link.setExpiresAt(LocalDateTime.now().minusHours(1));
        when(urlLinkDao.findByShortCode("expired1")).thenReturn(link);

        assertTrue(urlService.isExpired("expired1"));
    }

    // =========================================================================
    // TEST 6: isExpired — süresiz (null expiresAt) link
    // =========================================================================

    @Test
    @DisplayName("expiresAt null olan (süresiz) link için isExpired false dönmeli")
    void isExpired_shouldReturnFalse_whenPermanent() {
        UrlLink link = new UrlLink();
        link.setDeleted(false);
        link.setExpiresAt(null);
        when(urlLinkDao.findByShortCode("perma1")).thenReturn(link);

        assertFalse(urlService.isExpired("perma1"));
    }

    // =========================================================================
    // TEST 7: getActiveUrlsForUser — null kullanıcı → boş liste
    // =========================================================================

    @Test
    @DisplayName("null kullanıcı için DAO'ya gitmeden boş liste dönmeli")
    void getActiveUrlsForUser_shouldReturnEmpty_whenUserIsNull() {
        List<UrlLink> result = urlService.getActiveUrlsForUser(null);

        assertTrue(result.isEmpty(), "null kullanıcı için boş liste bekleniyor");
        verifyNoInteractions(urlLinkDao);
    }
}
