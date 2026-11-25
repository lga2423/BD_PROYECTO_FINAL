USE soundmetrics;

DELIMITER //

-- MARKETS TRIGGERS
CREATE TRIGGER trg_markets_insert_audit
AFTER INSERT ON markets
FOR EACH ROW
BEGIN
    INSERT INTO markets_audit (
        action_type, changed_by, changed_at, old_market_id, old_market_code, old_market_name, new_market_id, new_market_code, new_market_name
    )
    VALUES (
        'INSERT', CURRENT_USER(), NOW(), NULL, NULL, NULL, NEW.market_id, NEW.market_code, NEW.market_name
    );
END//

CREATE TRIGGER trg_markets_update_audit
AFTER UPDATE ON markets
FOR EACH ROW
BEGIN
    INSERT INTO markets_audit (
        action_type, changed_by, changed_at, old_market_id, old_market_code, old_market_name, new_market_id, new_market_code, new_market_name
    )
    VALUES (
        'UPDATE', CURRENT_USER(), NOW(), OLD.market_id, OLD.market_code, OLD.market_name, NEW.market_id, NEW.market_code, NEW.market_name
    );
END//

CREATE TRIGGER trg_markets_delete_audit
AFTER DELETE ON markets
FOR EACH ROW
BEGIN
    INSERT INTO markets_audit (
        action_type, changed_by, changed_at, old_market_id, old_market_code, old_market_name, new_market_id, new_market_code, new_market_name
    )
    VALUES (
        'DELETE', CURRENT_USER(), NOW(), OLD.market_id, OLD.market_code, OLD.market_name, NULL, NULL, NULL
    );
END//

-- CHART_YEARS TRIGGERS
CREATE TRIGGER trg_chart_years_insert_audit
AFTER INSERT ON chart_years
FOR EACH ROW
BEGIN
    INSERT INTO chart_years_audit (
        action_type, changed_by, changed_at, old_year_id, old_year_value, new_year_id, new_year_value
    )
    VALUES (
        'INSERT', CURRENT_USER(), NOW(), NULL, NULL, NEW.year_id, NEW.year_value
    );
END//

CREATE TRIGGER trg_chart_years_update_audit
AFTER UPDATE ON chart_years
FOR EACH ROW
BEGIN
    INSERT INTO chart_years_audit (
        action_type, changed_by, changed_at, old_year_id, old_year_value, new_year_id, new_year_value
    )
    VALUES (
        'UPDATE', CURRENT_USER(), NOW(), OLD.year_id, OLD.year_value, NEW.year_id, NEW.year_value
    );
END//

CREATE TRIGGER trg_chart_years_delete_audit
AFTER DELETE ON chart_years
FOR EACH ROW
BEGIN
    INSERT INTO chart_years_audit (
        action_type, changed_by, changed_at, old_year_id, old_year_value, new_year_id, new_year_value
    )
    VALUES (
        'DELETE', CURRENT_USER(), NOW(), OLD.year_id, OLD.year_value, NULL, NULL
    );
END//

-- SONGS TRIGGERS
CREATE TRIGGER trg_songs_insert_audit
AFTER INSERT ON songs
FOR EACH ROW
BEGIN
    INSERT INTO songs_audit (
        action_type, changed_by, changed_at, old_song_id, old_track_id, old_song_title, old_release_date, new_song_id, new_track_id, new_song_title, new_release_date
    )
    VALUES (
        'INSERT', CURRENT_USER(), NOW(), NULL, NULL, NULL, NULL, NEW.song_id, NEW.track_id, NEW.song_title, NEW.release_date
    );
END//

CREATE TRIGGER trg_songs_update_audit
AFTER UPDATE ON songs
FOR EACH ROW
BEGIN
    INSERT INTO songs_audit (
        action_type, changed_by, changed_at, old_song_id, old_track_id, old_song_title, old_release_date, new_song_id, new_track_id, new_song_title, new_release_date
    )
    VALUES (
        'UPDATE', CURRENT_USER(), NOW(), OLD.song_id, OLD.track_id, OLD.song_title, OLD.release_date, NEW.song_id, NEW.track_id, NEW.song_title, NEW.release_date
    );
