#!/usr/bin/env bash
#
# run_all_robots.sh
# 폴더 안의 robot_*.sh 스크립트를 모두 병렬로 실행하고,
# 로그를 개별 파일로 남기며, Ctrl+C 시 전체 프로세스를 함께 종료합니다.

set -uo pipefail

# ── 설정 ─────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$SCRIPT_DIR/run_robots}"   # 인자로 폴더 지정 가능. 기본값: 이 스크립트 위치의 run_robots 폴더
LOG_DIR="$TARGET_DIR/cout/$(date +%Y%m%d_%H%M%S)"

mkdir -p "$LOG_DIR"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "에러: 디렉토리가 존재하지 않습니다 -> $TARGET_DIR"
    exit 1
fi

# robot_*.sh 를 숫자 순서로 정렬해서 배열에 담기
# (robot_1, robot_2 ... robot_10, robot_11 순서가 되도록 -V 옵션 사용)
mapfile -t SCRIPTS < <(find "$TARGET_DIR" -maxdepth 1 -type f -name "robot_*.sh" | sort -V)

if [[ ${#SCRIPTS[@]} -eq 0 ]]; then
    echo "에러: $TARGET_DIR 에서 robot_*.sh 파일을 찾을 수 없습니다."
    exit 1
fi

echo "=== 총 ${#SCRIPTS[@]}개의 로봇 스크립트 실행 ==="
echo "로그 디렉토리: $LOG_DIR"
echo

# ── 실행 ─────────────────────────────────────────────
PIDS=()
NAMES=()

# Ctrl+C(SIGINT) 또는 종료 시그널이 오면 실행 중인 모든 자식 프로세스 종료
cleanup() {
    echo
    echo "=== 종료 신호 감지: 실행 중인 로봇 프로세스를 모두 정리합니다 ==="
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill -TERM "$pid" 2>/dev/null
        fi
    done
    wait
    echo "=== 정리 완료 ==="
    exit 1
}
trap cleanup SIGINT SIGTERM

for script in "${SCRIPTS[@]}"; do
    name="$(basename "$script" .sh)"
    log_file="$LOG_DIR/${name}.log"

    if [[ ! -x "$script" ]]; then
        chmod +x "$script" 2>/dev/null || true
    fi

    echo "[시작] $name  (로그: $log_file)"
    bash "$script" > "$log_file" 2>&1 &

    PIDS+=("$!")
    NAMES+=("$name")
done

echo
echo "=== 모든 로봇이 백그라운드로 실행 중입니다 (PID 목록) ==="
for i in "${!PIDS[@]}"; do
    echo "  ${NAMES[$i]} -> PID ${PIDS[$i]}"
done
echo
echo "종료하려면 Ctrl+C 를 누르세요 (모든 로봇 프로세스가 함께 종료됩니다)."
echo

# ── 종료 상태 확인 ────────────────────────────────────
FAIL_COUNT=0
for i in "${!PIDS[@]}"; do
    if wait "${PIDS[$i]}"; then
        echo "[정상 종료] ${NAMES[$i]}"
    else
        echo "[비정상 종료] ${NAMES[$i]} (로그 확인: $LOG_DIR/${NAMES[$i]}.log)"
        ((FAIL_COUNT++))
    fi
done

echo
echo "=== 전체 종료: 실패 $FAIL_COUNT / ${#PIDS[@]} ==="
exit $FAIL_COUNT