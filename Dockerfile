FROM debian:bookworm-slim
ARG JUPYTER_TOKEN
ENV JUPYTER_TOKEN=${JUPYTER_TOKEN}
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends build-essential python3 pandoc fonts-liberation python3-venv python3-pip git texlive-xetex locales && \
    apt-get autoclean  && \
    rm -rf /var/lib/apt/lists/*
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

RUN groupadd -g 1000 jupyter && \
    useradd -u 1000 -g jupyter -ms /bin/bash jupyter
USER jupyter
WORKDIR /home/jupyter

RUN python3 -m venv .venv
ENV PATH="/home/jupyter/.venv/bin:$PATH"
RUN pip install --upgrade pip && pip install jupyterlab notebook

RUN mkdir -p "/home/jupyter/work"
COPY requirements.txt "/home/jupyter/work"
RUN pip install -r work/requirements.txt 

EXPOSE 8888

ENTRYPOINT jupyter lab --ip=0.0.0.0 --no-browser --notebook-dir /home/jupyter/work