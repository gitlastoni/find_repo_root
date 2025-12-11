{smcl}
{* *! version 0.1.0 11dec2025}
{title:Title}

    {cmd:find_repo_root} — Locate repository root by searching for marker files

{title:Syntax}

    {cmd:find_repo_root} [{cmd:,} {opt maxdepth(#)} {opt marker(string)}]

{title:Description}

    {cmd:find_repo_root} traverses up to {it:maxdepth} parent directories
    starting from the current working directory ({cmd:c(pwd)}), searching for
    one or more marker files or directories. The default marker is
    {cmd:.git/HEAD}. When a marker is found, the command returns the absolute
    path of the matching directory in {cmd:r(repo_root)}. If no marker is
    found within the search depth, an informational message is displayed and
    {cmd:r(repo_root)} is empty.

{title:Options}

    {opt maxdepth(#)} specifies how many levels above the current directory
        to search. The default is 3. The current directory counts as level 0.

    {opt marker(string)} specifies the marker file(s) or directory(ies) to
        search for. Provide a space-separated list to allow multiple markers.
        The default is {cmd:.git/HEAD}.

{title:Examples}

    Search up to 3 levels (default) for a git repository root:
        {cmd:. find_repo_root}

    Search up to 5 levels for a custom marker file:
        {cmd:. find_repo_root, maxdepth(5) marker("README.md")}

    Search for any of multiple markers:
        {cmd:. find_repo_root, marker(".git/HEAD .svn")}

{title:Stored results}

    Macros:
        {cmd:r(repo_root)}   absolute path of the directory containing the marker

{title:Author}

    Lasse Brune (GitHub: gitlastoni)

