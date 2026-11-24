-- SOUNDMetrics: TABLAS DE AUDITORIA
-- Basado en el esquema proporcionado.
-- Ejecutar despues de crear las 7 tablas principales.

USE soundmetrics;

CREATE TABLE markets_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    changed_by VARCHAR(100),
    changed_at DATETIME,
    old_market_id INT,
    old_market_code VARCHAR(10),
    old_market_name VARCHAR(50),
    new_market_id INT,
    new_market_code VARCHAR(10),
    new_market_name VARCHAR(50)
);

CREATE TABLE chart_years_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    changed_by VARCHAR(100),
    changed_at DATETIME,
    old_year_id INT,
    old_year_value INT,
    new_year_id INT,
    new_year_value INT
);

CREATE TABLE songs_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    changed_by VARCHAR(100),
    changed_at DATETIME,
    old_song_id INT,
    old_track_id VARCHAR(100),
    old_song_title VARCHAR(255),
    old_release_date DATE,
    new_song_id INT,
    new_track_id VARCHAR(100),
    new_song_title VARCHAR(255),
    new_release_date DATE
);

CREATE TABLE artists_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    changed_by VARCHAR(100),
    changed_at DATETIME,
    old_artist_id INT,
    old_artist_uri VARCHAR(150),
    old_artist_name VARCHAR(255),
    new_artist_id INT,
    new_artist_uri VARCHAR(150),
    new_artist_name VARCHAR(255)
);

CREATE TABLE song_artists_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    changed_by VARCHAR(100),
    changed_at DATETIME,
    old_song_id INT,
    old_artist_id INT,
    new_song_id INT,
    new_artist_id INT
);

CREATE TABLE charts_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    changed_by VARCHAR(100),
    changed_at DATETIME,
    old_chart_id INT,
    old_market_id INT,
    old_year_id INT,
    new_chart_id INT,
    new_market_id INT,
    new_year_id INT
);


CREATE TABLE chart_entries_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    changed_by VARCHAR(100),
    changed_at DATETIME,
    old_entry_id INT,
    old_chart_id INT,
    old_song_id INT,
    old_annual_rank INT,
    old_annual_streams INT,
    old_weeks_charted INT,
    old_best_weekly_rank INT,
    new_entry_id INT,
    new_chart_id INT,
    new_song_id INT,
    new_annual_rank INT,
    new_annual_streams INT,
    new_weeks_charted INT,
    new_best_weekly_rank INT
);
