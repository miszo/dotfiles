function open_in_nvim { 
    local filename="$1"
    local line="${2:-1}"
    
    if [[ "$filename" != /* ]]; then
        filename="$(pwd)/$filename"
    fi
    
    if [[ -n "$NVIM" ]]; then
        # Store current terminal buffer number before switching
        current_buf=$(nvim --server "$NVIM" --remote-expr "bufnr('%')")
        
        # Open the file
        if [[ "$line" -gt 1 ]] 2>/dev/null; then
            nvim --server "$NVIM" --remote-send "<C-\\><C-n>:e $filename | $line<CR>"
        else
            nvim --server "$NVIM" --remote-send "<C-\\><C-n>:e $filename<CR>"
        fi
        
        # Close the specific terminal buffer we were in
        sleep 0.1
        nvim --server "$NVIM" --remote-send ":lua Snacks.terminal.get({ 'lazygit' }):hide()<CR>"
        
    elif [[ -n "$NVIM_LISTEN_ADDRESS" ]]; then
        current_buf=$(nvim --server "$NVIM_LISTEN_ADDRESS" --remote-expr "bufnr('%')")
        
        if [[ "$line" -gt 1 ]] 2>/dev/null; then
            nvim --server "$NVIM_LISTEN_ADDRESS" --remote-send "<C-\\><C-n>:e $filename | $line<CR>"
        else
            nvim --server "$NVIM_LISTEN_ADDRESS" --remote-send "<C-\\><C-n>:e $filename<CR>"
        fi
        
        sleep 0.1
        nvim --server "$NVIM_LISTEN_ADDRESS" --remote-send ":bd! $current_buf<CR>"
        
    else
        if [[ "$line" -gt 1 ]] 2>/dev/null; then
            nvim "+$line" "$filename"
        else
            nvim "$filename"
        fi
    fi
}

