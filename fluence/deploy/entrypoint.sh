#! /usr/bin/env sh

if ! [[ -d /root/.ssh ]]; then
  echo "Private key at '/root/.ssh' is missing or not readable"
  echo "Did you forget to mount .ssh directory with '-v $HOME/.ssh:/root/.ssh:ro'?"
  exit 1
fi

eval $(ssh-agent) > /dev/null
ssh-add

exec fab $@
