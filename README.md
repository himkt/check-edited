# Check Edited Action
This GitHub Action checks if the specified file(s) have been updated between two branches.

## Inputs

```yaml
- uses: himkt/check-edited@main
  with:
    # The source remote repository.
    # If source-remote is not empty, you must specify source-branch as well.
    # If src-remote and src-branch are both empty,
    # check-edited use $GITHUB_REF as a source refs.
    # Default: ''
    source-remote: ''

    # The source branch to compare changes from.
    # If source-branch is not empty, you must specify source-remote as well.
    # If src-remote and src-branch are both empty,
    # check-edited use $GITHUB_REF as a source refs.
    # Default: ''
    source-branch: ''

    # The target remote repository.
    # Default: 'origin'
    target-remote: ''

    # The target branch to compare changes to.
    # Default: 'main'
    target-branch: ''

    # The file(s) to check for updates. Specify multiple files by separating them with commas
    # (e.g., 'file1.txt,file2.txt').
    # Required: Yes
    target-file: ''
```

## Examples

### check-edited action

Action to check a specific file is modified on a pull request.
If you want to check if `NEWS` is modified, create a workflow like following:

```yaml
name: test

on: pull_request

jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: himkt/check-edited@main
        with:
          target-file: NEWS
```

### Only run when specific files are modified

It checks NEWS only when files in `src` are modified.

```yaml
name: test with path filter

on:
  pull_request
    paths:
      - 'src/**'

jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: himkt/check-edited@main
        with:
          target-file: NEWS
```

### Skip if a specific label is added to a pull request

If `skip-check` is added to a pull request, contents check is skipped.

```yaml
name: test with skip

on: pull_request

jobs:
  main:
    if: ${{ !contains(github.event.pull_request.labels.*.name, 'skip-check') }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: himkt/check-edited@main
        with:
          target-file: LICENSE
```
