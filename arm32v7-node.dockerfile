# arm dockerfile for crontab-ui
FROM arm32v7/node:8-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get upgrade -y && \
DEBIAN_FRONTEND=noninteractive apt-get install -y wget curl cron  && \
apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN mkdir /crontab-ui && \
# mkdir /etc/crontabs && \
# touch /etc/crontabs/root && \
# chmod +x /etc/crontabs/root

#RUN groupadd -r runner && useradd -m --no-log-init -g runner runner

#COPY supervisord.conf /etc/supervisord.conf
#COPY . /crontab-ui

#RUN  chown -R runner:runner /crontab-ui

#WORKDIR /home/runner

RUN npm install -g crontab-ui && \
npm install -g pm2

ENV HOST 0.0.0.0

ENV PORT 8000

#ENV CRON_PATH /etc/crontabs
#ENV CRON_IN_DOCKER true

EXPOSE $PORT

USER node

CMD [ "pm2-runtime", "npm", "--", "start", "contrab-ui"]
#CMD ["supervisord", "-c", "/etc/supervisord.conf"]
