# Etapa 1: Construcción de la aplicación
FROM maven:3.8.4-openjdk-11 AS builder

WORKDIR /app

# Copia los archivos de configuración de Maven
COPY pom.xml .

# Descarga las dependencias de Maven
RUN mvn dependency:go-offline

# Copia el código fuente
COPY src ./src

# Compila la aplicación
RUN mvn package -DskipTests

# Etapa 2: Creación de la imagen final
FROM adoptopenjdk:11-jre-hotspot

WORKDIR /app

# Copia el archivo JAR generado en la etapa anterior
COPY --from=builder /app/target/orders-service-example-0.0.1-SNAPSHOT.jar .


# Define el comando para ejecutar la aplicación

CMD ["java", "-jar", "orders-service-example-0.0.1-SNAPSHOT.jar","payments-service-example/app/payments-service-example-0.0.1-SNAPSHOT.jar","products-service-example/app/products-service-example-0.0.1-SNAPSHOT.jar","shipping-service-example/app/shipping-service-example-0.0.1-SNAPSHOT.jar"]