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

# Clone the Dynomite Git
RUN git clone https://github.com/Netflix/dynomite.git
RUN echo 'Git repo has been cloned in your Docker VM'

# Move to working directory
WORKDIR dynomite/

# Exposing the ports
RUN echo 'Exposing client port for Dynomite'
EXPOSE 8102

# Default port to execute the entrypoint (Dynomite)
CMD ["--port 8102"]
