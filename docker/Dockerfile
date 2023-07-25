from ubuntu:20.04

run apt-get -y update
run apt-get -y install iputils-ping
run apt-get -y install gcc
run apt-get -y install make 
run apt-get -y install wget
run apt-get -y install lsb-release
run apt-get -y install libssl-dev libreadline-dev
run mkdir /tmp/ruby272

workdir /tmp/ruby272 

run wget https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.2.tar.gz
run tar xzvf ruby-2.7.2.tar.gz

workdir /tmp/ruby272/ruby-2.7.2

run ./configure
run make
run make install


entrypoint ping 127.0.0.1 

