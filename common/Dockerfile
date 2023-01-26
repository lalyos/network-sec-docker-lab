FROM alpine:3.17

RUN apk add \
  bash \
  cmd:dig \
  tmux \
  docker-cli

ADD https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-linux-x86_64 /root/.docker/cli-plugins/docker-compose
RUN chmod +x /root/.docker/cli-plugins/docker-compose
COPY .bashrc /root
CMD [ "bash" ]