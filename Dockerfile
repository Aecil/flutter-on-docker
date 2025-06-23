FROM ubuntu:24.04

# Configuración básica del sistema
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y wget tar unzip && \
    rm -rf /var/lib/apt/lists/*

# Instalar OpenJDK 8 desde Adoptium (binario oficial)
RUN wget https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u402-b06/OpenJDK8U-jdk_x64_linux_hotspot_8u402b06.tar.gz && \
    tar xf OpenJDK8U-jdk_x64_linux_hotspot_8u402b06.tar.gz -C /opt && \
    rm OpenJDK8U-jdk_x64_linux_hotspot_8u402b06.tar.gz && \
    ln -s /opt/jdk8u402-b06 /opt/jdk-8

# Configurar variables de entorno para Java 8
ENV JAVA_HOME=/opt/jdk-8 \
    PATH=$PATH:/opt/jdk-8/bin

# Crear usuario y grupo para JBoss
RUN groupadd -r jboss && \
    useradd -r -g jboss -s /sbin/nologin -c "JBoss AS user" jboss

# Descargar e instalar WildFly
WORKDIR /opt

RUN wget https://download.jboss.org/wildfly/10.0.0.Final/wildfly-10.0.0.Final.tar.gz && \
    tar xf wildfly-10.0.0.Final.tar.gz && \
    rm wildfly-10.0.0.Final.tar.gz && \
    chown -R jboss:jboss wildfly-10.0.0.Final

# Configurar permisos y propietarios
RUN chmod -R g+rw /opt/wildfly-10.0.0.Final/standalone && \
    chmod -R g+rw /opt/wildfly-10.0.0.Final/domain

# Configurar variables de entorno para WildFly
ENV PATH=$PATH:/opt/wildfly-10.0.0.Final/bin \
    WILDFLY_HOME=/opt/wildfly-10.0.0.Final \
    WILDFLY_USER=jboss \
    WILDFLY_MODE=standalone

# Exponer puertos necesarios
EXPOSE 8080 9990 8787

# Iniciar como usuario jboss
USER jboss

# Comando para ejecutar el servidor
CMD ["sh", "-c", "/opt/wildfly-10.0.0.Final/bin/standalone.sh -b=0.0.0.0 -bmanagement=0.0.0.0"]
