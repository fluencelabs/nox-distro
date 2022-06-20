#! /usr/bin/env sh

cleanup() {
  kill -9 $SSH_AGENT_PID
  echo "ssh-agent with pid $SSH_AGENT_PID is killed"
  exit
}

if ! [[ -f /root/.ssh/id_rsa ]]; then
  echo "Private key at '/root/.ssh/id_rsa' is missing or not readable"
  echo "Did you forget to mount .ssh key with '-v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa:ro'?"
  exit 1
fi

# start ssh-agent
eval $(ssh-agent) > /dev/null
echo "ssh-agent started with pid $SSH_AGENT_PID"
# on exit kill ssh-agent
trap 'cleanup' EXIT INT TERM
echo "Adding private key to ssh-agent"
ssh-add /root/.ssh/id_rsa

exec fab $@
