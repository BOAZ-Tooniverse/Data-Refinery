/*
raw_data에 comment 테이블 생성 후 s3에서 Bulk Update (Stage 이용)
*/
CREATE TABLE raw_data.comment  (
    comment TEXT,
    comment_id STRING primary key,
    epi_no INTEGER,
    is_best BOOLEAN,
    login_id STRING,
    nickname STRING,
    recomm_cnt STRING,
    reply_cnt STRING,
    save_date STRING,
    title_id STRING,
    unrecomm_cnt STRING,
    write_date STRING
);

-- Snowflake 내부에 stage 생성 (stage는 S3와의 연결을 제공하는 중간 저장소)
CREATE or REPLACE STAGE comment_s3_stage
    URL='s3://(버킷명)/raw_data/comments'
    CREDENTIALS=(
        AWS_KEY_ID=''
        AWS_SECRET_KEY=''
    )
    FILE_FORMAT = (TYPE = PARQUET);

-- stage 목록
SHOW STAGES;
-- 위에서 만든 stage 상세 조회
DESC STAGE comment_s3_stage;
-- stage 하위 데이터 목록 확인
list @comment_s3_stage;

-- s3-> stage
COPY INTO raw_data.comment
FROM @comment_s3_stage
FILE_FORMAT = (
    TYPE = 'PARQUET'
)
ON_ERROR = 'SKIP_FILE'
match_by_column_name = case_insensitive;

-- comment 테이블에 잘 저장되어 있는지 확인하기
SELECT count(*) FROM raw_data.comment;
