# VERSION 0.1

FROM bgruening/galaxy-stable:18.05

MAINTAINER Ming Chen, ming.chen0919@gmail.com

ENV GALAXY_CONFIG_BRAND="Aurora Tools (RNASeq)"

# Install tools
ADD aurora_rnaseq.yml $GALAXY_ROOT/tools.yaml

RUN install-tools $GALAXY_ROOT/tools.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf
    