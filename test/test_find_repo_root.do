version 17
set more off

// Ensure local ado is on the path (use absolute path since we'll change dirs)
local testdir = c(pwd)
adopath ++ "`testdir'"

capture noisily {
    // Preserve original working directory
    local origpwd = c(pwd)

    // Create isolated test root
    tempname tdir
    local testroot "`c(tmpdir)'/`tdir'"
    // Remove if exists, then create fresh
    capture shell rm -rf "`testroot'"
    capture mkdir "`testroot'"

    // -----------------------
    // Setup: git-style repo
    // -----------------------
    capture mkdir "`testroot'/repo"
    capture mkdir "`testroot'/repo/.git"
    file open fh using "`testroot'/repo/.git/HEAD", write text replace
    file write fh "ref: refs/heads/main" _n
    file close fh
    capture mkdir "`testroot'/repo/subdir"
    capture mkdir "`testroot'/repo/subdir/child"

    // 1) Basic functionality from nested dir
    cd "`testroot'/repo/subdir/child"
    find_repo_root
    assert "`r(repo_root)'" == "`testroot'/repo"

    // 2) Current directory match (depth 0)
    cd "`testroot'/repo"
    find_repo_root
    assert "`r(repo_root)'" == "`testroot'/repo"

    // -----------------------
    // Setup: custom marker repo
    // -----------------------
    capture mkdir "`testroot'/customrepo"
    capture mkdir "`testroot'/customrepo/proj"
    file open fh2 using "`testroot'/customrepo/proj/README.md", write text replace
    file write fh2 "custom marker" _n
    file close fh2

    // 3) Custom marker option
    cd "`testroot'/customrepo/proj"
    find_repo_root, marker("README.md")
    assert "`r(repo_root)'" == "`testroot'/customrepo/proj"

    // -----------------------
    // Setup: multiple markers (svn style)
    // -----------------------
    capture mkdir "`testroot'/svnrepo"
    capture mkdir "`testroot'/svnrepo/.svn"
    capture mkdir "`testroot'/svnrepo/deep"
    capture mkdir "`testroot'/svnrepo/deep/child"

    // 4) Multiple markers option
    cd "`testroot'/svnrepo/deep/child"
    find_repo_root, marker(".git/HEAD .svn")
    assert "`r(repo_root)'" == "`testroot'/svnrepo"

    // 5) maxdepth respected (should succeed at depth 2)
    cd "`testroot'/repo/subdir/child"
    find_repo_root, maxdepth(2)
    assert "`r(repo_root)'" == "`testroot'/repo"

    // 6) Not found scenario returns empty
    capture mkdir "`testroot'/nomarker"
    capture mkdir "`testroot'/nomarker/deep"
    cd "`testroot'/nomarker/deep"
    find_repo_root, maxdepth(2)
    assert "`r(repo_root)'" == ""

    // Restore working directory
    cd "`origpwd'"

    // Cleanup
    shell rm -rf "`testroot'"
}

