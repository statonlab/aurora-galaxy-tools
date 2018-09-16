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

Steps to developing an Aurora Galaxy Tool  We have developed a set of template files to help 
developers to quickly develop new Aurora Galaxy tools. All template files (Table 2) are available 
from the GitHub repository. Most of those template files are common to both single HTML 
report and website report types of Aurora tools. In this section, we will go through how 
to develop an Aurora Galaxy Tool with those template files. We explain the main functionalities 
of each template file as follows:

### Step 1: define tool web interface
First, we need to create a Galaxy tool XML file which defines the web interfaces including 
inputs and outputs, as well as command line execution. The `rmarkdown_report.xml` file can 
be used an template. The command line execution portion in this file creates an output directory 
and three environment variables which store paths to the tool installation directory, 
the output report and the created output directory. Developers should extend the command line 
execution section by defining command line arguments that will be passed to the 
rmarkdown\_report\_render.R file.

### Step 2: collect inputs for data analysis
After we have defined the tool web interface, we can use the `rmarkdown_report_render.R` to 
collect inputs for the data analysis. This R script file functions as a command line application 
and bridges the tool definition XML file and the data analysis R Markdown files (see details in next step). 
This file reads the option specifications from the command-line-arguments.csv file and for 
each command line argument that is passed from the `rmarkdown_report.xml`, stores the value 
in both an R variable and an Unix environment variable. The argument’s short flag character 
is used in the variable names. For example, if an command line argument uses m as the flag symbol, 
its value is stored in the environment variable X\_m and R variable `opt$X_m`. opt is an R 
list object that stores all command line arguments. After all command line arguments are 
collected from the `rmarkdown_report.xml`, the template renders R Markdown files to perform 
the actual data analysis. At the end, it executes the expose-outputs-to-galaxy-history.sh 
script to expose outputs to the analysis history pane.

command-line-arguments.csv A four column table which stores specifications of command line 
options defined in the command line execution of the `rmarkdown_report.xml` file. In the 
`rmarkdown_report_render.R` template file, we defined a helper function named 
`getopt_specification_matrix` that assists in converting command line arguments into R variables. 
Therefore, this file stores the command line arguments from the command line section in the 
`rmarkdown_report.xml` file. The first and last columns store short option flags and variable 
names. The second column specifies if this option is required or not. The third column specify 
the data type that this option accepts. Users can refer to the documentation of the R 
package getopt for more details [12].
