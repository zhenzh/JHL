FROM alpine:latest as build

WORKDIR /build

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk update
RUN apk add gcc libc-dev make wget zlib-dev lua-dev pcre-dev luarocks

RUN luarocks-5.1 install lrexlib-pcre

RUN wget https://github.com/scandum/tintin/releases/download/2.02.20/tintin-2.02.20.tar.gz
RUN tar xzvf tintin-2.02.20.tar.gz && cd tt/src && ./configure && make install

FROM alpine:latest

WORKDIR /JHL
ENV LANG=C.UTF-8
ENV TZ=Asia/Shanghai
ENV TERM=screen-256color

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk update && apk add tzdata lua5.1 pcre screen
RUN mkdir -p /usr/local/lib/lua/5.1


RUN echo "startup_message off" >> ~/.screenrc
RUN echo "nonblock on" >> ~/.screenrc
RUN echo "altscreen on" >> ~/.screenrc
RUN echo "termcapinfo xterm-256color 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm'" >> ~/.screenrc
RUN echo "attrcolor b '.I'" >> ~/.screenrc
RUN echo "defscrollback 100000" >> ~/.screenrc
RUN echo "hardstatus alwayslastline" >> ~/.screenrc
RUN echo "hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %m-%d %{W}%c %{g}]'" >> ~/.screenrc
COPY --from=build /usr/local/bin/tt++ /usr/local/bin
COPY --from=build /usr/local/lib/lua/5.1/rex_pcre.so /usr/local/lib/lua/5.1
CMD [ "sleep", "infinity" ]
