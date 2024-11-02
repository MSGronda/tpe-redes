FROM nginx:1.27.2

# Instalamos los paquetes necesarios 
RUN apt-get update && apt-get install -y build-essential libcurl4-openssl-dev \
    liblmdb-dev libpcre3-dev libtool libxml2-dev libyajl-dev libmaxminddb0 libmaxminddb-dev \
	git zlib1g-dev wget nano tar

# Conseguimos el paquete de modsecurity
RUN git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity /opt/ModSecurity && \
    cd /opt/ModSecurity && git submodule init && git submodule update && ./build.sh && ./configure && make && make install

# Conseguimos el conector para nginx
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git /opt/ModSecurity-nginx

# Obtenemos el nginx
RUN wget http://nginx.org/download/nginx-1.27.2.tar.gz && tar -xzvf nginx-1.27.2.tar.gz && \
    cd nginx-1.27.2 && ./configure --with-compat --add-dynamic-module=/opt/ModSecurity-nginx && \
    make modules && cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules # Aca pasa la version custom al directorio de nginx 

# Obtenemos la configuracion default para modsecurity
RUN mkdir /etc/nginx/modsec && wget -P /etc/nginx/modsec/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended && \
	mv /etc/nginx/modsec/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf && \
	sed --i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
