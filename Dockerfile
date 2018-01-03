# Galaxy REPLACEMENT
#
# VERSION 0.1

FROM quay.io/bgruening/galaxy:17.01

MAINTAINER Ming Chen, ming.chen0919@gmail.com

ENV GALAXY_CONFIG_BRAND RMarkdown Tools

#-------edit galaxy.ini---------------------------
#USER galaxy
#
#RUN echo "conda_auto_init = True" >> /etc/galaxy/galaxy.ini
#RUN cp $GALAXY_ROOT/config/dependency_resolvers_conf.xml.sample $GALAXY_ROOT/config/dependency_resolvers_conf.xml

#-------Install tools from Galaxy toolshed--------
#USER root

ADD tool_yml_files/rmarkdown_fastqc_report.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_fastqc_report.yml
RUN install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_fastqc_report.yml

ADD tool_yml_files/rmarkdown_fastqc_site.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_fastqc_site.yml
RUN install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_fastqc_site.yml

ADD tool_yml_files/rmarkdown_deseq2.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_deseq2.yml
RUN install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_deseq2.yml

ADD tool_yml_files/rmarkdown_wgcna.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_wgcna.yml
RUN install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_wgcna.yml