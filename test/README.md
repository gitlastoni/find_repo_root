# Tests for find_repo_root

Run with Stata 17+ from the repo root:

```
do test/test_find_repo_root.do
```

The script:
- builds temporary directory trees with various markers,
- runs `find_repo_root` under different options,
- asserts stored results (`r(repo_root)`) match expectations,
- cleans up temporary files afterward.

