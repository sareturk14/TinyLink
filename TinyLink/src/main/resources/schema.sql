-- ============================================================
--  URL Kısaltma Projesi - Veritabanı Şeması
--  Veritabanı: url_shortener_db
-- ============================================================

USE url_shortener_db;

-- Önce bağımlı tablolar silinir (FK sırası)
DROP TABLE IF EXISTS logs;
DROP TABLE IF EXISTS urls;
DROP TABLE IF EXISTS users;

-- ============================================================
--  1. KULLANICILAR
-- ============================================================
CREATE TABLE users (
    id          BIGINT          NOT NULL AUTO_INCREMENT,
    username    VARCHAR(50)     NOT NULL,
    email       VARCHAR(100)    NOT NULL,
    password    VARCHAR(255)    NOT NULL,
    role        ENUM('ADMIN','USER') NOT NULL DEFAULT 'USER',
    is_verified BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY uq_users_username (username),
    UNIQUE KEY uq_users_email    (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
--  2. KISALTILMIŞ URL'LER
-- ============================================================
CREATE TABLE urls (
    id           BIGINT        NOT NULL AUTO_INCREMENT,
    user_id      BIGINT,                          -- NULL = anonim kullanıcı
    original_url VARCHAR(2048) NOT NULL,
    short_code   VARCHAR(10)   NOT NULL,
    expires_at   DATETIME,                        -- NULL = süresiz
    ai_summary   TEXT,                            -- Yapay zeka özeti
    ai_category  VARCHAR(50),                     -- Yapay zeka kategorisi (Teknoloji, Eğlence vb.)
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    click_count   INT           NOT NULL DEFAULT 0,
    is_deleted    BOOLEAN       NOT NULL DEFAULT FALSE,  -- Soft delete (çöp kutusu)
    deleted_at    DATETIME,                              -- Soft delete zamanı; 7 gün sonra hard delete
    category_name VARCHAR(50),                           -- NULL = kategorisiz

    PRIMARY KEY (id),
    UNIQUE KEY uq_urls_short_code (short_code),
    CONSTRAINT fk_urls_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
--  3. EYLEM KAYITLARI (LOG)
-- ============================================================
CREATE TABLE logs (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    user_id     BIGINT,                           -- NULL = anonim / sistem
    action_type VARCHAR(50)  NOT NULL,            -- Örn: URL_CREATED, URL_CLICKED, LOGIN
    details     TEXT,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    CONSTRAINT fk_logs_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
