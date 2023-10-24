FROM ubuntu:latest

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && apt-get clean
RUN apt-get update && apt-get install -y git clang cmake make gcc g++ libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
RUN git config --global --add safe.directory "*"

ENTRYPOINT ["/bin/bash"]
