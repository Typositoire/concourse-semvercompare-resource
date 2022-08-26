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

## Behavior

### `check`: Not Supported

### `in`: Not Supported

### `out`: Compare 2 versions together

#### Parameters

-   `current_version`: _Required._ Either a string semver compatible version or a path pointing to a semver compatible version.
-   `next_version`: _Required._ Either a string semver compatible version or a path pointing to a semver compatible version.

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