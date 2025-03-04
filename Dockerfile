FROM bcit.io/alpine:3.20

LABEL maintainer="ekraft2@bcit.ca"
LABEL build_id="1741124671"

# Add docker-entrypoint script base
ADD https://github.com/itsbcit/docker-entrypoint/releases/download/v1.6/docker-entrypoint.tar.gz /docker-entrypoint.tar.gz
RUN tar zxvf docker-entrypoint.tar.gz && rm -f docker-entrypoint.tar.gz \
 && chmod -R 555 /docker-entrypoint.* \
 && echo "UTC" > /etc/timezone \
 && ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
 && chmod 664 /etc/passwd \
              /etc/group \
              /etc/shadow \
              /etc/timezone \
              /etc/localtime \
 && chown 0:0 /etc/shadow \
 && chmod 775 /etc

# Add dockerize
ADD https://github.com/jwilder/dockerize/releases/download/v0.7.0/dockerize-alpine-linux-amd64-v0.7.0.tar.gz /dockerize.tar.gz
RUN [ -d /usr/local/bin ] || mkdir -p /usr/local/bin \
 && tar zxf /dockerize.tar.gz -C /usr/local/bin \
 && chown 0:0 /usr/local/bin/dockerize \
 && chmod 0555 /usr/local/bin/dockerize \
 && rm -f /dockerize.tar.gz

ENV DOCKERIZE_ENV production

RUN apk add --no-cache traceroute

ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]
CMD [ "init-loop" ]
