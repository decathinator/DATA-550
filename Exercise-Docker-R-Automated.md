This exercise will walk you through the process of containerizing the `hiv_project` report that we worked on earlier this semester.

The goal of the exercise is to ultimately build an image that

-   automatically builds the report for the HIV data analysis according to a user-specified choice of config

Below are specific instructions for completing this exercise.

#### **Initialize renv**

1.  On your local computer, determine where your project directory will be located.
2.  In that location unzip the contents of [docker_r_auto_report_gen.zip](https://canvas.emory.edu/courses/128222/files/11861414?wrap=1 "docker_r_auto_report_gen.zip")[ Download docker_r_auto_report_gen.zip](https://canvas.emory.edu/courses/128222/files/11861414/download?download_frd=1).
3.  Initialize renv package management.
    1.  Open R Studio.
    2.  In the Console, use `setwd` to set your working directory in R to your project directory.
    3.  Run `renv::init()` to initialize a project library.

**Create Dockerfile for first stage of multi-stage build**

1.  Create a file named `Dockerfile` in the project folder.

At this point, there is a major decision point for you to consider: *You will need to do some (light) development of code inside a container.*

-   -   I.e., you will be modifying R scripts and confirming that they work as expected inside the container.
    -   Thus, you need to decide if you want to do that development from the command line or in the RStudio IDE.

 2a. If you choose to do your development at the command line include a `FROM rocker/r-ubuntu as base` in your Dockerfile. Add a line to create a directory in the image, `/project`.

 2b. If you choose to do your development in the RStudio IDE include a `FROM rocker/rstudio as base` in your Dockerfile. Add a line to create a directory in the image `/home/rstudio/project`

Notice that we added `as base` to the the `FROM` statement. In order to speed up image building, we are using [a multi-stage buildLinks to an external site.](https://docs.docker.com/build/building/multi-stage/). The goal is to write our `Dockerfile` in such a way as to avoid re-installing packages every time we re-build the image.

3\. Edit your `Dockerfile` to create a project directory by adding the line `WORKDIR /project` (if using `r-ubuntu`) or `WORKDIR /home/rstudio/project` (if using Rstudio IDE).

4\. Create a folder called `renv` in the working directory you just created that will hold all renv-associated files. Copy renv-associated files into that folder.

`RUN mkdir -p renv`\
`COPY renv.lock renv.lock`\
`COPY .Rprofile .Rprofile`\
`COPY renv/activate.R renv/activate.R`\
`COPY renv/settings.dcf renv/settings.dcf`

Newer versions of `renv` may store settings in a .json file.

5\. Add the following lines to your Dockerfile to change the default location of the renv cache to be in your project directory.

`RUN mkdir renv/.cache`\
`ENV RENV_PATHS_CACHE renv/.cache`

6\. Add the following line to your Dockerfile to restore the package library.

`RUN R -e "renv::restore()"`

7\. Build the image by running `docker build -t <image_tag> .`. Be sure to replace `<image_tag>` with a name for your image. Note that this build may take some time as packages must be downloaded and installed. Hopefully, if you've done everything correctly, this will be the *only time* that the library needs to be installed.

**Modify Dockerfile for secon stage of multi-stage build**

1\. Add the following commented line to your Dockerfile below the lines written above.

`###### DO NOT EDIT STAGE 1 BUILD LINES ABOVE ######`

This will serve as a reminder to you to not edit the lines you just wrote, lest you have to re-install your entire package library :) 

2\. Working in **the same Dockerfile** add lines below the lines you wrote above that include the following. 

If you selected `rocker/r-ubuntu` above, include the following lines:

`FROM rocker/r-ubuntu`

`WORKDIR /project`\
`COPY --from=base /project .`

If you selected `rocker/rstudio` above, include the following lines

`FROM rocker/r-studio`

`WORKDIR /home/rstudio/project`\
`COPY --from=base /home/rstudio/project .`

These lines are creating a second image in the same Dockerfile. However, in this second image, we are simply copying the contents of the `project` directory to the new image from the first image we created. In this way, as long as we do not modify the contents of our `renv.lock` (and as long as we don't edit the lines above the comment line that you created), we will not need to re-install the package library.

3\. Build the image by running `docker build -t <image_tag2> .`. Be sure to replace `<image_tag2>` with a name for your image. If you've done everything correctly, this build should execute very quickly.

4\. Confirm that the renv cache was copied successfully.

-   Run a container from this image by executing `docker run -it <image_tag2> bash`
-   Inside the container `cd` to the project directory (`/project` or `/home/rstudio/project`)
-   Use `ls -a renv` to confirm that the `renv/.cache` directory is present.
-   Use `ls -a renv/.cache` to confirm that the cache includes the packages installed during the first build

5\. Confirm that R packages were properly installed.

-   Confirm that your working directory in the container is the project directory
-   Open the R GUI by typing `R` at the command line and hitting enter
-   Once R is open, try to load an R package used by the project, e.g., `library(gtsummary)` and confirm that it loads.
-   Quit the R GUI by typing `q("no")`
-   Once R is closed, close the container by running `exit`.

If anything inside the container is not as expected, edit your `Dockerfile` to correct mistakes and build the image again.

**Continue editing Dockerfile for second stage of multi-stage build**

Continuing adding lines to your Dockerfile.

1\. Edit your `Dockerfile` to set an environment variable named `WHICH_CONFIG` with value `"default"`

2\. Edit your `Dockerfile` to copy the Makefile, the config file, the hiv_report.Rmd file to the project directory in the image.

3\. Edit your `Dockerfile` to create a `code`, `output`, `raw_data`, and `final_report` directory in the project directory in the image.

4\. Edit your `Dockerfile` to copy the `raw_data/vrc01_data.csv` to the `raw_data` directory in the image.

Do not copy any contents of the `code` nor `output` directory to the image. I.e., those directories should remain empty in the image.

5\. Build your image again by running `docker build -t <image_tag3> .` Be sure to replace `<image_tag3>` with a name for your image. If you've done everything correctly, this build should execute very quickly.

6\. Confirm that all files were copied successfully.

-   Run a container from this image by executing `docker run -it <image_tag3> bash`
-   Inside the container `cd` to the project directory (`/project` or `/home/rstudio/project`)
-   Use `ls` to confirm that the directory structure is expected and files that were copied to the image during the build are available in the container.
-   Run `echo $WHICH_CONFIG` to confirm that the `WHICH_CONFIG` environment variable was created successfully.
-   Close the container by running `exit`

If anything inside the container is not as expected, edit your `Dockerfile` to correct mistakes and build the image again.

#### **Interactive development**

The goal is to now (lightly) edit the R code associated with the project and confirm that the edits work *inside the containerized environment*.

1.  Execute another docker run command that mounts your local code and output directory to the code and output directories in the image. First, use `cd` to make sure your terminal working directory is your project directory.

If you are using `r-ubuntu`:

`docker run -it -v "$(pwd)"/code:/project/code -v "$(pwd)"/output:/project/output <image_tag3> bash`

If you are using `r-studio`

`docker run -e PASSWORD=<your_password> -p 8787:8787 -v "$(pwd)"/code:/home/rstudio/project/code -v "$(pwd)"/output:/home/rstudio/project/output <image_tag3>`

where you will replace `<your_password>` with a desired password of your choice.

-   Recall that if you are using git bash on Windows, you will need an extra `/`, i.e., `"/$(pwd)"`

  2. Confirm that the interactive session is working as expected.

-   On `r-ubuntu` you should be able to see your local code files in the `/project/code` directory.
-   On `rstudio`, open a web browser and go to `http://localhost:8787`, login using user name rstudio and password `<your_password>`. Click on open folder and you should be able to see the code directory and its contents.

  3. Using either a local text editor (if on `r-ubuntu`) or the in-browser RStudio IDE (if on `r-studio`), edit line 13 of `code/02_scatter.R` to select a new theme for the scatter plot. Try out several themes until you find one that you like.

  4. Once you have found a theme you like, save the `code/02_scatter.R` file.

  5. Confirm that a report can be built in the container by executing `make` at the command line inside the container.

  5. Exit the running container.

  6. Confirm that your local copy of `code/02_scatter.R` has been updated to reflect the changes that were just made.

#### **Modify Dockerfile**

1.  Add lines to your `Dockerfile` to copy the contents of your local `code` directory to the `code` directory in the image's project directory.
2.  Add a line to your `Dockerfile` to add an entry point to the container that creates the report and copies it to the `final_report` directory.
3.  Build your image `docker build -t <image_tag4> .`
4.  Check that you can build the report automatically by running the container with the default configuration

On `r-ubuntu`:

`docker run -v "$(pwd)"/final_report:/project/final_report <your_image_name>`

On `rstudio`:

`docker run -v "$(pwd)"/final_report:/home/rstudio/final_report <your_image_name>`

-   Recall that if you are using git bash on Windows, you will need an extra `/`, i.e., `"/$(pwd)"`

  5. Check that you can build the report automatically with the test configuration

On `r-ubuntu`:

`docker run -e WHICH_CONFIG=test -v "$(pwd)"/final_report:/project/final_report <your_image_name>`

On `rstudio`:

`docker run -e WHICH_CONFIG=test -v "$(pwd)"/final_report:/home/rstudio/final_report <your_image_name>`

-   Recall that if you are using git bash on Windows, you will need an extra `/`, i.e., `"/$(pwd)"`

#### **Submission**

Your submission should include your final `Dockerfile`. The grade for this assignment will be for completion and effort rather than correctness.
