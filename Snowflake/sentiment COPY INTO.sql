/*
raw_data에 sentiment 테이블 생성 후 s3에서 Bulk Update (Stage 이용)
*/
CREATE TABLE raw_data.sentiment  (
    comment_id STRING primary key,
    sentiment TEXT,
    score STRING,
    magnitude STRING
);

CREATE or REPLACE STAGE senti_s3_stage
    URL='s3://(버킷명)/analytics/sentiment/output_file.csv'
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
DESC STAGE senti_s3_stage;
-- stage 하위 데이터 목록 확인
list @senti_s3_stage;

-- s3-> stage
COPY INTO raw_data.sentiment 
FROM @senti_s3_stage
FILE_FORMAT = (
    TYPE = 'CSV',
    skip_header=1,
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
)
ON_ERROR = 'CONTINUE';


SELECT count(*) FROM raw_data.sentiment ;

SELECT * FROM raw_data.sentiment ;
