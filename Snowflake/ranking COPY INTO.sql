CREATE TABLE raw_data.ranking_toon_total  (
    ranking_cnt INT, 
    title_id STRING primary key,
    title TEXT,
    summary  TEXT,
    author  STRING,
    score STRING,
    favorite_count STRING,
    episode_count STRING,
    genre STRING,
    genre_detail STRING,
    week_days STRING,
    ages STRING 
);

CREATE TABLE raw_data.ranking_toon_women  (
    ranking_cnt INT, 
    title_id STRING primary key,
    title TEXT,
    summary  TEXT,
    author  STRING,
    score STRING,
    favorite_count STRING,
    episode_count STRING,
    genre STRING,
    genre_detail STRING,
    week_days STRING,
    ages STRING 
);

CREATE TABLE raw_data.ranking_toon_men  (
    ranking_cnt STRING, 
    title_id STRING primary key,
    title TEXT,
    summary  TEXT,
    author  STRING,
    score STRING,
    favorite_count STRING,
    episode_count STRING,
    genre STRING,
    genre_detail STRING,
    week_days STRING,
    ages STRING 
);


--- TRUNCATE
-- TRUNCATE TABLE raw_data.ranking_toon_women ;
-- TRUNCATE TABLE raw_data.ranking_toon_men ;
-- TRUNCATE TABLE raw_data.ranking_toon_total ;

-- STAGE 없이 바로 COPY INTO
COPY INTO raw_data.ranking_toon_men 
FROM 's3://(버킷명)/analytics/ranking/ranking_toon_men_encoded.csv'
credentials=(
    AWS_KEY_ID=''
    AWS_SECRET_KEY=''
)
FILE_FORMAT = (type='CSV' skip_header=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

SELECT * FROM raw_data.ranking_toon_men ;


COPY INTO raw_data.ranking_toon_total
FROM 's3://(버킷명)/analytics/ranking/ranking_toon_total_encoded.csv'
credentials=(
    AWS_KEY_ID=''
    AWS_SECRET_KEY=''
)
FILE_FORMAT = (type='CSV' skip_header=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

SELECT * FROM raw_data.ranking_toon_total ;


COPY INTO raw_data.ranking_toon_women 
FROM 's3://(버킷명)/analytics/ranking/ranking_toon_women_encoded.csv'
credentials=(
    AWS_KEY_ID=''
    AWS_SECRET_KEY=''
)
FILE_FORMAT = (type='CSV' skip_header=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

SELECT * FROM raw_data.ranking_toon_women ;