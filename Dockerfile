FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /app

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY gradle.properties .

RUN chmod +x ./gradlew

COPY . .

RUN ./gradlew assemble -x test --no-daemon

FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

COPY --from=builder /app/build/libs/*.war app.war

ENV PORT=8080
EXPOSE $PORT

CMD java -Xmx400m -Xms200m -Dserver.port=${PORT} -Dgrails.env=production -jar app.wars