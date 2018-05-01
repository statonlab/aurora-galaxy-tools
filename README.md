## Aurora Galaxy Tools

![aurora galaxy tools](images/aurora-galaxy-tools-logo.png)

Aurora Galaxy Tools are a type of Galaxy tools that are wrapped with the R Markdown framework. Aurora Galaxy Tools make it possible to
generalize Galaxy tool outputs in HTML format. Aurora tool outputs could be either individual HTML documents or a static website. Aurora Galaxy Tools make
Galaxy analysis reports better organized, data visualization more interactive and prettier.  


## Two types of Aurora Galaxy Tools

* Output a single HTML report
* Output a website report

**Both types use a clickable file tree to display tool outputs**.

### Single HTML report tools

<img src="images/aurora_star.gif" width="100%" />

### Website report tools

<img src="images/aurora_star_site.gif" width="100%" />

### [More examples](https://statonlab.github.io/aurora-galaxy-tools/)

## Try Aurora Galaxy Tools

Thanks to [Björn Grüning](https://github.com/bgruening) for developing this excellent 
[Galaxy Docker image](https://github.com/bgruening/docker-galaxy-stable). We used his image (`bgruening/galaxy-stable` on Docker hub) 
as a base image and developed a Galaxy Docker image which has all Aurora Galaxy Tools installed. To try out our Galaxy
R Markdown tools, a Galaxy instance can be launched with the following command:

```bash 
docker run --rm -d \
    -p 8080:80 -p 8021:21 -p 8022:22 \
    -e "ENABLE_TTS_INSTALL=True" \
    mingchen0919/aurora_galaxy_tools:demo
```

The Galaxy instance will be available at http://127.0.0.1:8080/. Please refer to [this page](https://github.com/bgruening/docker-galaxy-stable/blob/master/README.md) for more details
about how to use the Docker image.

## Develop Aurora Galaxy Tools

Coming soon...
