# 1단계: GitHub에서 소스 다운로드
FROM alpine/git as clone
WORKDIR /app
RUN git clone --depth=1 --single-branch --branch master https://github.com/kk99corn/cschat.git .


# 2단계: Gradle 빌드 (Gradle Wrapper 사용)
FROM gradle:8.4.0-jdk21 as build
WORKDIR /app
COPY --from=clone /app /app
RUN gradle clean build -x test

# 3단계: 실행 이미지
FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]