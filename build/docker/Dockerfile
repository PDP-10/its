FROM ubuntu:24.04

ARG EMULATOR

RUN apt-get update
RUN apt-get install -y git sudo

RUN mkdir its
ADD / its/

WORKDIR its
RUN sh -ex ./build/dependencies.sh install_linux
RUN make EMULATOR=${EMULATOR}

ENTRYPOINT ["./start"]