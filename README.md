## Docker GRReport
A Galaxy docker container with R markdown based Galaxy tools installed. This Docker image is used as a demonstration to show how R markdown can be used as a framework for Galaxy tool development.

## Examples of R Markdown tool outputs

The [tool_report_examples](tool_report_examples) folder has some output examples in zip format. Download and uncompress these zip files. Click any HTML file to open the tool reports.


## Run galaxy image

A docker galaxy image is available to demonstrate several R Markdown based Galaxy tools. The docker image is based on the
[docker image](https://github.com/bgruening/docker-galaxy-stable) created by [Björn Grüning](https://github.com/bgruening).
Thank you to [Björn Grüning](https://github.com/bgruening) for the excellent work! 

```bash
docker run --rm -i -t -p 8080:80 -p 8021:21 -p 8022:22  \
    -e "GALAXY_CONFIG_ADMIN_USERS=admin@galaxy.org" \
    -e "ENABLE_TTS_INSTALL=True" \
    mingchen0919/docker-grreport-rnaseq /bin/bash  
```

## Start Galaxy

Within the interactive environment, run the following code to start Galaxy.
```
startup
```
