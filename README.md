# oak

## Description

### `TL;DR`

IPF Logging API, consistent logging across our apps

### More

We want logging everywhere, but want to ease the hassle of swapping logging libraries.

We'll follow the `fast-logger` style API, as it is my
current preference, and it should give us a bit of flexibility since a fair few libs are built
on top of `fast-logger`. We may even write our own at some point

However, if we ever decide to change to `katip` though, we'll be kind of stuffed...

## Building the lot

``` shell
bin/ci.common
```

## Building the projects

Each project can be built with the command:

``` shell
./mafia build
```

The first time you ever run it on your system it might take a while, as it will build and install
[`haskell-mafia/mafia`](https://github.com/haskell-mafia/mafia) on your system.

## Running the tests

``` shell
./mafia test
```
