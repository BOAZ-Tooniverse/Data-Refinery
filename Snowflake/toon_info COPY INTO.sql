/*
raw_data에 toon_info 테이블 생성 후 s3에서 Bulk Update (Stage 이용)
*/
CREATE TABLE raw_data.toon_info  (
    title_id STRING primary key,
    title TEXT,
    summary  TEXT,
    author  STRING,
    score STRING,
    favorite_count STRING,
    episode_count STRING,
    genre STRING,
    genre_detail STRING,
    week_days STRING
);


CREATE or REPLACE STAGE toon_s3_stage
    URL='s3://(버킷명)/raw_data/toon_info/weekly_toon_info_v1.csv'
    CREDENTIALS=(
        AWS_KEY_ID=''
        AWS_SECRET_KEY=''
    )
    FILE_FORMAT = (
    TYPE = CSV
    );

-- stage 목록
SHOW STAGES;
-- 위에서 만든 stage 상세 조회
DESC STAGE toon_s3_stage;
-- stage 하위 데이터 목록 확인
list @toon_s3_stage;


-- s3-> stage
-- 두 번째 옵션 꼭 해줘야됨 (또 삽질함;;)
COPY INTO raw_data.toon_info
FROM @toon_s3_stage
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
);

-- comment 테이블에 잘 저장되어 있는지 확인하기
SELECT count(*) FROM raw_data.toon_info;