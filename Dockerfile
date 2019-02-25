FROM registry.fedoraproject.org/fedora:25
RUN dnf -y install \
    git \
    python-pip \
    libselinux-python \
    python-devel \
    libffi-devel \
    redhat-rpm-config \
    openssl-devel \
    gcc \
    rpm-build  
RUN git clone https://github.com/projectatomic/atomic-host-tests
WORKDIR "/atomic-host-tests"
RUN pip install -r requirements.txt
COPY .aht.py /aht.py
ENTRYPOINT ["/aht.py"]
