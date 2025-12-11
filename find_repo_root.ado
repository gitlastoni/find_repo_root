*! version 0.1.0 11dec2025
program define find_repo_root, rclass
    version 17

    // Parse options
    syntax [, MAXDepth(integer 3) Marker(string)]

    // Defaults
    if ("`marker'" == "") local marker ".git/HEAD"
    local markers "`marker'"
    local maxdepth = max(0, `maxdepth')

    // Starting directory
    local dir = c(pwd)

    // Traverse up to maxdepth levels (including current dir at depth 0)
    forvalues depth = 0/`maxdepth' {

        // Check each marker at the current level
        foreach m of local markers {
            local candidate "`dir'/`m'"
            // Check if file or directory exists
            capture confirm file "`candidate'"
            local isfile = (_rc == 0)
            capture confirm directory "`candidate'"
            local isdir = (_rc == 0)
            if (`isfile' | `isdir') {
                return clear
                return local repo_root "`dir'"
                di as txt "find_repo_root: found marker `m' at `dir'"
                exit
            }
        }

        // Stop if we've reached maxdepth
        if (`depth' == `maxdepth') continue

        // Compute parent directory
        local lastslash = max(strrpos("`dir'", "/"), strrpos("`dir'", "\"))
        if (`lastslash' <= 1) {
            local parent "/"
        }
        else {
            local parent = substr("`dir'", 1, `lastslash' - 1)
        }

        // If parent is same as current, break to avoid infinite loop
        if ("`parent'" == "`dir'") continue

        local dir "`parent'"
    }

    // Not found within maxdepth
    return clear
    return local repo_root ""
    di as txt "find_repo_root: no marker found within `maxdepth' levels"
end

