vim9script

# Helper to strip formatting decorations while protecting scientific notation exponent characters
def SanitizeNumericString(val: string): string
    # Remove $, €, £, ¥, ₹, and thousands commas
    var clean = substitute(val, '[\$,€,£,¥,₹]', '', 'g')
    clean = substitute(clean, ',', '', 'g')
    return trim(clean)
enddef

export def SumVisualSelection(line1: number, line2: number)
    var mode = visualmode()
    
    var col1: number = virtcol("'<")
    var col2: number = virtcol("'>")
    
    var total: float = 0.0
    var found_cells = false

    # Updated pattern: now includes an optional scientific notation exponent suffix at the end
    var pattern = '\v-?[\$,€,£,¥,₹]?[0-9]+[0-9,]*(\.[0-9]+)?(([eE][+-]?[0-9]+)?)'

    for lnum in range(line1, line2)
        var line = getline(lnum)
        
        if line !~ '^\s*|.*|\s*$' || line =~ '^\s*|[-\s|:]*|\s*$'
            continue
        endif
        
        if mode == "\<Cc>" || mode == "\<C-v>"
            # --- Visual Block Mode Column Extraction ---
            var idx1: number = col1 - 1
            var idx2: number = col2 - 1
            
            var content = line[idx1 : idx2]
            var start_idx = 0
            
            while start_idx < len(content)
                var matched_str = matchstr(content, pattern, start_idx)
                if matched_str == ''
                    break
                endif
                
                var clean_str = SanitizeNumericString(matched_str)
                total += str2float(clean_str)
                found_cells = true
                
                var match_pos = match(content, pattern, start_idx)
                start_idx = match_pos + len(matched_str)
            endwhile
        else
            # --- Row Selection Mode ---
            var cells = split(line, '|')
            for cell in cells
                var CleanCell = trim(cell)
                if CleanCell =~ '^\v' .. pattern .. '$'
                    var clean_str = SanitizeNumericString(CleanCell)
                    total += str2float(clean_str)
                    found_cells = true
                endif
            endfor
        endif
    endfor

    if !found_cells
        echo "No valid Vimwiki table cells found in selection."
        return
    endif

    var result_str = (total == float2nr(total)) ? string(float2nr(total)) : string(total)

    setreg('+', result_str)
    setreg('*', result_str)

    echo "Sum copied to clipboard: " .. result_str
enddef
