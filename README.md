
|![](https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Warning.svg/156px-Warning.svg.png) | Deis Workflow is no longer maintained.<br />Please [read the announcement](https://deis.com/blog/2017/deis-workflow-final-release/) for more detail. |
|---:|---|
| 09/07/2017 | Deis Workflow [v2.18][] final release before entering maintenance mode |
| 03/01/2018 | End of Workflow maintenance: critical patches no longer merged |
| | [Hephy](https://github.com/teamhephy/workflow) is a fork of Workflow that is actively developed and accepts code contributions. |

# Prototype Component Repo

This repo is a prototype for what a Deis component's Git repository
should look like.

A Deis component is...

- An isolated piece of functionality (e.g. a microservice)
- That can be packaged into a container (via `docker build`)
- And can be run inside of Kubernetes

Typically, Deis components are written in Go.

## Practical Usage

If you want to experiment with creating a new repo using this framework,
try something like this:

```
$ mkdir my_project
$ cd my_project
$ curl -fsSL https://github.com/deis/prototype-repo/archive/master.tar.gz | tar -zxv --strip-components 1
```

## First-Class Kubernetes

Every component must define the appropriate Kubernetes files.
Preferably, components should use *Replication Controllers* over pods,
and use *Services* for autodiscovery.

*Labels* should be used for versioning components and also for
identifying components as part of Deis.

*Secrets* should be used for storing small bits of shared information,
and their contents may be set at startup time.

All Kubernetes definitions should be placed in the `manifests/` directory.

The _Makefile_ should have targets that use `kubectl` to load
definitions into Kubernetes.

## Dockerfiles are for Running

Source code should be built either outside of Docker or in a special
Docker build phase.

A separate Dockerfile should be used for building the image. That
Dockerfile should always be placed inside of the `rootfs` directory, and
should manage the final image size appropriately.

(See the Makefile for one possible way of doing a Docker build phase)

## RootFS

All files that are to be packaged into the container should be written
to the `rootfs/` folder.

## Extended Testing

Along with unit tests, Deis values functional and integration testing.
These tests should go in the `_tests` folder.

[v2.18]: https://github.com/deis/workflow/releases/tag/v2.18.0
