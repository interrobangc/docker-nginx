FROM nginx:alpine

RUN apk add --update --no-cache \
        openssl \
        curl

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
