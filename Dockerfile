FROM ubuntu:latest

ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt upgrade -y
RUN apt install nodejs npm -y
RUN apt install awscli -y
RUN apt install jq -y
# Define a build argment that can be supplied when building the container
# You can then do the following:
#
# docker build --build-arg PACKAGENAME=@myscope/cloudsploit
#
# This allows a fork to build their own container from this common Dockerfile.
# You could also use this to specify a particular version number.
ARG PACKAGENAME=cloudsploit

COPY . /var/scan/cloudsploit/

# Install cloudsploit/scan into the container using npm from NPM
RUN cd /var/scan \
&& npm init --yes \
&& npm install ${PACKAGENAME}

#RUN npm audit fix
# Setup the container's path so that you can run cloudsploit directly
# in case someone wants to customize it when running the container.
ENV PATH "$PATH:/var/scan/node_modules/.bin"


# By default, run the scan. CMD allows consumers of the container to supply
# command line arguments to the run command to control how this executes.
# Thus, you can use the parameters that you would normally give to index.js
# when running in a container.
#ENTRYPOINT ["cloudsploit-scan"]
RUN chmod +x /var/scan/cloudsploit/start.sh
ENTRYPOINT /var/scan/cloudsploit/start.sh
