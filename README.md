This is a build of the latest nginx from OpenResty (https://openresty.org/), which includes a few additional modules.

The NGINX also includes a full Lua JIT and Perl interpreter and is compiled with all the modules which do not create a log of dependencies:
- AJP module: https://github.com/yaoweibin/nginx_ajp_module
- upstream check module: https://github.com/yaoweibin/nginx_upstream_check_module
- thread module (--with-threads): https://www.nginx.com/blog/thread-pools-boost-performance-9x/
- file AIO module (--with-file-aio): http://nginx.org/en/docs/http/ngx_http_core_module.html#aio
- Lua (--with-luajit)
- PCRE (--with-pcre-jit)
- IPv6 support (--with-ipv6)
- ICONV module (--with-http_iconv_module): https://github.com/calio/iconv-nginx-module
- Stream module (--with-stream): http://nginx.org/en/docs/stream/ngx_stream_core_module.html
- SSL (--with-http_ssl_module)
- HTTP/2 (--with-http_v2_module)
- RealIP (--with-http_realip_module): http://nginx.org/en/docs/http/ngx_http_realip_module.html
- Adding Header and footer (--with-http_addition_module): http://nginx.org/en/docs/http/ngx_http_addition_module.html
- GeoIP headers (--with-http_geoip_module): http://nginx.org/en/docs/http/ngx_http_geoip_module.html
- Sub module (--with-http_sub_module): http://nginx.org/en/docs/http/ngx_http_sub_module.html
- GZip static files (--with-http_gzip_static_module): http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html
- Auth based on another request (--with-http_auth_request_module): http://nginx.org/en/docs/http/ngx_http_auth_request_module.html
- Basic status information (--with-http_stub_status_module): http://nginx.org/en/docs/http/ngx_http_stub_status_module.html
- Mail module (--with-mail): http://nginx.org/en/docs/mail/ngx_mail_core_module.html
- SSL support for mail (--with-mail_ssl_module): http://nginx.org/en/docs/mail/ngx_mail_ssl_module.html
- Brotli compression: https://github.com/cloudflare/ngx_brotli_module, enable with `brotli on;` in your config

Notably absent are:
- SSI, SCGI and UWSGI support
- Postgres support (requires client libraries, which are version dependent)

The image also includes logrotate to automatically HUP the NGINX and to rotate your logs in /var/log/nginx/ directory and its subdirectories.

