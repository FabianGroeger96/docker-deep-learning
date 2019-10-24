
FROM debian:stretch-slim

ENV BUILD_PACKAGES="\
    build-essential \
    linux-headers-4.9 \
    cmake \
    tcl-dev \
    xz-utils \
    zlib1g-dev \
    libssl-dev \
    libncurses5-dev \
    libsqlite3-dev \
    libreadline-dev \
    libtk8.5 \
    libgdm-dev \
    libdb4o-cil-dev \
    libpcap-dev \
    git \
    wget \
    curl" \
    APT_PACKAGES="\
    ca-certificates \
    openssl \
    sqlite3 \
    bash \
    fonts-noto \
    libpng16-16 \
    libfreetype6 \
    libjpeg62-turbo \
    python3-lxml \
    libxml2-dev \
    libxslt1-dev \
    python-dev \
    libgomp1" \
    PIP_PACKAGES="\
    h5py \
    requests \
    pillow \
    numpy \
    pandas \
    scipy \
    scikit-learn \
    seaborn \
    matplotlib \
    jupyter \
    tensorflow \
    keras \
    nltk \
    lxml \
    tqdm \
    pytest" \
    PYTHON_VER=3.6.8 \
    JUPYTER_CONFIG_DIR=/home/.ipython/profile_default/startup \
    LANG=C.UTF-8

RUN set -ex; \
    apt-get update -y; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends ${APT_PACKAGES}; \
    apt-get install -y --no-install-recommends ${BUILD_PACKAGES}; \
    cd /tmp && wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz; \
    tar xvf Python-${PYTHON_VER}.tgz; \
    cd Python-${PYTHON_VER}; \
    ./configure --enable-optimizations && make -j8 && make altinstall; \
    ln -s /usr/local/bin/python3.6 /usr/local/bin/python; \
    ln -s /usr/local/bin/pip3.6 /usr/local/bin/pip; \
    ln -s /usr/local/bin/idle3.6 /usr/local/bin/idle; \
    ln -s /usr/local/bin/pydoc3.6 /usr/local/bin/pydoc; \
    ln -s /usr/local/bin/python3.6m-config /usr/local/bin/python-config; \
    ln -s /usr/local/bin/pyvenv-3.6 /usr/local/bin/pyvenv; \
    pip install -U -V pip; \
    pip install -U -v setuptools wheel; \
    pip install -U -v ${PIP_PACKAGES}; \
    apt-get remove --purge --auto-remove -y ${BUILD_PACKAGES}; \
    apt-get clean; \
    apt-get autoclean; \
    apt-get autoremove; \
    rm -rf /tmp/* /var/tmp/*; \
    rm -rf /var/lib/apt/lists/*; \
    rm -f /var/cache/apt/archives/*.deb \
    /var/cache/apt/archives/partial/*.deb \
    /var/cache/apt/*.bin; \
    find / -name __pycache__ | xargs rm -r; \
    rm -rf /root/.[acpw]*; \
    pip install jupyter && jupyter nbextension enable --py widgetsnbextension; \
    mkdir -p ${JUPYTER_CONFIG_DIR}; \
    echo "import warnings" | tee ${JUPYTER_CONFIG_DIR}/config.py; \
    echo "warnings.filterwarnings('ignore')" | tee -a ${JUPYTER_CONFIG_DIR}/config.py; \
    echo "c.NotebookApp.token = u''" | tee -a ${JUPYTER_CONFIG_DIR}/config.py

WORKDIR /home/notebooks

EXPOSE 8888

CMD [ "jupyter", "notebook", "--port=8888", "--no-browser", \
    "--allow-root", "--ip=0.0.0.0", "--NotebookApp.token=" ]
