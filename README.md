## Aurora tools

Aurora tools are a type of Galaxy tools that are wrapped with the R Markdown framework. Aurora tools make it possible to
generalize Galaxy tool outputs in HTML format. Aurora tool outputs could be either individual HTML documents or a static website. Aurora tools make
Galaxy analysis reports better organized, data visualization more interactive and prettier.  

## [Example Outputs from Aurora Tools](https://statonlab.github.io/aurora-tools/)


## View Tool Outputs on Galaxy

If you are interested in viewing Aurora tool outputs on a running Galaxy instance, you can run the following
command to launch a Galaxy instance. The Galaxy instance has several Aurora tools installed and has a history displaying
the tool outputs.

``` 
docker run --rm -d --name=galaxy-r-markdown-tools \
    -p 8080:80 -p 8021:21 -p 8022:22 \
    -e "ENABLE_TTS_INSTALL=True" \
    mingchen0919/galaxy-rmarkdown:tool-outputs-demo
```

The Galaxy instance will be available at http://127.0.0.1:8080/. After logging in with email `admin@galaxy.org` and password `admin`,
you will be able to see the tool outputs on the job history panel.

## Try Aurora Tools

Thanks to [Björn Grüning](https://github.com/bgruening) for developing this excellent 
[Galaxy Docker image](https://github.com/bgruening/docker-galaxy-stable). We used his image (`bgruening/galaxy-stable` on Docker hub) 
as a base image and developed a Galaxy Docker image which has all Aurora tools installed. To try out our Galaxy
R Markdown tools, a Galaxy instance can be launched with the following command:

```bash 
docker run --rm -d --name=galaxy-r-markdown-tools \
    -p 8080:80 -p 8021:21 -p 8022:22 \
    -e "ENABLE_TTS_INSTALL=True" \
    mingchen0919/galaxy-rmarkdown
```

The Galaxy instance will be available at http://127.0.0.1:8080/. Please refer to [this page](https://github.com/bgruening/docker-galaxy-stable/blob/master/README.md) for more details
about how to use the Docker image.

![all-galaxy-r-markdown-tools](docs/images/all-galaxy-r-markdown-tools.png)

## Structure of the Aurora tool repository

### Output single HTML

To develop an R Markdown Galaxy tool, three types of files are required : 1) an XML tool config file 
(Figure 1.A) which defines the web interface of the Galaxy tool and deals with tool dependencies, 2) R scripts 
(Figure 1.B) that function as a command line application, 3) R markdown files (Figure 1.C) which are template 
files for generating the final HTML report and perform the real data analysis process. All the data analysis are 
defined in this file.

![fastqc_report_schema](docs/images/fastqc_report_schema.png)

See an example tool from Galaxy tool shed: [rmarkdown_fastqc_report](https://toolshed.g2.bx.psu.edu/repository?repository_id=fd6e5068c69788da&changeset_revision=8c79e5b7cfc0)
and an [example output](https://statonlab.github.io/aurora-tools/index.html#rmarkdown_fastqc_report) from this tool. 


### Output static website

Galaxy allows creating an extra files directory that is associated with a specific output. With this advantage, we can 
create Aurora tools that output a static website. The figure below show the structure of an R Markdown tool
which output a static website.

See an example tool from Galaxy tool shed: [rmarkdown_fastqc_report](https://toolshed.g2.bx.psu.edu/repository?repository_id=b88fddb3425cab4e&changeset_revision=a6f8382f852c)
and an [example output](https://statonlab.github.io/aurora-tools/index.html#rmarkdown_fastqc_site) from this tool. 


![fastqc_site_schema](docs/images/fastqc_site_schema.png)


## Contribute your Aurora tools

We would like to maintain a repository for all Aurora tools. If you are interested in hosting your Aurora tools in this
repository, please commit a PR. Please put a [planemo](http://planemo.readthedocs.io/en/latest/index.html) [`.shed.yml`](http://galaxy-iuc-standards.readthedocs.io/en/latest/best_practices/shed_yml.html) 
file that contains tool metadata and your [Galaxy Tool Shed](https://toolshed.g2.bx.psu.edu/) username in your tool repository.  


