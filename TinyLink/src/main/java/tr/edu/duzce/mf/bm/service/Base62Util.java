package tr.edu.duzce.mf.bm.service;

import org.springframework.stereotype.Component;

import java.security.SecureRandom;

@Component
public class Base62Util {

    private static final String ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private static final int BASE = ALPHABET.length();
    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Sayısal değeri Base62 kısa koduna çevirir.

     */
    public String encode(long value) {
        if (value < 0) {
            throw new IllegalArgumentException("Value must be non-negative");
        }

        if (value == 0) {
            return String.valueOf(ALPHABET.charAt(0));
        }

        StringBuilder sb = new StringBuilder();
        long current = value;
        while (current > 0) {
            int index = (int) (current % BASE);
            sb.append(ALPHABET.charAt(index));
            current /= BASE;
        }
        return sb.reverse().toString();
    }

    /**
     * Base62 kodunu tekrar sayısal değere çevirir.

     */
    public long decode(String code) {
        if (code == null || code.isBlank()) {
            throw new IllegalArgumentException("Code cannot be null or blank");
        }

        long num = 0L;
        for (int i = 0; i < code.length(); i++) {
            char ch = code.charAt(i);
            int index = ALPHABET.indexOf(ch);
            if (index < 0) {
                throw new IllegalArgumentException("Invalid Base62 character: " + ch);
            }
            num = (num * BASE) + index;
        }

        return num;
    }

    /**
     * Sayısal değeri minimum uzunlukta Base62 koduna çevirir.
     * Gerekirse başına 'a' karakteri eklenir.
     */
    public String encodeWithMinLength(long value, int minLength) {
        if (minLength < 1) {
            throw new IllegalArgumentException("minLength must be at least 1");
        }

        String code = encode(value);
        if (code.length() >= minLength) {
            return code;
        }

        StringBuilder padded = new StringBuilder(minLength);
        for (int i = code.length(); i < minLength; i++) {
            padded.append(ALPHABET.charAt(0));
        }
        padded.append(code);
        return padded.toString();
    }

    /**
     * Rastgele Base62 kısa kod üretir (fallback/deneysel kullanım).
     */
    public String generateRandomCode(int length) {
        if (length < 1) {
            throw new IllegalArgumentException("length must be at least 1");
        }

        StringBuilder code = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            code.append(ALPHABET.charAt(RANDOM.nextInt(BASE)));
        }
        return code.toString();
    }
}