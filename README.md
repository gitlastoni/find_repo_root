# find_repo_root

Stata package to locate the root of a repository by searching for marker files
while walking up parent directories from the current working directory.

## Features
- Searches current directory and up to `maxdepth` parents (default 3)
- Default marker `.git/HEAD`; accept custom single or space-separated markers
- Returns absolute path in `r(repo_root)`; informational message if not found
- Tested for Stata 17

## Installation

```stata
net install find_repo_root, from("https://raw.githubusercontent.com/gitlastoni/find_repo_root/main/")
```

## Usage

```stata
. find_repo_root
. find_repo_root, maxdepth(5) marker("README.md")
. find_repo_root, marker(".git/HEAD .svn")
```

After running, inspect:

```stata
. return list
```

`r(repo_root)` contains the located root path (or is empty if not found).

## Options
- `maxdepth(#)`: Levels to search above current dir (default 3; current dir is 0).
- `marker(string)`: Marker file(s) or directory(ies); space-separated list allowed. Default `.git/HEAD`.

## Testing
See `test/test_find_repo_root.do` for automated checks covering basics, custom
markers, multiple markers, different depths, not-found cases, and current-dir
matches.

## License
MIT License (see `LICENSE`).

