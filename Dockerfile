ARG KATSDPDOCKERBASE_REGISTRY=harbor.sdp.kat.ac.za/dpp

FROM $KATSDPDOCKERBASE_REGISTRY/base-build:focaluvpip AS build
LABEL maintainer="sdpdev+katsdpcam2telstate@ska.ac.za"

# Enable Python 3 venv
ENV PATH="$PATH_PYTHON3" VIRTUAL_ENV="$VIRTUAL_ENV_PYTHON3"

# Install dependencies
COPY --chown=kat:kat requirements.txt /tmp/install/requirements.txt
#RUN install_pinned.py -r /tmp/install/requirements.txt
RUN uv pip compile /tmp/install/requirements.txt \
    -o /tmp/install/requirements.lock && \
    uv pip sync /tmp/install/requirements.lock --strict

# Install current package
COPY --chown=kat:kat . /tmp/install/katsdpcam2telstate
WORKDIR /tmp/install/katsdpcam2telstate
RUN pip install "setuptools<70" "wheel" && \
    uv pip install --no-deps . && \
    pip check
#RUN python ./setup.py clean && pip install --no-deps . && pip check

########################################################################

FROM $KATSDPDOCKERBASE_REGISTRY/base-runtime:focaluvpip
LABEL maintainer="sdpdev+katsdpcam2telstate@ska.ac.za"

COPY --from=build --chown=kat:kat /home/kat/ve3 /home/kat/ve3
ENV PATH="$PATH_PYTHON3" VIRTUAL_ENV="$VIRTUAL_ENV_PYTHON3"

# Expose katcp port
EXPOSE 2047
