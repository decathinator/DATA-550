This exercise will walk you through the process of installing R in a docker image and running automated R scripts.

The goal of the exercise is to ultimately build an image that

-   has the current version of R installed
-   includes an R script that:
    -   reads a system environment variable
    -   prints out a message depending on the value of the environment variable
-   has an entry point that automatically runs the R script above

Below are specific instructions for completing this exercise.

#### **Dockerfile**

1.  On your local computer, create a folder that will hold all files associated with this exercise.
2.  Create a file named `Dockerfile` in this folder.
3.  Edit the `Dockerfile` so that an image built from the Dockerfile will:
    -   use an Ubuntu 22.04 operating system
    -   include a working R installation.
    -   To install R on Ubuntu, the following commands should be included in your Dockerfile: 
        -   `ENV DEBIAN_FRONTEND=noninteractive` or 
        -   `ARG DEBIAN_FRONTEND=noninteractive`
        -   `RUN apt-get update`\
            `RUN apt-get install -y build-essential`\
            `RUN apt-get install -y --no-install-recommends r-base`
4.  Creates a folder in the image's root directory called `project`
5.  Includes an environment variable called `WHICH_MESSAGE` that has the value `"GREETING"`

#### **Checkpoint 1**

1.  Build your image 
    -   In a terminal, `cd` to the directory that contains your `Dockerfile`
    -   `docker build -t <your_image_name> .`
    -   Replace `<your_image_name>` with whatever you would like your image to be called.
    -   Note: this build could take several minutes
        -   Optional: spend this time chatting amongst your group members about how INFO550 is the best class you've ever taken.
2.  Check that the image was built by running `docker image ls`
3.  Run an interactive container based on your built image
    -   `docker run -it <your_image_name> bash`
    -   Replace `<your_image_name>` with whatever you named your image above.
4.  Inside the container, check for the existence of the `WHICH_MESSAGE` variable by running `echo $WHICH_MESSAGE`
5.  Inside the container, confirm that R was properly installed.
    -   Open the R GUI by typing `R` at the command line and hitting enter.
    -   Once R is open, try to run any piece of R code you like, e.g., `print("hello world")`
    -   Quit the R GUI by typing `q("no")`
6.  Once R is closed, close the container by running `exit`.
7.  Confirm that the container exited, by typing `docker container ls`

#### **Add an R Script**

1.  On your local computer create a file called `message.R`
2.  Add code to this script so that when it is run it does the following:
    -   Retrieves the value of a system environment variable called `WHICH_MESSAGE`
        -   Hint: `Sys.getenv`
    -   If `WHICH_MESSAGE` evaluates to `"GREETING"` then the code should print `"HELLO FROM YOUR CONTAINER"`
    -   If `WHICH_MESSAGE` evaluates to `"FAREWELL"` then the code should print `"GOODBYE FROM YOUR CONTAINER"`
    -   If `WHICH_MESSAGE` evaluates to anything else then the code should print `"INVALID MESSAGE"`
3.  Once you are finished coding the above, save the `message.R` script.

#### **Modify Dockerfile**

1.  Add a line **to the end** of your `Dockerfile` that copies `message.R` into the `project` directory in your image.
    -   Be sure to add this line at the end (or at least after the lines where you install R), otherwise you will have to re-install R during the build process below.

#### **Checkpoint 2**

1.  Build your image 
    -   In a terminal, `cd` to the directory that contains your `Dockerfile`
    -   `docker build -t <your_image_name> .`
    -   Replace `<your_image_name>` with whatever you would like your image to be called (could be the same as above).
    -   Note: this build *should* execute very quickly.
2.  Run an interactive container based on your built image
    -   `docker run -it <your_image_name> bash`
    -   Replace `<your_image_name>` with whatever you named your image above.
3.  Inside the container, make sure your working directory is the `project` folder that you created above. 
    -   E.g., use `cd` or confirm that a `WORKDIR` statement in your Dockerfile worked correctly
4.  Check for the existence of the `message.R` file that you copied by listing the files of the `project` folder
5.  Run the message.R script in the container.
    -   `Rscript message.R`
    -   If the script errors, debug the error, `exit` from the container, correct the `message.R` script on your computer, and start over at step 1 of Checkpoint 2.
6.  Confirm that the script outputs the message `"HELLO FROM YOUR CONTAINER"`
    -   Confirm with your group members that you understand *why *this is the message that is outputted by `message.R`
7.  Exit the container by typing `exit` and hitting enter

#### **Checkpoint 3**

1.  Run an interactive container based on your built image, but overwrite the `WHICH_MESSAGE` environment variable at runtime. 
    -   `docker run -it -e WHICH_MESSAGE="FAREWELL" <your_image_name> bash`
    -   Replace `<your_image_name>` with whatever you named your image above.
2.  Inside the container, check the value of `WHICH_MESSAGE` by running `echo $WHICH_MESSAGE`.
3.  Repeat steps 3-5 of Checkpoint 2.
4.  Confirm that the script outputs the message `"GOODBYE FROM YOUR CONTAINER"`.
    -   Confirm with your group members that you understand *why *this is the message that is outputted by `message.R`
5.  Exit the container by typing `exit` and hitting enter

#### **Modify Dockerfile**

1.  Add a line **to the end** of your `Dockerfile` that adds an entry point to your image.
2.  The entry point should use `Rscript` to run `message.R`

#### **Checkpoint 4**

1.  Build your image 
    -   In a terminal, `cd` to the directory that contains your `Dockerfile`
    -   `docker build -t <your_image_name> .`
    -   Replace `<your_image_name>` with whatever you would like your image to be called (could be the same as above).
    -   Note: this build *should* execute very quickly.
2.  Run a non-interactive container based on your built image
    -   `docker run <your_image_name>`
    -   Replace `<your_image_name>` with whatever you named your image above.
3.  Confirm that your container prints the message `"HELLO FROM YOUR CONTAINER"`
4.  Run a non-interactive container based on your built image that overrides the `WHICH_MESSAGE` variable at run time
    -   `docker run -e WHICH_MESSAGE="FAREWELL" <your_image_name>`
5.  Confirm that your container prints the message `"GOODBYE FROM YOUR CONTAINER"`
6.  Run a non-interactive container based on your built image that overrides the `WHICH_MESSAGE` variable at run time
    -   `docker run -e WHICH_MESSAGE="OTHER" <your_image_name>`
7.  Confirm that your container prints the message `"INVALID MESSAGE"`

#### **Discussion**

Discuss with your group about how environment variables and Docker containers could be used to customize automatic reports (e.g., thinking back to the `hiv_report` project that we developed).

#### **Submission**

Your submission should include your final `Dockerfile` and a short paragraph (3-5 sentences) explaining how environment variables and Docker could be used to customize automatic reports.
