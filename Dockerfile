FROM nginx:1.13.8-alpine

RUN apk add --no-cache \
		curl \
		tini \
	&& apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	&& apk del .gettext \
	&& mv /tmp/envsubst /usr/bin/

COPY docker-entrypoint.sh /
COPY nginx.conf /etc/nginx/nginx.conf.tmpl

VOLUME ["/cache"]

ENTRYPOINT ["/sbin/tini", "-g", "--", "/docker-entrypoint.sh"]
CMD ["cache"]
