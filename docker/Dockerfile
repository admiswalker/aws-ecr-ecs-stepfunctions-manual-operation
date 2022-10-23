FROM amazonlinux:2

# install amazon-linux-extras install
RUN amazon-linux-extras install -y

# yum update & install
RUN yum update -y \
    && yum install \
        systemd \
        tar \
        unzip \
        sudo \
	python3 \
        -y

# install aws cli v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install

# install python env
COPY requirements.txt ./
RUN pip3 install -r requirements.txt

# embedding python code
COPY main.py ./

# set default execution command
CMD ["python3", "/main.py"]

