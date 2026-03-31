if [[ -z "$TMUX" && $- == *i* ]]; then
  if tmux has-session 2>/dev/null; then
    exec tmux attach-session
  else
    # Avoid calling `sesh` by default because it may fail with "No connection found for default".
    # If you explicitly want to use `sesh`, set `USE_SESH=1` in your environment.
    if command -v sesh >/dev/null 2>&1 && [[ -n "${USE_SESH:-}" ]]; then
      exec sesh connect "default"
    fi
    exec tmux new-session -s default
  fi
fi
