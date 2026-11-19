# Run in Docker

[README](../README.md) · [All docs](README.md)

The image includes the Python dependencies for the repository's three
command-line converters. [Install Docker](https://docs.docker.com/engine/install/) and make sure the `docker` command is
available, then build the image from the repository root:

```bash
docker build -t speaker-tuning-to-easyeffects .
```

Pass a tuning XML from a mounted directory and mount an output directory so
generated files remain on the host. This example writes EasyEffects presets
without configuring autoload:

```bash
mkdir -p output
docker run --rm --user "$(id -u):$(id -g)" \
    -v "$HOME/Downloads:/input:ro" \
    -v "$PWD/output:/output" \
    speaker-tuning-to-easyeffects \
    /app/dolby_to_easyeffects.py /input/your-tuning.xml \
    --output-dir /output/presets --irs-dir /output/irs
```

Pass a path inside the container, such as `/input/your-tuning.xml`, not the
host path. Mount Windows partitions or driver downloads explicitly too; the
container cannot discover the host's mounted partitions or hardware. The image
does not include driver-extraction utilities, so pass an extracted XML file.

To generate a PipeWire filter-chain without trying to activate it, use the
wrapper's output-only options:

```bash
docker run --rm --user "$(id -u):$(id -g)" \
    -v "$HOME/Downloads:/input:ro" \
    -v "$PWD/output:/output" \
    speaker-tuning-to-easyeffects \
    /app/dolby_to_pipewire.py /input/your-tuning.xml \
    --target-sink '' --output-dir /output/pipewire \
    --no-activate --no-validate
```

`--no-validate` skips checks against the container's PipeWire and LV2
environment. Install the required LV2 plugins on the host before using the
generated chain. Docker can generate files, but it cannot configure the host's
EasyEffects, connect to its PipeWire session, or activate the chain.

The image runs as root by default, so the examples use the current host UID and
GID to make output files writable by the host user. For other entry-point
options, replace the script path and arguments; for example, pass
`/app/ee_to_pipewire.py` to convert an existing EasyEffects preset.
