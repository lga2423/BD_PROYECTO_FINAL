USE soundmetrics;
DELIMITER //

-- MARKETS
CREATE PROCEDURE sp_markets_get_all() BEGIN SELECT * FROM markets; END//
CREATE PROCEDURE sp_markets_get_by_id(IN p_id INT) BEGIN SELECT * FROM markets WHERE market_id=p_id; END//
CREATE PROCEDURE sp_markets_insert(IN p_code VARCHAR(10), IN p_name VARCHAR(50)) BEGIN INSERT INTO markets(market_code,market_name) VALUES(p_code,p_name); END//
CREATE PROCEDURE sp_markets_update(IN p_id INT, IN p_code VARCHAR(10), IN p_name VARCHAR(50)) BEGIN UPDATE markets SET market_code=p_code, market_name=p_name WHERE market_id=p_id; END//
CREATE PROCEDURE sp_markets_delete_all() BEGIN DELETE FROM markets; END//
CREATE PROCEDURE sp_markets_delete_by_id(IN p_id INT) BEGIN DELETE FROM markets WHERE market_id=p_id; END//

-- CHART YEARS
CREATE PROCEDURE sp_chart_years_get_all() BEGIN SELECT * FROM chart_years; END//
CREATE PROCEDURE sp_chart_years_get_by_id(IN p_id INT) BEGIN SELECT * FROM chart_years WHERE year_id=p_id; END//
CREATE PROCEDURE sp_chart_years_insert(IN p_year INT) BEGIN INSERT INTO chart_years(year_value) VALUES(p_year); END//
CREATE PROCEDURE sp_chart_years_update(IN p_id INT, IN p_year INT) BEGIN UPDATE chart_years SET year_value=p_year WHERE year_id=p_id; END//
CREATE PROCEDURE sp_chart_years_delete_all() BEGIN DELETE FROM chart_years; END//
CREATE PROCEDURE sp_chart_years_delete_by_id(IN p_id INT) BEGIN DELETE FROM chart_years WHERE year_id=p_id; END//

-- SONGS
CREATE PROCEDURE sp_songs_get_all() BEGIN SELECT * FROM songs; END//
CREATE PROCEDURE sp_songs_get_by_id(IN p_id INT) BEGIN SELECT * FROM songs WHERE song_id=p_id; END//
CREATE PROCEDURE sp_songs_insert(IN p_track VARCHAR(100), IN p_title VARCHAR(255), IN p_date DATE) BEGIN INSERT INTO songs(track_id,song_title,release_date) VALUES(p_track,p_title,p_date); END//
CREATE PROCEDURE sp_songs_update(IN p_id INT, IN p_track VARCHAR(100), IN p_title VARCHAR(255), IN p_date DATE) BEGIN UPDATE songs SET track_id=p_track,song_title=p_title,release_date=p_date WHERE song_id=p_id; END//
CREATE PROCEDURE sp_songs_delete_all() BEGIN DELETE FROM songs; END//
CREATE PROCEDURE sp_songs_delete_by_id(IN p_id INT) BEGIN DELETE FROM songs WHERE song_id=p_id; END//

-- ARTISTS
CREATE PROCEDURE sp_artists_get_all() BEGIN SELECT * FROM artists; END//
CREATE PROCEDURE sp_artists_get_by_id(IN p_id INT) BEGIN SELECT * FROM artists WHERE artist_id=p_id; END//
CREATE PROCEDURE sp_artists_insert(IN p_uri VARCHAR(150), IN p_name VARCHAR(255)) BEGIN INSERT INTO artists(artist_uri,artist_name) VALUES(p_uri,p_name); END//
CREATE PROCEDURE sp_artists_update(IN p_id INT, IN p_uri VARCHAR(150), IN p_name VARCHAR(255)) BEGIN UPDATE artists SET artist_uri=p_uri,artist_name=p_name WHERE artist_id=p_id; END//
CREATE PROCEDURE sp_artists_delete_all() BEGIN DELETE FROM artists; END//
CREATE PROCEDURE sp_artists_delete_by_id(IN p_id INT) BEGIN DELETE FROM artists WHERE artist_id=p_id; END//

