# Etapa 1: Construcción
FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app

# Copiar pom y descargar dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar código fuente y compilar
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Entorno de Ejecución
FROM openjdk:17-jdk-slim

WORKDIR /app

# Crear usuario no-root por seguridad
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# Copiar el archivo JAR generado
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
