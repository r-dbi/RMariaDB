# You can find the new timestamped tags here: https://hub.docker.com/r/gitpod/workspace-base/tags
FROM gitpod/workspace-base:latest

# Install R and ccache
RUN sudo apt update
RUN sudo apt install -y \
  r-base \
  ccache \
  cmake \
  mariadb-server mariadb-client \
  # Install dependencies for devtools package
  libharfbuzz-dev libfribidi-dev

# Work around glitch with non-systemd systems
RUN ln -s $(which true) /usr/local/bin/timedatectl
