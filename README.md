# concourse-semvercompare-resource

![CI Build](https://concourse.pubb-it.com/api/v1/teams/main/pipelines/concourse-semvercompare-resource/jobs/build-image-tag/badge)

Compare 2 semver.

Keep
It
Simple (optional ,)
Stupid

## Usage

```yaml
resource_types:
- name: compare
  type: registry-image
  source:
    repository: ghcr.io/typositoire/concourse-semvercompare-resource
```

## Source Configuration

-   `debug`: _Optional._ Debug mode `set -x`.
-   `constrain`: _Required._ One of `lt`, `gt`, `eq`.
-   `ignored_paths`: _Optional._ List of paths to ignore for version bump.

## Behavior

### `check`: Not Supported

### `in`: Not Supported

### `out`: Compare 2 versions together

#### Parameters

-   `current_version`: _Required._ Either a string semver compatible version or a path pointing to a semver compatible version.
-   `next_version`: _Required._ Either a string semver compatible version or a path pointing to a semver compatible version.
-   `changed_files`: _Optional._ List of files modified by a PR. Mainly used with `list_changed_files` option of `telia-oss/github-pr-resource`. Needs a list of `ignored_paths` in `source` configuration.

## Examples

### Simple example

```yaml
- name: greater-than
    type: compare
    check_every: 24h
    source:
      constrain: gt
```

```yaml
- put: greater-than
  params:
    current_version: main-tags/.git/ref
    next_version:  pull-request/VERSION
```

### Example with ignored_paths

This is a very opinionated feature, thought to work with https://github.com/telia-oss/github-pr-resource only.

```yaml
- name: greater-than
  type: compare
  check_every: 24h
  source:
    constrain: gt
    ignored_paths:
      - README.md
```

```yaml
- put: greater-than
  params:
    ## List of files changed in the PR
    ## https://github.com/telia-oss/github-pr-resource
    changed_files: pull-request/.git/resource/changed_files
    current_version: main-tags/.git/ref
    next_version:  pull-request/VERSION
```

### With success/failure messages

```yaml
- name: greater-than
  type: compare
  check_every: 24h
  source:
    constrain: gt
```

```yaml
- put: greater-than
  on_success:
    task: success-message
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
          repository: alpine
      outputs:
        - name: pr-notes
      run:
        path: sh
        args:
          - -c
          - |
            #!/bin/sh
            echo "Concourse: Version bump found." | tee pr-notes/msg
  on_failure:
    task: failure-message
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
          repository: alpine
      outputs:
        - name: pr-notes
      run:
        path: sh
        args:
          - -c
          - |
            #!/bin/sh
            echo "Concourse: Version bump did not happen." | tee pr-notes/msg
  params:
    current_version: main-tags/.git/ref
    next_version:  pull-request/VERSION
```