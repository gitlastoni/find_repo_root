# find_repo_root

Stata package to locate the root of a repository by searching for marker files
while walking up parent directories from the current working directory.

**By default, assumes a git repository** (searches for `.git/HEAD`). Can be configured
for other version control systems or custom markers.

## Features
- **Default: git repository detection** (searches for `.git/HEAD`)
- Searches current directory and up to `maxdepth` parents (default 3)
- Accepts custom single or space-separated markers for other repo types
- Returns absolute path in `r(repo_root)`; informational message if not found
- Tested for Stata 17

## Installation

```stata
net install find_repo_root, from("https://raw.githubusercontent.com/gitlastoni/find_repo_root/main/")
```

## Usage

**Default usage (git repository):**
```stata
. find_repo_root
```

**Custom markers (for non-git repos or multiple options):**
```stata
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
- `marker(string)`: Marker file(s) or directory(ies); space-separated list allowed. **Default: `.git/HEAD` (git repository)**.

## Testing
See `test/test_find_repo_root.do` for automated checks covering basics, custom
markers, multiple markers, different depths, not-found cases, and current-dir
matches.

## License
MIT License (see `LICENSE`).

