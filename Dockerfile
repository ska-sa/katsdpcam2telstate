ARG KATSDPDOCKERBASE_REGISTRY=harbor.sdp.kat.ac.za/dpp

FROM $KATSDPDOCKERBASE_REGISTRY/docker-base-build AS build
LABEL maintainer="sdpdev+katsdpcam2telstate@ska.ac.za"



# Install dependencies
COPY --chown=kat:kat requirements.txt /tmp/install/requirements.txt
RUN uv pip install --no-deps -r /tmp/install/requirements.txt && \
    uv pip check

# Install current package
COPY --chown=kat:kat . /tmp/install/katsdpcam2telstate
WORKDIR /tmp/install/katsdpcam2telstate

RUN uv pip install --no-deps . && \
    uv pip check

########################################################################

FROM $KATSDPDOCKERBASE_REGISTRY/docker-base-runtime
LABEL maintainer="sdpdev+katsdpcam2telstate@ska.ac.za"

COPY --from=build --chown=kat:kat /home/kat/ve3 /home/kat/ve3
ENV PATH="$PATH_PYTHON3" VIRTUAL_ENV="$VIRTUAL_ENV_PYTHON3"

# Expose katcp port
EXPOSE 2047
