/*
analytics스키마 아래에 raw_data 테이블 기반으로 분석 테이블 생성함
[ 테이블 목록 ]
    COMMENT_TOTAL 
    BEST_COMMENT_TOTAL
    SENTIMENT_TOTAL
    SENTIMENT_BEST 
    EMOJI_TOTAL
    EMOJI_BEST
*/

-- COMMENT_TOTAL
-- 댓글 테이블과 웹툰 정보 테이블 합침
CREATE TABLE analytics.comment_total AS
SELECT c.*,  t.title, t.summary, t.author, t.score, t.favorite_count,
    t.episode_count, t.genre, t.genre_detail, t.week_days
FROM raw_data.comment c
JOIN raw_data.toon_info t ON c.title_id = t.title_id;

SELECT count(*) FROM analytics.comment_total;

SELECT count(*) FROM raw_data.comment;


-- BEST_COMMENT_TOTAL
-- 랭킹에 오른 웹툰들의 댓글만 추출
CREATE TABLE best_comment_total AS
SELECT *
FROM comment_total
WHERE title_id IN (
    SELECT title_id
    FROM ranking_toon_total
    UNION
    SELECT title_id
    FROM ranking_toon_men
    UNION
    SELECT title_id
    FROM ranking_toon_women
);

select count(*) from best_comment_total;


-- SENTIMENT_TOTAL
-- 댓글과 감정 분석 결과 연결
CREATE TABLE analytics.sentiment_total AS
SELECT raw_data.sentiment.SENTIMENT, raw_data.sentiment.SCORE as SENTIMENT_SCORE, raw_data.sentiment.MAGNITUDE,  
    analytics.comment_total.*
FROM raw_data.sentiment
LEFT JOIN analytics.comment_total
ON raw_data.sentiment.comment_id = analytics.comment_total.comment_id;

SELECT count(*) FROM analytics.sentiment_total ;

SELECT * FROM analytics.sentiment_total ;


-- SENTIMENT_BEST
-- 실시간 인기 웹툰 감정만 추출 CTAS
CREATE TABLE analytics.sentiment_best AS
SELECT *
FROM analytics.sentiment_total
WHERE title_id IN (
    SELECT title_id
    FROM ranking_toon_total
    UNION
    SELECT title_id
    FROM ranking_toon_men
    UNION
    SELECT title_id
    FROM ranking_toon_women
);

SELECT count(*) FROM analytics.sentiment_best ;


-- EMOJI_TOTAL
-- 댓글 전체에서 이모지 집계
CREATE OR REPLACE TABLE analytics.emoji_total AS
SELECT
    emoji,
    COUNT(*) AS count
FROM (
    SELECT
        comment,
        REGEXP_SUBSTR(comment, '[\u1F600-\u1F64F\uD83C\uDF00-\uD83C\uDFFF\uD83D\uDC00-\uD83D\uDE4F\uD83E\uDD00-\uD83E\uDDFF]') AS emoji
    FROM analytics.comment_total
)
WHERE emoji IS NOT NULL 
    AND (UNICODE(emoji) < UNICODE('\u3131') OR UNICODE(emoji) > UNICODE('\u318E')) -- 한글 제거
    AND NOT REGEXP_LIKE(emoji, '[A-Za-z0-9]') -- 알파벳, 숫자 제거
GROUP BY emoji;

SELECT * from emoji_total ORDER BY EMOJI ;



-- EMOJI_BEST
-- 랭킹에 오른 웹툰들의 댓글에서만 이모지 집계
CREATE OR REPLACE TABLE analytics.emoji_best AS
SELECT
    emoji,
    COUNT(*) AS count
FROM (
    SELECT
        comment,
        REGEXP_SUBSTR(comment, '[\u1F600-\u1F64F\uD83C\uDF00-\uD83C\uDFFF\uD83D\uDC00-\uD83D\uDE4F\uD83E\uDD00-\uD83E\uDDFF]') AS emoji
    FROM analytics.best_comment_total
)
WHERE emoji IS NOT NULL 
    AND (UNICODE(emoji) < UNICODE('\u3131') OR UNICODE(emoji) > UNICODE('\u318E'))
    AND NOT REGEXP_LIKE(emoji, '[A-Za-z0-9]')
GROUP BY emoji;

SELECT * from emoji_best ORDER BY EMOJI;





