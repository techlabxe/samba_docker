FROM alpine:3.6
MAINTAINER techlabxe

RUN apk update
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apk add samba

COPY smb.conf /etc/samba/smb.conf
COPY samba_users.txt .

RUN cat samba_users.txt |  awk '{print "adduser -D ", $1}' | /bin/sh
RUN cat samba_users.txt | awk '{print "(echo ",$2,"; echo ",$2,") | pdbedit -a ",$1, "-t" }' | /bin/sh

RUN rm samba_users.txt

ENTRYPOINT smbd --foreground

EXPOSE 445


