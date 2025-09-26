### Update submodule
git submodule update --init --recursive

### Build image
docker build -t nethswitchboard/preconf-taiko-protocol:<VERSION> . --progress=plain
