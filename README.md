# TPE - Redes de Información - WAF

<img src="images/modsecurity.png" alt="ModSecurity" width="300"/>

## Descripción
El propósito de este TP es exponer la tecnología de Web App Firewall (WAF), sus beneficios y funcionamiento a grandes rasgos. Es TP se basa en la herramienta ModSecurity, la cual permite muy fácilmente implementar un WAF, en conjunto con un proxy reverso.

## Enunciado de TP
- No puede ser implementado en nube.
- Configurar un servidor Proxy que funcione como proxy reverso para recibir las peticiones para al menos 2 servidores con web server.
- Configurar un servidor con ModSecurity que reciba las redirecciones del Proxy y chequee la seguridad de las mismas
- Configurar al menos 3 reglas de solo detección para realizar análisis.
- Configurar al menos 3 reglas de bloqueo.
- Probar al menos 3 ataques para mostrar la respuesta del waf, configurar un página default de respuesta ante detección de anomalía.

## Arquitectura
A continuación, se muestra la arquitectura usada para cumplir con los requisitos del enunciado:

<img src="images/arquitectura.png" alt="Arquitectura" width="1000"/>

### Componentes:
Todos los siguientes componentes corren en containers Docker. Estos son: 
1. **Reverse Proxy:** Se tiene un servidor nginx, el cual se le agrega el módulo de ModSecurity el cual da la funcionalidad de WAF. El servidor funciona como un Reverse Proxy, apuntando a las siguientes 2 web apps.
2. **Web App 1:** Una web app básica implementada en Python, la cual devuelve un numero aleatorio en el cuerpo HTML, luego de una espera aleatoria de 1 a 3 segundos.
3. **Web App 2:** bWAPP, una web app diseñada para tener un rango amplio de exploits. Esta tiene un backend que se conecta a una base de datos relacional MySQL.


## Instalación

### Requisitos:
- Docker
- Python 3 

### Pasos de instalación:
1. En la carpeta raiz del TP, ejecutar: 
```bash
docker compose up
```
2. Una vez levantados los conentedores, las web apps se puede acceder desde:
- bWebApp: `localhost/bwebapp/install.php`
- rWebApp: `localhost/rwebapp/`

### Testeo de DoS:
1. Tener instalado el modulo *requests*: 
```bash
pip install requests
```
2. En la carpeta raiz del TP, ejecutar:
```bash
python3 ./testing/test-dos.py
```
