#OwnCloud con Soporte Oracle
Este repositorio contiene la configuración necesaria para desplegar ownCloud utilizando una base de datos Oracle (OCI8), configurada y empaquetada mediante Docker.

🚀 Arquitectura
Este proyecto separa la lógica de la aplicación del almacenamiento de datos, garantizando un entorno portable y escalable.

🛠 Requisitos previos
Docker y Docker Compose instalados.

Archivos del driver Oracle Instant Client y OCI8 (deben estar en la carpeta raíz al construir).

⚙️ Cómo construir la imagen
Para generar tu propia imagen personalizada:

Bash

# Construir la imagen
docker build -t [TU_USUARIO]/owncloudoracle:stable .

# Subir a Docker Hub
docker push [TU_USUARIO]/owncloudoracle:stable
🚀 Despliegue
Para levantar el entorno, utiliza el archivo docker-compose.yml incluido:

Bash

docker-compose up -d
🔒 Notas de seguridad
IMPORTANTE: Este repositorio no contiene datos persistentes ni archivos de configuración sensibles (config.php, .dmp, etc.).

Asegúrate de gestionar tus copias de seguridad de la base de datos de forma externa.

Nunca subas archivos .dmp o credenciales de Oracle a repositorios públicos.

📦 Estructura del proyecto
Dockerfile: Receta para la imagen de ownCloud con soporte OCI8.

docker-compose.yml: Definición de servicios (App + DB).

.gitignore: Configurado para ignorar datos sensibles.
