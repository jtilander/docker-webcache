FROM nginx:1.15.1-alpine

RUN apk add --no-cache \
		curl \
		tini \
	&& apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	&& apk del .gettext \
	&& mv /tmp/envsubst /usr/bin/

COPY docker-entrypoint.sh /
COPY nginx.conf /etc/nginx/nginx.conf.tmpl

RUN mkdir -p /cache /log /etc/certs.d
COPY bad.* /etc/certs.d/

VOLUME ["/cache", "/log", "/etc/certs.d"]

ENTRYPOINT ["/sbin/tini", "-g", "--", "/docker-entrypoint.sh"]
CMD ["cache"]

ARG VERSION=unknown
RUN echo "$VERSION" > /version.txt
