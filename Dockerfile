FROM electronifie/docker-scientific-python:latest
MAINTAINER Ian McAllister "https://github.com/imcallister/docker-jupyter"


USER root

ADD requirements.txt /tmp

RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt && rm -f /tmp/requirements.txt

# JUPYTER END
ENV JUPYTER_HOME         /jupyter
ENV JUPYTER_NOTEBOOK_DIR $JUPYTER_HOME/notebook
ENV JUPYTER_PORT         8888
ENV USERID 5000
ENV NBUSER scientist
ENV NBGROUP scientist
ENV TINI_VERSION v0.13.2


RUN groupadd -g $USERID $NBUSER
RUN useradd -u $USERID -g $NBUSER $NBGROUP

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini


USER $USERID

# Setup home directory
RUN mkdir /home/$NBUSER/work


WORKDIR /home/$NBUSER/work
EXPOSE 8888

USER root
# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-notebook.sh

# Configure container startup
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["start-notebook.sh"]




