FROM ubuntu:24.04

# Configuración básica del sistema
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y wget tar unzip openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario y grupo para JBoss con UID/GID libres
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
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
    PATH=$PATH:/opt/wildfly-10.0.0.Final/bin \
    WILDFLY_HOME=/opt/wildfly-10.0.0.Final \
    WILDFLY_USER=jboss \
    WILDFLY_MODE=standalone

# Exponer puertos necesarios
EXPOSE 8080 9990 8787

# Iniciar como usuario jboss
USER jboss

# Comando para ejecutar el servidor
CMD ["sh", "-c", "/opt/wildfly-10.0.0.Final/bin/standalone.sh -b=0.0.0.0 -bmanagement=0.0.0.0"]
