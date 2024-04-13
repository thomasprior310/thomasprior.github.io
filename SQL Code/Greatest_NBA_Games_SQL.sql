CREATE TABLE games (
    game_id INTEGER PRIMARY KEY,
    season_id INTEGER,
    team_id_home INTEGER,
    team_abbreviation_home TEXT,
    team_name_home TEXT,
    game_date DATE,
    wl_home TEXT,
    minutes INTEGER,
    fgm_home INTEGER,
    fga_home INTEGER,
    fg_pct_home NUMERIC,
    fg3m_home INTEGER,
    fg3a_home INTEGER,
    fg3_pct_home NUMERIC,
    ftm_home INTEGER,
    fta_home INTEGER,
    ft_pct_home NUMERIC,
    oreb_home INTEGER,
    dreb_home INTEGER,
    reb_home INTEGER,
    ast_home INTEGER,
    stl_home INTEGER,
    blk_home INTEGER,
    tov_home INTEGER,
    pf_home INTEGER,
    pts_home INTEGER,
    plus_minus_home INTEGER,
    video_available_home BOOLEAN,
    team_id_away INTEGER,
    team_abbreviation_away TEXT,
    team_name_away TEXT,
    wl_away TEXT,
    fgm_away INTEGER,
    fga_away INTEGER,
    fg_pct_away NUMERIC,
    fg3m_away INTEGER,
    fg3a_away INTEGER,
    fg3_pct_away NUMERIC,
    ftm_away INTEGER,
    fta_away INTEGER,
    ft_pct_away NUMERIC,
    oreb_away INTEGER,
    dreb_away INTEGER,
    reb_away INTEGER,
    ast_away INTEGER,
    stl_away INTEGER,
    blk_away INTEGER,
    tov_away INTEGER,
    pf_away INTEGER,
    pts_away INTEGER,
    plus_minus_away INTEGER,
    video_available_away BOOLEAN,
    season_type TEXT
);

COPY games(season_id, team_id_home, team_abbreviation_home, team_name_home, game_id, game_date, wl_home, minutes, fgm_home, fga_home, fg_pct_home, fg3m_home, fg3a_home, fg3_pct_home, ftm_home, fta_home, ft_pct_home, oreb_home, dreb_home, reb_home, ast_home, stl_home, blk_home, tov_home, pf_home, pts_home, plus_minus_home, video_available_home, team_id_away, team_abbreviation_away, team_name_away, wl_away, fgm_away, fga_away, fg_pct_away, fg3m_away, fg3a_away, fg3_pct_away, ftm_away, fta_away, ft_pct_away, oreb_away, dreb_away, reb_away, ast_away, stl_away, blk_away, tov_away, pf_away, pts_away, plus_minus_away, video_available_away, season_type) 
FROM 'C:\Users\Public\Downloads\NBAgames.csv' WITH (FORMAT CSV, HEADER, NULL 'NA');

--DATA CLEANING

--REMOVE DUPLICATES FROM DATASET
DELETE FROM games
WHERE game_id IN (
    SELECT game_id
    FROM (
        SELECT game_id, ROW_NUMBER() OVER(PARTITION BY game_id ORDER BY game_id) AS row_num
        FROM games
    ) AS duplicates
    WHERE row_num > 1
); 

--REMOVE ROWS WITH MISSING VALUES
DELETE FROM games
WHERE game_id IS NULL 
   OR team_id_home IS NULL 
   OR team_abbreviation_home IS NULL
   OR team_name_home IS NULL 
   OR game_date IS NULL
   OR wl_home IS NULL 
   OR minutes IS NULL 
   OR fgm_home IS NULL 
   OR fga_home IS NULL
   OR fg_pct_home IS NULL 
   OR fg3m_home IS NULL 
   OR fg3a_home IS NULL
   OR fg3_pct_home IS NULL 
   OR ftm_home IS NULL 
   OR fta_home IS NULL
   OR ft_pct_home IS NULL 
   OR oreb_home IS NULL 
   OR dreb_home IS NULL
   OR reb_home IS NULL 
   OR ast_home IS NULL 
   OR stl_home IS NULL
   OR blk_home IS NULL 
   OR tov_home IS NULL 
   OR pf_home IS NULL
   OR pts_home IS NULL 
   OR plus_minus_home IS NULL 
   OR video_available_home IS NULL
   OR team_id_away IS NULL 
   OR team_abbreviation_away IS NULL
   OR team_name_away IS NULL 
   OR wl_away IS NULL 
   OR fgm_away IS NULL 
   OR fga_away IS NULL
   OR fg_pct_away IS NULL 
   OR fg3m_away IS NULL 
   OR fg3a_away IS NULL
   OR fg3_pct_away IS NULL 
   OR ftm_away IS NULL 
   OR fta_away IS NULL
   OR ft_pct_away IS NULL 
   OR oreb_away IS NULL 
   OR dreb_away IS NULL
   OR reb_away IS NULL 
   OR ast_away IS NULL 
   OR stl_away IS NULL
   OR blk_away IS NULL 
   OR tov_away IS NULL 
   OR pf_away IS NULL
   OR pts_away IS NULL 
   OR plus_minus_away IS NULL 
   OR video_available_away IS NULL
   OR season_type IS NULL; 
   
   
-- REMOVE GAMES PLAYED BEFORE 1979
DELETE FROM games
WHERE game_date <= '1979-12-31'; 

--KEEP ONLY GAMES WHERE BOTH TEAMS SCORED 5+ 3 POINTERS
DELETE FROM games
WHERE fg3m_home < 5 OR fg3m_away < 5;

--KEEP ONLY PLAYOFF GAMES
DELETE FROM games
WHERE season_type != 'Playoffs';

--KEEP ONLY CERTAIN TEAMS
DELETE FROM games
WHERE team_name_home NOT IN ('Boston Celtics', 'Chicago Bulls', 'Los Angeles Lakers', 'Golden State Warriors', 
'New York Knicks', 'Miami Heat', 'Detroit Pistons', 'Philadelphia 76ers', 'San Antonio Spurs', 'Houston Rockets','Cleveland Cavaliers')
OR team_name_away NOT IN ('Boston Celtics', 'Chicago Bulls', 'Los Angeles Lakers', 'Golden State Warriors', 
'New York Knicks', 'Miami Heat', 'Detroit Pistons', 'Philadelphia 76ers', 'San Antonio Spurs', 'Houston Rockets','Cleveland Cavaliers');

--KEEP ONLY ONE POSSESSION GAMES
DELETE FROM games
WHERE (pts_home - pts_away) > 3 OR (pts_away - pts_home) > 3;

SELECT * FROM games