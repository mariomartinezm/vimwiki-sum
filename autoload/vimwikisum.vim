vim9script

export def SumVisualSelection(line1: number, line2: number)
    var mode = visualmode()
    
    # virtcol() returns a plain number directly. No lists involved!
    var col1: number = virtcol("'<")
    var col2: number = virtcol("'>")
    
    var total: float = 0.0
    var found_cells = false

    for lnum in range(line1, line2)
        var line = getline(lnum)
        
        # Check if line is a valid table row
        if line !~ '^\s*|.*|\s*$' || line =~ '^\s*|[-\s|:]*|\s*$'
            continue
        endif
        
        if mode == "\<Cc>" || mode == "\<C-v>"
            # --- Visual Block Mode Column Extraction ---
            var idx1: number = col1 - 1
            var idx2: number = col2 - 1
            
            var content = line[idx1 : idx2]
            var pattern = '\d\+\(\.\d\+\)\?'
            var start_idx = 0
            
            while start_idx < len(content)
                var matched_str = matchstr(content, pattern, start_idx)
                if matched_str == ''
                    break
                endif
                
                total += str2float(matched_str)
                found_cells = true
                
                var match_pos = match(content, pattern, start_idx)
                start_idx = match_pos + len(matched_str)
            endwhile
        else
            # --- Row Selection Mode ---
            var cells = split(line, '|')
            for cell in cells
                var CleanCell = trim(cell)
                if CleanCell =~ '^\d\+\(\.\d\+\)\?$'
                    total += str2float(CleanCell)
                    found_cells = true
                endif
            endfor
        endif
    endfor

    if !found_cells
        echo "No valid Vimwiki table cells found in selection."
        return
    endif

    # Format output cleanly
    var result_str = (total == float2nr(total)) ? string(float2nr(total)) : string(total)

    setreg('+', result_str)
    setreg('*', result_str)

    echo "Sum copied to clipboard: " .. result_str
enddef