END//

CREATE TRIGGER trg_songs_delete_audit
AFTER DELETE ON songs
FOR EACH ROW
BEGIN
    INSERT INTO songs_audit (
        action_type, changed_by, changed_at, old_song_id, old_track_id, old_song_title, old_release_date, new_song_id, new_track_id, new_song_title, new_release_date
    )
    VALUES (
        'DELETE', CURRENT_USER(), NOW(), OLD.song_id, OLD.track_id, OLD.song_title, OLD.release_date, NULL, NULL, NULL, NULL
    );
END//

--  ARTISTS TRIGGERS
CREATE TRIGGER trg_artists_insert_audit
AFTER INSERT ON artists
FOR EACH ROW
BEGIN
    INSERT INTO artists_audit (
        action_type, changed_by, changed_at, old_artist_id, old_artist_uri, old_artist_name, new_artist_id, new_artist_uri, new_artist_name
    )
    VALUES (
        'INSERT', CURRENT_USER(), NOW(), NULL, NULL, NULL, NEW.artist_id, NEW.artist_uri, NEW.artist_name
    );
END//

CREATE TRIGGER trg_artists_update_audit
AFTER UPDATE ON artists
FOR EACH ROW
BEGIN
    INSERT INTO artists_audit (
        action_type, changed_by, changed_at, old_artist_id, old_artist_uri, old_artist_name, new_artist_id, new_artist_uri, new_artist_name
    )
    VALUES (
        'UPDATE', CURRENT_USER(), NOW(), OLD.artist_id, OLD.artist_uri, OLD.artist_name, NEW.artist_id, NEW.artist_uri, NEW.artist_name
    );
END//

CREATE TRIGGER trg_artists_delete_audit
AFTER DELETE ON artists
FOR EACH ROW
BEGIN
    INSERT INTO artists_audit (
        action_type, changed_by, changed_at, old_artist_id, old_artist_uri, old_artist_name, new_artist_id, new_artist_uri, new_artist_name
    )
    VALUES (
        'DELETE', CURRENT_USER(), NOW(), OLD.artist_id, OLD.artist_uri, OLD.artist_name, NULL, NULL, NULL
    );
END//

-- SONG_ARTISTS TRIGGERS
CREATE TRIGGER trg_song_artists_insert_audit
AFTER INSERT ON song_artists
FOR EACH ROW
BEGIN
    INSERT INTO song_artists_audit (
        action_type, changed_by, changed_at, old_song_id, old_artist_id, new_song_id, new_artist_id
    )
    VALUES (
        'INSERT', CURRENT_USER(), NOW(), NULL, NULL, NEW.song_id, NEW.artist_id
    );
END//

CREATE TRIGGER trg_song_artists_update_audit
AFTER UPDATE ON song_artists
FOR EACH ROW
BEGIN
    INSERT INTO song_artists_audit (
        action_type, changed_by, changed_at, old_song_id, old_artist_id, new_song_id, new_artist_id
    )
    VALUES (
        'UPDATE', CURRENT_USER(), NOW(), OLD.song_id, OLD.artist_id, NEW.song_id, NEW.artist_id
    );
END//

CREATE TRIGGER trg_song_artists_delete_audit
AFTER DELETE ON song_artists
FOR EACH ROW
BEGIN
    INSERT INTO song_artists_audit (
        action_type, changed_by, changed_at, old_song_id, old_artist_id, new_song_id, new_artist_id
    )
    VALUES (
        'DELETE', CURRENT_USER(), NOW(), OLD.song_id, OLD.artist_id, NULL, NULL
    );
END//

