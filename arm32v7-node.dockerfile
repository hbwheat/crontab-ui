# arm dockerfile for crontab-ui
FROM arm32v7/node

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get upgrade -y && \
apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /crontab-ui && touch /etc/crontabs/root && chmod +x /etc/crontabs/root

RUN groupadd -r runner -f -g 999 && \
useradd -u 1001 -r -g runner -d $HOME -s /sbin/nologin runner && \
chown -R runner:runner /crontab-ui && chmod -R runner:runner /crontab-ui

WORKDIR /crontab-ui

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

RUN npm install

ENV HOST 0.0.0.0

ENV PORT 8000

ENV CRON_PATH /etc/crontabs
ENV CRON_IN_DOCKER true

EXPOSE $PORT

USER runner

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
