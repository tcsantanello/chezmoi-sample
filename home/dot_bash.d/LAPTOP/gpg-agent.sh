if ps -u $USER -o command | awk '/gpg-agent/&&!/awk/&&/daemon/ { exit 1 }'; then 
  gpg-agent --daemon >& /dev/null;
fi
