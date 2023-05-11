name: Build and Deploy Spring Boot to AWS EC2

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  S3_BUCKET_NAME: auction-deploy

jobs:
  build:
    runs-on: ubuntu-20.04

    steps:
    - uses: actions/checkout@v1

    - name: Set up Java JDK 17
      uses: actions/setup-java@v1
      with:
        java-version: '17'

    - name : Copy Secret
      env :
        OCCUPY_SECRET : ${{ secrets.OCCUPY_SECRET }}
        OCCUPY_SECRET_DIR : src/main/resources
        OCCUPY_SECRET_DIR_FILE_NAME : application.properties
      run : echo $OCCUPY_SECRET | base64 --decode > $OCCUPY_SECRET_DIR/$OCCUPY_SECRET_DIR_FILE_NAME &&
            echo $OCCUPY_SECRET | base64 --decode > $OCCUPY_SECRET_TEST_DIR/$OCCUPY_SECRET_DIR_FILE_NAME

    - name: Grant execute permission for gradlew
      run: chmod +x gradlew

    - name: Build with Gradle
      run: ./gradlew build

    # 디렉토리 생성
    - name: Make Directory
      run: mkdir -p deploy

    # Jar 파일 복사
    - name: Copy Jar
      run: cp ./build/libs/*.jar ./deploy

    # appspec.yml 파일 복사
    - name: Copy appspec.yml
      run: cp appspec.yml ./deploy


    # script files 복사
    - name: Copy script
      run: cp ./scripts/*.sh ./deploy

    - name: Make zip file
      run: zip -r ./coinTalk.zip ./deploy
      shell: bash

    - name: Make zip file
      run: zip -r ./GetReadyAuction.zip ./deploy
      shell: bash

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ap-northeast-2

    - name: Upload to S3
      run: aws s3 cp --region ap-northeast-2 ./GetReadyAuction.zip s3://$S3_BUCKET_NAME/
