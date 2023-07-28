import csv
import chardet
import pandas as pd

"""
랭킹을 정리한 csv파일을 utf-8로 인코딩하는 코드
(선행 작업: 랭킹 정리한 엑셀 파일을 필드명 맞추기 및 CSV로 추출 - 코드없이 직접 수정)
"""


def check_csv_encoding(input_file):
    """
    CSV 파일 인코딩 확인
    """
    with open(input_file, 'rb') as f:
        result = chardet.detect(f.readline())  
        print(result)
        print(result['encoding'])


def convert_csv_to_utf8(input_files, output_files):
    """
    CSV 파일들 utf-8로 인코딩
    """
    for i in range(len(input_files)):
        input_file = input_files[i]
        output_file = output_files[i]
        with open(input_file, 'r', encoding='ANSI') as file:
            reader = csv.reader(file)
            data = list(reader) 

        with open(output_file, 'w', encoding='utf-8', newline='') as file:
            writer = csv.writer(file)
            writer.writerows(data) 

# 메인
input_file_path = 'ranking_toon_men.csv'
input_files = [ 'ranking_toon_men.csv',  'ranking_toon_women.csv',  'ranking_toon_total.csv']
output_files = ['ranking_toon_men_encoded.csv', 'ranking_toon_women_encoded.csv', 'ranking_toon_total_encoded.csv']

check_csv_encoding(input_file_path)
convert_csv_to_utf8(input_files, output_files)

