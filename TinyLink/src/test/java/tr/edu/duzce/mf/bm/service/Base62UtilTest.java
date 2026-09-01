package tr.edu.duzce.mf.bm.service;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class Base62UtilTest {

    private final Base62Util base62Util = new Base62Util();

    @Test
    void testEncode() {
        // ID 125 beklenen base62 çıktısı: 125 / 62 = 2, kalan = 1 (b). 2 (c). -> "cb"
        String result = base62Util.encode(125L);
        assertEquals("cb", result, "125 ID'si 'cb' olarak kodlanmalıdır.");
    }

    @Test
    void testDecode() {
        long result = base62Util.decode("cb");
        assertEquals(125L, result, "'cb' kodu 125 olarak çözülmelidir.");
    }

    @Test
    void testEncodeZero() {
        String result = base62Util.encode(0L);
        assertEquals("a", result, "0 ID'si 'a' olarak kodlanmalıdır.");
    }
}
