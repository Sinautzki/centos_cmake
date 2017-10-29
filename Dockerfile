# Use an official Python runtime as a parent image
FROM centos:7

LABEL maintainer "Stephan.Sinautzki@escrypt.com"

RUN yum install -y gcc gcc-c++ make
RUN g++ --version
RUN echo $CXX
COPY assets/cmake-3.9.4.tar.gz /tmp
 
RUN cd /tmp && tar -xvzf cmake-3.9.4.tar.gz 
RUN cd /tmp/cmake-3.9.4/ 
RUN cd /tmp/cmake-3.9.4/ && ./bootstrap 
RUN cd /tmp/cmake-3.9.4/ && make -j4
RUN cd /tmp/cmake-3.9.4/ && make install 

CMD /bin/bash
