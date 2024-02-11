FROM ubuntu:22.04
RUN apt-get update -y && apt-get install curl build-essential gdb nasm clang rust-all cmake make golang-go -y

