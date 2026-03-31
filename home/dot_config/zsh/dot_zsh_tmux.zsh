if [[ -z "$TMUX" && $- == *i* ]]; then
  if tmux has-session 2>/dev/null; then
    exec tmux attach-session
  else
    exec sesh connect "default"
  fi
fi
