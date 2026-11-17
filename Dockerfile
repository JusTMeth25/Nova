# Single image: the React build is bundled into the Spring Boot jar and served
# from the same origin as the API, so the frontend keeps calling relative /api.

# 1) Frontend build
FROM node:22-alpine AS fe
WORKDIR /fe
COPY FE/package.json FE/package-lock.json ./
RUN npm ci
COPY FE/ ./
RUN npm run build

# 2) Backend build (frontend copied into static resources)
FROM maven:3.9-eclipse-temurin-25 AS be
WORKDIR /be
COPY BE/pom.xml ./
RUN mvn -q -B dependency:go-offline
COPY BE/src ./src
COPY --from=fe /fe/dist ./src/main/resources/static
RUN mvn -q -B package -DskipTests

# 3) Runtime
FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=be /be/target/*.jar app.jar
ENV SERVER_ADDRESS=0.0.0.0 \
    JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75"
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
