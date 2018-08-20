FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update ; apt-get upgrade -y;

RUN apt-get -y install openssh-server;

RUN apt-get -y install python3-pip python-pip supervisor cron locales mlocate tmux \
borgbackup iputils-ping \
htop rsyslog tzdata libpng-dev dh-autoreconf ctags dstat \
mercurial autoconf automake libtool nasm make pkg-config git \
libpython-dev python-dev libpq-dev \
logrotate build-essential zlib1g-dev cmake doxygen \
python3 sudo curl libpython3-dev netcat libffi-dev libevent-dev \
tree silversearcher-ag libgoogle-glog-dev \
libzip-dev libsnappy-dev libprotobuf-dev protobuf-compiler bzip2 ruby-dev \
gist rsync nodejs npm vim xtail whois p7zip-full postgresql-client;\
locale-gen zh_CN.UTF-8; 


RUN ln -s /usr/bin/nodejs /usr/bin/node;\
npm install -g n;n stable;\
npm install -g cnpm --registry=https://registry.npm.taobao.org; \
pip3 install virtualenv autopep8 trash-cli ;\
cp /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime;\
cnpm install -g coffeelint pngquant-bin image-webpack-loader webpack webpack-dev-server gulp coffee-script js-beautify yarn;\
yarn config set registry 'https://registry.npm.taobao.org';\
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/;\
gem install sass;


# vimrc.local 中的自动格式化需要用到 js-beautify sass

RUN cd /tmp;\
git clone https://github.com/BYVoid/OpenCC.git --depth=1;\
cd /tmp/OpenCC;\
make;\
make install;\
cd /tmp;\
rm -rf /tmp/OpenCC;

RUN git clone https://github.com/gu321/docker.git /tmp/docker --depth=1;\
rsync -av /tmp/docker/data/ /;

RUN git clone https://github.com/gu321/docker_home.git /home/docker --depth=1;\
rsync -av /home/docker/home/ /root;

RUN git clone https://github.com/gmarik/Vundle.vim.git /usr/share/vim/vimfiles/bundle/Vundle.vim --depth=1;\
vim +PluginInstall +qall;

#sed -i '/colorscheme/ i colorscheme molokai' /etc/vim/vimrc.local;

RUN curl -fsS https://dlang.org/install.sh | bash -s dmd -p /opt/dlang ; find /opt/dlang -type d -exec chmod 755 {} \;

RUN bash /tmp/install.sh;rm /tmp/install.sh; updatedb ;


USER ol

WORKDIR /home/ol

USER root
ENTRYPOINT ["/etc/rc.local"]
