FROM ubuntu

# Update the repository sources list and Install package Build Essential
RUN apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	dh-autoreconf \
	git \
	libssl-dev \
	libtool \
	python-software-properties \
	redis-server \
	tcl8.5

# Get Redis Running
RUN service redis-server start

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

# Expose the peer port
RUN echo 'Exposing peer port 8101'
EXPOSE 8101

# Exposing the ports
RUN echo 'Exposing client port for Dynomite'
EXPOSE 8102

# Default port to execute the entrypoint (Dynomite)
CMD ["--port 8102"]

# Setting the dynomite as the dockerized entry-point application
RUN echo 'Starting Dynomite'
RUN src/dynomite --conf-file=conf/redis_single.yml -v11
