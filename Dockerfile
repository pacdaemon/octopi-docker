FROM resin/rpi-raspbian
LABEL manteiner="pac@codebox.com.ar"
LABEL version="1.3.7"
ENV CURA_VERSION=15.04.6
ENV OCTOPRINT_VERSION=1.3.8

# install prerequisites
RUN apt-get update

RUN apt-get install python-pip python-dev python-setuptools git libyaml-dev build-essential zlib1g-dev \
    unzip wget libjpeg8-dev
RUN pip install virtualenv
RUN easy_install virtualenv

# Install Cura
RUN cd /tmp \
  && wget https://github.com/Ultimaker/CuraEngine/archive/${CURA_VERSION}.tar.gz \
  && tar -zxf ${CURA_VERSION}.tar.gz \
	&& cd CuraEngine-${CURA_VERSION} \
	&& mkdir build \
	&& make \
	&& mv -f ./build /opt/cura/ \
&& rm -Rf /tmp/*

RUN mkdir /opt/octoprint
RUN useradd -ms /bin/bash octoprint
RUN usermod -g dialout octoprint
RUN chown octoprint:octoprint /opt/octoprint
USER octoprint
RUN mkdir /home/octoprint/.octoprint
WORKDIR /opt/octoprint
RUN git clone https://github.com/foosel/OctoPrint.git .
RUN git checkout tags/${OCTOPRINT_VERSION}
RUN cd /opt/octoprint && virtualenv venv && ./venv/bin/python setup.py install

# Install Astroprint
RUN /opt/octoprint/venv/bin/python -m pip install https://github.com/AstroPrint/OctoPrint-AstroPrint/archive/master.zip

EXPOSE 5000
VOLUME /home/octoprint/.octoprint
CMD /opt/octoprint/venv/bin/octoprint serve


    