package tr.edu.duzce.mf.bm.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tr.edu.duzce.mf.bm.dao.LogDao;
import tr.edu.duzce.mf.bm.dao.UrlLinkDao;
import tr.edu.duzce.mf.bm.entity.Log;
import tr.edu.duzce.mf.bm.entity.UrlLink;
import tr.edu.duzce.mf.bm.entity.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@Transactional
public class UrlServiceImpl implements UrlService {

    @Autowired
    private UrlLinkDao urlLinkDao;

    @Autowired
    private LogDao logDao;

    @Autowired
    private Base62Util base62Util;

    @Autowired
    private AiService aiService;

    private static final int SHORT_CODE_LENGTH = 6;

    @Override
    public UrlLink createShortUrl(String originalUrl, User owner, LocalDateTime expiresAt) {
        UrlLink urlLink = new UrlLink();
        urlLink.setOriginalUrl(originalUrl);
        urlLink.setUser(owner);
        urlLink.setExpiresAt(expiresAt);

        // AI servisi "KATEGORİ | ÖZET" formatında cevap döndürür; ayır ve kaydet
        String aiResponse = aiService.analyzeAndGetSummary(originalUrl);
        String[] aiParts = aiResponse.split("\\|", 2);
        if (aiParts.length == 2) {
            String category = aiParts[0].trim();
            String summary  = aiParts[1].trim();
            if (!category.isEmpty()) {
                urlLink.setAiCategory(category);
            }
            urlLink.setAiSummary(summary);
        } else {
            urlLink.setAiSummary(aiResponse);
        }

        // 6 karakterlik rastgele benzersiz kısa kod üret — çakışma varsa döngüde yenile
        String shortCode;
        do {
            shortCode = base62Util.generateRandomCode(SHORT_CODE_LENGTH);
        } while (urlLinkDao.findByShortCode(shortCode) != null);

        urlLink.setShortCode(shortCode);
        urlLinkDao.save(urlLink);

        logDao.save(new Log(null, owner, "URL_CREATED",
                "shortCode=" + shortCode + " url=" + originalUrl, null));

        return urlLink;
    }

    @Override
    public UrlLink createShortUrl(String originalUrl) {
        return createShortUrl(originalUrl, null, null);
    }

    @Override
    public String getOriginalUrl(String shortCode) {
        return findActiveByShortCode(shortCode)
                .map(link -> {
                    registerClick(link);
                    return link.getOriginalUrl();
                })
                .orElse(null);
    }

    @Override
    public Optional<UrlLink> findActiveByShortCode(String shortCode) {
        UrlLink link = urlLinkDao.findByShortCode(shortCode);
        if (link == null) {
            return Optional.empty();
        }
        if (link.isDeleted()) {
            return Optional.empty();
        }
        if (link.getExpiresAt() != null && link.getExpiresAt().isBefore(LocalDateTime.now())) {
            return Optional.empty();
        }
        return Optional.of(link);
    }

    @Override
    public boolean isExpired(String shortCode) {
        UrlLink link = urlLinkDao.findByShortCode(shortCode);
        if (link == null || link.isDeleted()) {
            return false;
        }
        return link.getExpiresAt() != null && link.getExpiresAt().isBefore(LocalDateTime.now());
    }

    @Override
    public void registerClick(UrlLink link) {
        link.setClickCount(link.getClickCount() + 1);
        urlLinkDao.update(link);
        logDao.save(new Log(null, link.getUser(), "URL_CLICKED",
                "shortCode=" + link.getShortCode(), null));
    }

    @Override
    public List<UrlLink> getAllUrls() {
        return urlLinkDao.findAll();
    }

    @Override
    public List<UrlLink> getActiveUrlsForUser(User owner) {
        if (owner == null) return List.of();
        return urlLinkDao.findActiveByUser(owner);
    }

    @Override
    public List<UrlLink> getTrashedUrlsForUser(User owner) {
        if (owner == null) return List.of();
        return urlLinkDao.findTrashedByUser(owner);
    }

    @Override
    public void softDelete(Long id, User owner) {
        UrlLink link = loadOwnedOrThrow(id, owner);
        if (!link.isDeleted()) {
            link.setDeleted(true);
            link.setDeletedAt(LocalDateTime.now());
            urlLinkDao.update(link);
            logDao.save(new Log(null, owner, "URL_DELETED",
                    "shortCode=" + link.getShortCode(), null));
        }
    }

    @Override
    public void restore(Long id, User owner) {
        UrlLink link = loadOwnedOrThrow(id, owner);
        if (link.isDeleted()) {
            link.setDeleted(false);
            link.setDeletedAt(null);
            urlLinkDao.update(link);
            logDao.save(new Log(null, owner, "URL_RESTORED",
                    "shortCode=" + link.getShortCode(), null));
        }
    }

    @Override
    public void permanentlyDelete(Long id, User owner) {
        UrlLink link = loadOwnedOrThrow(id, owner);
        logDao.save(new Log(null, owner, "URL_DESTROYED",
                "shortCode=" + link.getShortCode(), null));
        urlLinkDao.delete(link);
    }

    private UrlLink loadOwnedOrThrow(Long id, User owner) {
        UrlLink link = urlLinkDao.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("URL bulunamadı: " + id));
        if (link.getUser() == null || owner == null
                || !Objects.equals(link.getUser().getId(), owner.getId())) {
            throw new IllegalStateException("Bu URL üzerinde işlem yetkin yok.");
        }
        return link;
    }
}
