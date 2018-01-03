# Galaxy REPLACEMENT
#
# VERSION 0.1

FROM quay.io/bgruening/galaxy:17.09

MAINTAINER Ming Chen, ming.chen0919@gmail.com

ENV GALAXY_CONFIG_BRAND RMarkdown Tools



ADD ../tool_yml_files/rmarkdown_fastqc_report.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_fastqc_report.yml
RUN ../install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_fastqc_report.yml

ADD ../tool_yml_files/rmarkdown_fastqc_site.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_fastqc_site.yml
RUN ../install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_fastqc_site.yml

ADD ../tool_yml_files/rmarkdown_trimmomatic.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_trimmomatic.yml
RUN ../install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_trimmomatic.yml

ADD ../tool_yml_files/rmarkdown_hisat2.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_hisat2.yml
RUN ../install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_hisat2.yml

ADD ../tool_yml_files/rmarkdown_samtools_flagstat.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_samtools_flagstat.yml
RUN ../install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_samtools_flagstat.yml

ADD ../tool_yml_files/rmarkdown_feature_counts.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_feature_counts.yml
RUN ../install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_feature_counts.yml

ADD ../tool_yml_files/rmarkdown_deseq2_count_matrix.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_deseq2_count_matrix.yml
RUN ../install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_deseq2_count_matrix.yml

ADD ../tool_yml_files/rmarkdown_deseq2_count_matrix.yml $GALAXY_ROOT/tool_yml_files/rmarkdown_deseq2_count_matrix.yml
RUN ../install-tools $GALAXY_ROOT/tool_yml_files/rmarkdown_deseq2_count_matrix.yml