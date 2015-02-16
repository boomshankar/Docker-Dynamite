##########################################################################
# Dockerfile to build Dynomite 
# Based on Ubuntu
##########################################################################

#Set the base image to Ubuntu
FROM ubuntu

#File Author / Maintainer
MAINTAINER Novjean Kannathara - Email: nkannath@purdue.edu

# Update the repository sources list and Install package Build Essential
RUN apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	dh-autoreconf \
	git \
	libssl-dev \
	libtool \
	python-software-properties \
	tcl8.5

# Clone the Dynomite Git
RUN git clone https://github.com/Netflix/dynomite.git
RUN echo 'Git repo has been cloned in your Docker VM'

# Move to working directory
WORKDIR dynomite/

# Autoreconf
RUN autoreconf -fvi \
	&& ./configure --enable-debug=log \
	&& make

## Installation Ends ##

#Run Dynomite	
RUN src/dynomite -h

#Expose the peer ports
#Expose 8101

#RUN echo ip addr show
#ENTRYPOINT ["src/dynomite", "-c", "conf/dynomite.yml", "-v", "11"]
