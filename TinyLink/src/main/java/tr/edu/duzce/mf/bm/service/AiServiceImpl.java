package tr.edu.duzce.mf.bm.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class AiServiceImpl implements AiService {

    // Kendi Gemini API Anahtarını buraya yapıştır
    private static final String API_KEY = "YOUR_API_KEY";
    // Kotan olan Gemini 2.5 Flash sürümünü kullanıyoruz
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + API_KEY;

    @Override
    public String analyzeAndGetSummary(String url) {
        if (url == null || url.isEmpty()) {
            return "Özet bulunamadı.";
        }

        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // Gemini'ye vereceğimiz görev (Prompt)
            String prompt = "Bu URL'yi analiz et. Cevabını tam olarak şu formatta dön: KATEGORİ | ÖZET. "
                    + "Kategori için sadece şu kelimelerden birini seç: Sosyal Medya, Eğitim, Teknoloji, Haber, E-Ticaret, Eğlence, Kurumsal, Diğer. "
                    + "URL: " + url;

            // Gemini API'nin beklediği katı JSON formatı
            String requestBody = "{\"contents\": [{\"parts\":[{\"text\": \"" + prompt + "\"}]}]}";

            HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers);

            // API'ye POST isteği atıyoruz
            ResponseEntity<String> response = restTemplate.postForEntity(GEMINI_API_URL, requestEntity, String.class);

            // Dönen karmaşık JSON cevabını parçalayıp sadece metni alıyoruz
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());

            // Gemini cevabı: candidates -> [0] -> content -> parts -> [0] -> text
            String result = root.path("candidates").get(0)
                    .path("content")
                    .path("parts").get(0)
                    .path("text").asText();

            // Metindeki gereksiz satır boşluklarını temizleyip "KATEGORİ | ÖZET" formatında döndürüyoruz
            return result.replace("\n", " ").trim();

        } catch (Exception e) {
            System.err.println("Gemini API Hatası: " + e.getMessage());
            return "Diğer | Geçici bağlantı sorunu nedeniyle API'ye ulaşılamadı.";
        }
    }
}