FROM electronifie/docker-scientific-python:latest
MAINTAINER Ian McAllister "https://github.com/imcallister/docker-jupyter"


USER root

ADD requirements.txt /tmp

RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt && rm -f /tmp/requirements.txt

# JUPYTER END
ENV JUPYTER_HOME         /jupyter
ENV JUPYTER_NOTEBOOK_DIR $JUPYTER_HOME/notebook
ENV JUPYTER_PORT         8888
ENV NBID 5000
ENV NBUSER scientist
ENV NBGROUP scientist
ENV TINI_VERSION v0.13.2


RUN useradd -m -s /bin/bash -N -u $NBID $NBUSER

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini


USER $NBUSER

# Setup home directory
RUN mkdir /home/$NBUSER/work && \
	mkdir /home/$NBUSER/.jupyter

COPY jupyter_notebook_config.py /home/$NBUSER/.jupyter/


WORKDIR /home/$NBUSER/work
EXPOSE 8888

USER root

# Configure container startup
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-notebook.sh
RUN chown -R $NBUSER:users /home/$NBUSER/.jupyter

USER $NBUSER


