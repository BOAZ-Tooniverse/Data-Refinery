import pandas as pd
import os

"""
GCP로 감정 분석 결과 저장한 xlsx 파일에서 특정 칼럼만 추출하여 csv 파일로 저장하는 코드
"""


def extract_fields_to_csv(xlsx_files, output_csv_file):
    if len(xlsx_files) == 0:
        print("xlsx파일 없음")
        return

    required_fields = ['comment_id', 'sentiment', 'score', 'magnitude']
    data_to_save = []

    for xlsx_file in xlsx_files:
        df = pd.read_excel(xlsx_file)

        if all(field in df.columns for field in required_fields):
            data_to_save.append(df[required_fields])

    if not data_to_save:
        print("데이터 없음")
    else:
        result_df = pd.concat(data_to_save, ignore_index=True)
        total_cnt = result_df.count()
        print("총 개수 : ", total_cnt)
        result_df.to_csv(output_csv_file, index=False)
        print(f"파일 저장 완료 : {output_csv_file}.")

if __name__ == "__main__":
    directory_path = "input/"

    xlsx_files = [os.path.join(directory_path, file) for file in os.listdir(directory_path) if file.endswith(".xlsx")]

    output_csv_file = "output_file.csv"

    extract_fields_to_csv(xlsx_files, output_csv_file)
