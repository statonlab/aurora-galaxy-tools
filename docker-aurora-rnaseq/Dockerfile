#
# VERSION 0.1

FROM quay.io/bgruening/galaxy:17.09

MAINTAINER Ming Chen, ming.chen0919@gmail.com

ENV GALAXY_CONFIG_BRAND Aurora Tools (RNASeq)

# Install tools
ADD aurora_rnaseq.yml $GALAXY_ROOT/tools.yaml

RUN install-tools $GALAXY_ROOT/tools.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf