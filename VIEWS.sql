USE soundmetrics;

-- song_details 
-- Displays song details, artists, rankings, and streams.

CREATE OR REPLACE VIEW song_details AS
SELECT
    m.market_name,
    cy.year_value,
    ce.annual_rank,
    s.song_title,
    GROUP_CONCAT(DISTINCT a.artist_name SEPARATOR ', ') AS artists,
    ce.annual_streams,
    ce.weeks_charted,
    ce.best_weekly_rank
FROM chart_entries ce
INNER JOIN charts c
    ON ce.chart_id = c.chart_id
INNER JOIN markets m
    ON c.market_id = m.market_id
INNER JOIN chart_years cy
    ON c.year_id = cy.year_id
INNER JOIN songs s
    ON ce.song_id = s.song_id
LEFT JOIN song_artists sa
    ON s.song_id = sa.song_id
LEFT JOIN artists a
    ON sa.artist_id = a.artist_id
GROUP BY
    ce.entry_id,
    m.market_name,
    cy.year_value,
    ce.annual_rank,
    s.song_title,
    ce.annual_streams,
    ce.weeks_charted,
    ce.best_weekly_rank;


-- artist_stats
-- Shows artist statistics by market and year.
CREATE OR REPLACE VIEW artist_stats AS
SELECT
    a.artist_id,
    a.artist_name,
    m.market_name,
    cy.year_value,
    COUNT(DISTINCT s.song_id) AS total_songs,
    SUM(ce.annual_streams) AS total_streams,
    AVG(ce.annual_rank) AS average_rank
FROM artists a
INNER JOIN song_artists sa
    ON a.artist_id = sa.artist_id
INNER JOIN songs s
    ON sa.song_id = s.song_id
INNER JOIN chart_entries ce
    ON s.song_id = ce.song_id
INNER JOIN charts c
    ON ce.chart_id = c.chart_id
INNER JOIN markets m
    ON c.market_id = m.market_id
INNER JOIN chart_years cy
    ON c.year_id = cy.year_id
GROUP BY
    a.artist_id,
    a.artist_name,
    m.market_name,
    cy.year_value;


--  top_songs_by_market_year
-- Lists top songs by market and year, ordered by streams.
CREATE OR REPLACE VIEW top_songs_by_market_year AS
SELECT
    m.market_name,
    cy.year_value,
    s.song_title,
    ce.annual_rank,
    ce.annual_streams,
    ce.weeks_charted
FROM charts c
INNER JOIN markets m
    ON c.market_id = m.market_id
INNER JOIN chart_years cy
    ON c.year_id = cy.year_id
INNER JOIN chart_entries ce
    ON c.chart_id = ce.chart_id
INNER JOIN songs s
    ON ce.song_id = s.song_id
    ORDER BY ce.annual_streams DESC;


-- TESTING THE VIEWS
SELECT * FROM song_details;

SELECT * FROM artist_stats;

SELECT * FROM top_songs_by_market_year;