package tr.edu.duzce.mf.bm.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * javax.mail üzerinden SMTP ile mail gönderir.
 *
 * SMTP yapılandırması ortam değişkenlerinden okunur:
 *  - MAIL_SMTP_HOST  (default: smtp.gmail.com)
 *  - MAIL_SMTP_PORT  (default: 587)
 *  - MAIL_SMTP_USER  (boş bırakılırsa mail gönderilmez, sadece loglanır)
 *  - MAIL_SMTP_PASS  (Gmail için "App Password" kullanılmalı)
 *  - MAIL_FROM       (default: noreply@bm470.local)
 *
 * Geliştirme kolaylığı: SMTP_USER/PASS boşsa mailler gönderilmez, içerikleri INFO seviyesinde
 * loglara basılır — böylece SMTP yapılandırması olmadan akış test edilebilir.
 */
@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    private final String smtpHost = System.getenv().getOrDefault("MAIL_SMTP_HOST", "smtp.gmail.com");
    private final String smtpPort = System.getenv().getOrDefault("MAIL_SMTP_PORT", "587");
    private final String smtpUser = System.getenv().getOrDefault("MAIL_SMTP_USER", "");
    private final String smtpPass = System.getenv().getOrDefault("MAIL_SMTP_PASS", "");
    private final String fromAddr = System.getenv().getOrDefault("MAIL_FROM", "noreply@bm470.local");

    @Async
    public void send(String to, String subject, String body) {
        if (smtpUser.isBlank() || smtpPass.isBlank()) {
            log.info("[E-MAIL FALLBACK] SMTP yapılandırması yok, mail loga basılıyor.\n"
                    + "  TO: {}\n  SUBJECT: {}\n  BODY:\n{}", to, subject, body);
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPass);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromAddr));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body, "UTF-8");
            Transport.send(message);
            log.info("Mail gönderildi: to={}, subject={}", to, subject);
        } catch (MessagingException e) {
            log.error("Mail gönderilemedi: to={}, error={}", to, e.getMessage(), e);
        }
    }
}
