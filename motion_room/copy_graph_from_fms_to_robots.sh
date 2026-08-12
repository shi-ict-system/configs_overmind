#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SRC="$SCRIPT_DIR/configs/fms/mediator/graph_manager"

if [ ! -d "$SRC" ]; then
    echo "[ERROR] 소스 디렉토리가 존재하지 않습니다: $SRC"
    exit 1
fi

for i in $(seq 1 12); do
    DEST="$SCRIPT_DIR/configs/robot_${i}/mediator/graph_manager"
    mkdir -p "$DEST"
    cp -rf "$SRC/." "$DEST/"
    echo "[OK] robot_${i} 복사 완료: $DEST"
done

echo "완료: robot_1 ~ robot_10 graph_manager 복사 완료"