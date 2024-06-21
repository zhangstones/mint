FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV GOROOT /usr/local/go
ENV GOPATH /usr/local/gopath
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH
ENV MINT_ROOT_DIR /mint

ENV http_proxy http://10.33.97.245:7890
ENV https_proxy http://10.33.97.245:7890

ADD source.sh /mint/source.sh
ADD preinstall.sh /mint/preinstall.sh
ADD install-packages.list /mint/install-packages.list

RUN /mint/preinstall.sh

COPY . /mint
WORKDIR /mint

RUN /mint/create-data-files.sh

RUN /mint/release.sh

ENV http_proxy=
ENV https_proxy=

ENTRYPOINT ["/mint/entrypoint.sh"]
