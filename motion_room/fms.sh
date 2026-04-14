#!/bin/bash

set -e  # 오류 발생 시 스크립트 중단

#/home/xaco/xaco_ws/overload/overload/build/appVCS/src/vcs/apps/appVCS /home/xaco/xaco_ws/overload/script/configs/vcs/

#/home/xaco/xaco_ws/overload/overload/build/app_fms/src/apps/t_app_fms ./configs/fms


# ../../overload/build/app_fms/src/apps/app_fms ./configs/fms


# 스크립트 위치로 이동
cd "$(dirname "$0")"

# 1. 실행 파일 경로 (시스템 설치 경로 사용)
BINARY_PATH="/opt/overload/bin/app_fms"

# 2. 설정 경로
CONFIG_PATH="./configs/fms"

echo ">>> FMS 실행 중: ${BINARY_PATH} ${CONFIG_PATH}"

# 실행
$BINARY_PATH $CONFIG_PATH
