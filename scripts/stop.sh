#!/usr/bin/env bash

REPOSITORY=/home/ubuntu/app
JAR_FILE="$PROJECT_ROOT/GetReadyAuction-0.0.1-SNAPSHOT.jar"

echo "> 현재 구동 중인 애플리케이션 pid 확인"
CURRENT_PID=$(pgrep -f $JAR_FILE)

echo "현재 구동 중인 애플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  echo "현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "현재 구동 중인 $CURRENT_PID 애플리케이션을 종료합니다."
  kill -15 $CURRENT_PID
fi