#!/usr/bin/env bash

PROJECT_ROOT="/home/ubuntu/app"
JAR_FILE="$PROJECT_ROOT/GetReadyAuction-0.0.1-SNAPSHOT.jar"

TIME_NOW=$(date +%c)

## build 파일 복사
#echo "$TIME_NOW > $JAR_FILE 파일 복사"
#cp $PROJECT_ROOT/build/libs/*.jar $JAR_FILE

# jar 파일 실행
echo "$TIME_NOW > $JAR_FILE 파일 실행"
nohup java -jar $JAR_FILE

CURRENT_PID=$(pgrep -f $JAR_FILE)
echo "$TIME_NOW > 실행된 프로세스 아이디 $CURRENT_PID 입니다."