FROM ubuntu:24.04

ENV DEBIAN_FRONTEND="noninteractive"
ARG PHP_VERSION=5.6,7.0,7.1,7.2,7.3,7.4,8.0,8.1,8.2,8.3,8.4
ARG NODE_VERSION=14,16,18,20,22,24
ARG GO_VERSION=1.22.12,1.23.11,1.24.5
ARG DENO_VERSION=1.46.3,2.0.6,2.1.10,2.2.12,2.3.7,2.4.2
ARG PYTHON_VERSION=2.7,3.8,3.9,3.10,3.11,3.12,3.13

RUN <<EOF
apt update
apt upgrade -yq
apt install -yq --no-install-recommends --no-install-suggests \
  sudo locales curl git zip unzip 7zip wget cron nano vim ca-certificates openssh-client sqlite3 runit \
  software-properties-common build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev xz-utils libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

locale-gen en_US.UTF-8

apt clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EOF

# install apache2
RUN <<EOF
add-apt-repository ppa:ondrej/apache2
apt update
apt install -yq --no-install-recommends --no-install-suggests apache2

apt clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EOF

# install nginx
RUN <<EOF
add-apt-repository ppa:ondrej/nginx
apt update
apt install -yq --no-install-recommends --no-install-suggests nginx

apt clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EOF

# Install PHP
RUN <<EOF
add-apt-repository ppa:ondrej/php
apt update

# install multiple PHP versions
for v in $(echo $PHP_VERSION | tr "," "\n"); do
  apt install -yq --no-install-recommends --no-install-suggests \
    php$v \
    php$v-fpm \
    libapache2-mod-php$v
    php$v-cli \
    php$v-cgi \
    php$v-mysql \
    php$v-mbstring \
    php$v-xml \
    php$v-curl \
    php$v-zip \
    php$v-gd \
    php$v-imagick \
    php$v-bcmath \
    php$v-redis \
    php$v-intl \
    php$v-soap \
    php$v-sqlite3 \
    php$v-mongodb \
    php$v-igbinary \
    php$v-xdebug \
    php$v-bz2 \
    php$v-ldap \
    php$v-ssh2 \
    php$v-xmlrpc \
    php$v-apcu \
    php$v-memcached \
    php$v-tidy \
    php$v-pspell \

    if echo "$v" | grep -E '^8\.' > /dev/null; then
      apt install -yq --no-install-recommends --no-install-suggests php$v-swoole
    fi
done

apt clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EOF

# install composer
RUN curl -fsSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install WP-CLI
RUN curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x /usr/local/bin/wp

# Install Go
RUN <<EOF
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
  ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
  ARCH="arm64"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

# Download & Install
for v in $(echo $GO_VERSION | tr "," "\n"); do
  echo "Installing Go $v"
  curl -fsSL -o /tmp/go.tar.gz https://dl.google.com/go/go$v.linux-$ARCH.tar.gz
  tar -C /tmp -xzf /tmp/go.tar.gz
  mkdir -p /usr/local/go/versions
  mv /tmp/go /usr/local/go/versions/$v
  rm /tmp/go.tar.gz

  chmod +x /usr/local/go/versions/$v/bin/go
  chmod +x /usr/local/go/versions/$v/bin/gofmt

  if [ "$v" = "$(echo $GO_VERSION | tr "," "\n" | tail -n 1)" ]; then
    ln -s /usr/local/go/versions/$v/bin/go /usr/local/bin/go
    ln -s /usr/local/go/versions/$v/bin/gofmt /usr/local/bin/gofmt
  fi
done
EOF

# Install n & nodejs
RUN <<EOF
curl -fsSL -o /usr/local/bin/n https://raw.githubusercontent.com/tj/n/master/bin/n
chmod +x /usr/local/bin/n

for v in $(echo $NODE_VERSION | tr "," "\n"); do
  /usr/local/bin/n install $v
done
EOF

# Install deno
RUN <<EOF
ARCH=$(uname -m)
for v in $(echo $DENO_VERSION | tr "," "\n"); do
  echo "Installing Deno $v"

  curl -fsSL -o "/tmp/deno.zip" "https://github.com/denoland/deno/releases/download/v$v/deno-$ARCH-unknown-linux-gnu.zip"
  mkdir -p /usr/local/deno/versions/$v
  unzip -o /tmp/deno.zip -d /usr/local/deno/versions/$v
  chmod +x /usr/local/deno/versions/$v/deno
  rm "/tmp/deno.zip"
  if [ "$v" = "$(echo $DENO_VERSION | tr "," "\n" | tail -n 1)" ]; then
    ln -s /usr/local/deno/versions/$v/deno /usr/local/bin/deno
  fi
done
EOF

# Install pyenv & python
RUN <<EOF
export PYENV_ROOT="/usr/local/pyenv"

curl -fsSL https://pyenv.run | bash

ln -s /usr/local/pyenv/libexec/pyenv /usr/local/bin/pyenv

for v in $(echo $PYTHON_VERSION | tr "," "\n"); do
  pyenv install $v

  # set last python version as global
  if [ "$v" = "$(echo $v | tr "," "\n" | tail -n 1)" ]; then
    pyenv global $v
  fi
done

rm -rf /tmp/* /var/tmp/*
EOF

# Install starship
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

# Configure basic settings
RUN <<EOF
# make ubuntu user sudo without password
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# fix copy/paste issue
echo 'set enable-bracketed-paste off' >> /etc/inputrc
EOF

RUN <<EOF
echo 'export PYENV_ROOT="/usr/local/pyenv"' >> /home/ubuntu/.bashrc
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> /home/ubuntu/.bashrc
echo 'export GOPATH="$HOME/.go"' >> /home/ubuntu/.bashrc
echo 'export PATH="$GOPATH/bin:$PATH"' >> /home/ubuntu/.bashrc
echo 'eval "$(starship init bash)"' >> /home/ubuntu/.bashrc
echo 'eval "$(pyenv init - --no-rehash bash)"' >> /home/ubuntu/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> /home/ubuntu/.bashrc
EOF

# Switch to non-root user
USER ubuntu

# Congfigure ubuntu user
RUN <<EOF
echo 'export PYENV_ROOT="/usr/local/pyenv"' >> /home/ubuntu/.bashrc
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> /home/ubuntu/.bashrc
echo 'export GOPATH="$HOME/.go"' >> /home/ubuntu/.bashrc
echo 'export PATH="$GOPATH/bin:$PATH"' >> /home/ubuntu/.bashrc
echo 'eval "$(starship init bash)"' >> /home/ubuntu/.bashrc
echo 'eval "$(pyenv init - --no-rehash bash)"' >> /home/ubuntu/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> /home/ubuntu/.bashrc
EOF

# Install Composer and GO Air
RUN <<EOF
composer global require laravel/installer

export GOPATH="$HOME/.go"
go install github.com/air-verse/air@latest
EOF
