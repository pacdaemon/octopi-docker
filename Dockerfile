FROM resin/rpi-raspbian
LABEL manteiner="pac@codebox.com.ar"
LABEL version="1.3.7"

# install prerequisites
RUN apt-get update

#TODO: Remove unzip 
RUN apt-get install unzip
RUN apt-get install python-pip python-dev python-setuptools git libyaml-dev build-essential 
RUN pip install virtualenv
RUN easy_install virtualenv

RUN mkdir /opt/octoprint
RUN useradd -ms /bin/bash octoprint
RUN chown octoprint:octoprint /opt/octoprint
USER octoprint
WORKDIR /opt/octoprint
RUN git clone https://github.com/foosel/OctoPrint.git .
RUN git checkout tags/1.3.8
RUN cd /opt/octoprint && virtualenv venv && ./venv/bin/python setup.py install
EXPOSE 5000
CMD /opt/octoprint/venv/bin/octoprint serve


    