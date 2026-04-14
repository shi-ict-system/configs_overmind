#!/bin/bash

set -e  # 오류 발생 시 스크립트 중단

# 스크립트 위치로 이동
cd "$(dirname "$0")"

# 1. 실행 파일 경로 (시스템 설치 경로 사용)
BINARY_PATH="/opt/drone/bin/app_robot"

# 2. 설정 경로
CONFIG_PATH="./configs/robot_1"

echo ">>> Robot 1 실행 중: ${BINARY_PATH} ${CONFIG_PATH}"

# 실행
$BINARY_PATH $CONFIG_PATH
