### Update submodule
```sh
git submodule update --init --recursive
```

### Build image
```sh
docker build -t nethswitchboard/preconf-taiko-protocol:<VERSION> . --progress=plain
```