-- SONG_ARTISTS 
CREATE PROCEDURE sp_song_artists_get_all() BEGIN SELECT * FROM song_artists; END//
CREATE PROCEDURE sp_song_artists_get_by_id(IN p_song INT, IN p_artist INT) BEGIN SELECT * FROM song_artists WHERE song_id=p_song AND artist_id=p_artist; END//
CREATE PROCEDURE sp_song_artists_insert(IN p_song INT, IN p_artist INT) BEGIN INSERT INTO song_artists(song_id,artist_id) VALUES(p_song,p_artist); END//
CREATE PROCEDURE sp_song_artists_update(IN p_old_song INT, IN p_old_artist INT, IN p_new_song INT, IN p_new_artist INT) BEGIN UPDATE song_artists SET song_id=p_new_song,artist_id=p_new_artist WHERE song_id=p_old_song AND artist_id=p_old_artist; END//
CREATE PROCEDURE sp_song_artists_delete_all() BEGIN DELETE FROM song_artists; END//
CREATE PROCEDURE sp_song_artists_delete_by_id(IN p_song INT, IN p_artist INT) BEGIN DELETE FROM song_artists WHERE song_id=p_song AND artist_id=p_artist; END//

-- CHARTS
CREATE PROCEDURE sp_charts_get_all() BEGIN SELECT * FROM charts; END//
CREATE PROCEDURE sp_charts_get_by_id(IN p_id INT) BEGIN SELECT * FROM charts WHERE chart_id=p_id; END//
CREATE PROCEDURE sp_charts_insert(IN p_market INT, IN p_year INT) BEGIN INSERT INTO charts(market_id,year_id) VALUES(p_market,p_year); END//
CREATE PROCEDURE sp_charts_update(IN p_id INT, IN p_market INT, IN p_year INT) BEGIN UPDATE charts SET market_id=p_market,year_id=p_year WHERE chart_id=p_id; END//
CREATE PROCEDURE sp_charts_delete_all() BEGIN DELETE FROM charts; END//
CREATE PROCEDURE sp_charts_delete_by_id(IN p_id INT) BEGIN DELETE FROM charts WHERE chart_id=p_id; END//

-- CHART ENTRIES
CREATE PROCEDURE sp_chart_entries_get_all() BEGIN SELECT * FROM chart_entries; END//
CREATE PROCEDURE sp_chart_entries_get_by_id(IN p_id INT) BEGIN SELECT * FROM chart_entries WHERE entry_id=p_id; END//
CREATE PROCEDURE sp_chart_entries_insert(IN p_chart INT, IN p_song INT, IN p_rank INT, IN p_streams INT, IN p_weeks INT, IN p_best INT) BEGIN INSERT INTO chart_entries(chart_id,song_id,annual_rank,annual_streams,weeks_charted,best_weekly_rank) VALUES(p_chart,p_song,p_rank,p_streams,p_weeks,p_best); END//
CREATE PROCEDURE sp_chart_entries_update(IN p_id INT, IN p_chart INT, IN p_song INT, IN p_rank INT, IN p_streams INT, IN p_weeks INT, IN p_best INT) BEGIN UPDATE chart_entries SET chart_id=p_chart,song_id=p_song,annual_rank=p_rank,annual_streams=p_streams,weeks_charted=p_weeks,best_weekly_rank=p_best WHERE entry_id=p_id; END//
CREATE PROCEDURE sp_chart_entries_delete_all() BEGIN DELETE FROM chart_entries; END//
CREATE PROCEDURE sp_chart_entries_delete_by_id(IN p_id INT) BEGIN DELETE FROM chart_entries WHERE entry_id=p_id; END//

DELIMITER ;
SHOW PROCEDURE STATUS WHERE Db='soundmetrics';
