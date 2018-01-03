## Galaxy R Markdown Tools

Galaxy R Markdown Tools use R markdown as a framework to wrap multiple tools and/or scripts from different 
programming languages into a single tool and generate an R markdown document in the format of either single HTML or a web site. 
Technically, all Galaxy tools can be wrapped in the R Markdown framework to provide well-organized HTML outputs with better
data visualization.

## [Example Outputs from Galaxy R Markdown Tools](https://mingchen0919.github.io/galaxy-r-markdown-tools/)

## Try Galaxy R Markdown Tools

Thanks to [Björn Grüning](https://github.com/bgruening) for developing this excellent 
[Galaxy Docker image](https://github.com/bgruening/docker-galaxy-stable). We used his image (`bgruening/galaxy-stable` on Docker hub) 
as a base image and developed a Galaxy Docker image which has all Galaxy R Markdown tools installed. To try out our Galaxy
R Markdown tools, a Galaxy instance can be launched with the following command:

```bash 
docker run --rm -d --name=galaxy-r-markdown-tools \
    -p 80:80 -p 8021:21 -p 8022:22 \
    -e "ENABLE_TTS_INSTALL=True" \
    mingchen0919/galaxy-rmarkdown
```

Please refer to [this page](https://github.com/bgruening/docker-galaxy-stable/blob/master/README.md) for more details
about how to use the Docker image.

## Structure of the Galaxy R Markdown tool repository



### Output single HTML

To develop an R Markdown Galaxy tool, three types of files are required : 1) an XML tool config file 
(Figure 1.A) which defines the web interface of the Galaxy tool and deals with tool dependencies, 2) R scripts 
(Figure 1.B) that function as a command line application, 3) R markdown files (Figure 1.C) which are template 
files for generating the final HTML report and perform the real data analysis process. All the data analysis are 
defined in this file.

![fastqc_report_schema](docs/images/fastqc_report_schema.png)

See an example tool from Galaxy tool shed: [rmarkdown_fastqc_report](https://toolshed.g2.bx.psu.edu/repository?repository_id=fd6e5068c69788da&changeset_revision=8c79e5b7cfc0)
and an [example output](https://mingchen0919.github.io/galaxy-r-markdown-tools/index.html#rmarkdown_fastqc_report) from this tool. 


### Output static website

Galaxy allows creating an extra files directory that is associated with a specific output. With this advantage, we can 
create Galaxy R Markdown tools that output a static website. The figure below show the structure of an R Markdown tool
which output a static website.

See an example tool from Galaxy tool shed: [rmarkdown_fastqc_report](https://toolshed.g2.bx.psu.edu/repository?repository_id=b88fddb3425cab4e&changeset_revision=a6f8382f852c)
and an [example output](https://mingchen0919.github.io/galaxy-r-markdown-tools/index.html#rmarkdown_fastqc_site) from this tool. 


![fastqc_site_schema](docs/images/fastqc_site_schema.png)


