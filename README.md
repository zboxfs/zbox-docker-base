# zbox-docker-base

Base docker image for building [ZboxFS].

This image is used as the base image for those images:

- [zbox-docker-wasm]
  Docker image for building WebAssembly binding

- [zbox-docker-nodejs]
  Docker image for building Node.js binding

- [zbox-docker-android]
  Docker image for building Android Java binding

## Update with upstream ZboxFS

After cloning this repo, use below commands to update upstream ZboxFS.

```sh
cd zbox-docker-base/zbox
git pull
```

## How to build this image

Make sure you've already updated to the latest upstream as above. Then use below
command to build the image.

```sh
cd zbox-docker-base
./build.sh
```

## How to use this image

This image can be used to build ZboxFS on Linux. First get the latest code from
https://github.com/zboxfs/zbox

```sh
git clone https://github.com/zboxfs/zbox.git
```

And then in the cloned folder use rust toolchain to build ZboxFS. For example,

```bash
docker run --rm -v $PWD:/root/zbox zboxfs/base cargo build
```

It can also be used to run the test suite.

```bash
docker run --rm -v $PWD:/root/zbox zboxfs/base cargo test
```

[ZboxFS]: https://github.com/zboxfs/zbox
[zbox-docker-wasm]: https://github.com/zboxfs/zbox-docker-wasm
[zbox-docker-nodejs]: https://github.com/zboxfs/zbox-docker-nodejs
[zbox-docker-android]: https://github.com/zboxfs/zbox-docker-android
