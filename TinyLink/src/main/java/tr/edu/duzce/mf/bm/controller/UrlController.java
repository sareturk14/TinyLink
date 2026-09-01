package tr.edu.duzce.mf.bm.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import tr.edu.duzce.mf.bm.dao.UserDao;
import tr.edu.duzce.mf.bm.entity.UrlLink;
import tr.edu.duzce.mf.bm.entity.User;
import tr.edu.duzce.mf.bm.service.UrlService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Controller
public class UrlController {

    @Autowired
    private UrlService urlService;

    @Autowired
    private UserDao userDao;

    // ==========================================================================
    // ANA SAYFA: Kullanıcının aktif URL'leri + kısaltma formu
    // ==========================================================================
    @GetMapping("/")
    @Transactional(readOnly = true)
    public String index(Model model) {
        User current = currentUser();
        List<UrlLink> urls = urlService.getActiveUrlsForUser(current);
        model.addAttribute("urls", urls);
        model.addAttribute("currentUser", current);
        return "index";
    }

    // ==========================================================================
    // KISALTMA: Giriş yapmış kullanıcı + opsiyonel ömür süresi
    // ==========================================================================
    @PostMapping("/shorten")
    @Transactional
    public String shortenUrl(@RequestParam("originalUrl") String originalUrl,
                             @RequestParam(value = "lifetime", required = false) String lifetime,
                             HttpServletRequest request,
                             RedirectAttributes redirectAttributes) {
        if (originalUrl == null || originalUrl.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "URL boş olamaz.");
            return "redirect:/";
        }
        if (!originalUrl.startsWith("http://") && !originalUrl.startsWith("https://")) {
            originalUrl = "http://" + originalUrl;
        }

        try {
            User owner = currentUser();
            LocalDateTime expiresAt = parseLifetime(lifetime);

            UrlLink createdLink = urlService.createShortUrl(originalUrl, owner, expiresAt);

            // Tam URL'yi mevcut isteğin host/port/contextPath bilgisinden türet —
            // hardcoded "/bm470" hatasına yol açmaması için.
            String base = request.getScheme() + "://" + request.getServerName()
                    + (isStandardPort(request) ? "" : ":" + request.getServerPort())
                    + request.getContextPath();
            redirectAttributes.addFlashAttribute("shortUrl", base + "/" + createdLink.getShortCode());
            redirectAttributes.addFlashAttribute("originalUrl", createdLink.getOriginalUrl());
            redirectAttributes.addFlashAttribute("shortCode", createdLink.getShortCode());
            redirectAttributes.addFlashAttribute("aiSummary", createdLink.getSummary());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Hata oluştu: " + e.getMessage());
        }

        return "redirect:/";
    }

    private boolean isStandardPort(HttpServletRequest request) {
        int port = request.getServerPort();
        return ("http".equalsIgnoreCase(request.getScheme()) && port == 80)
                || ("https".equalsIgnoreCase(request.getScheme()) && port == 443);
    }

    // ==========================================================================
    // YÖNLENDİRME: Tıklanan kısa kodu hedef URL'ye 302 ile yönlendir.
    // Süresi dolmuşsa "süresi dolmuş" sayfası göster.
    // ==========================================================================
    @GetMapping("/{shortCode}")
    public String redirectUrl(@PathVariable("shortCode") String shortCode, Model model) {
        Optional<UrlLink> opt = urlService.findActiveByShortCode(shortCode);

        if (opt.isEmpty()) {
            if (urlService.isExpired(shortCode)) {
                model.addAttribute("shortCode", shortCode);
                return "link-expired";
            }
            return "redirect:/";
        }

        UrlLink url = opt.get();
        urlService.registerClick(url);

        String target = url.getOriginalUrl();
        if (!target.startsWith("http://") && !target.startsWith("https://")) {
            target = "http://" + target;
        }
        return "redirect:" + target;
    }

    // ==========================================================================
    // SOFT DELETE — kullanıcı kendi URL'sini çöp kutusuna atar
    // ==========================================================================
    @PostMapping("/urls/{id}/delete")
    @Transactional
    public String softDelete(@PathVariable("id") Long id, RedirectAttributes ra) {
        try {
            urlService.softDelete(id, currentUser());
            ra.addFlashAttribute("info", "URL çöp kutusuna taşındı.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/";
    }

    // ==========================================================================
    // ÇÖP KUTUSU
    // ==========================================================================
    @GetMapping("/trash")
    @Transactional(readOnly = true)
    public String trash(Model model) {
        User current = currentUser();
        List<UrlLink> trashed = urlService.getTrashedUrlsForUser(current);
        model.addAttribute("urls", trashed);
        model.addAttribute("currentUser", current);
        return "trash";
    }

    @PostMapping("/urls/{id}/restore")
    @Transactional
    public String restore(@PathVariable("id") Long id, RedirectAttributes ra) {
        try {
            urlService.restore(id, currentUser());
            ra.addFlashAttribute("info", "URL geri yüklendi.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/trash";
    }

    @PostMapping("/urls/{id}/destroy")
    @Transactional
    public String permanentlyDelete(@PathVariable("id") Long id, RedirectAttributes ra) {
        try {
            urlService.permanentlyDelete(id, currentUser());
            ra.addFlashAttribute("info", "URL kalıcı olarak silindi.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/trash";
    }

    // ==========================================================================
    // YARDIMCI METOTLAR
    // ==========================================================================
    private User currentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        // username = email (CustomUserDetailsService bu şekilde kuruyor)
        return userDao.findByEmail(auth.getName()).orElse(null);
    }

    /**
     * Form'dan gelen "lifetime" değerini expiresAt LocalDateTime'a çevirir.
     *  - "1h"      -> 1 saat sonra
     *  - "24h"     -> 24 saat sonra
     *  - "7d"      -> 7 gün sonra
     *  - "30d"     -> 30 gün sonra
     *  - null/""/"forever" -> null (süresiz)
     */
    private LocalDateTime parseLifetime(String lifetime) {
        if (lifetime == null || lifetime.isBlank() || "forever".equalsIgnoreCase(lifetime)) {
            return null;
        }
        LocalDateTime now = LocalDateTime.now();
        return switch (lifetime) {
            case "1h"  -> now.plusHours(1);
            case "24h" -> now.plusHours(24);
            case "7d"  -> now.plusDays(7);
            case "30d" -> now.plusDays(30);
            default    -> null;
        };
    }
}
