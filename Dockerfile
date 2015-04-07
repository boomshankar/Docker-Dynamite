
#########################################
#   Dynomite Installation Node 1        #
#   Ubuntu OS                           #
#########################################

#Base Image
FROM ubuntu:14.04

#Author
MAINTAINER Novjean J Kannathara "nkannath@purdue.edu"

# Updating and installing

RUN echo '91.189.88.46 archive.ubuntu.com' >> /etc/hosts
RUN apt-get update

RUN apt-get install -y autoconf \
	build-essential \
	dh-autoreconf \
	git \
	software-properties-common \
	tcl8.5 \
	python-software-properties \
	libssl-dev \
	libtool \
	redis-server

#RUN add-apt-repository ppa:rwky/redis

# Get Redis Running
RUN service redis-server start

# Cloning the dynomite Git
RUN git clone https://github.com/Netflix/dynomite.git
RUN echo 'Git repo has been cloned in your Docker VM'

# Moving to Work Directory
WORKDIR dynomite/

# Autoreconf
RUN autoreconf -fvi \
	&& ./configure --enable-debug=log \
	&& make

# Upload the file to the container
ADD my_dyno1.yml /dynomite/


################################ Installation Ends #####################################

# Expose the peer port
RUN echo 'Exposing peer port 8101'
EXPOSE 8101

# Default port to acccess Dynomite
RUN echo 'Exposing client port for Dynomite'
EXPOSE 8102

# Expose the port for Redis 
EXPOSE 6379

# Setting the dynomite as the dockerized entry-point application
RUN echo 'Starting Dynomite'
ENTRYPOINT ["src/dynomite", "--conf-file=my_dyno1.yml", "-v", "11"]

CMD ["run"]

##############################################################

# Default port to execute the entrypoint (Dynomite)
#CMD ["--port 8102"]

###############################################################


# Changing the values
#RUN sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf \
# && sed 's/^bind 127.0.0.1/bind 0.0.0.0/' -i /etc/redis/redis.conf \
# && sed 's/^# unixsocket /unixsocket /' -i /etc/redis/redis.conf \
# && sed 's/^# unixsocketperm 755/unixsocketperm 777/' -i /etc/redis/redis.conf \
# && sed '/^logfile/d' -i /etc/redis/redis.conf

#################################################################################################
#RUN src/dynomite -h

#EXPOSE 8101

#ENTRYPOINT ["src/dynomite", "--conf-file=conf/dynomite.yml", "-v11"]

#CMD ["run"]
