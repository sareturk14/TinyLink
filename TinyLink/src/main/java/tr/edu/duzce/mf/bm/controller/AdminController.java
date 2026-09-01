package tr.edu.duzce.mf.bm.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import tr.edu.duzce.mf.bm.dao.UrlLinkDao;
import tr.edu.duzce.mf.bm.dao.UserDao;
import tr.edu.duzce.mf.bm.entity.UrlLink;
import tr.edu.duzce.mf.bm.entity.User;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Admin paneli — yalnızca ROLE_ADMIN erişebilir (SecurityConfig'de korunuyor).
 *
 * Dashboard üç bilgi grubu sunar:
 *  - Özet kartları (kullanıcı/URL/tıklanma sayısı)
 *  - Kullanıcı tablosu
 *  - URL tablosu (tıklanma sayılarıyla)
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserDao userDao;

    @Autowired
    private UrlLinkDao urlLinkDao;

    @GetMapping
    @Transactional(readOnly = true)
    public String dashboard(Model model) {
        List<User> users = userDao.findAll();
        List<UrlLink> urls = urlLinkDao.findAll();

        long totalUsers = userDao.count();
        long totalUrls = urlLinkDao.count();
        long totalClicks = urlLinkDao.totalClickCount();

        Map<String, Long> categoryStats = urlLinkDao.countByCategory();

        model.addAttribute("users", users);
        model.addAttribute("urls", urls);
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalUrls", totalUrls);
        model.addAttribute("totalClicks", totalClicks);
        model.addAttribute("categoryStats", categoryStats);
        model.addAttribute("currentUser", currentUser());

        return "admin";
    }

    @PostMapping("/users/{id}/toggle-ban")
    @Transactional
    public String toggleBan(@PathVariable("id") Long id, RedirectAttributes ra) {
        User admin = currentUser();
        if (admin != null && admin.getId().equals(id)) {
            ra.addFlashAttribute("banErrorCode", "self");
            return "redirect:/admin";
        }
        Optional<User> opt = userDao.findById(id);
        if (opt.isEmpty()) {
            ra.addFlashAttribute("banErrorCode", "notFound");
            return "redirect:/admin";
        }
        User target = opt.get();
        target.setBanned(!target.isBanned());
        userDao.update(target);
        ra.addFlashAttribute("banAction", target.isBanned() ? "ban" : "unban");
        return "redirect:/admin";
    }

    private User currentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        return userDao.findByEmail(auth.getName()).orElse(null);
    }
}
