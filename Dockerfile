FROM alpine:edge
MAINTAINER Bojan Cekrlic (https://github.com/boky8) 

ENV OPENRESTY_VERSION 1.9.7.3
ENV GLIBC_VERSION 2.23-r1

# Download and install glibc
RUN apk add --update curl && \
  curl -o glibc.apk -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  apk add --allow-untrusted glibc.apk && \
  curl -o glibc-bin.apk -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add --allow-untrusted glibc-bin.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  apk del curl && \
  rm -f glibc.apk glibc-bin.apk && \
  rm -rf /var/cache/apk/*

RUN true \
 && echo " ===> Installing run-time dependecies..." \
 && apk update \
 && apk add bash curl perl unzip ca-certificates openssl pcre zlib openssl supervisor logrotate xz

RUN true \
 && echo " ===> Downloading nginx_ajp_module" \
 && curl --retry 5 --max-time 120 --connect-timeout 5 -o /tmp/nginx_ajp_module.zip -SL https://github.com/yaoweibin/nginx_ajp_module/archive/master.zip \
 && cd /tmp && unzip nginx_ajp_module.zip && mv /tmp/nginx_ajp_module-master /root/nginx_ajp_module \
 && true \
 && echo " ===> Downloading nginx_upstream_check_module" \
 && curl --retry 5 --max-time 120 --connect-timeout 5 -o /tmp/nginx_upstream_check_module.zip -SL https://github.com/yaoweibin/nginx_upstream_check_module/archive/master.zip \
 && cd /tmp && unzip nginx_upstream_check_module.zip && mv /tmp/nginx_upstream_check_module-master /root/nginx_upstream_check_module \
 && echo " ===> Downloading GeoIP data..." \
 && mkdir -p /usr/local/share/GeoIP/ && cd /usr/local/share/GeoIP/ \
 && curl --retry 5 --max-time 120 --connect-timeout 5 -sSL http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz | gunzip > GeoLiteCity.dat \
 && curl --retry 5 --max-time 120 --connect-timeout 5 -sSL http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz| gunzip > GeoIP.dat

RUN true \
 && echo " ===> Installing dependencies..." \
 && build_pkgs="build-base linux-headers openssl-dev pcre-dev wget zlib-dev make gcc pcre-dev openssl-dev zlib-dev ncurses-dev readline-dev" \
 && adduser -D nginx \
 && apk add ${build_pkgs} \
 && true \
 && echo " ===> Downloading and installing GeoIP" \
 && cd /tmp \
 && curl --retry 5 --max-time 120 --connect-timeout 5 -sSL http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz | tar xvz \
 && cd GeoIP-* && ./configure && make && make install \
 && true \
 && mkdir -p /root/ngx_openresty \
 && cd /root/ngx_openresty \
 && echo " ===> Downloading OpenResty..." \
 && curl -sSL http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz | tar -xvz \
 && cd openresty-* \
 && echo " ===> Configuring OpenResty..." \
 && readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
 && echo "using upto $NPROC threads" \
 && ./configure \
    --prefix=/usr/local/openresty \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=$VAR_PREFIX/client_body_temp \
    --http-proxy-temp-path=$VAR_PREFIX/proxy_temp \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/lock/nginx.lock \
    --add-module=/root/nginx_ajp_module \
    --add-module=/root/nginx_upstream_check_module \
    --user=nginx \
    --group=nginx \
    --with-threads \
    --with-file-aio \
    --with-luajit \
    --with-pcre-jit \
    --with-ipv6 \
    --with-http_iconv_module \
    --with-stream \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_geoip_module \
    --with-http_sub_module \
    --with-http_gzip_static_module \
    --with-http_auth_request_module \
    --with-http_stub_status_module \
    --with-mail \
    --with-mail_ssl_module \
    --without-http_ssi_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    -j${NPROC} \
 && echo " ===> Building OpenResty..." \
 && make -j${NPROC} \
 && echo " ===> Installing OpenResty..." \
 && make install  \
 && echo " ===> Finishing..." \
 && mkdir -p /usr/local/bin \
 && ln -sf /usr/sbin/nginx /usr/local/bin/nginx \
 && ln -sf /usr/sbin/nginx /usr/local/bin/openresty \
 && ln -sf /usr/local/openresty/bin/resty /usr/local/bin/resty \
 && ln -sf /usr/local/openresty/luajit/bin/luajit-* /usr/local/openresty/luajit/bin/lua \
 && ln -sf /usr/local/openresty/luajit/bin/luajit-* /usr/local/bin/lua \
 && apk del ${build_pkgs} \
 && rm -rf /var/cache/apk/* \
 && (rm -rf /root/ngx_* || true) \
 && (rm -rf /root/nginx_* || true) \
 && (rm -rf /tmp/* || true)

COPY supervisord.conf /etc/supervisord.conf
COPY logrotate.sh /usr/local/logrotate.sh
COPY nginx /etc/logrotate.d/nginx
RUN chmod +x /usr/local/logrotate.sh

EXPOSE 80
EXPOSE 8080
EXPOSE 8081
EXPOSE 443
EXPOSE 8443

USER root
WORKDIR /tmp
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
