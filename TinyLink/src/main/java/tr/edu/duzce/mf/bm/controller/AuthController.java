package tr.edu.duzce.mf.bm.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import tr.edu.duzce.mf.bm.service.AuthService;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam("username") String username,
                           @RequestParam("email") String email,
                           @RequestParam("password") String password,
                           @RequestParam("confirmPassword") String confirmPassword,
                           RedirectAttributes redirectAttributes) {
        try {
            if (!password.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "password_mismatch");
                redirectAttributes.addFlashAttribute("username", username);
                redirectAttributes.addFlashAttribute("email", email);
                return "redirect:/register";
            }
            authService.register(username, email, password);
            return "redirect:/login?registered";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            redirectAttributes.addFlashAttribute("username", username);
            redirectAttributes.addFlashAttribute("email", email);
            return "redirect:/register";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Kayıt sırasında bir hata oluştu: " + e.getMessage());
            return "redirect:/register";
        }
    }

    @PostMapping("/auth/resend-verification")
    public String resendVerification(@RequestParam("email") String email,
                                     RedirectAttributes redirectAttributes) {
        try {
            authService.resendVerification(email);
            redirectAttributes.addFlashAttribute("resendSuccess", true);
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("resendError", e.getMessage());
        }
        return "redirect:/login";
    }

    @GetMapping("/verify")
    public String verify(@RequestParam("token") String token) {
        boolean valid = authService.verifyToken(token);
        if (valid) {
            return "redirect:/login?verified";
        }
        return "redirect:/login?error=invalid_token";
    }
}
