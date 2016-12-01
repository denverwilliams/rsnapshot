FROM buildpack-deps:jessie
MAINTAINER DLX

# install rsnapshot and cron
RUN apt-get update && apt-get -y upgrade && apt-get -y install rsnapshot cron

WORKDIR /home/rsnapshot

COPY . /home/rsnapshot

RUN chmod +x ./rsnapshot.sh

ENTRYPOINT ["/home/rsnapshot/rsnapshot.sh"]

CMD ["rsnapshotd"]
