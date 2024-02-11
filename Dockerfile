FROM ubuntu:22.04
RUN apt-get update -y && apt-get install curl build-essential gdb nasm clang rust-all cmake make -y

RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

RUN export PATH=$PATH:/usr/local/go/bin
