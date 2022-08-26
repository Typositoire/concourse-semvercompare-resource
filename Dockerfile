FROM alpine:3.16.2
LABEL maintainer "Yann David (@Typositoire) <davidyann88@gmail>"

#install packages
RUN apk add --update --upgrade --no-cache jq bash

#copy assets
ADD assets /opt/resource

#copy scripts
ADD scripts /opt/resource/scripts

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
