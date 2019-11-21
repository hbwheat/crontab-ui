# arm dockerfile for crontab-ui
FROM arm32v7/node:8-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get upgrade -y && \
DEBIAN_FRONTEND=noninteractive apt-get install -y wget curl supervisor cron  && \
apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /crontab-ui && \
 mkdir /etc/crontabs && \
 touch /etc/crontabs/root && \
 chmod +x /etc/crontabs/root

RUN groupadd -r runner && useradd --no-log-init -r -g runner runner

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

RUN  chown -R runner:runner /crontab-ui

WORKDIR /crontab-ui

RUN npm install

ENV HOST 0.0.0.0

ENV PORT 8000

ENV CRON_PATH /etc/crontabs
ENV CRON_IN_DOCKER true

EXPOSE $PORT

USER runner

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
