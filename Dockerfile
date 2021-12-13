ARG KATSDPDOCKERBASE_REGISTRY=quay.io/ska-sa

FROM $KATSDPDOCKERBASE_REGISTRY/docker-base-build as build
LABEL maintainer="sdpdev+katsdpcam2telstate@ska.ac.za"

# Enable Python 3 venv
ENV PATH="$PATH_PYTHON3" VIRTUAL_ENV="$VIRTUAL_ENV_PYTHON3"

# Install dependencies
COPY requirements.txt /tmp/install/requirements.txt
RUN install_pinned.py -r /tmp/install/requirements.txt

# Install current package
COPY --chown=kat:kat . /tmp/install/katsdpcam2telstate
WORKDIR /tmp/install/katsdpcam2telstate
RUN python ./setup.py clean && pip install --no-deps . && pip check

########################################################################

FROM $KATSDPDOCKERBASE_REGISTRY/docker-base-runtime
LABEL maintainer="sdpdev+katsdpcam2telstate@ska.ac.za"

COPY --from=build --chown=kat:kat /home/kat/ve3 /home/kat/ve3
ENV PATH="$PATH_PYTHON3" VIRTUAL_ENV="$VIRTUAL_ENV_PYTHON3"

# Expose katcp port
EXPOSE 2047
