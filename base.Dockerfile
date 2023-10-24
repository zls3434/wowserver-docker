FROM ubuntu:latest

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && apt-get clean
RUN apt-get update && apt-get install -y libmysqlclient-dev libreadline8 libboost-system1.74.0 libboost-filesystem1.74.0 libboost-thread1.74.0 libboost-program-options1.74.0 libboost-iostreams1.74.0 libboost-regex1.74.0 mysql-client 

CMD ["/bin/bash"]
