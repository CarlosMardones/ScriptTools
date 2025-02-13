#!/bin/bash

# Definir variables
POSTGRES_USER="admin"
POSTGRES_PASSWORD="adminpassword"
POSTGRES_DB="mydatabase"

# Actualizar el sistema
echo "Actualizando paquetes..."
sudo apt update && sudo apt upgrade -y

# Instalar Apache y mod_wsgi
echo "Instalando Apache y mod_wsgi..."
sudo apt install apache2 libapache2-mod-wsgi-py3 -y
sudo systemctl enable apache2
sudo systemctl start apache2

# Instalar PostgreSQL
echo "Instalando PostgreSQL..."
sudo apt install postgresql postgresql-contrib -y
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Configurar PostgreSQL: crear usuario y base de datos
echo "Configurando PostgreSQL..."
sudo -u postgres psql -c "CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';"
sudo -u postgres psql -c "CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;"
sudo -u postgres psql -c "ALTER ROLE $POSTGRES_USER SET client_encoding TO 'utf8';"
sudo -u postgres psql -c "ALTER ROLE $POSTGRES_USER SET default_transaction_isolation TO 'read committed';"
sudo -u postgres psql -c "ALTER ROLE $POSTGRES_USER SET timezone TO 'UTC';"

# Instalar Python y pip
echo "Instalando Python y dependencias..."
sudo apt install python3 python3-pip python3-venv -y

# Crear entorno virtual para aplicaciones Python
echo "Creando entorno virtual de Python..."
mkdir -p ~/myapp
cd ~/myapp
python3 -m venv venv
source venv/bin/activate
pip install flask psycopg2

# Instalar Docker
echo "Instalando Docker..."
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Configurar Apache para servir aplicaciones Python con WSGI
echo "Configurando Apache para Python..."
WSGI_CONF="/etc/apache2/sites-available/myapp.conf"

echo "<VirtualHost *:80>
    ServerName localhost

    WSGIDaemonProcess myapp python-home=/home/$USER/myapp/venv python-path=/home/$USER/myapp
    WSGIScriptAlias / /home/$USER/myapp/myapp.wsgi

    <Directory /home/$USER/myapp>
        Require all granted
    </Directory>

    Alias /static /home/$USER/myapp/static
    <Directory /home/$USER/myapp/static>
        Require all granted
    </Directory>
</VirtualHost>" | sudo tee $WSGI_CONF

# Habilitar el nuevo sitio y reiniciar Apache
sudo a2ensite myapp.conf
sudo systemctl restart apache2

# Crear archivo WSGI de prueba
echo "Creando aplicación de prueba..."
echo "def application(environ, start_response):
    status = '200 OK'
    output = b'Hello, World!'

    response_headers = [('Content-type', 'text/plain')]
    start_response(status, response_headers)

    return [output]" > ~/myapp/myapp.wsgi

# Mensaje de finalización
echo "Instalación completada. Reinicia o cierra sesión para aplicar los cambios de Docker."
echo "Puedes probar tu servidor web en: http://localhost"
