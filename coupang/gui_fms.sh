#!/bin/bash

set -e  # 오류 발생 시 스크립트 중단

cd "$(dirname "$0")"

# 2. 실행 파일 및 설정 경로 수정
# 파일 두단계 위로 올라가기
BINARY_PATH="../../overload/build/app_fms/src/drivers/test/t_gui_fms_client_2"

CONFIG_PATH="./configs/fms"

# 실행

$BINARY_PATH $CONFIG_PATH