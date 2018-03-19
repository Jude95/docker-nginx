This is a build of the latest nginx from OpenResty (https://openresty.org/), which includes a few additional modules.

The NGINX also includes a full Lua JIT and Perl interpreter and is compiled with all the modules which do not create a log of dependencies:

| Command | Module |
| ------- | ------ |
| `--add-module=/root/nginx_ajp_module` | [AJP module](https://github.com/yaoweibin/nginx_ajp_module) |
| `--add-module=/root/ngx_brotli_module` | [Brotli](https://github.com/google/ngx_brotli) |
| `--add-module=/root/nginx_upstream_check_module` | [upstream check module](https://github.com/yaoweibin/nginx_upstream_check_module) |
| `--with-threads` | [thread module](https://www.nginx.com/blog/thread-pools-boost-performance-9x/) |
| `--with-file-aio` | [file AIO module](http://nginx.org/en/docs/http/ngx_http_core_module.html#aio) |
| `--with-luajit` | [Lua](https://github.com/openresty/lua-nginx-module) |
| `--with-pcre-jit` | [PCRE JIT](https://nginx.org/en/docs/ngx_core_module.html#pcre_jit) |
| `--with-ipv6` | IPv6 support |
| `--with-http_iconv_module` | [ICONV module](https://github.com/calio/iconv-nginx-module) |
| `--with-stream` | [Stream module](http://nginx.org/en/docs/stream/ngx_stream_core_module.html) |
| `--with-stream_ssl_module` | [SSL support for stream module](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html) |
| `--with-http_slice_module` | [HTTP slice module](https://nginx.org/en/docs/http/ngx_http_slice_module.html) |
| `--with-http_ssl_module` | SSL |
| `--with-http_v2_module` | HTTP v2 |
| `--with-http_realip_module` | [RealIP](http://nginx.org/en/docs/http/ngx_http_realip_module.html) |
| `--with-http_addition_module` | [Adding Header and footer](http://nginx.org/en/docs/http/ngx_http_addition_module.html) |
| `--with-http_sub_module` | [Sub module](http://nginx.org/en/docs/http/ngx_http_sub_module.html) |
| `--with-http_dav_module` | [WebDAV support for Nginx](https://nginx.org/en/docs/http/ngx_http_dav_module.html) |
| `--with-http_flv_module` | [Pseudo-streaming for FLV](https://nginx.org/en/docs/http/ngx_http_flv_module.html) |
| `--with-http_mp4_module` | [Pseudo-streaming for MP4](https://nginx.org/en/docs/http/ngx_http_mp4_module.html) |
| `--with-http_gunzip_module` | [Auto decompress GZIP files for clients](https://nginx.org/en/docs/http/ngx_http_gunzip_module.html) |
| `--with-http_gzip_static_module` | [GZip static files](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html) |
| `--with-http_random_index_module` | [Randomly serve a file from directory](https://nginx.org/en/docs/http/ngx_http_random_index_module.html) |
| `--with-http_secure_link_module` | [Check the authenticity of requested links](https://nginx.org/en/docs/http/ngx_http_secure_link_module.html) |
| `--with-http_auth_request_module` | [Auth based on another request](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html) |
| `--with-http_stub_status_module` | [Basic status information](http://nginx.org/en/docs/http/ngx_http_stub_status_module.html) |
| `--with-http_xslt_module=dynamic` | [Transform XML using XSLT](https://nginx.org/en/docs/http/ngx_http_xslt_module.html) |
| `--with-http_image_filter_module=dynamic` | [Transform images in JPEG, GIF, PNG and WebP](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html) |
| `--with-http_geoip_module=dynamic` | [GeoIP headers](http://nginx.org/en/docs/http/ngx_http_geoip_module.html) |
| `--with-http_perl_module=dynamic` | [Perl](https://nginx.org/en/docs/http/ngx_http_perl_module.html) |
| `--with-mail` | [Mail module](http://nginx.org/en/docs/mail/ngx_mail_core_module.html) |
| `--with-mail_ssl_module` | [SSL support for mail](http://nginx.org/en/docs/mail/ngx_mail_ssl_module.html) |

Notably absent are:
- SSI, SCGI and UWSGI support
- Postgres support (requires client libraries, which are version dependent)

The image also includes logrotate to automatically HUP the NGINX and to rotate your logs in /var/log/nginx/ directory and its subdirectories.

