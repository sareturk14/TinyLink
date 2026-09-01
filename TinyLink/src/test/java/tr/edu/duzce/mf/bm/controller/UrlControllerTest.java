package tr.edu.duzce.mf.bm.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import tr.edu.duzce.mf.bm.dao.UserDao;
import tr.edu.duzce.mf.bm.entity.UrlLink;
import tr.edu.duzce.mf.bm.service.UrlService;

import java.util.Collections;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.*;

public class UrlControllerTest {

    @Mock
    private UrlService urlService;

    @Mock
    private UserDao userDao;

    @Mock
    private Model model;

    @Mock
    private RedirectAttributes redirectAttributes;

    @Mock
    private HttpServletRequest request;

    @InjectMocks
    private UrlController urlController;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testIndex() {
        // SecurityContext kurulu değil → currentUser() null döner → boş liste beklenir
        when(urlService.getActiveUrlsForUser(isNull())).thenReturn(Collections.emptyList());

        String viewName = urlController.index(model);

        assertEquals("index", viewName, "Index sayfası çağrıldığında 'index' görünümü dönmelidir.");
        verify(urlService, times(1)).getActiveUrlsForUser(isNull());
    }

    @Test
    void testShortenUrl() {
        String originalUrl = "http://example.com";
        UrlLink mockLink = new UrlLink();
        mockLink.setOriginalUrl(originalUrl);
        mockLink.setShortCode("abc");

        when(urlService.createShortUrl(eq(originalUrl), any(), any())).thenReturn(mockLink);
        when(request.getScheme()).thenReturn("http");
        when(request.getServerName()).thenReturn("localhost");
        when(request.getServerPort()).thenReturn(8080);
        when(request.getContextPath()).thenReturn("/bm470");

        String viewName = urlController.shortenUrl(originalUrl, "forever", request, redirectAttributes);

        assertEquals("redirect:/", viewName, "Kısaltma işleminden sonra ana sayfaya dönmelidir.");
        verify(urlService, times(1)).createShortUrl(eq(originalUrl), any(), any());
    }
}
