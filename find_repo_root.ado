*! version 0.1.0 11dec2025
program define find_repo_root, rclass
    version 17

    // Parse options
    syntax [, MAXDepth(integer 3) Marker(string)]

    // Validate maxdepth >= 0
    if (`maxdepth' < 0) {
        di as err "maxdepth() must be >= 0"
        exit 198
    }

    // Set default marker
    if ("`marker'" == "") local marker ".git/HEAD"
    local markers "`marker'"

    // Save original directory to restore later
    local origdir = c(pwd)
    local dir "`origdir'"

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
                // Restore original directory before returning
                cd "`origdir'"
                return local repo_root "`dir'"
                di as txt "find_repo_root: found marker `m' at `dir'"
                exit
            }
        }

        // Move up one directory level (skip if we've reached maxdepth)
        if (`depth' < `maxdepth') {
            cd ..
            local newdir = c(pwd)
            
            // Check if we're stuck (didn't actually move up - at root)
            if ("`newdir'" == "`dir'") continue, break
            
            local dir "`newdir'"
        }
    }

    // Restore original directory
    cd "`origdir'"

    // Not found within maxdepth
    return local repo_root ""
    di as txt "find_repo_root: no marker found within `maxdepth' levels"
end