-- CHARTS TRIGGERS
CREATE TRIGGER trg_charts_insert_audit
AFTER INSERT ON charts
FOR EACH ROW
BEGIN
    INSERT INTO charts_audit (
        action_type, changed_by, changed_at, old_chart_id, old_market_id, old_year_id, new_chart_id, new_market_id, new_year_id
    )
    VALUES (
        'INSERT', CURRENT_USER(), NOW(), NULL, NULL, NULL, NEW.chart_id, NEW.market_id, NEW.year_id
    );
END//

CREATE TRIGGER trg_charts_update_audit
AFTER UPDATE ON charts
FOR EACH ROW
BEGIN
    INSERT INTO charts_audit (
        action_type, changed_by, changed_at, old_chart_id, old_market_id, old_year_id, new_chart_id, new_market_id, new_year_id
    )
    VALUES (
        'UPDATE', CURRENT_USER(), NOW(), OLD.chart_id, OLD.market_id, OLD.year_id, NEW.chart_id, NEW.market_id, NEW.year_id
    );
END//

CREATE TRIGGER trg_charts_delete_audit
AFTER DELETE ON charts
FOR EACH ROW
BEGIN
    INSERT INTO charts_audit (
        action_type, changed_by, changed_at, old_chart_id, old_market_id, old_year_id, new_chart_id, new_market_id, new_year_id
    )
    VALUES (
        'DELETE', CURRENT_USER(), NOW(), OLD.chart_id, OLD.market_id, OLD.year_id, NULL, NULL, NULL
    );
END//

-- TRIGGERS DE CHART_ENTRIES
CREATE TRIGGER trg_chart_entries_insert_audit
AFTER INSERT ON chart_entries
FOR EACH ROW
BEGIN
    INSERT INTO chart_entries_audit (
        action_type, changed_by, changed_at, old_entry_id, old_chart_id, old_song_id, old_annual_rank, old_annual_streams, old_weeks_charted, old_best_weekly_rank, new_entry_id, new_chart_id, new_song_id, new_annual_rank, new_annual_streams, new_weeks_charted, new_best_weekly_rank
    )
    VALUES (
        'INSERT', CURRENT_USER(), NOW(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NEW.entry_id, NEW.chart_id, NEW.song_id, NEW.annual_rank, NEW.annual_streams, NEW.weeks_charted, NEW.best_weekly_rank
    );
END//

CREATE TRIGGER trg_chart_entries_update_audit
AFTER UPDATE ON chart_entries
FOR EACH ROW
BEGIN
    INSERT INTO chart_entries_audit (
        action_type, changed_by, changed_at, old_entry_id, old_chart_id, old_song_id, old_annual_rank, old_annual_streams, old_weeks_charted, old_best_weekly_rank, new_entry_id, new_chart_id, new_song_id, new_annual_rank, new_annual_streams, new_weeks_charted, new_best_weekly_rank
    )
    VALUES (
        'UPDATE', CURRENT_USER(), NOW(), OLD.entry_id, OLD.chart_id, OLD.song_id, OLD.annual_rank, OLD.annual_streams, OLD.weeks_charted, OLD.best_weekly_rank, NEW.entry_id, NEW.chart_id, NEW.song_id, NEW.annual_rank, NEW.annual_streams, NEW.weeks_charted, NEW.best_weekly_rank
    );
END//

CREATE TRIGGER trg_chart_entries_delete_audit
AFTER DELETE ON chart_entries
FOR EACH ROW
BEGIN
    INSERT INTO chart_entries_audit (
        action_type, changed_by, changed_at, old_entry_id, old_chart_id, old_song_id, old_annual_rank, old_annual_streams, old_weeks_charted, old_best_weekly_rank, new_entry_id, new_chart_id, new_song_id, new_annual_rank, new_annual_streams, new_weeks_charted, new_best_weekly_rank
    )
    VALUES (
        'DELETE', CURRENT_USER(), NOW(), OLD.entry_id, OLD.chart_id, OLD.song_id, OLD.annual_rank, OLD.annual_streams, OLD.weeks_charted, OLD.best_weekly_rank, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    );
END//

DELIMITER ;

SHOW TRIGGERS FROM soundmetrics;
