#!/bin/bash

# Actualizar paquetes
echo "Actualizando paquetes..."
sudo apt update && sudo apt upgrade -y

# Instalar herramientas básicas
echo "Instalando herramientas básicas..."
sudo apt install -y curl wget git unzip htop glances \
    build-essential python3 python3-pip python3-venv \
    apache2 libapache2-mod-wsgi-py3 postgresql postgresql-contrib \
    wireshark tcpdump 

# Instalar Docker y Docker Compose
echo "Instalando Docker y Docker Compose..."
sudo apt install -y docker.io docker-compose 
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# Instalar herramientas para PostgreSQL
echo "Instalando herramientas para PostgreSQL..."
sudo apt install -y postgresql-client 
pip3 install pgcli

# Instalar herramientas de depuración de Python
echo "Instalando herramientas de depuración de Python..."
pip3 install debugpy pdbpp snakeviz flask-debugtoolbar

# Instalar herramientas de depuración y pruebas HTTP
echo "Instalando herramientas de red y prueba HTTP..."
sudo apt install -y apache2-utils
pip3 install httpie

# Configurar Apache (opcional)
echo "Habilitando mod_status de Apache..."
sudo a2enmod status 
echo "Configuración predeterminada de mod_status aplicada. Puedes modificar /etc/apache2/mods-enabled/status.conf"
sudo systemctl restart apache2

# Mensaje final
echo "Instalación completada. Reinicia la sesión para aplicar los cambios de Docker."
