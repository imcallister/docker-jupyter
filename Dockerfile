FROM electronifie/docker-scientific-python:latest
MAINTAINER Ian McAllister "https://github.com/imcallister/docker-jupyter"


ADD requirements.txt /tmp

RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt && rm -f /tmp/requirements.txt

# JUPYTER END
ENV JUPYTER_HOME         /jupyter
ENV JUPYTER_NOTEBOOK_DIR $JUPYTER_HOME/notebook
ENV JUPYTER_PORT         8080

ENV USERID 5000

RUN groupadd -g $USERID calculator
RUN useradd -u $USERID -g calculator calculator

ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]


USER $USERID

# Setup home directory
RUN mkdir /home/calculator/work



WORKDIR /home/calculator/work
EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
COPY jupyter_notebook_config.py /home/calculator/.jupyter/