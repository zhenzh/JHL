FROM alpine as build

WORKDIR /build

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk update
RUN apk add gcc libc-dev make wget zlib-dev lua-dev pcre-dev luarocks

RUN luarocks-5.1 install lrexlib-pcre

RUN wget https://github.com/scandum/tintin/releases/download/2.02.11/tintin-2.02.11.tar.gz
RUN tar xzvf tintin-2.02.11.tar.gz
COPY . .
RUN cd /build/tt/src && ./configure && make install

FROM alpine

WORKDIR /JHL

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk update
RUN apk add lua5.1 pcre
RUN mkdir -p /usr/local/lib/lua/5.1
COPY --from=build /usr/local/bin/tt++ /usr/local/bin
COPY --from=build /usr/local/lib/lua/5.1/rex_pcre.so /usr/local/lib/lua/5.1
