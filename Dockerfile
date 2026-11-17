ARG KATSDPDOCKERBASE_REGISTRY=harbor.sdp.kat.ac.za/dpp

FROM $KATSDPDOCKERBASE_REGISTRY/docker-base-build AS build
LABEL maintainer="sdpdev+katsdpcam2telstate@ska.ac.za"

# uv is installed in ~/.local/bin in the base image
# Activate the base image virtualenv and make uv available
ENV PATH="/home/kat/.local/bin:$PATH_PYTHON3" VIRTUAL_ENV="$VIRTUAL_ENV_PYTHON3"


# Install dependencies
COPY --chown=kat:kat requirements.txt /tmp/install/requirements.txt
RUN uv pip compile /tmp/install/requirements.txt \
        -c /home/kat/docker-base/base-requirements.lock \
        -o /tmp/install/requirements.lock && \
    uv pip install --no-deps -r /tmp/install/requirements.lock && \
    uv pip check

# Install current package
COPY --chown=kat:kat . /tmp/install/katsdpcam2telstate
WORKDIR /tmp/install/katsdpcam2telstate
# Temporary compatibility fix: legacy SDP packages (katversion/katsdpcal)
# depend on pkg_resources, so pin setuptools to a version that still includes it.
RUN pip install "setuptools<81" "wheel" && \
    python ./setup.py clean && \
    uv pip install --no-deps . && \
    uv pip check

########################################################################

FROM $KATSDPDOCKERBASE_REGISTRY/docker-base-runtime
LABEL maintainer="sdpdev+katsdpcam2telstate@ska.ac.za"

COPY --from=build --chown=kat:kat /home/kat/ve3 /home/kat/ve3
ENV PATH="$PATH_PYTHON3" VIRTUAL_ENV="$VIRTUAL_ENV_PYTHON3"

# Expose katcp port
EXPOSE 2047
